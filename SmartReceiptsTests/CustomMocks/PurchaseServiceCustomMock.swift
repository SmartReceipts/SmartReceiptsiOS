//
//  PurchaseServiceCustomMock.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 15/04/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxSwift

class PurchaseServiceCustomMockSuccess: PurchaseService {
    override func validateSubscription() -> Observable<SubscriptionValidation> {
        return Observable<SubscriptionValidation>.just(
            SubscriptionValidation(
                plusValid: true,
                plusExpireTime: Date().addingTimeInterval(300),
                standardPurchased: false,
                premiumPurchased: true
            )
        )
    }
}

class PurchaseServiceCustomMockFail: PurchaseService {
    override func validateSubscription() -> Observable<SubscriptionValidation> {
        return Observable<SubscriptionValidation>.just(
            SubscriptionValidation(
                plusValid: false,
                plusExpireTime: nil,
                standardPurchased: false,
                premiumPurchased: false
            )
        )
    }
}
