//
//  OCRConfigurationRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class OCRConfigurationRouter: Router {
    func openSubscriptionPage() {
        let vc = SubscriptionBuilder.build() as! SubscriptionViewController
        vc.modalPresentationStyle = .overFullScreen
        _view.viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationRouter {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
}
