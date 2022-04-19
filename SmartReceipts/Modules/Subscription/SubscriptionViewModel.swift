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
        var plans: [PlanModel]
    }
    
    enum Action {
        case viewDidLoad
        case didSelect(PlanModel)
    }
    
    var output: Driver<State> { state.asDriver() }
        
    private let environment: SubscriptionEnvironment
    private let state = BehaviorRelay<State>.init(value: State(plans: []))
    private let isPurchasedRelay = BehaviorRelay<Bool>.init(value: false)
    private var isAuthorizedRelay = BehaviorRelay<Bool>(value: false)
    private let bag = DisposeBag()
    
    init(environment: SubscriptionEnvironment) {
        self.environment = environment
    }
    
    func accept(action: Action) {
        switch action {
        case .viewDidLoad:
            getPlanSectionItems()
        case .didSelect(let model):
            isHasPurchased()
            isPurchasedRelay
                .asObservable()
                .subscribe(onNext: { [weak self] isPurchased in
                    guard let self = self else { return }
                    if !isPurchased { self.purchase(productId: model.id) }
                })
                .disposed(by: bag)
        }
    }
    
    private func getPlanSectionItems() {
        let hud = PendingHUDView.showFullScreen()
        getPlansWithPurchases()
            .map { $0.sorted { plan, _ in plan.kind == .standard } }
            .subscribe(
                onSuccess: { [weak self] plans in
                    hud.hide()
                    guard let self = self else { return }
                    self.state.update { $0.plans = plans }
                }).disposed(by: bag)
    }
    
    private func purchase(productId: String) {
        let hud = PendingHUDView.showFullScreen()
        environment.purchaseService.purchase(prodcutID: productId)
            .subscribe(onNext: { _ in
                hud.hide()
            }, onError: { error in
                hud.hide()
            }, onCompleted: { [weak self] in
                self?.environment.router.openSuccessPage()
            }).disposed(by: bag)
    }
}

extension SubscriptionViewModel {
    private func getPlansWithPurchases() -> Single<[PlanModel]> {
        auth()
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
            .map({ purchasesModel -> [PlanModel] in
                purchasesModel
                    .sorted(by: { $0.purchasedTime < $1.purchasedTime })
                    .map({
                        PlanModel(
                            kind: $0.productId == PRODUCT_STANDARD_SUB ? .standard : .premium,
                            price: $0.productId == PRODUCT_STANDARD_SUB ? standardPrice : premiumPrice,
                            isPurchased: $0.subscriptionActive
                        )
                    })
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
    
    private func isHasPurchased() {
        getPlansWithPurchases()
            .map { $0.sorted { plan, _ in plan.kind == .standard } }
            .subscribe(
                onSuccess: { [weak self] plans in
                    guard let self = self else { return }
                    plans.forEach { plan in
                        if plan.isPurchased {
                            self.isPurchasedRelay.accept(true)
                        }
                    }
                })
            .disposed(by: bag)
    }
    
    private func auth() {
        if !environment.authService.isLoggedIn {
            environment.router.openLogin()
                .subscribe { event in
                    print(event)
                }.disposed(by: bag)
        }
    }
}
