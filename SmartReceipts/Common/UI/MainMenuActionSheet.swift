//
//  MainMenuActionSheet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05.02.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices
import SwiftUI
import ComposableArchitecture
import Toaster

class MainMenuActionSheet: ActionSheet, Disposable {
    private weak var viewController: UIViewController?
    var bag: DisposeBag { return sheetViewController.bag }
    let remoteConfig = RemoteConfigService()
    
    init(openOn viewController: UIViewController) {
        
        super.init(closable: true)
        self.viewController = viewController
        
        bag.insert(self)
        
        if remoteConfig.subscriptionsEnabled {
            addAction(
                title: LocalizedString("menu_main_subscriptions"),
                image: #imageLiteral(resourceName: "subscriptions"),
                style: .violet
            )
            .debug()
            .subscribe(onNext: { [weak self] in
                self?.openSubscriptions()
            })
            .disposed(by: bag)
        }
        
        addAction(title: LocalizedString("menu_main_settings"), image: #imageLiteral(resourceName: "settings"))
            .debug()
            .subscribe(onNext: { [weak self] in
                self?.openSettings()
            }).disposed(by: bag)
        
        addAction(title: LocalizedString("menu_main_ocr_configuration"), image: #imageLiteral(resourceName: "cpu"))
            .subscribe(onNext: { [weak self] in self?.openAutoScans() })
            .disposed(by: bag)
        
        addAction(title: LocalizedString("menu_main_export"), image: #imageLiteral(resourceName: "upload-cloud"))
            .subscribe(onNext: { [weak self] in self?.openBackup() })
            .disposed(by: bag)
        
        addAction(title: LocalizedString("menu_main_usage_guide"), image: #imageLiteral(resourceName: "info"))
            .subscribe(onNext: { [weak self] in self?.openUserGuide() })
            .disposed(by: bag)
        
        #if DEBUG
        addAction(title: "DEBUG", image: #imageLiteral(resourceName: "alert-triangle"), style: .destructive)
            .subscribe(onNext: { [weak self] in self?.openDebug() })
            .disposed(by: bag)
        #endif
    }
    
    private func openAuth() -> AuthViewOutput {
        let authViewOutput = AuthViewOutput()
        let authView = AuthViewScreen(
            store: Store(initialState: AuthViewReducer.State()) {
            AuthViewReducer(authViewOutput: authViewOutput)
        })
        let authController = UIHostingController(rootView: authView)
        authViewOutput.viewController = authController
        authViewOutput.showToast()
        viewController?.present(authController, animated: true)
        return authViewOutput
    }
    
    private func openAutoScans() {
        if AuthService.shared.isLoggedIn {
            AnalyticsManager.sharedManager.record(event: Event.Navigation.OcrConfiguration)
            let module = AppModules.OCRConfiguration.build()
            openInNavigationController(module.view.viewController)
        } else {
            let authModule = openAuth()
            authModule.successAuth
                .map({ authModule.close() })
                .delay(.milliseconds(Int(VIEW_CONTROLLER_TRANSITION_DELAY * 1000)), scheduler: MainScheduler.instance)
                .flatMap({ _ -> Observable<UNAuthorizationStatus> in
                    PushNotificationService.shared.authorizationStatus()
                }).observe(on: MainScheduler.instance)
                .flatMap({ status -> Observable<Void> in
                    let text = LocalizedString("push_request_alert_text")
                    return status == .notDetermined ? UIAlertController.showInfo(text: text) : Observable<Void>.just(())
                }).subscribe(onNext: { [weak self] in
                    _ = PushNotificationService.shared.requestAuthorization().subscribe()
                    self?.openAutoScans()
                }).disposed(by: bag)
        }
    }
    
    private func openSubscriptions() {
        if AuthService.shared.isLoggedIn {
            let vc = SubscriptionBuilder.build()
            let nc = UINavigationController(rootViewController: vc)
            viewController?.present(nc, animated: true)
        } else {
            let authModule = openAuth()
            authModule.successAuth
                .map({ authModule.close() })
                .delay(.milliseconds(Int(VIEW_CONTROLLER_TRANSITION_DELAY * 1000)), scheduler: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.openSubscriptions()
                })
                .disposed(by: bag)
        }
    }
    
    private func openSettings() {
        let module = AppModules.settings.build()
        openInNavigationController(module.view.viewController)
    }

    private func openBackup() {
        let module = AppModules.backup.build()
        openInNavigationController(module.view.viewController)
    }
    
    private func openUserGuide() {
        let USER_GUIDE_URL = "https://www.smartreceipts.co/guide"
        AnalyticsManager.sharedManager.record(event: Event.Navigation.OcrConfiguration)
        let safari = SFSafariViewController(url: URL(string: USER_GUIDE_URL)!, entersReaderIfAvailable: true)
        viewController?.present(safari, animated: true, completion: nil)
    }
    
    private func openDebug() {
        let module = AppModules.debug.build()
        openInNavigationController(module.view.viewController)
    }
    
    private func openInNavigationController(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        viewController?.present(nav, animated: true, completion: nil)
    }
    
    func dispose() {}
}
