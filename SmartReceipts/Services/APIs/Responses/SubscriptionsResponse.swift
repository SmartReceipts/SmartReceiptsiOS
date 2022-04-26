//
//  SubscriptionsResponse.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

struct SubscriptionsResponse: Codable {
    private(set) var subscriptions: [SubscriptionModel]
}

struct SubscriptionModel: Codable {
    private(set) var id: Int
    private(set) var subscriptionProvider: String
    private(set) var productName: String
    private(set) var purchasedAt: Date
    private(set) var expiresAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case subscriptionProvider = "subscription_provider"
        case productName = "product_name"
        case purchasedAt = "purchased_at"
        case expiresAt = "expires_at_iso8601"
    }
}
