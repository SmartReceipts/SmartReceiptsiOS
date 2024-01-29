//
//  SubscriptionBuilder.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa

public struct SubscriptionEnvironment {
    let purchaseService: PurchaseService
    let router: SubscriptionRouter
    let authService: AuthService
    
    init(purchaseService: PurchaseService, router: SubscriptionRouter, authService: AuthService ) {
        self.purchaseService = purchaseService
        self.router = router
        self.authService = authService
    }
}

public enum SubscriptionBuilder {
    public static func build() -> UIViewController {
        let purchaseService = PurchaseService()
        let router = SubscriptionRouter()
        let authService = AuthService()
        let environment = SubscriptionEnvironment(
            purchaseService: purchaseService,
            router: router,
            authService: authService
        )
        let viewModel = SubscriptionViewModel(environment: environment)
        let dataSource = SubscriptionDataSource()
        let vc = SubscriptionViewController(dataSource: dataSource)
        router.moduleViewController = vc
        vc.output.drive(onNext: {
            viewModel.accept(action: $0)
        }).disposed(by: vc.bag)
        vc.bind(viewModel.output.map(convert(state:)))
        return vc
    }
    
    private static func convert(
        state: SubscriptionViewModel.State
    ) -> SubscriptionViewController.ViewState {
        let plans = state.plans
        var purchaseViewState: SubscriptionViewController.PurchaseViewState = .notPurchased
        var contentViewState: SubscriptionViewController.ContentViewState? = nil
        if state.isLoading {
            contentViewState = .loading
        } else {
            contentViewState = .loaded
        }
        plans.forEach { model in
            if model.isPurchased {
                purchaseViewState = .purchased
            }
        }
        return .init(
            collection: [PlanSectionItem(items: plans)],
            purchaseViewState: purchaseViewState,
            contentViewState: contentViewState,
            needUpdatePlansAfterPurchased: state.needUpdatePlansAfterPurchased
        )
    }
}
