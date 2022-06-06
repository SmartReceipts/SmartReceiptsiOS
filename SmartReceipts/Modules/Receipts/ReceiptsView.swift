//
//  ReceiptsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol ReceiptsViewInterface {
    func setup(trip: WBTrip)
    func setup(fetchedModelAdapter: FetchedModelAdapter)
    var viewForTooltip: UIView { get }
}

//MARK: ReceiptsView Class
final class ReceiptsView: FetchedTableViewController {
    static var sharedInputCache = [String: Date]()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    private var _imageForCreatorSegue: UIImage!
    private var _receiptForCreatorSegue: WBReceipt!
    private var tapped: WBReceipt!
    private var dateFormatter = WBDateFormatter()
    private var showReceiptDate = false
    private var showReceiptCategory = false
    private var lastDateFormat: String!
    private var showAttachmentMarker = false
    fileprivate let bag = DisposeBag()
    
    var receiptsCount: Int { get { return itemsCount } }
    override var placeholderTitle: String { get { return LocalizedString("receipt_no_data") } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.separatorInset = .zero
        
        titleLabel.text = LocalizedString("report_info_receipts")
        tableView.register(headerFooter: ReceiptsSectionHeader.self)
        
        ReceiptsView.sharedInputCache = [String: Date]()
        AppTheme.customizeOnViewDidLoad(self)
        
        showReceiptDate = WBPreferences.layoutShowReceiptDate()
        showReceiptCategory = WBPreferences.layoutShowReceiptCategory()
        showAttachmentMarker = WBPreferences.layoutShowReceiptAttachmentMarker()
        
        setPresentationCellNib(ReceiptCell.viewNib())
        
        lastDateFormat = WBPreferences.dateFormat()
        subscribe()
        subscribeTooltip()
        
        let notifications = [AppNotificationCenter.syncProvider.asVoid(), AppNotificationCenter.didSyncBackup]
        Observable<Void>.merge(notifications)
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
            }).disposed(by: bag)
        
        presenter.tooltipPresenter.updateInsets
            .subscribe(onNext: { [weak self] in
                self?.tableView.contentInset = $0
            }).disposed(by: bag)
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.tooltipPresenter.presentBackupReminderIfNeeded()
        presenter.tooltipPresenter.presentBackupPlusTooltip()
        presenter.tooltipPresenter.presentGenerateIfNeeded()
    }
    
    @objc func tripUpdated(_ notification: Notification) {
        guard let trip = notification.object as? WBTrip, self.trip == trip else { return }
        Logger.debug("Updated Trip: \(trip.description)")
    
        //TODO jaanus: check posting already altered object
        self.trip = Database.sharedInstance().tripWithName(trip.name)
        contentChanged()
    }
    
    override var dataSourceType: TableType {
        return .sections
    }
    
    override func configureCell(cell: UITableViewCell, item: Any) {
        let cell = cell as! ReceiptCell
        let receipt = item as! WBReceipt
        cell.configure(receipt: receipt)
        cell.onImageTap = { [weak self] in
            self?.presenter.onReceiptImageTap(receipt: receipt)
        }
    }

    override func contentChanged() {
        super.contentChanged()
        reloadHeaders()
        subtitleLabel.text = String(format: LocalizedString("next_id"), Database.sharedInstance().nextReceiptID())
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        presenter.receiptDeleteSubject.onNext(object as! WBReceipt)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        self.tapped = tapped as? WBReceipt
        if tableView.isEditing {
            presenter.editReceiptSubject.onNext(self.tapped)
        } else {
            presenter.receiptActionsSubject.onNext(self.tapped)
        }
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return displayData.fetchedModelAdapter
    }
    
    @objc func settingsSaved() {
        if showReceiptDate == WBPreferences.layoutShowReceiptDate()
            && showReceiptCategory == WBPreferences.layoutShowReceiptCategory()
            && showAttachmentMarker == WBPreferences.layoutShowReceiptAttachmentMarker()
            && lastDateFormat == WBPreferences.dateFormat() {
            return
        }
        
        lastDateFormat = WBPreferences.dateFormat()
        showReceiptDate = WBPreferences.layoutShowReceiptDate()
        showReceiptCategory = WBPreferences.layoutShowReceiptCategory()
        showAttachmentMarker = WBPreferences.layoutShowReceiptAttachmentMarker()
    }
    
    //MARK: Private
    
    private func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(tripUpdated(_:)), name: .DatabaseDidUpdateModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsSaved), name: .SmartReceiptsSettingsSaved, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeTooltip() {
        presenter.tooltipPresenter.errorTap.subscribe(onNext: { [weak self] error in
            if error == .userRevokedRemoteRights {
                self?.presenter.presentBackups()
            } else if error == .userDeletedRemoteData {
                _ = BackupProvidersManager.shared.clearCurrentBackupConfiguration()
                    .subscribe(onCompleted: {
                        SyncService.shared.trySyncData()
                    })
            } else if error == .noRemoteDiskSpace {
                BackupProvidersManager.shared.markErrorResolved(syncErrorType: .noRemoteDiskSpace)
            }
        }).disposed(by: bag)
        
        presenter.tooltipPresenter.generateTap.subscribe(onNext: { [weak self] in
            self?.tripTabBarConroller?.openTab(at: 3)
        }).disposed(by: bag)
        
        presenter.tooltipPresenter.reminderTap.do(onNext: {
            AnalyticsManager.sharedManager.record(event: Event.clickedBackupReminderTip())
        }).subscribe(onNext: { [weak self] in
            self?.presenter.presentBackups()
        }).disposed(by: bag)
    }
}

