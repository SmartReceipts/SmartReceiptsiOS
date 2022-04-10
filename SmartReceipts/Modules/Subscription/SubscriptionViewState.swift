//
//  SubscriptionViewState.swift
//  SmartReceipts
//
//  Created by a.agataev on 09.04.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

extension SubscriptionViewController {
    enum ViewState {
        case content([PlanSectionItem])
        case loading
        case error
        
        var collection: [PlanSectionItem] {
            switch self {
            case .content(let sections):
                return sections
            case .loading, .error:
                return []
            }
        }
    }
}
