//
//  AdPresentingContainerViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import GoogleMobileAds
import Viperit
import RxSwift
import Darwin

fileprivate let BANNER_HEIGHT: CGFloat = 50

class AdPresentingContainerViewController: UIViewController {
    @IBOutlet fileprivate var adContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var bannerView: GADBannerView?
    @IBOutlet fileprivate var upsellBannerView: UpsellBannerAdView!
    @IBOutlet fileprivate var container: UIView!
    private let purchaseService = PurchaseService()
    
    private let bag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upsellBannerView.isHidden = true
        adContainerHeight.constant = 0

        bannerView?.rootViewController = self
        bannerView?.adUnitID = AD_UNIT_ID_BANNER
        bannerView?.delegate = self
        bannerView?.tintColor = AppTheme.accentColor
        
        checkAdsStatus()
        
        upsellBannerView.bannerTap
            .do(onNext: {
                AnalyticsManager.sharedManager.record(event: Event.Purchases.AdUpsellTapped)
            }).subscribe(onNext: { [unowned self] in
                let hud = PendingHUDView.showFullScreen()
                _ = self.purchaseService.purchasePlusSubscription().do(onNext: { _ in
                    hud.hide()
                }, onError: { _ in
                    hud.hide()
                }).subscribe()
            }).disposed(by: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkAdsStatus), name: .SmartReceiptsAdsRemoved, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerView?.adSize = getAdSize()
    }
    
    private func loadAd() {
        let request = GADRequest()
        
        let extras = GADExtras()
        let npaParameter = WBPreferences.adPersonalizationEnabled() ? "0" : "1"
        extras.additionalParameters = ["npa": npaParameter]
        request.register(extras)
        
        bannerView?.adSize = getAdSize()
        bannerView?.load(request)
    }
    
    fileprivate func getAdSize() -> GADAdSize {
        let adSize = CGSize(width: view.bounds.width, height: BANNER_HEIGHT)
        return GADAdSizeFromCGSize(adSize)
    }
    
    @objc private func checkAdsStatus() {
        purchaseService.validateSubscription().subscribe(onNext: { [unowned self] validation in
            if validation.adsRemoved {
                Logger.debug("Remove Ads")

                self.adContainerHeight.constant = 0
                self.view.layoutSubviewsAnimated()
                self.bannerView?.removeFromSuperview()
            } else if arc4random() % 100 == 0 {
                // Show UpsellBannerAdView randomly (1/100 times)
                self.upsellBannerView.isHidden = false
                self.bannerView?.isHidden = true
                self.adContainerHeight.constant = BANNER_HEIGHT
                self.view.layoutSubviewsAnimated()
                
                AnalyticsManager.sharedManager.record(event: Event.Purchases.AdUpsellShown)
            } else {
                self.adContainerHeight.constant = BANNER_HEIGHT
                self.view.layoutSubviewsAnimated()
                self.loadAd()
            }
        }).disposed(by: bag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdPresentingContainerViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.adSize = getAdSize()
        adContainerHeight.constant = BANNER_HEIGHT
        view.layoutSubviewsAnimated()
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        bannerView.isHidden = true
        upsellBannerView.isHidden = false
        
        AnalyticsManager.sharedManager.record(event: Event.Purchases.AdUpsellShownOnFailure)
    }
}

class AdNavigationEntryPoint: UINavigationController {
     static fileprivate(set) var navigationController: UINavigationController?
    
    override func viewDidLoad() {
        AdNavigationEntryPoint.navigationController = self
        show(TripTabBarViewController.create(), sender: nil)
    }
}
