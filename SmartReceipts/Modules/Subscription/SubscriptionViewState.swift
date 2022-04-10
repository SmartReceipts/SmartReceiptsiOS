//
//  SubscriptionViewState.swift
//  SmartReceipts
//
//  Created by a.agataev on 09.04.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

extension SubscriptionViewController {
    struct ViewState {
        let collection: [PlanSectionItem]
        var purchaseViewState: PurchaseViewState
    }
    
    enum PurchaseViewState {
        case notPurchased
        case purchased
        
        var firstFunctionTitle: String {
            switch self {
            case .notPurchased:
                return LocalizedString("subscription_first_function")
            case .purchased:
                return LocalizedString("subscription_first_function_active")
            }
        }
        
        var secondFunctionTitle: String {
            switch self {
            case .notPurchased:
                return LocalizedString("subscription_second_function")
            case .purchased:
                return LocalizedString("subscription_second_function_active")
            }
        }
        
        var thirdFunctionTitle: String {
            switch self {
            case .notPurchased:
                return LocalizedString("subscription_third_function")
            case .purchased:
                return LocalizedString("subscription_third_function_active")
            }
        }
        
        var cancelPlanHidden: Bool {
            switch self {
            case .notPurchased:
                return false
            case .purchased:
                return true
            }
        }
    }
}
