//
//  EditReceiptInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

fileprivate let MIN_SCANS_TOOLTIP = 5

class EditReceiptInteractor: Interactor {
    private let tooltipBag = DisposeBag()
    private var authService: AuthServiceInterface!
    private var scansPurchaseTracker: ScansPurchaseTracker!
    private var tooltipService: TooltipService!
    var receiptFilePath: URL?
    let bag = DisposeBag()
    
    required init(
        authService: AuthServiceInterface,
        scansPurchaseTracker: ScansPurchaseTracker,
        tooltipService: TooltipService
    ) {
        self.authService = authService
        self.scansPurchaseTracker = scansPurchaseTracker
        self.tooltipService = tooltipService
    }
    
    convenience required init() {
        self.init(
            authService: AuthService.shared,
            scansPurchaseTracker: ScansPurchaseTracker.shared,
            tooltipService: TooltipService.shared
        )
    }
    
    func configureSubscribers() {
        presenter.addReceiptSubject
            .subscribe(onNext: { [unowned self] receipt in
                Logger.debug("Added Receipt: \(receipt.name)")
                AnalyticsManager.sharedManager.record(event: Event.receiptsPersistNewReceipt())
                self.saveImage(to: receipt)
                self.save(receipt: receipt)
            }).disposed(by: bag)
        
        presenter.updateReceiptSubject
            .subscribe(onNext: { [unowned self] receipt in
                Logger.debug("Updated Receipt: \(receipt.name)")
                AnalyticsManager.sharedManager.record(event: Event.receiptsPersistUpdateReceipt())
                self.replaceImageIfNeeded(receipt: receipt)
                self.save(receipt: receipt)
            }).disposed(by: bag)
        
        presenter.paymentMehtodInsert
            .subscribe(onNext: { [weak self] in
                self?.insertPaymentMethods()
            }).disposed(by: bag)
    }
    
    func tooltipText() -> String? {
        if authService.isLoggedIn && scansPurchaseTracker.remainingScans < MIN_SCANS_TOOLTIP {
            let format = LocalizedString("ocr.informational.tooltip.limited.scans.text")
            return String.localizedStringWithFormat(format, scansPurchaseTracker.remainingScans)
        } else if !authService.isLoggedIn && !tooltipService.configureOCRDismissed() {
            presenter.tooltipClose
                .subscribe(onNext: { [unowned self] in
                    self.tooltipService.markConfigureOCRDismissed()
                }).disposed(by: tooltipBag)
            return LocalizedString("ocr_informational_tooltip_configure_text")
        }
        return nil
    }
    
    private func insertPaymentMethods() {
        let csvColumns = Database.sharedInstance().allCSVColumns() as! [ReceiptColumn]
        let pdfColumns = Database.sharedInstance().allPDFColumns() as! [ReceiptColumn]
        
        let columnName = LocalizedString("column_item_payment_method")
        let columnType = 27
        
        if !csvColumns.contains(where: { $0.isKind(of: ReceiptColumnPaymentMethod.self) }) {
            let index = Database.sharedInstance().nextCSVColumnObjectID()
            let paymentMethodColumn = ReceiptColumnPaymentMethod(index: index,type: columnType, name: columnName)
            Database.sharedInstance().addCSVColumn(paymentMethodColumn)
        }
        
        if !pdfColumns.contains(where: { $0.isKind(of: ReceiptColumnPaymentMethod.self) }) {
            let index = Database.sharedInstance().nextPDFColumnObjectID()
            let paymentMethodColumn = ReceiptColumnPaymentMethod(index: index,type: columnType, name: columnName)
            Database.sharedInstance().addPDFColumn(paymentMethodColumn)
        }
        
    }
    
    private func save(receipt: WBReceipt) {
        receipt.lastLocalModificationTime = Date()
        if !Database.sharedInstance().save(receipt) {
            presenter.present(errorDescription: LocalizedString("database_error"))
            let action = receipt.objectId == 0 ? "insert" : "update"
            Logger.error("Can't \(action) receipt: \(receipt.description)")
        } else {
            validateDate(in: receipt)
            presenter.done()
        }
    }
    
    private func replaceImageIfNeeded(receipt: WBReceipt) {
        if receipt.hasPDF() || receipt.hasImage() {
            let currentPath = receipt.imageFilePath(for: receipt.trip)
            let tripFolder = currentPath.asNSString.deletingLastPathComponent
            let newFileName = String(format: "%tu_%@.%@", receipt.objectId, receipt.omittedName, currentPath.asNSString.pathExtension)
            let newPath = "\(tripFolder)/\(newFileName)"
            receipt.setFilename(newFileName)
            
            do {
                try FileManager.default.moveItem(atPath: currentPath, toPath: newPath)
            } catch let error as NSError {
                Logger.error(error.localizedDescription)
            }
        }
    }
    
    private func saveImage(to receipt: WBReceipt) {
        if let url = receiptFilePath, let fileData = try? Data(contentsOf: url) {
            var imgFileName = ""
            let nextId = Database.sharedInstance().nextReceiptID()
            imgFileName = String(format: "%tu_%@.%@", nextId, receipt.omittedName, url.pathExtension)
            let path = receipt.trip.file(inDirectoryPath: imgFileName)
            if !FileManager.forceWrite(data: fileData, to: path!) {
                imgFileName = ""
            } else {
                receipt.setFilename(imgFileName)
            }
        }
    }
    
    private func validateDate(in receipt: WBReceipt) {
        Observable<Void>.just(())
            .filter({ receipt.date > receipt.trip.endDate || receipt.date < receipt.trip.startDate })
            .subscribe(onNext: {
                let message = LocalizedString("DIALOG_RECEIPTMENU_TOAST_BAD_DATE")
                Toast.show(message)
        }).disposed(by: bag)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptInteractor {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
}
