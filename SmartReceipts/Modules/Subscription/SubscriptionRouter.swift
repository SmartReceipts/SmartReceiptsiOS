//
//  SubscriptionRouter.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import ComposableArchitecture
import RxSwift
import SwiftUI
import UIKit
import Toaster

final class SubscriptionRouter {
    weak var moduleViewController: UIViewController!

    func openSuccessPage(updateState: @escaping (() -> Void)) {
        let vc = SuccessPlanBuilder.build()
        let nc = UINavigationController(rootViewController: vc)
        moduleViewController.present(nc, animated: true, completion: { updateState() })
    }
    
    func handlerError(errorMessage: String, retryAction: (() -> Void)? = nil) {
        let title = LocalizedString("generic_error_alert_title")
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: LocalizedString("exchange_rate_retrieve_error_retry_button"),
                style: .default,
                handler: { _ in
                    retryAction?()
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: LocalizedString("generic_button_title_ok"),
                style: .cancel,
                handler: nil
            )
        )
        moduleViewController.present(alert, animated: true, completion: nil)
    }
    
    func openSubscriptions() {
        let subscriptionsUrl = URL(string: "https://apps.apple.com/account/subscriptions")!
        UIApplication.shared.open(subscriptionsUrl, options: [:])
    }
    
    func close() {
        moduleViewController.dismiss(animated: true)
    }
}
