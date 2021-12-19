//
//  PlanAPI.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 14.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import Foundation

class PlanAPI {
    
    static func getPlans() -> [PlanModel] {
        let plans = [
            PlanModel(
                name: "Standard",
                kind: .standard,
                price: 2.99,
                isPurchased: false,
                functionDescription: "Main functions"
            ),
            PlanModel(
                name: "Premium",
                kind: .premium,
                price: 3.99,
                isPurchased: true,
                functionDescription: "Disable all ads"
            )
        ]
        
        return plans
    }
}
