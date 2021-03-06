//
//  ReceiptsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ReceiptsInteractor: Interactor {
    var fetchedModelAdapter: FetchedModelAdapter!
    var trip: WBTrip!
    var scanService: ScanService!
    
    private let bag = DisposeBag()
    
    required init() {
        scanService = ScanService()
    }
    
    func configureSubscribers() {
        presenter.receiptDeleteSubject.subscribe( onNext: { receipt in
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuDelete())
            if SyncProvider.current == .none || receipt.attachemntType == .none {
                Database.sharedInstance().delete(receipt)
            } else {
                SyncService.shared.deleteFile(receipt: receipt)
            }
        }).disposed(by: bag)
    }
    
    func distanceReceipts() -> [WBReceipt] {
        let distances = Database.sharedInstance().fetchedAdapterForDistances(in: trip, ascending: true)
        return DistancesToReceiptsConverter.convertDistances(distances!.allObjects()) as! [WBReceipt]
    }
    
    func fetchedAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        fetchedModelAdapter = Database.sharedInstance().fetchedReceiptsAdapter(for: trip)
        return fetchedModelAdapter
    }
    
    func swapUpReceipt(_ receipt: WBReceipt) {
        let idx = Int(fetchedModelAdapter.index(for: receipt))
        if idx == 0 || idx == NSNotFound {
            return
        }
        swapReceipt(idx1: idx, idx2: idx - 1)
    }
    
    func swapDownReceipt(_ receipt: WBReceipt) {
        let idx = Int(fetchedModelAdapter.index(for: receipt))
        if idx >= Int(fetchedModelAdapter.numberOfObjects()) - 1 || idx == NSNotFound {
            return
        }
        swapReceipt(idx1: idx, idx2: idx + 1)
    }
    
    func attachAppInputFile(to receipt: WBReceipt) -> Bool {
        let result = processAttachFile(to: receipt)
        AppDelegate.instance.freeFilePathToAttach()
        return result
    }
    
    func attachImage(_ image: UIImage, to receipt: WBReceipt) -> Bool {
        let imageFileName = String(format: "%tu_%@.jpg", receipt.receiptId(), receipt.omittedName)
        let path = receipt.trip.file(inDirectoryPath: imageFileName)
        if !FileManager.forceWrite(data: image.jpegData(compressionQuality: kImageCompression)!, to: path!) {
            return false
        }
        receipt.isSynced = false
        if !Database.sharedInstance().update(receipt, changeFileNameTo: imageFileName) {
            Logger.error("Error: cannot update image file")
            return false
        }
        return true
    }
    
    private func processAttachFile(to receipt: WBReceipt) -> Bool {
        guard let file = AppDelegate.instance.filePathToAttach else { return false }
        let ext = file.asNSString.pathExtension
        
        let imageFileName = String(format: "%tu_%@.%@", receipt.receiptId(), receipt.omittedName, ext)
        let newFile = receipt.trip.file(inDirectoryPath: imageFileName)
        
        if !FileManager.forceCopy(from: file, to: newFile!) {
            Logger.error("Couldn't force copy from \(file) to \(newFile!)")
            return false
        }
        
        if !Database.sharedInstance().update(receipt, changeFileNameTo: imageFileName) {
            Logger.error("Error: cannot update image file \(imageFileName) for receipt \(receipt.name)")
            return false
        }
        return true
    }
    
    private func swapReceipt(idx1: Int, idx2: Int) {
        let rec1 = fetchedModelAdapter.object(at: idx1) as! WBReceipt
        let rec2 = fetchedModelAdapter.object(at: idx2) as! WBReceipt
        
        if !Database.sharedInstance().reorder(rec1, with: rec2) {
            Logger.warning("Error: Cannot Swap")
        }
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsInteractor {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
}
