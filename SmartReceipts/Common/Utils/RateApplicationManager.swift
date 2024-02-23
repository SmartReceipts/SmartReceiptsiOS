//
//  RateApplicationManager.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 16.02.2024.
//  Copyright © 2024 Will Baumann. All rights reserved.
//

import Foundation
import StoreKit

@objcMembers
final class RateApplicationManager: NSObject {
    static let shared = RateApplicationManager()
    private let ud = UserDefaults.standard

    override init() {
        if ud.integer(forKey: .sRRateAppTargetLaunchesForRatingKey) == 0 {
            ud.set(SmartReceiptTargetLaunchesForAppRating, forKey: .sRRateAppTargetLaunchesForRatingKey)
        }
        super.init()
    }
    
    func markAppLaunch() {
        var launchCount = ud.integer(forKey: .sRRateAppAppLaunchCountKey)
        launchCount += 1
        ud.set(launchCount, forKey: .sRRateAppAppLaunchCountKey)
        if ud.object(forKey: .sRRateAppFirstLaunchDateKey) == nil {
            ud.set(Date(), forKey: .sRRateAppFirstLaunchDateKey)
        }
        
        if shouldShowRateDialog() {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                showAlertDialog()
            }
        }
    }
    
    func markAppCrash() {
        ud.set(true, forKey: .sRRateAppCrashMarkerKey)
    }
    
    func markAppGeneratedReport() {
        ud.set(true, forKey: .sRRateAppGeneratedReportKey)
        showAlertDialog()
    }
    
    func generatedReportFlag() -> Bool {
        ud.bool(forKey: .sRRateAppGeneratedReportKey)
    }
    
    private func showAlertDialog() {
        if #available(iOS 14, *) {
            guard let scene = UIApplication.shared.foregroundActiveScene else { return }
            SKStoreReviewController.requestReview(in: scene)
        } else {
            guard let rootViewController = UIApplication.shared.rootViewController else { return }
            rootViewController.present(alertDialog(), animated: true)
            AnalyticsManager.sharedManager.record(event: .ratingsRatingPromptShown())
        }
    }
    
    func rateLater() {
        var target = ud.integer(forKey: .sRRateAppTargetLaunchesForRatingKey)
        target += Int(SmartReceiptDelayedLaunchesOnAppRatingLater)
        ud.set(target, forKey: .sRRateAppTargetLaunchesForRatingKey)
    }
    
    func shouldShowRateDialog() -> Bool {
        if ud.bool(forKey: .sRRateAppCrashMarkerKey) {
            return false
        }
        if ud.bool(forKey: .sRRateAppRatePressedKey) {
            return false
        }
        if ud.bool(forKey: .sRRateAppNoPressedKey) {
            return false
        }
        if launchCount() < launchTarget() {
            return false
        }
        
        let date = firstLaunchDate() as? NSDate
        let now = NSDate.now
        let requiredDaysSinceFirstLaunch = date?.addingDays(Int(SmartReceiptMinUsageDaysForRating)) as? NSDate
        let laterDate = requiredDaysSinceFirstLaunch?.laterDate(now) as? NSDate
        return laterDate?.is(onSameDate: now) ?? false
    }
    
    func markRatePressed() {
        ud.set(true, forKey: .sRRateAppRatePressedKey)
    }
    
    func markNoPressed() {
        ud.set(true, forKey: .sRRateAppNoPressedKey)
    }
    
    func launchCount() -> Int {
        ud.integer(forKey: .sRRateAppAppLaunchCountKey)
    }
    
    func launchTarget() -> Int {
        ud.integer(forKey: .sRRateAppTargetLaunchesForRatingKey)
    }
    
    func firstLaunchDate() -> Date? {
        ud.object(forKey: .sRRateAppFirstLaunchDateKey) as? Date
    }
    
    private func alertDialog() -> UIAlertController {
        let alertController = UIAlertController(
            title: LocalizedString("rating_tooltip_text"),
            message: LocalizedString("leave_feedback_text"),
            preferredStyle: .alert
        )
        let positive = UIAlertAction(
            title: LocalizedString("apprating_dialog_positive"),
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.markRatePressed()
            AnalyticsManager.sharedManager.record(event: .ratingsUserSelectedRate())
            guard let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/id\(SmartReceiptAppStoreId)") else { return }
            UIApplication.shared.open(reviewURL)
        }
        let negative = UIAlertAction(
            title: LocalizedString("apprating_dialog_negative"),
            style: .cancel
        ) { [weak self] _ in
            guard let self else { return }
            self.markNoPressed()
            AnalyticsManager.sharedManager.record(event: .ratingsUserSelectedNever())
        }
        let neutral = UIAlertAction(
            title: LocalizedString("apprating_dialog_neutral"),
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.rateLater()
            AnalyticsManager.sharedManager.record(event: .ratingsUserSelectedLater())
        }
        [
            positive,
            negative,
            neutral
        ].forEach {
            alertController.addAction($0)
        }
        return alertController
    }
    
#if DEBUG
    func reset() {
        ud.removeObject(forKey: .sRRateAppCrashMarkerKey)
        ud.removeObject(forKey: .sRRateAppAppLaunchCountKey)
        ud.removeObject(forKey: .sRRateAppFirstLaunchDateKey)
        ud.removeObject(forKey: .sRRateAppRatePressedKey)
        ud.removeObject(forKey: .sRRateAppNoPressedKey)
        ud.set(SmartReceiptTargetLaunchesForAppRating, forKey: .sRRateAppTargetLaunchesForRatingKey)
    }
    
    func setLaunchCount(_ count: Int) {
        ud.set(count, forKey: .sRRateAppAppLaunchCountKey)
    }
    
    func setFirstLaunchDate(_ date: Date?) {
        ud.set(date, forKey: .sRRateAppFirstLaunchDateKey)
    }
#endif
}

private extension String {
    static let sRRateAppCrashMarkerKey = "SRRateAppCrashMarkerKey"
    static let sRRateAppAppLaunchCountKey = "SRRateAppAppLaunchCountKey"
    static let sRRateAppFirstLaunchDateKey = "SRRateAppFirstLaunchDateKey"
    static let sRRateAppTargetLaunchesForRatingKey = "SRRateAppTargetLaunchesForRatingKey"
    static let sRRateAppNoPressedKey = "SRRateAppNoPressedKey"
    static let sRRateAppRatePressedKey = "SRRateAppRatePressedKey"
    static let sRRateAppGeneratedReportKey = "SRRateAppGeneratedReportKey"
}
