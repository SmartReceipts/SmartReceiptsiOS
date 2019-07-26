//
//  DebugFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import RxCocoa
import Toaster
import Crashlytics
import GoogleSignIn

fileprivate let SCAN_ROW = "ScanRow"

class DebugFormView: FormViewController, GIDSignInUIDelegate {
    
    fileprivate let loginSubject = PublishSubject<Void>()
    fileprivate let ocrConfigSubject = PublishSubject<Void>()
    fileprivate let testLoginSubject = PublishSubject<Void>()
    fileprivate let subscriptionSubject = PublishSubject<Bool>()
    fileprivate let scanSubject = PublishSubject<Void>()
    private let s3Service = S3Service()
    private let organizationService = OrganizationsService()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section("Modules")
        <<< ButtonRow() { row in
            row.title = "Auth Module"
        }.onCellSelection({ [unowned self] _,_  in
            self.loginSubject.onNext(())
        })
            
        <<< ButtonRow() { row in
            row.title = "OCR Configuration Module"
        }.onCellSelection({ [unowned self] _,_  in
            self.ocrConfigSubject.onNext(())
        })
            
        +++ Section("Flags")
        <<< SwitchRow() { row in
            row.title = "Subscription"
            row.value = DebugStates.subscription()
        }.onChange({ [unowned self] row in
            self.subscriptionSubject.onNext(row.value!)
        })
            
        <<< SwitchRow() { row in
            row.title = "Use Production endpoints"
            row.value = FeatureFlags.useProdEndpoints.isEnabled
        }.onChange({ row in
            FeatureFlags.useProdEndpoints = Feature(row.value!)
        })
        
        +++ Section("Amazon S3")
        <<< ButtonRow() {row in
            row.title = "Upload Test Image"
            row.cell.imageView?.image = #imageLiteral(resourceName: "launch_image")
        }.onCellSelection({ [unowned self] cell, row in
            if let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TestImage.jpg") {
                try? #imageLiteral(resourceName: "launch_image").pngData()?.write(to: imageURL)
                self.s3Service.upload(file: imageURL)
                    .flatMap({ url -> Observable<UIImage> in
                        return self.s3Service.downloadImage(url)
                    }).subscribe(onNext: { img in
                        
                    }, onError: {
                        Toast.show($0.localizedDescription)
                    }).disposed(by: self.bag)
            }
        }).cellSetup({ cell, row in
            cell.tintColor = AppTheme.primaryColor
        })
        
        +++ Section("Scan")
        <<< ButtonRow() { row in
            row.title = "Test Scan"
        }.onCellSelection({ [unowned self] cell, row in
            self.scanSubject.onNext(())
        })
            
        <<< ScanRow(SCAN_ROW)
        
        +++ Section("Crashlytics")
        <<< SwitchRow() { row in
            row.title = "Crashlytics 'DEBUG MODE'"
            row.value = Crashlytics.sharedInstance().debugMode
        }.onChange({ row in
            guard let value = row.value else { return }
            Crashlytics.sharedInstance().debugMode = value
        })
            
        <<< ButtonRow() { row in
            row.title = "Initiate crash"
        }.onCellSelection({ _, _ in
            Crashlytics.sharedInstance().debugMode = false
            Crashlytics.sharedInstance().crash()
        })
        
        <<< ButtonRow() { row in
            row.title = "Initiate Exception"
        }.onCellSelection({ _, _ in
            Crashlytics.sharedInstance().debugMode = false
            Crashlytics.sharedInstance().throwException()
        })
        
        +++ Section("Automatic Backups")
        <<< ButtonRow() { row in
            row.title = "Google Drive - Sign In"
        }.onCellSelection({ [unowned self] _, _ in
            let hud = PendingHUDView.show(on: self.view)
            GoogleDriveService.shared.signIn(onUI: self).subscribe(onNext: {
                hud.hide()
            }).disposed(by: self.bag)
        })
        
        <<< ButtonRow() { row in
            row.title = "Google Drive - Sign Out"
        }.onCellSelection({ [unowned self] _, _ in
            let hud = PendingHUDView.show(on: self.view)
            GoogleDriveService.shared.signOut().subscribe(onNext: {
                hud.hide()
            }).disposed(by: self.bag)
        })
        
        <<< SwitchRow() { row in
            row.title = "Use AppData Folder"
            row.value = FeatureFlags.driveAppDataFolder.isEnabled
        }.onChange({ row in
            FeatureFlags.driveAppDataFolder = Feature(row.value!)
            _ = BackupProvidersManager.shared.clearCurrentBackupConfiguration().subscribe()
        })
        
        +++ Section("Organizations")
        <<< ButtonRow() { row in
            row.title = "Get Organizations"
        }.onCellSelection({ [unowned self] _, _ in
            self.organizationService.getOrganizations()
                .subscribe(onSuccess: { orgs in
                    print(orgs)
                }).disposed(by: self.bag)
        })
    }
    
    var scanObserver: AnyObserver<ScanResult> {
        return AnyObserver<ScanResult>(onNext: { [weak self] scanResult in
            if self == nil { return }
            let scanRow = self!.form.rowBy(tag: SCAN_ROW) as! ScanRow
            scanRow.value = scanResult
            scanRow.updateCell()
        })
    }
    
}

extension Reactive where Base: DebugFormView  {
    var loginTap: Observable<Void> { return base.loginSubject }
    var ocrConfiurationTap: Observable<Void> { return base.ocrConfigSubject }
    var subscriptionChange: Observable<Bool> { return base.subscriptionSubject }
    var testLoginTap: Observable<Void> { return base.testLoginSubject }
    var scanTap: Observable<Void> { return base.scanSubject }
}
