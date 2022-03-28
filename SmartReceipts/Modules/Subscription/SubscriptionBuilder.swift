//
//  SubscriptionBuilder.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

public enum SubscriptionBuilder {
    public static func build() -> UIViewController {
        let purchaseService = PurchaseService()
        let router = SubscriptionRouter()
        let model = SubscriptionViewModel(purchaseService: purchaseService, router: router)
        let dataSource = SubscriptionDataSource()
        let controller = SubscriptionViewController(viewModel: model, dataSource: dataSource)
        router.moduleViewController = controller
        return controller
    }
}
