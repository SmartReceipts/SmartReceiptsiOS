//
//  GoogleDriveBackupProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import GoogleAPIClientForREST_Drive

class GoogleDriveBackupProvider: BackupProvider {
    let backupMetadata = GoogleDriveSyncMetadata()
    private var syncErrorsSubject = BehaviorSubject<SyncError?>(value: nil)
    
    var deviceSyncId: String? {
        return backupMetadata.deviceIdentifier
    }
    
    var lastDatabaseSyncTime: Date {
        return backupMetadata.getLastDatabaseSyncTime() ?? Date(timeIntervalSince1970: 0)
    }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return GoogleDriveService.shared.getFolders(name: SYNC_FOLDER_NAME)
            .map({ list -> [RemoteBackupMetadata] in
                var result = [RemoteBackupMetadata]()
                guard let files = list.files else { return result }
                for file in files {
                    result.append(DefaultRemoteBackupMetadata(file: file))
                }
                return result
            }).do(onError: { [weak self] in self?.handleError($0) })
    }
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Completable {
        return GoogleDriveService.shared.getFiles(inFolderId: remoteBackupMetadata.id)
            .flatMap({ fileList -> Single<Bool> in
                guard let dbFile = fileList.files?.filter({ $0.name == SYNC_DB_NAME }).first else { return Single<Bool>.never() }
                return GoogleDriveService.shared.downloadFile(id: dbFile.identifier!)
                    .map({ $0.data })
                    .map({ data -> Bool in
                        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(SYNC_DB_NAME)!
                        do { try data.write(to: fileURL) } catch { return false }
                        return Database.sharedInstance().importData(fromBackup: fileURL.path, overwrite: overwriteExistingData)
                    })
            }).asCompletable()
            .do(onError: { [weak self] in self?.handleError($0) })
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Completable {
        return GoogleDriveService.shared.deleteFile(id: remoteBackupMetadata.id)
            .do(onError: { [weak self] in self?.handleError($0) })
    }
    
    func clearCurrentBackupConfiguration() -> Completable {
        return Completable.create(subscribe: { [weak self] completable -> Disposable in
            Database.sharedInstance().markAllEntriesSynced(false)
            self?.backupMetadata.clear()
            completable(.completed)
            return Disposables.create()
        })
    }
    
    func downloadDatabase(remoteBackupMetadata: RemoteBackupMetadata) -> Single<Database> {
        return GoogleDriveService.shared.getFiles(inFolderId: remoteBackupMetadata.id)
            .flatMap({ fileList -> Single<Database> in
                guard let dbFile = fileList.files?.filter({ $0.name == SYNC_DB_NAME }).first else { return Single<Database>.never() }
                return GoogleDriveService.shared.downloadFile(id: dbFile.identifier!)
                    .map({ $0.data })
                    .map({ data -> Database in
                        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(SYNC_DB_NAME)!
                        try? data.write(to: fileURL)
                        return Database(databasePath: fileURL.absoluteString, tripsFolderPath: FileManager.tripsDirectoryPath)
                    })
            }).do(onError: { [weak self] in self?.handleError($0) })
    }
    
    func downloadReceiptFile(syncId: String) -> Single<BackupReceiptFile> {
        return GoogleDriveService.shared.downloadFile(id: syncId)
            .map({ fileData -> BackupReceiptFile in
                return ("", fileData.data)
            }).do(onError: { [weak self] in self?.handleError($0) })
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return fetchBackup(remoteBackupMetadata: remoteBackupMetadata, debug: false)
    }
    
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return fetchBackup(remoteBackupMetadata: remoteBackupMetadata, debug: true)
    }
    
    func getCriticalSyncErrorStream() -> Observable<SyncError> {
        return syncErrorsSubject.asObservable().filter({ $0 != nil }).map({ $0! }).asObservable()
    }
    
    func markErrorResolved(syncErrorType: SyncError) {
        guard let currentError = try? syncErrorsSubject.value() else { return }
        if syncErrorType == currentError {
            syncErrorsSubject.onNext(nil)
        }
    }
    
    // MARK: - Private
    
    private func fetchBackup(remoteBackupMetadata: RemoteBackupMetadata, debug: Bool) -> Single<BackupFetchResult> {
        return GoogleDriveService.shared.getFiles(inFolderId: remoteBackupMetadata.id)
            .flatMap({ fileList -> Single<BackupFetchResult> in
                guard let dbFile = fileList.files?.filter({ $0.name == SYNC_DB_NAME }).first else { return .never() }
                guard let receiptFiles = fileList.files?.filter({ $0.name != SYNC_DB_NAME }) else { return .never() }
                return GoogleDriveService.shared.downloadFile(id: dbFile.identifier!).asObservable()
                    .map({ $0.data })
                    .map({ data -> Database in
                        let dbName = debug ? "\(dbFile.identifier!)_\(SYNC_DB_NAME)" : SYNC_DB_NAME
                        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(dbName)!
                        try? data.write(to: fileURL)
                        return Database(databasePath: fileURL.absoluteString, tripsFolderPath: FileManager.tripsDirectoryPath)
                    }).flatMap({ database -> Single<BackupFetchResult> in
                        return receiptFiles.asObservable()
                            .filter({ $0.name != SYNC_DB_NAME })
                            // Added to avoid Google Drive requests rate
                            .delayEach(.milliseconds(200), scheduler: BackgroundScheduler)
                            .flatMap({ file -> Observable<(GTLRDrive_File, Data)> in
                                return GoogleDriveService.shared.downloadFile(id: file.identifier!).asObservable()
                                    .map({ (file, $0.data) })
                            })
                            .map({ downloading -> BackupReceiptFile in
                                let file = downloading.0
                                let filename = debug ? "\(file.identifier!)_\(file.name!)" : file.name!
                                return (filename, downloading.1)
                            }).toArray()
                            .map({ downloadedFiles -> BackupFetchResult in
                                return BackupFetchResult(database, downloadedFiles)
                            })
                        
                    }).asSingle()
            }).do(onError: { [weak self] in self?.handleError($0) })
    }
    
    private func handleError(_ error: Error) {
        let syncError = SyncError.error(error)
        syncErrorsSubject.onNext(syncError)
    }
}
