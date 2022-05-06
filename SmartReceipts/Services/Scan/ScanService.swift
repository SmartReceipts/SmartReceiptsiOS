//
//  ScanService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import Toaster

fileprivate let PUSH_TIMEOUT: RxTimeInterval = .seconds(15)
fileprivate let NETWORK_TIMEOUT: RxTimeInterval = .seconds(10)
fileprivate let RECOGNITION_KEY = "recognition"

class ScanService {
    private var s3Service: S3Service!
    private var recognitionService: RecognitionService!
    private var pushNotificationService: PushNotificationService!
    private var authService: AuthServiceInterface!
    private var scansPurchaseTracker: ScansPurchaseTracker!
    fileprivate let statusSubject = PublishSubject<ScanStatus>()
    
    init(s3Service: S3Service,
         recognitionService: RecognitionService,
         pushService: PushNotificationService,
         authService: AuthServiceInterface,
         scansPurchaseTracker: ScansPurchaseTracker)
    {
        self.s3Service = s3Service
        self.recognitionService = recognitionService
        self.pushNotificationService = pushService
        self.authService = authService
        self.scansPurchaseTracker = scansPurchaseTracker
    }
    
    convenience init(){
        self.init(s3Service: S3Service(),
                  recognitionService: RecognitionService(),
                  pushService: PushNotificationService.shared,
                  authService: AuthService.shared,
                  scansPurchaseTracker: ScansPurchaseTracker.shared)
    }
    
    var status: Observable<ScanStatus> {
        return statusSubject.observe(on: MainScheduler.instance).asObservable()
    }
    
    func scan(image: UIImage) -> Single<ScanResult> {
        let doc = ReceiptDocument.makeDocumentFrom(image: image)
        return scan(document: doc)
    }
    
    func scan(document: ReceiptDocument) -> Single<ScanResult> {
        guard let url = document.localURL else { return .just(ScanResult(filepath: document.localURL!)) }
        
        if WBPreferences.automaticScansEnabled() && FeatureFlags.ocrSupport.isEnabled &&
            authService.isLoggedIn && scansPurchaseTracker.hasAvailableScans {
            pushNotificationService.updateToken()
            statusSubject.onNext(.uploading)
            
            return scanFrom(uploading: s3Service.upload(file: url), document: document)
        } else {
            let isFeatureEnabled = "isFeatureEnabled = \(FeatureFlags.ocrSupport.isEnabled)"
            let isLoggedIn = "isLoggedIn = \(AuthService.shared.isLoggedIn)"
            let hasAvailableScans = "hasAvailableScans = \(ScansPurchaseTracker.shared.hasAvailableScans)"
            let authScansEabled = "authScansEabled = \(ScansPurchaseTracker.shared.hasAvailableScans)"
            Logger.debug("Ignoring OCR: \(isFeatureEnabled), \(isLoggedIn), \(hasAvailableScans), \(authScansEabled).")
            statusSubject.onNext(.completed)
            
            return .just(ScanResult(filepath: document.localURL!))
        }
    }
    
    private func scanFrom(uploading: Observable<URL>, document: ReceiptDocument) -> Single<ScanResult> {
        return uploading
            .do(onSubscribed: { AnalyticsManager.sharedManager.record(event: Event.ocrRequestStarted()) })
            .catch({ _ -> Observable<URL> in
                return AuthService.shared.getUser()
                    .do(onSuccess: { CognitoService.saveCognitoData(user: $0) })
                    .do(onError: { [weak self] in self?.handle(error: $0) })
                    .asObservable()
                    .flatMap({ _ in uploading })
            }).asSingle()
            .flatMap({ [weak self] url -> Single<String> in
                guard let api = self?.recognitionService else {
                    self?.statusSubject.onNext(.completed)
                    return Single<String>.never()
                }
                self?.statusSubject.onNext(.scanning)
                return api.recognize(url: url, incognito: !WBPreferences.allowSaveImageForAccuracy())
            })
            .flatMap({ [weak self] id -> Single<String> in
                if let recognition = self?.getRecognitionID(id: id) { return recognition }
                return .just(id)
            })
            .flatMap({ [weak self] id -> Single<ScanResult> in
                guard let service = self?.recognitionService else { return .never() }
                self?.statusSubject.onNext(.fetching)
                return service.getRecognition(id)
                    .map { $0.recognition }
                    .timeout(NETWORK_TIMEOUT, scheduler: MainScheduler.instance)
                    .do(onError: { error in
                        AnalyticsManager.sharedManager.record(event: Event.ocrRequestFailed())
                        AnalyticsManager.sharedManager.record(event: ErrorEvent(error: error))
                    }).map({ ScanResult(recognition: $0, filepath: document.localURL!) })
                    .do(onSuccess: { [weak self] _ in
                        self?.statusSubject.onNext(.completed)
                        AnalyticsManager.sharedManager.record(event: Event.ocrRequestSucceeded())
                        ScansPurchaseTracker.shared.decrementRemainingScans()
                    })
            })
            .catch({ error -> Single<ScanResult> in
                return .just(ScanResult(filepath: document.localURL!))
            })
    }
    
    private func getRecognitionID(id: String) -> Single<String> {
        guard let pushService = self.pushNotificationService else { return .never() }
        
        let recognitionByPush = pushService.notification
            .map { _ in id }
            .do(onNext: { _ in
                AnalyticsManager.sharedManager.record(event: Event.ocrPushMessageReceived())
            })
        
        let recognitionByTimeOut = Observable.just(id)
            .delay(PUSH_TIMEOUT, scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                AnalyticsManager.sharedManager.record(event: Event.ocrPushMessageTimeOut())
            })

        return Observable.of(recognitionByPush, recognitionByTimeOut)
            .merge()
            .take(1)
            .asSingle()
    }
    
    private func handle(error: Error) {
        switch error.code {
        case 300...599:
            _ = AuthService.shared.logout()
            Logger.debug(error.localizedDescription)
        default: break
        }
    }
}

enum ScanStatus {
    case uploading
    case scanning
    case fetching
    case completed
    
    var localizedText: String {
        switch self {
        case .uploading: return LocalizedString("ocr_status_message_uploading_image")
        case .scanning: return LocalizedString("ocr_status_message_performing_scan")
        case .fetching: return LocalizedString("ocr_status_message_fetching_results")
        case .completed: return ""
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .uploading: return #imageLiteral(resourceName: "upload-cloud")
        case .scanning: return #imageLiteral(resourceName: "cpu")
        case .fetching: return #imageLiteral(resourceName: "download-cloud")
        case .completed: return nil
        }
    }
}
