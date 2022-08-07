//
//  BackupInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster
import Zip

class BackupInteractor: Interactor {
    let bag = DisposeBag()
    
    let purchaseService = PurchaseService()
    
    func isCurrentDevice(backup: RemoteBackupMetadata) -> Bool {
        return backup.syncDeviceId == BackupProvidersManager.shared.deviceSyncId
    }
    
    func hasValidSubscription() -> Bool {
        return PurchaseService.hasValidPlusSubscriptionValue
    }
    
    func downloadZip(_ backup: RemoteBackupMetadata) {
        weak var hud = PendingHUDView.showFullScreen()
        BackupProvidersManager.shared.downloadAllData(remoteBackupMetadata: backup)
            .map({ result -> URL? in
                if !result.database.open() { return nil }
                let tempDirPath = NSTemporaryDirectory()
                let database = result.database
                let trips = database.allTrips() as! [WBTrip]
            
                var urls = Set<URL>()
                urls.insert(try! result.database.pathToDatabase.asURL())
                
                for file in result.files {
                    for trip in trips {
                        let receipts = database.allReceipts(for: trip) as! [WBReceipt]
                        guard !receipts.filter({ $0.imageFilePath(for: trip).contains(file.filename) }).isEmpty else { continue }
                        let tripPath = tempDirPath.asNSString.appendingPathComponent(trip.name)
                        _ = FileManager.createDirectiryIfNotExists(path: tripPath)
                        let receiptPath = tripPath.asNSString.appendingPathComponent(file.filename)
                        FileManager.default.createFile(atPath: receiptPath, contents: file.data, attributes: nil)
                        urls.insert(tripPath.asFileURL)
                    }
                }
                
                let backupPath = tempDirPath.asNSString.appendingPathComponent("\(backup.syncDeviceName).zip")
                try? DataExport.zipFiles(Array(urls), to: backupPath)
                for url in urls { try? FileManager.default.removeItem(at: url) }
                
                database.close()
                return backupPath.asFileURL
            }).do(onSuccess: { _ in
                hud?.hide()
            }).filter({ $0 != nil })
            .subscribe(onSuccess: { [weak self] url in
                self?.presenter.presentOptions(file: url!)
            }, onError: { [weak self] _ in
                hud?.hide()
                self?.presenter.presentAlert(title: nil, message: LocalizedString("EXPORT_ERROR"))
            }).disposed(by: bag)
    }
    
    func downloadDebugZip(_ backup: RemoteBackupMetadata) {
        weak var hud = PendingHUDView.showFullScreen()
        BackupProvidersManager.shared.debugDownloadAllData(remoteBackupMetadata: backup)
            .map({ result -> URL? in
                let tempDirPath = NSTemporaryDirectory()
                var urls = Set<URL>()
                urls.insert(try! result.database.pathToDatabase.asURL())
                
                for file in result.files {
                    let receiptPath = tempDirPath.asNSString.appendingPathComponent(file.filename)
                    FileManager.default.createFile(atPath: receiptPath, contents: file.data, attributes: nil)
                    urls.insert(receiptPath.asFileURL)
                }
                
                let backupPath = tempDirPath.asNSString.appendingPathComponent("debug_\(backup.syncDeviceName).zip")
                try? DataExport.zipFiles(Array(urls), to: backupPath)
                for url in urls { try? FileManager.default.removeItem(at: url) }
                
                return backupPath.asFileURL
            }).observeOn(MainScheduler.instance)
            .do(onSuccess: { _ in
                hud?.hide()
            }).filter({ $0 != nil })
            .subscribe(onSuccess: { [weak self] url in
                self?.presenter.presentOptions(file: url!)
            }, onError: { [weak self] _ in
                hud?.hide()
                self?.presenter.presentAlert(title: nil, message: LocalizedString("EXPORT_ERROR"))
            }).disposed(by: bag)
    }
    
