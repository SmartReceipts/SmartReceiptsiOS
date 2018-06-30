//
//  NoOpBackupProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class NoOpBackupProvider: BackupProvider {
    
    var deviceSyncId: String {
        return ""
    }
    
    var lastDatabaseSyncTime: Date {
        return Date()
    }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return Single<[RemoteBackupMetadata]>.just([])
    }
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Single<Bool> {
        return Single<Bool>.just(false)
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Single<Bool> {
        return Single<Bool>.just(false)
    }
    
    func clearCurrentBackupConfiguration() -> Single<Bool> {
        return Single<Bool>.just(false)
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata, downloadLocation: URL) -> Single<[URL]> {
        return Single<[URL]>.just([])
    }
    
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata, downloadLocation: URL) -> Single<[URL]> {
        return Single<[URL]>.just([])
    }
    
    func getCriticalSyncErrorStream() -> Observable<CriticalSyncError> {
        return Observable<CriticalSyncError>.empty()
    }
    
    func markErrorResolved(syncErrorType: SyncErrorType) {
        
    }
}
