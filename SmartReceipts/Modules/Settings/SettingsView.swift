//
//  SettingsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import MessageUI
import StoreKit

//MARK: - Public Interface Protocol
protocol SettingsViewInterface {
    var doneButton: UIBarButtonItem { get }
    func setupShowSettingsOption(_ option: ShowSettingsOption?)
}

//MARK: SettingsView Class
final class SettingsView: UserInterface {

    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    
    private var formView: SettingsFormView!
    private let bag = DisposeBag()
    private lazy var feedbackComposer = FeedbackComposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("menu_main_settings")
        
        formView = SettingsFormView(
            settingsView: self,
            dateFormats: displayData.formats,
            hasValidSubscription: presenter.hasValidSubscription()
        )
        formView.showOption = displayData.showSettingsOption
        formView.openModuleSubject = presenter.openModuleSubject
        formView.alertSubject = presenter.alertSubject
        
        addChild(formView)
        view.addSubview(formView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return presenter.retrivePlusSubscriptionPrice()
    }
    
    func restoreSubscription() -> Observable<SubscriptionValidation> {
        return presenter.restoreSubscription()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return presenter.purchaseSubscription()
    }
    
    func subscriptionValidation() -> Observable<SubscriptionValidation> {
        return presenter.subscriptionValidation()
    }
    
    func sendFeedback(subject: String) {
        feedbackComposer.present(on: self, subject: subject)
    }
}

//MARK: - Public interface
extension SettingsView: SettingsViewInterface {
    var doneButton: UIBarButtonItem { get{ return doneButtonItem } }
    
    func setupShowSettingsOption(_ option: ShowSettingsOption?) {
        displayData.showSettingsOption = option
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsView {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
    var displayData: SettingsDisplayData {
        return _displayData as! SettingsDisplayData
    }
}
