//
//  SubscriptionAPI.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 14.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import Foundation

class SubscriptionAPI {
    
    static func getSubscriptions() -> [Subscription] {
        let subscriptions = [
            Subscription(
                name: "Standard",
                kind: .standard,
                price: 2.99,
                functionDescription: "Main functions"
            ),
            Subscription(
                name: "Premium",
                kind: .premium,
                price: 3.99,
                functionDescription: "Disable all ads"
            )
        ]
        
        return subscriptions
    }
}
