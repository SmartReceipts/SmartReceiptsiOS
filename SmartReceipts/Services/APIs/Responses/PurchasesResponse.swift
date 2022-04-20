//
//  PurchasesResponse.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

struct PurchasesResponse: Codable {
    private(set) var purchases: [PurchaseModel]
}

struct PurchaseModel: Codable {
    private(set) var id: String
    private(set) var productId: String
    private(set) var purchaseTime: Date
    private(set) var subscriptionActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case purchaseTime = "purchase_time"
        case subscriptionActive = "subscription_active"
    }
}
