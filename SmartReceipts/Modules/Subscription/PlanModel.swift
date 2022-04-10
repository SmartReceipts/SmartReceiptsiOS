//
//  SubscriptionModel.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

struct PlanModel {
    enum Kind {
        case standard
        case premium
    }
    
    var id: String {
        switch kind {
        case .standard:
            return PRODUCT_STANDARD_SUB
        case .premium:
            return PRODUCT_PREMIUM_SUB
        }
    }
    let kind: Kind
    var name: String {
        switch kind {
        case .standard:
            return LocalizedString("subscription_standart")
        case .premium:
            return LocalizedString("subscription_premium")
        }
    }
    let price: String
    let isPurchased: Bool
    var functionDescription: String {
        switch kind {
        case .standard:
            return LocalizedString("subscription_main_functions")
        case .premium:
            return LocalizedString("subscription_disable_all_ads")
        }
    }
}
