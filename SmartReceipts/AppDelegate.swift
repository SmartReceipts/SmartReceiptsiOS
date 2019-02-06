//
//  AppDelegate.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import Firebase
import RxSwift
import Crashlytics
import SwiftyStoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static private(set) var instance: AppDelegate!

    var window: UIWindow?
    private var purchaseService: PurchaseService!
    
    fileprivate(set) var isFileImage: Bool = false
    
    private lazy var quickActionService: QuickActionService = {
        let rootViewController = UIApplication.shared.keyWindow!.rootViewController!
        return QuickActionService(view: rootViewController)
    }()
    
    var filePathToAttach: String?
    var dataImport: DataImport!
    let dataQueue = DispatchQueue(label: "wb.dataAccess")
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        AppDelegate.instance = self
        
        AppMonitorServiceFactory().createAppMonitor().configure()
        
        AppTheme.customizeOnAppLoad()
        EurekaWhitespaceWorkaround.configureTextCells()
        Crashlytics.sharedInstance().debugMode = DebugStates.isDebug
        
        _ = FileManager.initTripsDirectory()
        
        if !Database.sharedInstance().open() {
            NSException(name: NSExceptionName(rawValue: "DBOpenFail"), reason: nil, userInfo: [:]).raise()
        }
        
        RecentCurrenciesCache.shared.update()
        
        Logger.info("Language: \(Locale.preferredLanguages.first!)")
        
        purchaseService = PurchaseService()
        purchaseService.cacheSubscriptionValidation()
        purchaseService.logPurchases()
        purchaseService.completeTransactions()
        
        RateApplication.sharedInstance().markAppLaunch()
        PushNotificationService.shared.initialize()
        ScansPurchaseTracker.shared.initialize()
        GoogleDriveService.shared.initialize()
        SyncService.shared.initialize()
        
        MigrationService().migrate()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        freeFilePathToAttach()
        quickActionService.configureQuickActions()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        quickActionService.configureQuickActions()
        Database.sharedInstance().close()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        _ = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }
        
        if url.isFileURL {
            let tempURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(url.lastPathComponent)!
            do { try FileManager.default.copyItem(at: url, to: tempURL) }
            catch { Logger.error("Can't copy temp file \(tempURL.lastPathComponent)") }
            
            if url.pathExtension.isStringIgnoreCaseIn(array: ["png", "jpg", "jpeg"]) {
                Logger.info("Launched for image")
                if DataValidator().isValidImage(url: tempURL) {
                    isFileImage = true
                    handlePDForImage(url: tempURL)
                } else {
                    Logger.error("Invalid Image for import")
                }
            } else if url.pathExtension.caseInsensitiveCompare("pdf") == .orderedSame {
                Logger.info("Launched for pdf")
                if DataValidator().isValidPDF(url: tempURL) {
                    isFileImage = false
                    handlePDForImage(url: tempURL)
                } else {
                    Logger.error("Invalid PDF for import")
                }
            } else if url.pathExtension.caseInsensitiveCompare("smr") == .orderedSame {
                Logger.info("Launched for smr")
                handleSMR(url: tempURL)
            } else {
                Logger.info("Loaded with unknown file")
            }
        } else {
            let sourceApp = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
            let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: annotation)
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let quickAction = QuickAction(rawValue: shortcutItem.type) else { return }
        quickActionService.performAction(action: quickAction)
    }
}

extension AppDelegate {
    func freeFilePathToAttach() {
        guard let path = filePathToAttach else { return }
        FileManager.deleteIfExists(filepath: path)
        filePathToAttach = nil
    }
}
