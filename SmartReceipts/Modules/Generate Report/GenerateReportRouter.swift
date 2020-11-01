//
//  GenerateReportRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import GoogleMobileAds

class GenerateReportRouter: Router {
    private var interstitial: GADInterstitial?
    private var inerstitialDelegate: InerstitialDelegate?
    
    func prepareAds() {
        guard !PurchaseService.hasValidSubscriptionValue else { return }
        let updateBlock = { [weak self] in
            self?.interstitial = GADInterstitial(adUnitID: AD_UNIT_ID_INTERSTITIAL)
            self?.interstitial?.delegate = self?.inerstitialDelegate
            self?.interstitial?.load(.init())
        }
        inerstitialDelegate = .init(updateClosure: updateBlock)
        updateBlock()
    }
    
    func close() {
        _view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func openSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            sheet.addAction(action)
        }
        _view.viewController.present(sheet, animated: true, completion: nil)
    }
    
    func openSettingsOnDisatnce() {
        openSettings(option: .distanceSection)
    }
    
    func openSettingsOnReportLayout() {
        AnalyticsManager.sharedManager.record(event: Event.informationalConfigureReport())
        openSettings(option: .reportCSVOutputSection)
    }
    
    func openSettings(option: ShowSettingsOption) {
        let module = AppModules.settings.build()
        module.presenter.setupView(data: option)
        module.router.show(from: _view.viewController, embedInNavController: true)
    }
    
    func open(vc: UIViewController, animated: Bool = true, isPopover: Bool = false, completion: (() -> Void)? = nil) {
        if isPopover {
            // For iPad
            if let popover = vc.popoverPresentationController {
                popover.permittedArrowDirections = .up
                popover.sourceView = _view.viewController.view
                popover.sourceRect = _view.viewController.navigationController?.navigationBar.frame ?? _view.viewController.view.frame
            }
        }
        _view.viewController.present(vc, animated: animated, completion: completion)
    }
    
    func openInterstitialAd() {
        guard !PurchaseService.hasValidSubscriptionValue else { return }
        interstitial?.present(fromRootViewController: _view.viewController)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportRouter {
    var presenter: GenerateReportPresenter {
        return _presenter as! GenerateReportPresenter
    }
}

private class InerstitialDelegate: NSObject, GADInterstitialDelegate {
    private var updateClosure: VoidBlock
    
    init(updateClosure: @escaping VoidBlock) {
        self.updateClosure = updateClosure
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        updateClosure()
    }
}
