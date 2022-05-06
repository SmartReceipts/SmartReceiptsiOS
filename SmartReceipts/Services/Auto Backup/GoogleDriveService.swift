//
//  GoogleDriveService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST_Drive
import GTMAppAuth
import RxSwift

fileprivate let GOOGLE_CLIENT_ID = "718869294394-6p4ic33brhs8nd4rgvu72q76o5mfvft2.apps.googleusercontent.com"

fileprivate let FOLDER_MIME_TYPE = "application/vnd.google-apps.folder"

class GoogleDriveService: NSObject {
    static let shared = GoogleDriveService()
    
    private let gDriveService = GTLRDriveService()
    private var signInSubject = PublishSubject<Void>()
    private var signOutSubject = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    private var authScopes: [String] {
        return DebugStates.isDebug ? [kGTLRAuthScopeDrive, kGTLRAuthScopeDriveAppdata] : [kGTLRAuthScopeDriveAppdata]
    }
    
    private var spaces: String {
        return FeatureFlags.driveAppDataFolder.isEnabled ? "appDataFolder" : "drive"
    }
    
    private override init() {
        gDriveService.shouldFetchNextPages = true
        gDriveService.isRetryEnabled = true
    }
    
    func initialize() {
        if let viewController = UIApplication.shared.topViewCtonroller {
            GIDSignIn.sharedInstance.addScopes(
                authScopes,
                presenting: viewController,
                callback: signInHandler
            )
        }
        GIDSignIn.sharedInstance.restorePreviousSignIn(callback: signInHandler)
    }
    
    private func signInHandler(_ user: GIDGoogleUser?, error: Error?) {
        guard let sUser = user else {
            signInSubject.onError(error!)
            return
        }
        gDriveService.authorizer = sUser.authentication.fetcherAuthorizer()
        signInSubject.onNext(())
        signInSubject.onCompleted()
        BackupProvidersManager.shared.markErrorResolved(syncErrorType: .userRevokedRemoteRights)
    }
    
    func signIn() -> Observable<Void> {
        guard let viewController = UIApplication.shared.topViewCtonroller else { return .never() }
        signInSubject.dispose()
        signInSubject = PublishSubject<Void>()
        return signInSubject.do(onSubscribed: { [weak self] in
            guard let self = self else { return }
            GIDSignIn.sharedInstance.addScopes(
                self.authScopes,
                presenting: viewController,
                callback: self.signInHandler
            )
            GIDSignIn.sharedInstance.signIn(
                with: .init(clientID: GOOGLE_CLIENT_ID),
                presenting: viewController,
                callback: self.signInHandler
            )
        })
    }
    
    func signOut() -> Observable<Void> {
        signOutSubject.dispose()
        signOutSubject = PublishSubject<Void>()
        return signOutSubject.do(onSubscribed: {
            GIDSignIn.sharedInstance.disconnect(callback: { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.signOutSubject.onError(error)
                } else {
                    self.signOutSubject.onNext()
                }
            })
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        gDriveService.authorizer = nil
        error != nil ? signOutSubject.onError(error) : signOutSubject.onNext(())
        signOutSubject.onCompleted()
    }
    
    func findFile(name: String) -> Single<GTLRDrive_File> {
        let query = GTLRDriveQuery_FilesList.query()
        query.q = "name='\(name)'"
        query.spaces = spaces
        query.fields = "files(name, id, properties)"
        
        return Single<GTLRDrive_File>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let filelist = object as? GTLRDrive_FileList, let file = filelist.files?.first {
                    single(.success(file))
                }
            }
            return Disposables.create()
        })
    }
    
    func getFiles(inFolderId: String) -> Single<GTLRDrive_FileList> {
        let query = GTLRDriveQuery_FilesList.query()
        query.q = "'\(inFolderId)' in parents"
        query.spaces = spaces
        query.fields = "files(name, id, properties)"
        
        return Single<GTLRDrive_FileList>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let filelist = object as? GTLRDrive_FileList {
                    single(.success(filelist))
                }
            }
            return Disposables.create()
        })
    }
    
    func updateFile(id: String, file: GTLRDrive_File, data: Data, mimeType: String) -> Single<GTLRDrive_File> {
        let params = GTLRUploadParameters(data: data, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesUpdate.query(withObject: file, fileId: id, uploadParameters: params)
        return Single<GTLRDrive_File>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let file = object as? GTLRDrive_File {
                    single(.success(file))
                }
            }
            return Disposables.create()
        })
    }
    
    func downloadFile(id: String) -> Single<GTLRDataObject> {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: id)
        return Single<GTLRDataObject>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let data = object as? GTLRDataObject {
                    single(.success(data))
                }
            }
            return Disposables.create()
        })
    }
    
    func deleteFile(id: String) -> Completable {
        return Completable.create(subscribe: { completable -> Disposable in
            let query = GTLRDriveQuery_FilesDelete.query(withFileId: id)
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                error != nil ? completable (.error(error!)) : completable(.completed)
            }
            return Disposables.create()
        })
    }
    
    func getFolders(name: String? = nil) -> Single<GTLRDrive_FileList> {
        let query = GTLRDriveQuery_FilesList.query()
        var q = "mimeType='\(FOLDER_MIME_TYPE)'"
        if let folderName = name {
            q += "and name='\(folderName)'"
        }
        query.q = q
        query.spaces = spaces
        query.fields = "nextPageToken, files(id, name, properties, description, modifiedTime)"
        
        return Single<GTLRDrive_FileList>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let filelist = object as? GTLRDrive_FileList {
                    single(.success(filelist))
                }
            }
            return Disposables.create()
        })
    }
    
    func createFolder(name: String, parent: String? = nil, json: [AnyHashable : Any]? = nil, description: String? = nil) -> Single<GTLRDrive_File> {
        let folder = GTLRDrive_File()
        folder.name = name
        folder.mimeType = FOLDER_MIME_TYPE
        folder.descriptionProperty = description
        folder.properties = GTLRDrive_File_Properties(json: json)
        folder.parents = FeatureFlags.driveAppDataFolder.isEnabled ? [spaces] : nil
        
        if let p = parent {
            folder.parents == nil ? folder.parents = [p] : folder.parents?.append(p)
        }
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: folder, uploadParameters: nil)
        
        return Single<GTLRDrive_File>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let file = object as? GTLRDrive_File {
                    single(.success(file))
                }
            }
            return Disposables.create()
        })
    }
    
    func createFile(name: String, data: Data, mimeType: String, parent: String? = nil) -> Single<GTLRDrive_File> {
        let file = GTLRDrive_File()
        file.name = name
        if let p = parent { file.parents = [p] }
        
        let params = GTLRUploadParameters(data: data, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters:params)
        
        return Single<GTLRDrive_File>.create(subscribe: { [unowned self] single in
            self.gDriveService.executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let queryError = error {
                    single(.failure(queryError))
                } else if let file = object as? GTLRDrive_File {
                    single(.success(file))
                }
            }
            return Disposables.create()
        })
    }
}
