//
//  PlanModel.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 14.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import Foundation

enum Kind {
    case standard
    case premium
}

struct PlanModel {
    let name: String
    let kind: Kind
    let price: Double
    let isPurchased: Bool
    let functionDescription: String
}
