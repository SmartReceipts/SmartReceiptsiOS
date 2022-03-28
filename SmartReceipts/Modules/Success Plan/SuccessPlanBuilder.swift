//
//  SuccessPlanBuilder.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

public enum SuccessPlanBuilder {
    public static func build() -> UIViewController {
        let router = SuccessPlanRouter()
        let model = SuccessPlanViewModel(router: router)
        let controller = SuccessPlanViewController(viewModel: model)
        router.moduleViewController = controller
        return controller
    }
}