    func importBackup(_ backup: RemoteBackupMetadata, overwrite: Bool) {
        weak var hud = PendingHUDView.showFullScreen()
        BackupProvidersManager.shared.downloadDatabase(remoteBackupMetadata: backup)
            .map({ database -> [WBReceipt] in
                let path = NSTemporaryDirectory().asNSString.appendingPathComponent(SYNC_DB_NAME)
                Database.sharedInstance().importData(fromBackup: path, overwrite: overwrite)
                if !database.open() { return [] }
                let trips = database.allTrips() as! [WBTrip]
                var result = [WBReceipt]()
                for trip in trips {
                    let receipts = database.allReceipts(for: trip) as! [WBReceipt]
                    result.append(contentsOf: receipts.filter({ !$0.syncId.isEmpty }))
                }
                database.close()
                return result
            }).asObservable().flatMap({ receipts -> Observable<WBReceipt> in
                return receipts.asObservable().delayEach(.seconds(1), scheduler: MainScheduler.instance)
            }).flatMap({ receipt -> Observable<(WBReceipt, BackupReceiptFile)> in
                return BackupProvidersManager.shared.downloadReceiptFile(syncId: receipt.syncId)
                    .asObservable()
                    .map({ (receipt, $0) })
            })
            .subscribe(onNext: { [weak self] downloaded in
              let receipt = downloaded.0
              let file = downloaded.1

              let path = receipt.imageFilePath(for: receipt.trip)
              let folder = path.asNSString.deletingLastPathComponent
              let fm = FileManager.default
              if !fm.fileExists(atPath: folder) {
                  do {
                    try fm.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
                  } catch {
                    hud?.hide()
                    self?.presenter.presentAlert(title: nil, message: LocalizedString("IMPORT_ERROR"))
                  }
              }
              let result = fm.createFile(atPath: path, contents: file.data, attributes: nil)
              if result {
                hud?.hide()
                Toast.show(LocalizedString("toast_import_complete"))
                SyncService.shared.trySyncData()
              } else {
                hud?.hide()
                self?.presenter.presentAlert(title: nil, message: LocalizedString("IMPORT_ERROR"))
              }
            }, onError: { [weak self] _ in
              hud?.hide()
              self?.presenter.presentAlert(title: nil, message: LocalizedString("IMPORT_ERROR"))
            }).disposed(by: bag)
    }
    
    func deleteBackup(_ backup: RemoteBackupMetadata) {
        weak var hud = PendingHUDView.showFullScreen()
        BackupProvidersManager.shared.deleteBackup(remoteBackupMetadata: backup)
            .andThen(onDeleteBackup(backup))
            .subscribe(onCompleted: { [weak self] in
                self?.presenter.updateBackups()
                hud?.hide()
                Toast.show(LocalizedString("dialog_remote_backup_delete_toast_success"))
            }, onError: { [weak self] error in
                hud?.hide()
                self?.presenter.presentAlert(title: nil, message: LocalizedString("dialog_remote_backup_delete_toast_failure"))
            }).disposed(by: bag)
    }
    
    func getBackups() -> Single<[RemoteBackupMetadata]> {
        return BackupProvidersManager.shared.getRemoteBackups()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return purchaseService.purchasePlusSubscription().asVoid()
    }
    
    func saveCurrent(provider: SyncProvider) {
        guard provider == .googleDrive else { setup(provider: provider); return }
        weak var hud = PendingHUDView.showFullScreen()
        GoogleDriveService.shared.signIn()
            .subscribe(onNext: { [weak self, weak hud] in
                self?.setup(provider: .googleDrive)
                hud?.hide()
            }, onError: { [weak self] error in
                self?.setup(provider: .none)
                hud?.hide()
            }).disposed(by: bag)
    }
    
    func setupUseWifiOnly(enabled: Bool) {
        WBPreferences.setAutobackupWifiOnly(enabled)
    }
    
    private func setup(provider: SyncProvider) {
        SyncProvider.current = provider
        presenter.updateUI()
        presenter.updateBackups()
    }
    
    private func onDeleteBackup(_ backup: RemoteBackupMetadata) -> Completable {
        guard isCurrentDevice(backup: backup) else { return .empty() }
        return BackupProvidersManager.shared.clearCurrentBackupConfiguration()
            .do(onCompleted: {
                Database.sharedInstance().markAllEntriesSynced(false)
                AppNotificationCenter.postDidSyncBackup()
            })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupInteractor {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
}
