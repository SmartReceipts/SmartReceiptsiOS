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
    var items: Driver<[PlanSectionItem]> { itemsReplay.asDriver() }
    var isPurchased: Driver<Bool> { isPurchasedReplay.asDriver() }
    
    private let purchaseService: PurchaseService
    private let router: SubscriptionRouter
    
    private var itemsReplay = BehaviorRelay<[PlanSectionItem]>(value: [])
    private var isPurchasedReplay = BehaviorRelay<Bool>(value: false)
    private(set) var plans = [PlanSectionItem]()
    private let bag = DisposeBag()
    
    init(purchaseService: PurchaseService, router: SubscriptionRouter) {
        self.purchaseService = purchaseService
        self.router = router
    }
    
    func accept(_ action: Action) {
        switch action {
        case .viewDidLoad:
            getPlanSectionItems()
        case .didSelect(let model):
            isPurchased
                .asObservable()
                .subscribe(onNext: { [weak self] isPurchased in
                    if !isPurchased { self?.purchase(productId: model.id) }
                })
                .disposed(by: bag)
        }
    }
    
    private func getProducts() -> Single<[SKProduct]> {
        let ids: Set = [PRODUCT_STANDARD_SUB, PRODUCT_PREMIUM_SUB]
        return Single<[SKProduct]>.create { single in
            SwiftyStoreKit.retrieveProductsInfo(ids) { result in
                if let error = result.error {
                    single(.error(error))
                    let errorEvent = ErrorEvent(error: error)
                    AnalyticsManager.sharedManager.record(event: errorEvent)
                } else {
                    single(.success(Array(result.retrievedProducts)))
                }
            }
            return Disposables.create()
        }
    }
    
    private func getPlanSectionItems() {
        let hud = PendingHUDView.showFullScreen()
        getProducts()
            .map({ product in
                return product.sorted { (product1, product2) -> Bool in
                    return product1.localizedPrice < product2.localizedPrice
                }
            })
            .subscribe(onSuccess: { [weak self] in
                hud.hide()

                guard let self = self else { return }
                self.plans = $0.compactMap { product in
                    PlanSectionItem(
                        items: [
                            PlanModel(
                            kind: product.productIdentifier == PRODUCT_STANDARD_SUB ? .standard : .premium,
                            price: product.localizedPrice,
                            isPurchased: product.productIdentifier == PRODUCT_STANDARD_SUB ? true : false )
                    ])
                }
                
                self.itemsReplay.accept(self.plans)
            }, onError: { error in
                hud.hide()
                Logger.error(String(describing: error))
            })
            .disposed(by: bag)
    }
    
    private func purchase(productId: String) {
        let hud = PendingHUDView.showFullScreen()
        purchaseService.purchase(prodcutID: productId)
            .subscribe(onNext: { _ in
                hud.hide()
                self.isPurchasedReplay.accept(true)
                self.router.open(route: .showSuccessPage)
            }, onError: { error in
                hud.hide()
            })
            .disposed(by: bag)
    }
}

extension SubscriptionViewModel {
    enum State {
        case loading
        case loaded
    }
    
    enum Action {
        case viewDidLoad
        case didSelect(PlanModel)
    }
}
