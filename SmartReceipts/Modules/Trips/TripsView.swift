//
//  TripsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol TripsViewInterface {
    var privacyTap: Observable<Void> { get }
    var addButtonTap: Observable<Void> { get }
}

//MARK: Trips View
final class TripsView: FetchedTableViewController {
    @IBOutlet fileprivate weak var moreButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var editItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var addItem: UIBarButtonItem!
    
    fileprivate let privacySubject = PublishSubject<Void>()
    
    private var lastDateFormat: String!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppTheme.customizeOnViewDidLoad(self)
        lastDateFormat = WBPreferences.dateFormat()
        setPresentationCellNib(TripCell.viewNib())
        title = PurchaseService.hasValidPlusSubscriptionValue ? AppTheme.appTitlePlus : AppTheme.appTitle
        
        configurePrivacyTooltip()
        configureRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configureRx() {
        Observable<Void>.merge(AppNotificationCenter.syncProvider.asVoid(), AppNotificationCenter.didSyncBackup)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.SmartReceiptsSettingsSaved)
            .subscribe(onNext: { [weak self] _ in
                self?.settingsSaved()
            }).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.SmartReceiptsAdsRemoved)
            .subscribe(onNext: { [weak self] _ in
                self?.title = AppTheme.appTitlePlus
            }).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.SmartReceiptsImport)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchObjects()
            }).disposed(by: bag)
        
        editItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.setEditing(!self.isEditing, animated: true)
            }).disposed(by: bag)
        
        moreButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                MainMenuActionSheet(openOn: self).show()
            }).disposed(by: bag)
    }
    
    func configurePrivacyTooltip() {
        guard let tooltip = TooltipService.shared.tooltipText(for: .trips) else { return }
        let tooltipView = TooltipView.showOn(view: view, text: tooltip)
        tableView.contentInset = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)

        weak var weakTable = tableView
        tooltipView.rx.action
            .do(onNext: {
                TooltipService.shared.markPrivacyOpened()
                weakTable?.contentInset = .zero
            }).bind(to: privacySubject)
            .disposed(by: bag)
        
        tooltipView.rx.close
            .subscribe(onNext: {
                TooltipService.shared.markPrivacyDismissed()
                weakTable?.contentInset = .zero
            }).disposed(by: bag)
    }
    
    private func settingsSaved() {
        if lastDateFormat == WBPreferences.dateFormat() { return }
        lastDateFormat = WBPreferences.dateFormat()
        tableView.reloadData()
    }
    
    override var placeholderTitle: String {
        get { return LocalizedString("trip_no_data") }
    }

    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return presenter.fetchedModelAdapter()
    }
    
    override func configureCell(cell: UITableViewCell, item: Any) {
        let pCell = cell as! TripCell
        let trip = item as! WBTrip
        let selected = WBPreferences.lastOpenedTrip?.objectId == trip.objectId
        pCell.configure(trip: trip, selected: selected)
    }
    
    override func configureSubrcibers(for adapter: FetchedModelAdapter?) {
        super.configureSubrcibers(for: adapter)
        guard let fetchedModelAdapter = adapter else { return }
        
        fetchedModelAdapter.rx.didInsert.subscribe(onNext: { [unowned self] action in
            self.presenter.tripSelectedSubject.onNext(action.object as! WBTrip)
        }).disposed(by: bag)
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        let trip = object as! WBTrip
        if WBPreferences.lastOpenedTrip?.objectId == trip.objectId {
            if #available(iOS 13.0, *) {
                navigationController?.isModalInPresentation = true
            }
        }
        presenter.tripDeleteSubject.onNext(trip)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        let trip = tapped as! WBTrip
        isEditing ? presenter.tripEditSubject.onNext(trip) : presenter.tripSelectedSubject.onNext(trip)
    }
    
    override func contentChanged() {
        super.contentChanged()
    }
}

//MARK: - Public interface
extension TripsView: TripsViewInterface {
    var privacyTap: Observable<Void> { return privacySubject }
    var addButtonTap: Observable<Void> { return addItem.rx.tap.asObservable() }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsView {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
    var displayData: TripsDisplayData {
        return _displayData as! TripsDisplayData
    }
}
