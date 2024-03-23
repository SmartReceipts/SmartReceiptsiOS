//
//  EditDistanceRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class EditDistanceRouter: Router {
    private let interstitialAdsManager = InterstitialAdsManagerImpl()

    func close() {
        _view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func done(completion: (() -> Void)? = nil) {
        _view.viewController.dismiss(animated: true, completion: completion)
    }

    func prepareInterstitialAd() {
        interstitialAdsManager.prepareAds()
    }

    func openInterstitialAd() {
        guard let numberOfShowAd = RemoteConfigService.shared.numberOfShowAd,
              let receipts = Database.sharedInstance().allDistances(for: WBPreferences.lastOpenedTrip),
              receipts.count.isMultiple(of: numberOfShowAd)
        else {
            return
        }
        interstitialAdsManager.openInterstitialAd()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistanceRouter {
    var presenter: EditDistancePresenter {
        return _presenter as! EditDistancePresenter
    }
}
