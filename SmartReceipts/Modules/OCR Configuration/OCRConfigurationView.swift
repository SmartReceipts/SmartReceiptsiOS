//
//  OCRConfigurationView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol OCRConfigurationViewInterface {
    var buy10ocr: Observable<Void> { get }
    var buy50ocr: Observable<Void> { get }
    
    var OCR10Price: AnyObserver<String> { get }
    var OCR50Price: AnyObserver<String> { get }
    
    func updateScansCount()
    
    var logoutTap: Observable<Void> { get }
    var successLogoutHandler: AnyObserver<Void> { get }
    var errorHandler: AnyObserver<String> { get }
}

//MARK: OCRConfigurationView Class
final class OCRConfigurationView: UserInterface {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var autoScansLabel: UILabel!
    @IBOutlet private weak var saveImagesLabel: UILabel!
    @IBOutlet private weak var availablePurchases: UILabel!
    @IBOutlet private weak var closeButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var scans10button: ScansPurchaseButton!
    @IBOutlet fileprivate weak var scans50button: ScansPurchaseButton!
    
    @IBOutlet fileprivate weak var autoScans: UISwitch!
    @IBOutlet fileprivate weak var allowSaveImages: UISwitch!
    @IBOutlet fileprivate weak var logoutButton: UIBarButtonItem!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeLabels()
    
        scans10button.setScans(count: 10)
        scans50button.setScans(count: 50)
        
        autoScans.isOn = WBPreferences.automaticScansEnabled()
        allowSaveImages.isOn = WBPreferences.allowSaveImageForAccuracy()
        
        configureRx()
    }
    
    func updateScansCount() {
        ScansPurchaseTracker.shared.fetchAndPersistAvailableRecognitions()
            .map { String(format: LocalizedString("ocr_configuration_scans_remaining"), $0) }
            .subscribe(onSuccess: { [weak self] in
                self?.setTitle($0, subtitle: AuthService.shared.email)
            }).disposed(by: bag)
    }
    
    private func configureRx() {
        AuthService.shared.loggedInObservable
            .subscribe(onNext: { [unowned self] loggedIn in
                self.logoutButton.isEnabled = loggedIn
            }).disposed(by: bag)
        
        updateScansCount()
        
        autoScans.rx.isOn
            .subscribe(onNext:{ WBPreferences.setAutomaticScansEnabled($0) })
            .disposed(by: bag)
        
        allowSaveImages.rx.isOn
            .subscribe(onNext:{ WBPreferences.setAllowSaveImageForAccuracy($0) })
            .disposed(by: bag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func localizeLabels() {
        titleLabel.text = LocalizedString("ocr_configuration_welcome")
        availablePurchases.text = LocalizedString("ocr_configuration_available_purchases")
        autoScansLabel.text = LocalizedString("ocr_is_enabled")
        saveImagesLabel.text = LocalizedString("ocr_save_scans_to_improve_results")
        logoutButton.title = LocalizedString("logout_button_text")
        
        // Note: Android split these strings across multiple files, so we combine them here
        let localizedDescriptionFormat = "%@\n\n%@\n\n%@"
        let localizedDescription = String(format: localizedDescriptionFormat,
                                          LocalizedString("ocr_configuration_information"),
                                          LocalizedString("ocr_configuration_information_line2"),
                                          LocalizedString("ocr_configuration_information_line3"))
        descriptionLabel.text = localizedDescription
    }
}

//MARK: - Public interface
extension OCRConfigurationView: OCRConfigurationViewInterface {
    var buy10ocr: Observable<Void> { return scans10button.rx.tap.asObservable() }
    var buy50ocr: Observable<Void> { return scans50button.rx.tap.asObservable() }
    
    var OCR10Price: AnyObserver<String> { return scans10button.rx.price }
    var OCR50Price: AnyObserver<String> { return scans50button.rx.price }
    
    var successLogoutHandler: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { [weak self] event in
            switch event {
            case .next:
                Logger.info("Successfully logged out")
                self?.dismiss(animated: true, completion: nil)
            default: break
            }
        })
    }
    
    var logoutTap: Observable<Void> {
        return logoutButton.rx.tap.asObservable()
    }
    
    var errorHandler: AnyObserver<String> {
        return AnyObserver<String>(eventHandler: { [weak self] event in
            switch event {
            case .next(let errorMessage):
                let alert = UIAlertController(title: LocalizedString("generic_error_alert_title"), message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            default: break
            }
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationView {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
    var displayData: OCRConfigurationDisplayData {
        return _displayData as! OCRConfigurationDisplayData
    }
}
