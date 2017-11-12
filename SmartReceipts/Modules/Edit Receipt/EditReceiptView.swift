//
//  EditReceiptView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol EditReceiptViewInterface {
    func setup(trip: WBTrip, receipt: WBReceipt?)
    func setup(scan: Scan)
}

//MARK: EditReceiptView Class
final class EditReceiptView: UserInterface {
    
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    private weak var formView: EditReceiptFormView!
    private weak var tooltip: TooltipView?
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        let formView = EditReceiptFormView(trip: displayData.trip, receipt: displayData.receipt)
        self.formView = formView
        formView.apply(scan: displayData.scan)
        formView.settingsTap = presenter.settingsTap
        addChildViewController(formView)
        view.addSubview(formView.view)
        
        configureUIActions()
        configureSubscribers()
        configureTooltip()
    }
    
    override func viewWillLayoutSubviews() {
        tooltip?.updateFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.presenter.close()
        }).disposed(by: bag)
        
        doneButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.formView.validate()
        }).disposed(by: bag)
    }
    
    private func configureSubscribers() {
        formView.receiptSubject.subscribe(onNext: { [unowned self] receipt in
            self.displayData.receipt == nil ?
                self.presenter.addReceiptSubject.onNext(receipt) :
                self.presenter.updateReceiptSubject.onNext(receipt)
        }).addDisposableTo(bag)
        
        formView.errorSubject.subscribe(onNext: { [unowned self] errorDescription in
            self.presenter.present(errorDescription: errorDescription)
        }).addDisposableTo(bag)
    }
    
    private func configureTitle() {
        // We will add rx for database in future, and it will looks better.
        DispatchQueue(label: "com.smartreceipts.background").async { [weak self] in
            var newTitle: String!
            var id: UInt!
            if self?.displayData.receipt == nil {
                id = Database.sharedInstance().nextReceiptID()
                newTitle = LocalizedString("edit.receipt.controller.add.title")
            } else {
                id = self?.displayData.receipt!.objectId
                newTitle = LocalizedString("edit.receipt.controller.edit.title")
            }
            newTitle = WBPreferences.showReceiptID() ? newTitle + " - \(id!)" : newTitle
            DispatchQueue.main.async { [weak self] in
                self?.title = newTitle
            }
        }
    }
    
    private func configureTooltip() {
        if let text = presenter.tooltipText() {
            var screenWidth = false
            executeFor(iPhone: { screenWidth = true }, iPad: { screenWidth = false })
            tooltip = TooltipView.showOn(view: view, text: text, offset: CGPoint.zero, screenWidth: screenWidth)
            formView.tableView.contentInset = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)
            
            tooltip?.rx.tap
                .do(onNext: onTooltipClose)
                .bind(to: presenter.tooltipTap)
                .disposed(by: bag)
            
            tooltip?.rx.close
                .do(onNext: onTooltipClose)
                .bind(to: presenter.tooltipClose)
                .disposed(by: bag)
        }
    }
    
    private func onTooltipClose() {
        UIView.animate(withDuration: 0.3, animations: {
            self.formView.tableView.contentInset = UIEdgeInsets.zero
        })
    }
    
}

//MARK: - Public interface
extension EditReceiptView: EditReceiptViewInterface {
    func setup(trip: WBTrip, receipt: WBReceipt?) {
        displayData.trip = trip
        displayData.receipt = receipt
    }
    
    func setup(scan: Scan) {
        displayData.scan = scan
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptView {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
    var displayData: EditReceiptDisplayData {
        return _displayData as! EditReceiptDisplayData
    }
}
