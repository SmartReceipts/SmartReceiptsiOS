//
//  InterstitialAdsManager.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 23.03.2024.
//  Copyright © 2024 Will Baumann. All rights reserved.
//

import GoogleMobileAds

protocol InterstitialAdsManager {
    var interstitialAd: GADInterstitialAd? { get }
    func prepareAds()
    func openInterstitialAd()
    func loadInterstitialAd()
}

final class InterstitialAdsManagerImpl: NSObject, InterstitialAdsManager {
    var interstitialAd: GADInterstitialAd?

    func prepareAds() {
        guard !PurchaseService.hasValidPlusSubscriptionValue else { return }
        loadInterstitialAd()
    }
    
    func openInterstitialAd() {
        guard !PurchaseService.hasValidPlusSubscriptionValue else { return }
        guard let root = UIApplication.shared.rootViewController else { return }
        if let interstitialAd {
            interstitialAd.present(fromRootViewController: root)
        } else {
            Logger.error("[InterstitialAdsManager]: failed to present interstitial ad!")
            loadInterstitialAd()
        }
    }

    func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: AD_UNIT_ID_INTERSTITIAL,
            request: request,
            completionHandler: { [weak self] ad, error in
                guard let self else { return }
                if let error = error {
                    Logger.error("[InterstitialAdsManager]: failed to load interstitial ad with error: \(error.localizedDescription)")
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 3.0,
                        execute: { self.loadInterstitialAd() }
                    )
                    return
                }
                self.interstitialAd = ad
                self.interstitialAd?.fullScreenContentDelegate = self
            })
    }
}

extension InterstitialAdsManagerImpl: GADFullScreenContentDelegate {
    func interstitialWillDismissScreen(_ ad: GADInterstitialAd) {
        Logger.info("[InterstitialAdsManager]: interstitial ad will dismiss screen")
        loadInterstitialAd()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.error("[InterstitialAdsManager]: failed to display interstitial ad with error: \(error.localizedDescription)")
        loadInterstitialAd()
    }
}
