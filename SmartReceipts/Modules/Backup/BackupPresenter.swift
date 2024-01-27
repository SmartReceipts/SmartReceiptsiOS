//
//  BackupPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import GoogleSignIn

class BackupPresenter: Presenter {
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        view.importTap
            .subscribe(onNext: { [unowned self] in
                self.router.openBackupImport()
            }).disposed(by: bag)
    }
    
    func getBackups() -> Single<[RemoteBackupMetadata]> {
        return interactor.getBackups()
    }
    
    func importBackup(_ backup: RemoteBackupMetadata, overwrite: Bool) {
        interactor.importBackup(backup, overwrite: overwrite)
    }
    
    func deleteBackup(_ backup: RemoteBackupMetadata) {
        interactor.deleteBackup(backup)
    }
    
    func downloadZip(_ backup: RemoteBackupMetadata) {
        interactor.downloadZip(backup)
    }
    
    func downloadDebugZip(_ backup: RemoteBackupMetadata) {
        interactor.downloadDebugZip(backup)
    }
    
    func isCurrentDevice(backup: RemoteBackupMetadata) -> Bool {
        return interactor.isCurrentDevice(backup: backup)
    }
    
    func hasValidSubscription() -> Bool {
        return interactor.hasValidSubscription()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return interactor.purchaseSubscription()
    }
    
    func saveCurrent(provider: SyncProvider) {
        interactor.saveCurrent(provider: provider)
    }
    
    func updateUI() {
        view.updateUI()
    }
    
    func updateBackups() {
        view.updateBackups()
    }
    
    func presentOptions(file: URL) {
        view.showOptions(file: file)
    }
    
    func setupUseWifiOnly(enabled: Bool) {
        interactor.setupUseWifiOnly(enabled: enabled)
    }
    
    func openSubscriptionPage() {
        router.openSubscriptionPage()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupPresenter {
    var view: BackupViewInterface {
        return _view as! BackupViewInterface
    }
    var interactor: BackupInteractor {
        return _interactor as! BackupInteractor
    }
    var router: BackupRouter {
        return _router as! BackupRouter
    }
}
