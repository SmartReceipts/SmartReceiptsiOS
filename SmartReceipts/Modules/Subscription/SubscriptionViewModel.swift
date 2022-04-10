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
    enum State {
        case loading
        case content([SKProduct])
        case error
        
    }
    
    enum Action {
        case viewDidLoad
        case didSelect(PlanModel)
    }
    
    var output: Driver<State> { state.asDriver() }
        
    private let environment: SubscriptionEnvironment
    private let state = BehaviorRelay<State>.init(value: .loading)
    private var isAuthorizedRelay = BehaviorRelay<Bool>(value: false)
    private let bag = DisposeBag()
    
    init(environment: SubscriptionEnvironment) {
        self.environment = environment
    }
    
    func accept(action: Action) {
        switch action {
        case .viewDidLoad:
            getPlanSectionItems()
        case .didSelect(_):
            ()
        }
    }
    
    func isAvailable() {
        guard let receiptString = environment.purchaseService.appStoreReceipt() else {
            return
        }

        environment.purchaseService.requestMobilePurchasesV2(receiptString: receiptString)
            .subscribe(onSuccess: { planModels in
                print(planModels)
                Logger.debug("Purchase Models")
            })
            .disposed(by: bag)
    }
    
    private func getPlanSectionItems() {
        if environment.authService.isLoggedIn {
            environment.router.openLogin()
        }

        environment.purchaseService.getProducts()
            .map({ product in
                return product.sorted { (product1, product2) -> Bool in
                    return product1.localizedPrice < product2.localizedPrice
                }
            })
            .subscribe(onSuccess: { [weak self] products in
                guard let self = self else { return }
                self.state.update { $0 = .content(products) }
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
