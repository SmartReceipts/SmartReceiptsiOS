//
//  SettingsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class SettingsRouter: Router {
    private let bag = DisposeBag()
    
    func openRoute(_ route: SettingsRoutes) {
        switch route {
        case .privacyPolicy:
            open(url: "https://www.smartreceipts.co/privacy")
        case .termsOfUse:
            openAlert(title: nil, message: LocalizedString("pref_about_terms_dialogMessage"))
        case .about:
            openAlert(title: nil, message: LocalizedString("pref_about_about_dialogMessage"))
        case .columns(let isCSV):
            openColumns(isCSV: isCSV)
        case .paymentMethods:
            openPaymentMethods()
        case .categories:
            openCategories()
        case .subscription:
            openSubscriptionPage()
        }
    }
    
    func close() {
        _view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func openPrivacyPolicy() {
        open(url: "https://www.smartreceipts.co/privacy")
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
    
    func openSubscriptionPage() {
        let viewController = _view.viewController
        if AuthService.shared.isLoggedIn {
            let vc = SubscriptionBuilder.build()
            let nc = UINavigationController(rootViewController: vc)
            viewController.present(nc, animated: true)
        } else {
            let authModule = AuthViewBuilder.build(from: viewController)
            authModule.successAuth
                .map({ authModule.close() })
                .delay(.milliseconds(Int(VIEW_CONTROLLER_TRANSITION_DELAY * 1000)), scheduler: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.openSubscriptionPage()
                })
                .disposed(by: bag)
        }
    }
    
    private func open(url: String) {
        guard let url = URL(string: url) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url,
                options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                completionHandler: nil
            )
        }
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
    case about
    case termsOfUse
    case subscription
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
