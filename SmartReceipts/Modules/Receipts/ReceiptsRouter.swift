//
//  ReceiptsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ReceiptsRouter: Router {
    var moduleTrip: WBTrip! = nil
    private var documentViewController: UIDocumentInteractionController!
    private let bag = DisposeBag()
    private var subscription: Disposable?
    
    func openDistances() {
        let module = AppModules.tripDistances.build()
        module.router.show(from: _view.viewController, embedInNavController: true, setupData: moduleTrip)
    }
    
    func openImageViewer(for receipt: WBReceipt) {
        Observable<Void>.just(())
            .delay(.seconds(0), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let module = AppModules.receiptImageViewer.build()
                module.router.show(from: self._view.viewController, embedInNavController: false, setupData: receipt)
            }).disposed(by: bag)
    }
    
    func openPDFViewer(for receipt: WBReceipt) {
        Observable<Void>.just(())
            .delay(.seconds(0), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let url = URL(fileURLWithPath: receipt.imageFilePath(for: receipt.trip))
                self.documentViewController = UIDocumentInteractionController(url: url)
                self.documentViewController.name = receipt.name
                self.documentViewController.delegate = self._view as? UIDocumentInteractionControllerDelegate
                self.documentViewController.presentPreview(animated: true)
            }).disposed(by: bag)
    }
    
    func openGenerateReport() {
        let module = AppModules.generateReport.build()
        module.router.show(from: _view.viewController, embedInNavController: true, setupData: moduleTrip)
    }
    
    func openBackups() {
        let backupModuleView = AppModules.backup.build().view
        let navController = UINavigationController(rootViewController: backupModuleView.viewController)
        navController.modalTransitionStyle = .coverVertical
        navController.modalPresentationStyle = .formSheet
        _view.viewController.present(navController, animated: true, completion: nil)
    }
    
    func openCreateReceipt() {
        openEditModuleWith(receipt: nil)
    }
    
    func openCreatePhotoReceipt() {
        var hud: PendingHUDView?
        self.subscription = ImagePicker.shared.presentCamera(on: _view.viewController)
            .flatMap({ [unowned self] img -> Single<ScanResult> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.presenter.scanService.status)
                return self.presenter.scanService.scan(image: img)
            }).subscribe(onSuccess: { [unowned self] scan in
                hud?.hide()
                self.openEditModule(with: scan)
            })
    }
    
    func openImportReceiptFile() {
        var hud: PendingHUDView?
        ReceiptFilePicker.sharedInstance.openFilePicker(on: _view.viewController)
            .do(onError: { [unowned self] error in
                Logger.error("Import failed with: \(error.localizedDescription)")
                self.openAlert(title: nil, message: error.localizedDescription)
            }).subscribe(onNext: { [unowned self] doc in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.presenter.scanService.status)
                self.subscription = self.presenter.scanService.scan(document: doc)
                    .subscribe(onSuccess: { [unowned self] scan in
                        hud?.hide()
                        self.openEditModule(with: scan)
                    })
            }, onError: { [unowned self] _ in
                self.openEditModuleWith(receipt: nil)
            }).disposed(by: bag)
    }
    
    func openMove(receipt: WBReceipt) {
        openMoveCopy(receipt: receipt, copyOrMove: false)
    }
    
    func openCopy(receipt: WBReceipt) {
        openMoveCopy(receipt: receipt, copyOrMove: true)
    }
    
    func openEdit(receipt: WBReceipt) {
        openEditModuleWith(receipt: receipt)
    }
    
    private func openEditModuleWith(receipt: WBReceipt?) {
        subscription?.dispose()
        subscription = nil
        
        let module = AppModules.editReceipt.build()
        let data = (trip: moduleTrip, receipt: receipt)
        module.router.show(from: _view.viewController, embedInNavController: true, setupData: data)
    }
    
    private func openEditModule(with scan: ScanResult) {
        let module = AppModules.editReceipt.build()
        let data = (trip: moduleTrip, scan: scan)
        module.router.show(from: _view.viewController, embedInNavController: true, setupData: data)
    }
    
    private func openMoveCopy(receipt: WBReceipt, copyOrMove: Bool) {
        let data = (receipt, copyOrMove)
        let module = AppModules.receiptMoveCopy.build()
        module.router.show(from: _view.viewController, embedInNavController: true, setupData: data)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsRouter {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
}
