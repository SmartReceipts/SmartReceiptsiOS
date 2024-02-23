//
//  AppMonitorService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 21/05/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Firebase

protocol AppMonitorService {
    func configure()
}

class AppMonitorServiceFactory {
    func createAppMonitor() -> AppMonitorService {
        if AppDelegate.isRunningForTest {
            return NoOpAppMonitorService()
        }
        return FirebaseAppMonitorService()
    }
}

//MARK: Implementations

class FirebaseAppMonitorService: AppMonitorService {
    func configure() {
        FirebaseApp.configure()
        setupCustomExceptionHandler()
        enableAnalytics()
        applyPrivacySettings()
    }
    
    private func enableAnalytics() {
        AnalyticsManager.sharedManager.register(newService: FirebaseAnalytics())
        AnalyticsManager.sharedManager.register(newService: AnalyticsLogger())
    }
    
    private func applyPrivacySettings() {
        AnalyticsManager.sharedManager.setAnalyticsSending(allowed: WBPreferences.analyticsEnabled())
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(WBPreferences.crashTrackingEnabled())
    }
    
    private func setupCustomExceptionHandler() {
        // Catches most but not all fatal errors
        NSSetUncaughtExceptionHandler { exception in
            RateApplicationManager.shared.markAppCrash()
            
            var message = exception.description
            message += "\n"
            message += exception.callStackSymbols.description
            Logger.error(message, file: "UncaughtExcepetion", function: "onUncaughtExcepetion", line: 0)
            guard let reason = exception.reason else { return }
            Crashlytics.crashlytics().record(exceptionModel: .init(name: exception.name.rawValue, reason: reason))
            
            let errorEvent = ErrorEvent(exception: exception)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        }
    }
}


class NoOpAppMonitorService: AppMonitorService {
    func configure() {}
}



