//
//  SubscriptionViewState.swift
//  SmartReceipts
//
//  Created by a.agataev on 09.04.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation
import UIKit

extension SubscriptionViewController {
    struct ViewState {
        let collection: [PlanSectionItem]
        var purchaseViewState: PurchaseViewState
        var contentViewState: ContentViewState?
        var needUpdatePlansAfterPurchased: Bool
    }
    
    enum PurchaseViewState {
        case notPurchased
        case purchased
        
        var choosePlanTitle: String {
            switch self {
            case .notPurchased:
                return LocalizedString("subscription_plan_label")
            case .purchased:
                return LocalizedString("subscription_plan_label")
            }
        }
        
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
    
    enum ContentViewState {
        case loading
        case loaded
        
        var choosePlanIsHidden: Bool {
            switch self {
            case .loading:
                return true
            case .loaded:
                return false
            }
        }
        
        var labelStackViewIsHidden: Bool {
            switch self {
            case .loading:
                return true
            case .loaded:
                return false
            }
        }
        
        var imageStackViewIsHidden: Bool {
            switch self {
            case .loading:
                return true
            case .loaded:
                return false
            }
        }
    }
}
