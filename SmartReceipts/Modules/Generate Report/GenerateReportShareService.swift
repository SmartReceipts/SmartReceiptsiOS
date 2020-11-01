//
//  GenerateReportShareService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import MessageUI

class GenerateReportShareService: NSObject, MFMailComposeViewControllerDelegate {

    private weak var presenter: GenerateReportPresenter!
    private var trip: WBTrip!
    
    init(presenter: GenerateReportPresenter, trip: WBTrip) {
        super.init()
        self.presenter = presenter
        self.trip = trip
    }
    
    func emailFiles(_ files: [String]) {
        guard MFMailComposeViewController.canSendMail() else {
            self.presenter.presentAlert(title: LocalizedString("generic_error_alert_title"),
                                        message: LocalizedString("error_email_not_configured_message"))
            remove(files: files)
            return
        }
        
        // TODO: Switch to using plurals once we integrate this with Twine
        let messageBody = files.count > 1 ? String(format: LocalizedString("reports_attached", comment: ""), "\(files.count)") : LocalizedString("report_attached", comment: "")
        
        let composer = MFMailComposeViewController()
        let subjectFormatter = SmartReceiptsFormattableString(fromOriginalText: WBPreferences.defaultEmailSubject())
        
        composer.mailComposeDelegate = self
        composer.setSubject(subjectFormatter.format(trip))
        composer.setMessageBody(messageBody, isHTML: false)
        composer.setToRecipients(split(WBPreferences.defaultEmailRecipient()))
        composer.setCcRecipients(split(WBPreferences.defaultEmailCC()))
        composer.setBccRecipients(split(WBPreferences.defaultEmailBCC()))
        
        if #available(iOS 13.0, *) {
            composer.navigationBar.tintColor = AppTheme.primaryColor
            composer.view.tintColor = AppTheme.primaryColor
        } else {
            composer.navigationBar.tintColor = .white
        }
        
        for file in files {
            Logger.debug("func emailFiles: Attach \(file)")
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
                Logger.warning("func emailFiles: No data?")
                continue
            }
            
            let mimeType: String
            if file.hasSuffix("pdf") {
                mimeType = "application/pdf"
            } else if file.hasSuffix("csv") {
                mimeType = "text/csv"
            } else {
                mimeType = "application/octet-stream"
            }
            
            composer.addAttachmentData(data, mimeType: mimeType, fileName: NSString(string: file).lastPathComponent)
        }
        
        remove(files: files)
        presenter.present(vc: composer, animated: true)
    }
    
    func shareFiles(_ files: [String]) {
        var attached = [URL]()
        for file in files {
            attached.append(URL(fileURLWithPath: file))
        }
        let shareViewController = UIActivityViewController(activityItems: attached, applicationActivities: nil)
        shareViewController.completionWithItemsHandler = { [weak self]
            type, success, returned, error in
            
            Logger.debug("Type \(type.debugDescription) - \(success.description)")
            Logger.debug("Returned \(returned?.count ?? 0)")
            if let error = error {
                Logger.error(error.localizedDescription)
            }
            
            if success {
                self?.presenter.close()
            }
            self?.remove(files: files)
            self?.presenter.presentInterstitialAd()
        }
        presenter.present(vc: shareViewController, animated: true, isPopover: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            Logger.error("Send email error: \(error)")
        }
        
        controller.dismiss(animated: true) { [weak self] in
            self?.presenter.close()
            self?.presenter.presentInterstitialAd()
        }
    }
    
    fileprivate func split(_ string: String) -> [String] {
        if string.contains(",") {
            // For legacy reasons, we allow these to also be separated by a comma (,)
            return string.components(separatedBy: ",")
        } else {
            return string.components(separatedBy: ";")
        }
    }
    
    private func remove(files: [String]) {
        for file in files { FileManager.deleteIfExists(filepath: file) }
    }
}
