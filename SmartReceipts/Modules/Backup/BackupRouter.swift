//
//  BackupRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class BackupRouter: Router {
    private let bag = DisposeBag()
    
    func openBackupImport() {
        BackupFilePicker.sharedInstance.openFilePicker(on: self._view.viewController)
            .subscribe(onNext: { smrURL in
                (UIApplication.shared.delegate as? AppDelegate)?.handleSMR(url: smrURL)
            }).disposed(by: bag)
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
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupRouter {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
}
