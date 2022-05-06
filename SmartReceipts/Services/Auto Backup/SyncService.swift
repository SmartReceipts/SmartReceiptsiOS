//
//  SyncService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol SyncServiceProtocol {
    func syncDatabase()
    
    func uploadFile(receipt: WBReceipt)
    func deleteFile(receipt: WBReceipt)
    func replaceFile(receipt: WBReceipt)
    func getCriticalSyncErrorStream() -> Observable<SyncError?>
}

class SyncService {
    static let shared = SyncService()
    
    private let bag = DisposeBag()
    private let network = NetworkReachabilityManager()
    
    private var syncService: SyncServiceProtocol?
    private var syncProvider: SyncProvider?
    private var syncErrorsSubject = BehaviorSubject<SyncError?>(value: nil)
    
    private var canUploadReceipts: Bool {
        guard let net = network else { return false }
        return !WBPreferences.autobackupWifiOnly() || net.isReachableOnEthernetOrWiFi
    }
    
    func initialize() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(didInsert(_:)), name: .DatabaseDidInsertModel, object: nil)
        center.addObserver(self, selector: #selector(didUpdate(_:)), name: .DatabaseDidUpdateModel, object: nil)
        center.addObserver(self, selector: #selector(didDelete(_:)), name: .DatabaseDidDeleteModel, object: nil)
        
        GoogleDriveService.shared.signIn()
            .subscribe({ _ in
                self.updateSyncServiceIfNeeded()
                self.configurePreferencesListeners()
                self.startListeningNetwork()
            }).disposed(by: bag)
    }
    
    // MARK: - Configurations
    
    private func configurePreferencesListeners() {
        AppNotificationCenter.preferencesWiFiOnly
            .subscribe(onNext: { wifiOnly in
                self.syncReceipts()
            }).disposed(by: bag)
        
        AppNotificationCenter.syncProvider
            .subscribe(onNext: { provider in
                self.updateSyncServiceIfNeeded()
                self.syncService?.syncDatabase()
                self.syncReceipts()
            }).disposed(by: bag)
    }
    
    private func startListeningNetwork() {
        network?.startListening(onUpdatePerforming: { status in
            switch status {
            case .reachable(.cellular):
                if !WBPreferences.autobackupWifiOnly() { self.syncReceipts() }
            case .reachable(.ethernetOrWiFi):
                self.syncReceipts()
            default: break
            }
        })
    }
    
    func trySyncData() {
        syncService?.syncDatabase()
        syncReceipts()
    }
    
    // MARK: - Private
    
    private func syncReceipts() {
        if !canUploadReceipts { return }
        
        var markedReceipts: [WBReceipt]!
        var unsyncedReceipts: [WBReceipt]!
        
        Database.sharedInstance().databaseQueue.inDatabase { db in
            markedReceipts = db.fetchAllMarkedForDeletionReceipts()
            unsyncedReceipts = db.fetchAllUnsyncedReceipts()
        }
        
        for receipt in markedReceipts {
            if !receipt.isSynced(syncProvider: .current) {
                deleteFile(receipt: receipt)
            } else {
                Database.sharedInstance().delete(receipt)
            }
        }
        
        unsyncedReceipts.asObservable()
            .filter { !$0.isMarkedForDeletion(syncProvider: .current) }
            .filter { !$0.isSynced }
            // Added to avoid Google Drive requests rate
            .delayEach(.milliseconds(300), scheduler: BackgroundScheduler)
            .subscribe(onNext: { [unowned self] receipt in
                guard let trip = Database.sharedInstance().tripBy(id: receipt.parentKey) else { return }
                receipt.trip = trip
                self.syncService?.uploadFile(receipt: receipt)
            }).disposed(by: bag)
    }
    
    func deleteFile(receipt: WBReceipt) {
        syncService?.deleteFile(receipt: receipt)
    }
    
    func getCriticalSyncErrorStream() -> Observable<SyncError?> {
        return syncErrorsSubject.asObservable()
    }
    
    func markErrorResolved(syncErrorType: SyncError) {
        guard let currentError = try? syncErrorsSubject.value() else { return }
        if syncErrorType == currentError {
            syncErrorsSubject.onNext(nil)
        }
    }
    
    private func updateSyncServiceIfNeeded() {
        if let provider = syncProvider, provider == SyncProvider.current { return }
        switch SyncProvider.current {
        case .googleDrive:
            syncService = GoogleSyncService()
            startListeningNetwork()
        case .none:
            syncService = nil
            network?.stopListening()
        }
        syncProvider = SyncProvider.current
        syncService?.getCriticalSyncErrorStream().bind(to: syncErrorsSubject).disposed(by: bag)
    }

    // MARK: - DB Handlers
    
    @objc private func didInsert(_ notification: Notification) {
        syncService?.syncDatabase()
        guard canUploadReceipts else { return }
        
        guard let receipt = notification.object as? WBReceipt, !receipt.isSynced(syncProvider: .current) else { return }
        let objectID = Database.sharedInstance().nextReceiptID() - UInt(1)
        guard let syncReceipt = Database.sharedInstance().receipt(byObjectID: objectID) else { return }
        syncReceipt.trip = receipt.trip
        syncService?.uploadFile(receipt: syncReceipt)
    }
    
    @objc private func didUpdate(_ notification: Notification)  {
        syncService?.syncDatabase()
        if !canUploadReceipts { return }
        
        guard let receipt = notification.object as? WBReceipt else { return }
        if !receipt.isSynced(syncProvider: .current) && !receipt.isMarkedForDeletion(syncProvider: .current) {
            let upload = receipt.getSyncId(provider: .current)?.isEmpty ?? true
            upload ? syncService?.uploadFile(receipt: receipt) : syncService?.replaceFile(receipt: receipt)
        }
    }
    
    @objc private func didDelete(_ notification: Notification)  {
        syncService?.syncDatabase()
    }
}


