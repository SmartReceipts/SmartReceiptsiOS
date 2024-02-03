//
//  SettingsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import StoreKit

typealias AlertTuple = (title: String?, message: String)

class SettingsPresenter: Presenter {
    
    let openModuleSubject = PublishSubject<SettingsRoutes>()
    let alertSubject = PublishSubject<AlertTuple>()
    private let bag = DisposeBag()
    
    override func setupView(data: Any) {
        view.setupShowSettingsOption(data as? ShowSettingsOption)
    }
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        view.doneButton.rx.tap.subscribe(onNext: { [unowned self] in
            NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsSettingsSaved, object: nil)
            self.router.close()
        }).disposed(by: bag)
        
        openModuleSubject.subscribe(onNext: { [unowned self] route in
            self.router.openRoute(route)
        }).disposed(by: bag)
        
        alertSubject.subscribe(onNext: { [unowned self] alert in
            self.router.openAlert(title: alert.title, message: alert.message)
        }).disposed(by: bag)
    }
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return interactor.retrivePlusSubscriptionPrice()
    }
    
    func restoreSubscription() -> Observable<SubscriptionValidation> {
        return interactor.restoreSubscription()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return interactor.purchaseSubscription()
    }
    
    func subscriptionValidation() -> Observable<SubscriptionValidation> {
        return interactor.subscriptionValidation()
    }
    
    func hasValidSubscription() -> Bool {
        return interactor.hasValidSubscription()
    }
}

enum ShowSettingsOption {
    case reportCSVOutputSection
    case distanceSection
    case privacySection
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsPresenter {
    var view: SettingsViewInterface {
        return _view as! SettingsViewInterface
    }
    var interactor: SettingsInteractor {
        return _interactor as! SettingsInteractor
    }
    var router: SettingsRouter {
        return _router as! SettingsRouter
    }
}
