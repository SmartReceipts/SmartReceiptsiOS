//
//  SubscriptionRouter.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit

final class SubscriptionRouter {
    weak var moduleViewController: UIViewController!
    
    enum Route {
//        case showLogin
        case showSuccessPage
    }
    
    func open(route: Route) {
        switch route {
//        case .showLogin:
        case .showSuccessPage:
            let successPlanVc = SuccessPlanBuilder.build() as! SuccessPlanViewController
            successPlanVc.modalPresentationStyle = .fullScreen
            moduleViewController.present(successPlanVc, animated: true)
        }
    }
}
