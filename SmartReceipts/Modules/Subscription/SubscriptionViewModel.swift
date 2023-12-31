//
//  SubscriptionViewModel.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import StoreKit
import SwiftyStoreKit
import Toaster

final class SubscriptionViewModel {
    struct State {
        var isLoggin: LogginState?
        var plans: [PlanModel]
        var needUpdatePlansAfterPurchased: Bool
    }
    
    enum Action {
        case viewDidLoad
        case didSelect(PlanModel)
        case loginTapped
        case openSubscriptions
        case close
    }
    
    enum LogginState {
        case loading
        case noAuth
        case auth
    }
    
    var output: Driver<State> { state.asDriver() }
        
    private let environment: SubscriptionEnvironment
    private let state = BehaviorRelay<State>.init(
        value: State(
            isLoggin: nil,
            plans: [],
            needUpdatePlansAfterPurchased: false
        )
    )
    private let bag = DisposeBag()
    
    init(environment: SubscriptionEnvironment) {
        self.environment = environment
        AnalyticsManager.sharedManager.record(event: Event.subscriptionShown())
    }
    
    deinit {
        AnalyticsManager.sharedManager.record(event: Event.subscriptionClose())
    }
    
    func accept(action: Action) {
        switch action {
        case .viewDidLoad:
            state.update { $0.isLoggin = .noAuth }
            if environment.authService.isLoggedIn {
                state.update { $0.isLoggin = .auth }
                updatePlanSectionItems()
                return
            }
        case .didSelect(let model):
            guard !model.isPurchased else { return }
            purchase(productId: model.id)
            AnalyticsManager.sharedManager.record(
                event: Event.subscriptionTapped(productId: model.id)
            )
        case .loginTapped:
            openLogin()
        case .openSubscriptions:
            environment.router.openSubscriptions()
        case .close:
            environment.router.close()
        }
    }
    
    private func openLogin() {
        environment.router.openLogin()
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.state.update { $0.isLoggin = .auth }
                self.updatePlanSectionItems()
                AnalyticsManager.sharedManager.record(event: Event.subscriptionShowLogin())
            }, onError: { error in
                Logger.error(error.localizedDescription)
                AnalyticsManager.sharedManager.record(event: Event.subsctiptionLoginFailed())
            }).disposed(by: bag)
    }
    
    private func updatePlanSectionItems() {
        let hud = PendingHUDView.showFullScreen()
        state.update { $0.isLoggin = .loading }
        getPlansWithPurchases()
            .map { $0.sorted { plan, _ in plan.kind == .premium } }
            .debug("UPDATE PLAN SECTION ITEMS")
            .subscribe(with: self, onSuccess: { viewModel, plans in
                hud.hide()
                viewModel.state.update { $0.isLoggin = .auth }
                viewModel.state.update { $0.plans = plans }
            }, onFailure: { viewModel, error in
                hud.hide()
                Logger.error(error.localizedDescription)
                viewModel.environment.router.handlerError(
                    errorMessage: error.localizedDescription,
                    retryAction: { viewModel.updatePlanSectionItems() }
                )
            })
            .disposed(by: bag)
    }
    
    private func purchase(productId: String) {
        let hud = PendingHUDView.showFullScreen()
        environment.purchaseService.purchase(prodcutID: productId)
            .subscribe(with: self, onNext: { viewModel, purchase in
                hud.hide()
                viewModel.environment.purchaseService.markAppStoreInteracted()
                viewModel.environment.purchaseService.resetCache()
            }, onError: { viewModel, error in
                hud.hide()
                Logger.warning("Failed to payment: \(error.localizedDescription)")
                viewModel.environment.router.handlerError(
                    errorMessage: error.localizedDescription,
                    retryAction: { viewModel.purchase(productId: productId) }
                )
                AnalyticsManager.sharedManager.record(event: Event.subscriptionPurchaseFailed())
            }, onCompleted: { viewModel in
                hud.hide()
                viewModel.environment.router.openSuccessPage(updateState: viewModel.updatePlanSectionItems)
                viewModel.state.update { $0.needUpdatePlansAfterPurchased = true }
                Logger.debug("Successuful payment: \(productId)")
                AnalyticsManager.sharedManager.record(
                    event: Event.subscriptionPurchaseSuccess(productId: productId)
                )
            })
            .disposed(by: bag)
    }
}

extension SubscriptionViewModel {
    private func getPlansWithPurchases() -> Single<[PlanModel]> {
        guard let receiptString = environment.purchaseService.appStoreReceipt() else {
            return getPlansByProducts()
        }
        return environment.purchaseService.getProducts()
            .flatMap({ [weak self] products -> Single<[PlanModel]> in
                guard let self = self else { return .never() }
                let standardPrice = products.first(where: { $0.productIdentifier == PRODUCT_STANDARD_SUB })?.localizedPrice
                let premiumPrice = products.first(where: { $0.productIdentifier == PRODUCT_PREMIUM_SUB })?.localizedPrice
                return self.getPlansByMobilePurchases(
                    standardPrice: standardPrice ?? "0",
                    premiumPrice: premiumPrice ?? "0",
                    receiptString: receiptString
                )
            })
    }
    
    private func getPlansByMobilePurchases(
        standardPrice: String,
        premiumPrice: String,
        receiptString: String
    ) -> Single<[PlanModel]> {
        return environment.purchaseService.requestMobilePurchasesV2(receiptString: receiptString)
            .map({ purchases -> [PlanModel] in
                let sortedPurchases = purchases.sorted(by: { $0.purchaseTime < $1.purchaseTime })
                let standardPurchase = sortedPurchases.last(where: { $0.productId == PRODUCT_STANDARD_SUB })
                let premiumPurchase = sortedPurchases.last(where: { $0.productId == PRODUCT_PREMIUM_SUB })
                var plansModel = [PlanModel]()
                
                plansModel.append(PlanModel(
                    kind: .standard,
                    price: standardPrice,
                    isPurchased: standardPurchase?.subscriptionActive ?? false
                ))
                
                plansModel.append(PlanModel(
                    kind: .premium,
                    price: premiumPrice,
                    isPurchased: premiumPurchase?.subscriptionActive ?? false
                ))
                
                return plansModel
            })
    }
    
    private func getPlansByProducts() -> Single<[PlanModel]> {
        return environment.purchaseService.getProducts()
            .map { $0.sorted { product, _ in product.productIdentifier == PRODUCT_STANDARD_SUB } }
            .map { products -> [PlanModel] in
                return products.compactMap { product in
                    PlanModel(
                        kind: product.productIdentifier == PRODUCT_STANDARD_SUB ? .standard : .premium,
                        price: product.localizedPrice,
                        isPurchased: false
                    )
                }
            }
    }
}
