//
//  SettingsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class SettingsRouter: Router {
    
    func openRoute(_ route: SettingsRoutes) {
        switch route {
        case .privacyPolicy:
            openPrivacyPolicy()
        case .columns(let isCSV):
            openColumns(isCSV: isCSV)
        case .paymentMethods:
            openPaymentMethods()
        case .categories:
            openCategories()
        }
    }
    
    func close() {
        _view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func openPrivacyPolicy() {
        if let privacyPolicyURL = URL(string: "https://www.smartreceipts.co/privacy") {
            if UIApplication.shared.canOpenURL(privacyPolicyURL) {
                UIApplication.shared.open(privacyPolicyURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    func openColumns(isCSV: Bool) {
        let module = AppModules.columns.build()
        module.presenter.setupView(data: isCSV)
        module.router.show(from: _view.viewController)
    }
    
    func openPaymentMethods() {
        let module = AppModules.paymentMethods.build()
        module.router.show(from: _view.viewController)
    }
    
    func openCategories() {
        let module = AppModules.categories.build()
        module.router.show(from: _view.viewController)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsRouter {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}

enum SettingsRoutes {
    case privacyPolicy
    case columns(isCSV: Bool)
    case paymentMethods
    case categories
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
