//
//  SuccessPlanRouter.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation

final class SuccessPlanRouter {
    weak var moduleViewController: UIViewController!

    enum Route {
        case close
    }
    
    func open(route: Route) {
        switch route {
        case .close:
            moduleViewController.dismiss(animated: true, completion: nil)
        }
    }
}