extension ReceiptsView: TabHasMainAction {
    func mainAction() {
        let sheet = ActionSheet()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(title: LocalizedString("receipt_action_camera"), image: #imageLiteral(resourceName: "camera"))
                .bind(to: presenter.createReceiptCameraSubject)
                .disposed(by: bag)
        }
    
        sheet.addAction(title: LocalizedString("receipt_action_text"), image: #imageLiteral(resourceName: "file-text"))
            .bind(to: presenter.createReceiptTextSubject)
            .disposed(by: bag)
        
        sheet.addAction(title: LocalizedString("manual_backup_import"), image: #imageLiteral(resourceName: "file-plus"))
            .bind(to: presenter.importReceiptFileSubject)
            .disposed(by: bag)
        
        sheet.show()
    }
}

//MARK: UIDocumentInteractionControllerDelegate
extension ReceiptsView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().barTintColor = .violetMain
        UINavigationBar.appearance().tintColor = .white
        return navigationController ?? self
    }
}

//MARK: UIViewControllerPreviewingDelegate
extension ReceiptsView: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(UINavigationController(rootViewController: viewControllerToCommit), animated: true, completion: nil)
        viewControllerToCommit.interface(EditReceiptModuleInterface.self)?.makeNameFirstResponder()
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil}
        let receipt = objectAtIndexPath(indexPath) as! WBReceipt
        
        let module = AppModules.editReceipt.build()
        let data = (trip: trip!, receipt: receipt)
        module.presenter.setupView(data: data)
        
        let previewInterface = module.interface(EditReceiptModuleInterface.self)
        previewInterface.disableFirstResponder()
        
        previewInterface.removeAction
            .bind(to: presenter.receiptDeleteSubject)
            .disposed(by: bag)
        
        previewInterface
            .showAttachmentAction.subscribe(onNext: { [unowned self] receipt in
                self.presenter.presentAttachment(for: receipt)
            }).disposed(by: bag)
        
        return module.view.viewController
    }
}

extension ReceiptsView {
    
    func reloadHeaders() {
        let visibleSections = Set(tableView.indexPathsForVisibleRows?.compactMap { $0.section } ?? [])
        visibleSections.forEach { section in
            guard let header = tableView.headerView(forSection: section) as? ReceiptsSectionHeader else { return }
            configure(header: header, section: section)
        }
    }
    
    func price(section: Int) -> String {
        let firstReceipt = dataSource.object(at: IndexPath(row: 0, section: section)) as! WBReceipt
        let price = fetchedItems
            .map { $0 as! WBReceipt }
            .filter { $0.sectionDate == firstReceipt.sectionDate }
            .reduce(PricesCollection(), { result, receipt in
                result.addPrice(receipt.price())
                return result
            }).currencyFormattedTotalPrice()
        
        return price.isEmpty ? Price(currencyCode: firstReceipt.trip.defaultCurrency.code).currencyFormattedPrice() : price
    }
    
    private func configure(header: ReceiptsSectionHeader, section: Int) {
        guard let title = dataSource.tableView(tableView, titleForHeaderInSection: section) else { return }
        _ = header.configure(title: title, subtitle: price(section: section))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.tableView(tableView, titleForHeaderInSection: section) else { return UIView(frame: .zero) }
        let header = tableView.dequeueHeaderFooter(headerFooter: ReceiptsSectionHeader.self)
        return header.configure(title: title, subtitle: price(section: section))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constatns.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Float.ulpOfOne)
    }
    
    private enum Constatns {
        static let headerHeight: CGFloat = 54
        
    }
}

//MARK: - Public interface
extension ReceiptsView: ReceiptsViewInterface {
    func setup(trip: WBTrip) {
        self.trip = trip
    }
    
    func setup(fetchedModelAdapter: FetchedModelAdapter) {
        displayData.fetchedModelAdapter = fetchedModelAdapter
    }
    
    var viewForTooltip: UIView {
        return view
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsView {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
    var displayData: ReceiptsDisplayData {
        return _displayData as! ReceiptsDisplayData
    }
}
