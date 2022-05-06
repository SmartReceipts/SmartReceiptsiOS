//
//  S3Service.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import AWSS3
import RxSwift

fileprivate let BUCKET = "smartreceipts"
fileprivate let FOLDER = "ocr/"
fileprivate let AMAZON_PREFIX = "https://s3.amazonaws.com/"

class S3Service {
    private var cognitoService = CognitoService()
    private var credentialsProvider: AWSCognitoCredentialsProvider!
    private let transferUtility: AWSS3TransferUtility!
    private let bag = DisposeBag()
    
    init() {
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityProvider: cognitoService)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        transferUtility = AWSS3TransferUtility.default()
        
        AuthService.shared.loggedInObservable
            .filter({ !$0 })
            .subscribe(onNext: { [weak self] _ in
                self?.cognitoService.clear()
            }).disposed(by: bag)
    }
    
    func upload(image: UIImage) -> Observable<URL> {
        if let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.jpg") {
            try? image.jpegData(compressionQuality: 1.0)?.write(to: imageURL)
            return upload(file: imageURL)
        }
        return Observable.error(NSError(domain: "temp.image.url.error", code: 1, userInfo: nil))
    }
    
    func upload(file url: URL) -> Observable<URL> {
        return Observable<URL>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            let key = FOLDER + UUID().uuidString + "_\(url.lastPathComponent)"
            
            self.transferUtility.uploadFile(
                url,
                bucket: BUCKET,
                key: key,
                contentType: "image/jpeg",
                expression: nil,
                completionHandler: { _, error in
                    if let error = error  {
                        printError(error, operation: "Upload")
                        observer.onError(error)
                    } else {
                        Logger.debug("Upload complete for: \(key)")
                        var resultURL = URL(string: AMAZON_PREFIX + BUCKET)
                        resultURL = resultURL!.appendingPathComponent(key)
                        observer.onNext(resultURL!)
                        observer.onCompleted()
                    }
                }
            ).continueWith(executor: .mainThread(), block: { task in
                if let error = task.error  {
                    printError(error, operation: "Upload")
                    observer.onError(error)
                }
                return nil
            })
            return Disposables.create()
        }
    }
    
    func downloadImage(_ url: URL, folder: String = FOLDER) -> Observable<UIImage> {
        return Observable<UIImage>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(url.lastPathComponent)
            
            let key = folder + url.lastPathComponent
            
            self.transferUtility.download(
                to: downloadingFileURL,
                bucket: BUCKET,
                key: key,
                expression: nil,
                completionHandler: {  _, url, data, error in
                    if let error = error  {
                        printError(error, operation: "Download")
                        observer.onError(error)
                    } else {
                        Logger.debug("Download complete for: \(url)")
                        let img = UIImage(data: try! Data(contentsOf: downloadingFileURL))
                        observer.onNext(img!)
                        observer.onCompleted()
                    }
                }).continueWith(executor: .mainThread(), block: { task in
                    if let error = task.error  {
                        printError(error, operation: "Download")
                        observer.onError(error)
                    }
                    return nil
                })
            return Disposables.create()
        }
    }
}

fileprivate func printError(_ error: Error, operation: String) {
    Logger.error(operation + " Error: \(error)")
}
