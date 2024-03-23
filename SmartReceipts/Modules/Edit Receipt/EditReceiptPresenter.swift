//
//  EditReceiptPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import UserNotifications

fileprivate let ANIMATIONS_DURATION: RxTimeInterval = .milliseconds(600)
protocol EditReceiptModuleInterface {
    var removeAction: Observable<WBReceipt> { get }
    var showAttachmentAction: Observable<WBReceipt> { get }
    
    func disableFirstResponder()
    func makeNameFirstResponder()
}

class EditReceiptPresenter: Presenter {
    
    let addReceiptSubject = PublishSubject<WBReceipt>()
    let updateReceiptSubject = PublishSubject<WBReceipt>()
    let settingsTap = PublishSubject<Void>()
    let tooltipClose = PublishSubject<Void>()
    let tooltipTap = PublishSubject<Void>()
    let paymentMehtodInsert = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        
        settingsTap.subscribe(onNext: { [unowned self] in
            self.router.openSettings()
        }).disposed(by: bag)
        
        view.managePaymentMethodsTap?
            .do(onNext:{
                AnalyticsManager.sharedManager.record(event: Event.receiptsManagePaymentMethodsTap())
            }).subscribe(onNext: { [unowned self] in
                self.router.openPaymentMethods()
            }).disposed(by: bag)
        
        view.manageCategoriesTap?
            .do(onNext:{
                AnalyticsManager.sharedManager.record(event: Event.receiptsManageCategoriesTap())
            }).subscribe(onNext: { [unowned self] in
                self.router.openCategories()
            }).disposed(by: bag)
        
        tooltipTap.subscribe(onNext: { [weak self] in
            guard let authModule = self?.router.openAuth() else { return }
            _ = authModule.successAuth
                .do(onNext: { authModule.close() })
                .delay(ANIMATIONS_DURATION, scheduler: MainScheduler.instance)
                .flatMap({ _ -> Observable<UNAuthorizationStatus> in
                    PushNotificationService.shared.authorizationStatus()
                }).flatMap({ status -> Observable<Void> in
                    let text = LocalizedString("push_request_alert_text")
                    return status == .notDetermined ? UIAlertController.showInfo(text: text) : Observable<Void>.just(())
                }).subscribe(onNext: { [unowned self] in
                    _ = PushNotificationService.shared.requestAuthorization().subscribe()
                    self?.router.openAutoScans()
                })
        }).disposed(by: bag)
        
        router.prepareInterstitialAd()
    }
    
    override func setupView(data: Any) {
        if let inputData = data as? (trip: WBTrip, receipt: WBReceipt?) {
            view.setup(trip: inputData.trip, receipt: inputData.receipt)
        } else if let scanData = data as? (trip: WBTrip, scan: ScanResult) {
            view.setup(trip: scanData.trip, receipt: nil)
            view.setup(scanResult: scanData.scan)
            interactor.receiptFilePath = scanData.scan.filepath
        }
    }
    
    func close() {
        router.close()
    }
    
    func done() {
        router.done(completion: router.openInterstitialAd)
    }
    
    func present(errorDescription: String) {
        router.openAlert(title: nil, message: errorDescription)
    }
    
    func tooltipText() -> String? {
        interactor.tooltipText()
    }
}

// MARK: EditReceiptModuleInterface

extension EditReceiptPresenter: EditReceiptModuleInterface {
    func disableFirstResponder() {
        view.disableFirstResponeder()
    }
    
    func makeNameFirstResponder() {
        view.makeNameFirstResponder()
    }
    
    var removeAction: Observable<WBReceipt> { return view.removeAction }
    
    var showAttachmentAction: Observable<WBReceipt> { return view.showAttachmentAction }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptPresenter {
    var view: EditReceiptViewInterface {
        return _view as! EditReceiptViewInterface
    }
    var interactor: EditReceiptInteractor {
        return _interactor as! EditReceiptInteractor
    }
    var router: EditReceiptRouter {
        return _router as! EditReceiptRouter
    }
}
