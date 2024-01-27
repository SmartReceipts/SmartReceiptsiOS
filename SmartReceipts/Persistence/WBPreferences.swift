//
//  WBPreferences.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

typealias LanguageAlias = (name: String, identifier: String)

private let LAST_OPENED_TRIP_KEY = "LastOpenedTripKey"

extension WBPreferences {
    static func prefferedPDFSize() -> PDFPageSize {
        if let index = Int(string: preferredRawPDFSize()) {
            return PDFPageSize.pdfPageSizeBy(index: index)
        }
        return PDFPageSize(rawValue: preferredRawPDFSize())!
    }
    
    static func setPrefferedPDFSize(_ pdfSize: PDFPageSize) {
        setPreferredRawPDFSize(pdfSize.rawValue)
    }
    
    @objc static func isPDFFooterUnlocked() -> Bool {
        return PurchaseService.hasValidAllSubscription
    }
    
    static var languages: [LanguageAlias] = {
        return Bundle.main.localizations
            .map { identifier -> LanguageAlias? in
                guard let name = (Locale.current as NSLocale).displayName(forKey: .identifier, value: identifier) else { return nil }
                return LanguageAlias(name, identifier)
            }.compactMap { $0 }
    }()
    
    static func languageBy(identifier: String) -> LanguageAlias? {
        return WBPreferences.languages.first { identifier == $0.identifier }
    }
    
    static func languageBy(name: String) -> LanguageAlias? {
        return WBPreferences.languages.first { name == $0.name }
    }
    
    @objc class func localized(key: String, comment: String = "") -> String {
        var result = key
        if let path = Bundle.main.path(forResource: WBPreferences.preferredReportLanguage(), ofType: "lproj") {
            if let enBundle = Bundle(path: path) {
                result = NSLocalizedString(key, bundle: enBundle, comment: comment)
                if result == key {
                    result = NSLocalizedString(key, tableName: "SharedLocalizable", bundle: enBundle, comment: comment)
                }
            }
        }
        return result
    }
    
    @objc class func localized(key: String) -> String {
        return WBPreferences.localized(key: key, comment: "")
    }
    
    static func markLastOpened(trip: WBTrip) {
        UserDefaults.standard.set(trip.name, forKey: LAST_OPENED_TRIP_KEY)
    }
    
    static var lastOpenedTrip: WBTrip? {
        guard let tripName = UserDefaults.standard.value(forKey: LAST_OPENED_TRIP_KEY) as? String else { return nil }
        return Database.sharedInstance().tripWithName(tripName)
    }
}

enum PDFPageSize: String {
    case A4 = "A4"
    case letter = "Letter"
    
    func size(portrait: Bool) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch self {
        case .A4:
            width = 595.0
            height = 842.0
        case .letter:
            width = 612.001
            height = 792.0
        }
        
        return portrait ? CGSize(width: width, height: height) : CGSize(width: height, height: width)
    }
    
    static func pdfPageSizeBy(index: Int) -> PDFPageSize {
        let sizes: [PDFPageSize] = [.A4, .letter]
        return sizes[index]
    }
}

