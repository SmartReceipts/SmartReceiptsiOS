//
//  SubscriptionRouter.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

final class SubscriptionRouter {
    weak var moduleViewController: UIViewController!
    
    func openLogin() -> Completable {
        let module = AppModules.auth.build()
        module.router.show(from: moduleViewController, embedInNavController: true)
        
        let interface = module.interface(AuthModuleInterface.self)
        return Completable.create { [weak interface] event -> Disposable in
                _ = interface?.successAuth.subscribe(onNext: {
                    event(.completed)
                })
                return Disposables.create()
            }.do(onCompleted: {
                module.view.viewController.dismiss(animated: true, completion: nil)
            })
    }
    
    func openSuccessPage(updateState: @escaping (() -> Void)) {
        let successPlanVc = SuccessPlanBuilder.build() as! SuccessPlanViewController
        successPlanVc.modalPresentationStyle = .fullScreen
        moduleViewController.present(successPlanVc, animated: true, completion: { updateState() })
    }
}
