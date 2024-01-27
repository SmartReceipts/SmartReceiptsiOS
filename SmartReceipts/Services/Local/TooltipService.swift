//
//  TooltipService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class TooltipService {
    private let bag = DisposeBag()
    
    fileprivate var database: Database!
    
    private init() {
        database = Database.sharedInstance()
        NotificationCenter.default.addObserver(self, selector: #selector(didInsert(_:)), name: .DatabaseDidInsertModel, object: nil)
        if UserDefaults.standard.double(forKey: Keys.REMINDER_DATE) == 0 {
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: Keys.REMINDER_DATE)
        }
        
        AppNotificationCenter.didSyncBackup.subscribe(onNext: { [weak self] in
            self?.markBackup()
        }).disposed(by: bag)
    }
    
    static let shared = TooltipService()
    
    static func service(for db: Database) -> TooltipService {
        let service = TooltipService()
        service.database = db
        return service
    }
    
    func tooltipText(for module: AppModules) -> String? {
        
        switch module {
        case .trips:
            let privacyTooltip = tooltipPrivacy()
            if privacyTooltip != nil {
                return privacyTooltip
            } else {
                return backupPlusReminder()
            }
        case .receipts:
            return backupPlusReminder()
        default: break
        }
        
        Logger.error("No tooltip text for module '\(module.rawValue)'")
        return nil
    }
    
    func generateTooltip(for trip: WBTrip) -> String? {
        if moveToGenerateTrigger(for: trip) {
            return LocalizedString("tooltip_generate_info_message")
        }
        return nil
    }
    
    func backupPlusReminder() -> String? {
        if PurchaseService.hasValidAllSubscription && !marked(key: Keys.REMINDER_PLUS_BACKUP) {
            return LocalizedString("tooltip_automatic_backups_recovery_hint")
        }
        return nil
    }
    
    func reportHint() -> String? {
        let inserts = UserDefaults.standard.integer(forKey: Keys.REMINDER_INSERTS)
        if inserts == 0 && !marked(key: Keys.REPORT_HINT_INTERACTED) {
            return LocalizedString("tooltip_first_report_hint")
        }
        return nil
    }
    
    func paymentMethodHintAvailable() -> Bool {
        return !marked(key: Keys.PAYMENT_METHOD_HINT_CLOSED)
    }
    
    func tooltipBackupReminder() -> String? {
        guard needRemindByInserts() && needRemindByDays() else { return nil }
        if UserDefaults.standard.bool(forKey: Keys.REMINDER_HAS_BACKUP) {
            let timeInterval = UserDefaults.standard.double(forKey: Keys.REMINDER_DATE)
            let backupDate = Date(timeIntervalSince1970: timeInterval)
            let days = Date().daysDifference(date: backupDate)
            return String(format: LocalizedString("tooltip_backup_info_message"), days)
        } else {
            return LocalizedString("tooltip_no_backups_info_message")
        }
    }
    
    func tooltipPrivacy() -> String? {
        let inserts = UserDefaults.standard.integer(forKey: Keys.REMINDER_INSERTS)
        return (Locale.current.isEurope || inserts > 0) && !privacyTooltipUsed() ? LocalizedString("tooltip_review_privacy") : nil
    }
    
    @objc private func didInsert(_ notification: Notification) {
        let inserts = UserDefaults.standard.integer(forKey: Keys.REMINDER_INSERTS) + 1
        UserDefaults.standard.set(inserts, forKey: Keys.REMINDER_INSERTS)
    }
}

//MARK: Triggers
extension TooltipService {
    
    // Mark
    func markMoveToGenerateDismiss() {
        mark(key: Keys.MOVE_TO_GENERATE_DISMISSED)
    }
    
    func markReportGenerated() {
        mark(key: Keys.REPORT_GENERATED)
    }
    
    func markConfigureOCRDismissed() {
        mark(key: Keys.CONFIGURE_OCR)
    }
    
    func markPrivacyOpened() {
        mark(key: Keys.PRIVACY_OPENED)
    }
    
    func markPrivacyDismissed() {
        mark(key: Keys.PRIVACY_DISSMISED)
    }
    
    func markReportHintInteracted() {
        mark(key: Keys.REPORT_HINT_INTERACTED)
    }
    
    func markBackupReminderDismissed() {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: Keys.REMINDER_DATE)
    }
    
    func markBackupPlusDismissed() {
        mark(key: Keys.REMINDER_PLUS_BACKUP)
    }
    
    func markPaymentMethodHintClosed() {
        mark(key: Keys.PAYMENT_METHOD_HINT_CLOSED)
    }
    
    func markBackup() {
        UserDefaults.standard.set(true, forKey: Keys.REMINDER_HAS_BACKUP)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: Keys.REMINDER_DATE)
    }
    
    // Get
    func moveToGenerateTrigger(for trip: WBTrip) -> Bool {
        let hasReceipts = database.allReceipts(for: trip).count > 0
        return !marked(key: Keys.MOVE_TO_GENERATE_DISMISSED) && !marked(key: Keys.REPORT_GENERATED) && hasReceipts
    }
    
    func configureOCRDismissed() -> Bool {
        return marked(key: Keys.CONFIGURE_OCR)
    }
    
    func privacyTooltipUsed() -> Bool {
        return marked(key: Keys.PRIVACY_OPENED) || marked(key: Keys.PRIVACY_DISSMISED)
    }
    
    fileprivate func needRemindByDays() -> Bool {
        let timeInterval = UserDefaults.standard.double(forKey: Keys.REMINDER_DATE)
        if timeInterval != 0 { return false }
        let backupDate = Date(timeIntervalSince1970: timeInterval)
        return Date().daysDifference(date: backupDate) >= Constants.MIN_DAYS_COUNT
    }
    
    fileprivate func needRemindByInserts() -> Bool {
        let inserts = UserDefaults.standard.integer(forKey: Keys.REMINDER_INSERTS)
        return inserts >= Constants.MIN_INSERTS_COUNT
    }
    
    // Private
    private func mark(key: String) {
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func marked(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}

private extension TooltipService {
    enum Keys {
        static let MOVE_TO_GENERATE_DISMISSED = "move.to.generate.dismissed"
        static let REPORT_GENERATED = "move.to.generate.dismissed"
        static let CONFIGURE_OCR = "ocr.configure.dismissed"
        static let PRIVACY_OPENED = "privacy.opened"
        static let PRIVACY_DISSMISED = "privacy.dissmissed"
        static let REMINDER_DATE = "reminder.date"
        static let REMINDER_INSERTS = "reminder.inserts"
        static let REMINDER_HAS_BACKUP = "reminder.has.backup"
        static let REMINDER_PLUS_BACKUP = "reminder.plus.backup"
        static let REPORT_HINT_INTERACTED = "report.hint.interacted"
        static let PAYMENT_METHOD_HINT_CLOSED = "payment.method.hint.close"
    }
    
    enum Constants {
        static let MIN_INSERTS_COUNT = 15
        static let MIN_DAYS_COUNT = 10
    }
}
