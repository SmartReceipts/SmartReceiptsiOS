//
//  GenerateReportPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class GenerateReportPresenter: Presenter {
    private let rateApplicationManager: RateApplicationManager = .shared
    
    override func viewHasLoaded() {
        interactor.trackConfigureReportEvent()
        router.prepareAds()
    }
    
    override func setupView(data: Any) {
        guard let trip = data as? WBTrip else { return }
        interactor.configure(with: trip)
    }
    
    func close() {
        router.close()
    }
    
    func generateReport(selection: GenerateReportSelection) {
        interactor.trackGeneratorEvents(selection: selection)
        interactor.generateReport(selection: selection)
    }
    
    func presentAlert(title: String, message: String) {
        router.openAlert(title: title, message: message)
    }
    
    func presentSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        router.openSheet(title: title, message: message, actions: actions)
    }
    
    func present(vc: UIViewController, animated: Bool = true, isPopover: Bool = false, completion: (() -> Void)? = nil) {
        router.open(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
    }
    
    func presentOutputSettings() {
        router.openSettingsOnReportLayout()
    }
    
    func hideHudFromView() {
        view.hideHud()
    }
    
    func presentEnableDistances() {
        router.openSettingsOnDisatnce()
    }
    
    func presentInterstitialAd() {
        guard rateApplicationManager.generatedReportFlag() else {
            rateApplicationManager.markAppGeneratedReport()
            return
        }
        router.openInterstitialAd()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportPresenter {
    var view: GenerateReportViewInterface {
        return _view as! GenerateReportViewInterface
    }
    var interactor: GenerateReportInteractor {
        return _interactor as! GenerateReportInteractor
    }
    var router: GenerateReportRouter {
        return _router as! GenerateReportRouter
    }
}