extension WBPreferences {
    static func importModel(settings: SettingsModel) {
        if let value = settings.tripDuration { setDefaultTripDuration(Int32(value)) }
        if let value = settings.isocurr { setDefaultCurrency(value) }
        if let value = settings.dateformat { setDateFormat(value) }
        if let value = settings.trackcostcenter { setTrackCostCenter(value) }
        if let value = settings.predictCategories { setPredictCategories(value) }
        if let value = settings.matchNameCategories { setMatchNameToCategory(value) }
        if let value = settings.matchCommentCategories { setMatchCommentToCategory(value) }
        if let value = settings.onlyIncludeExpensable { setOnlyIncludeReimbursableReceiptsInReports(value) }
        if let value = settings.expensableDefault { setExpensableDefault(value) }
        if let value = settings.includeTaxField { setIncludeTaxField(value) }
        if let value = settings.taxPercentage { setDefaultTaxPercentage(value) }
        if let value = settings.preTax { setEnteredPricePreTax(value) }
        if let value = settings.enableAutoCompleteSuggestions { setAutocompleteEnabled(value) }
        if let value = settings.minReceiptPrice { setMinimumReceiptPriceToIncludeInReports(value) }
        if let value = settings.defaultToFirstReportDate { setDefaultToFirstReportDate(value) }
        if let value = settings.showReceiptID { setShowReceiptID(value) }
        if let value = settings.useFullPage { setAssumeFullPage(value) }
        if let value = settings.usePaymentMethods { setUsePaymentMethods(value) }
        if let value = settings.printByIDPhotoKey { setPrintReceiptIDByPhoto(value) }
        if let value = settings.printCommentByPhoto { setPrintCommentByPhoto(value) }
        if let value = settings.emailTo { setDefaultEmailRecipient(value) }
        if let value = settings.emailCC { setDefaultEmailCC(value) }
        if let value = settings.emailBCC { setDefaultEmailBCC(value) }
        if let value = settings.emailSubject { setDefaultEmailSubject(value) }
        if let value = settings.saveBW { setCameraSaveImagesBlackAndWhite(value) }
        if let value = settings.layoutIncludeReceiptDate { setLayoutShowReceiptDate(value) }
        if let value = settings.layoutIncludeReceiptCategory { setLayoutShowReceiptCategory(value) }
        if let value = settings.layoutIncludeReceiptPicture { setLayoutShowReceiptAttachmentMarker(value) }
        if let value = settings.mileageTotalInReport { setTheDistancePriceBeIncludedInReports(value) }
        if let value = settings.mileageRate { setDistanceRateDefaultValue(value) }
        if let value = settings.mileagePrintTable { setPrintDistanceTable(value) }
        if let value = settings.mileageAddToPDF { setPrintDailyDistanceValues(value) }
        if let value = settings.pdfFooterString { setPDFFooterString(value) }
    }
    
    static var settingsModel: SettingsModel {
        return .init(
            tripDuration: Int(defaultTripDuration()),
            isocurr: defaultCurrency(),
            dateformat: dateFormat(),
            trackcostcenter: trackCostCenter(),
            predictCategories: predictCategories(),
            matchNameCategories: matchNameToCategory(),
            matchCommentCategories: matchCommentToCategory(),
            onlyIncludeExpensable: onlyIncludeReimbursableReceiptsInReports(),
            expensableDefault: expensableDefault(),
            includeTaxField: includeTaxField(),
            taxPercentage: defaultTaxPercentage(),
            preTax: enteredPricePreTax(),
            enableAutoCompleteSuggestions: isAutocompleteEnabled(),
            minReceiptPrice: minimumReceiptPriceToIncludeInReports(),
            defaultToFirstReportDate: defaultToFirstReportDate(),
            showReceiptID: showReceiptID(),
            useFullPage: assumeFullPage(),
            usePaymentMethods: usePaymentMethods(),
            printByIDPhotoKey: printReceiptIDByPhoto(),
            printCommentByPhoto: printCommentByPhoto(),
            emailTo: defaultEmailRecipient(),
            emailCC: defaultEmailCC(),
            emailBCC: defaultEmailBCC(),
            emailSubject: defaultEmailSubject(),
            saveBW: cameraSaveImagesBlackAndWhite(),
            layoutIncludeReceiptDate: layoutShowReceiptDate(),
            layoutIncludeReceiptCategory: layoutShowReceiptCategory(),
            layoutIncludeReceiptPicture: layoutShowReceiptAttachmentMarker(),
            mileageTotalInReport: isTheDistancePriceBeIncludedInReports(),
            mileageRate: distanceRateDefaultValue(),
            mileagePrintTable: printDistanceTable(),
            mileageAddToPDF: printDailyDistanceValues(),
            pdfFooterString: pdfFooterString()
        )
    }
}
