//
//  AppDelegate+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/12/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

//MARK: - Import
extension AppDelegate {
    func handlePDForImage(url: URL) {
        var path = url.path
        
        path = path.hasSuffix("/") ? String(path[..<path.index(before: path.endIndex)]) : path
        filePathToAttach = path
        
        if isFileImage {
            // String(format: LocalizedString("dialog_attachment_text"), LocalizedString("image"))
            let alert = UIAlertController(title: LocalizedString("receipt_attach_file"),
                                          message: String(format: LocalizedString("dialog_attachment_text"), LocalizedString("image")), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
            AdNavigationEntryPoint.navigationController?.visibleViewController?.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: LocalizedString("receipt_attach_file"),
                                          message: String(format: LocalizedString("dialog_attachment_text"), LocalizedString("pdf")), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
            AdNavigationEntryPoint.navigationController?.visibleViewController?.present(alert, animated: true)
        }
    }
    
    func handleSMR(url: URL) {
        let alert = UIAlertController(title: LocalizedString("manual_backup_import"),
                                      message: LocalizedString("dialog_import_text"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: { _ in
            FileManager.deleteIfExists(filepath: url.path)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizedString("yes"), style: .default, handler: { _ in
            self.importZip(from: url, overwrite: true)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizedString("no"), style: .default, handler: { _ in
            self.importZip(from: url, overwrite: false)
        }))
        AdNavigationEntryPoint.navigationController?.visibleViewController?.present(alert, animated: true)
    }
    
    func importZip(from: URL, overwrite: Bool) {
        guard let viewController = AdNavigationEntryPoint.navigationController?.visibleViewController else { return }
        let hud = PendingHUDView.showFullScreen()
        dataQueue.async {
            self.dataImport = DataImport(inputFile: from.path, output: FileManager.documentsPath)
            _ = self.dataImport.execute(overwrite: overwrite)
                .subscribe(on: MainScheduler.instance)
                .subscribe(onNext: {
                    SyncService.shared.trySyncData()
                    hud.hide()
                    NotificationCenter.default.post(name: .SmartReceiptsImport, object: nil)
                    let text = LocalizedString("toast_import_complete")
                    _ = UIAlertController.showInfo(text: text, on: viewController).subscribe()
                    Logger.debug("Successfully imported all reciepts")
                }, onError: { error in
                    hud.hide()
                    let text = LocalizedString("IMPORT_ERROR")
                    _ = UIAlertController.showInfo(text: text, on: viewController).subscribe()
                    Logger.error("Failed to import this backup: \(error.localizedDescription)")
                })
        }
    }
}

// MARK: - Services initialize

extension AppDelegate {
    func initializeServices() {
        let purchaseService = ServiceFactory.shared.purchaseService
        purchaseService.cacheSubscriptionValidation()
        purchaseService.logPurchases()
        purchaseService.completeTransactions()
        
        RateApplicationManager.shared.markAppLaunch()
        PushNotificationService.shared.initialize()
        ScansPurchaseTracker.shared.initialize()
        GoogleDriveService.shared.initialize()
        SyncService.shared.initialize()
        
        MigrationService().migrate()
        
        ServiceFactory.shared.organizationService.startSync()
    }
}
