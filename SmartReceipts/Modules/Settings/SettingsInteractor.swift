//
//  SettingsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import StoreKit
import RxSwift

class SettingsInteractor: Interactor {
    private let purchaseService = PurchaseService()
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return purchaseService.price(productID: PRODUCT_PLUS)
            .map({ "\($0)/yr" })
    }
    
    func restoreSubscription() -> Observable<SubscriptionValidation> {
        return purchaseService.forceValidateSubscription()
            .do(onNext: { validation in
                if validation.adsRemoved {
                    NotificationCenter.default.post(name: .SmartReceiptsAdsRemoved, object: nil)
                }
            })
    }
    
    func purchaseSubscription() -> Observable<Void> {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SmartReceiptsPlusOverflow)
        return purchaseService.purchasePlusSubscription().asVoid()
    }
    
    func subscriptionValidation() -> Observable<SubscriptionValidation> {
        return purchaseService.validateSubscription()
    }
    
    func hasValidSubscription() -> Bool {
        return PurchaseService.hasValidAllSubscription
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsInteractor {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}
