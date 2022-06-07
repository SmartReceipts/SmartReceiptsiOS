//
//  Event+Categories.swift
//  SmartReceipts
//
//  Created by Victor on 12/15/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

/// All possible Event's categories are here:
extension Event {
    enum Category: String {
        case Purchases = "Purchases"
        case Navigation = "Navigation"
        case Reports = "Reports"
        case Receipts = "Receipts"
        case Distance = "Distance"
        case Generate = "Generate"
        case Ratings = "Ratings"
        case Informational = "Informational"
        case OnError = "OnError"
        case OCR = "OCR"
        case Graphs = "Graphs"
        case Subscription = "Subscription"
        case SuccessPlan = "SuccessPlan"
        
        static let allValues = [Purchases, Navigation, Reports, Receipts, Distance, Generate, Ratings, Informational, OnError, OCR, Graphs, Subscription, SuccessPlan]
    }
}



// MARK: - Event constants



/// Event constructors:
public extension Event {
    
    /*
     Important note:
     
     We can't expose Swift structs to Objective-C. if you want add analytics code into Objective-C, you have two choices:
        1) Add class function in next Event extension below int this file (recommended)
        2) Write a Swift extension for Obj-C class and implement AnalyticsManager logging functions inside that Swift extension.
     
     */
    
    struct Purchases {
        static let PurchaseSuccess = Event(category: Category.Purchases, name: "PurchaseSuccess")
        static let PurchaseFailed = Event(category: Category.Purchases, name: "PurchaseFailed")
        static let ShowPurchaseIntent = Event(category: Category.Purchases, name: "ShowPurchaseIntent") // means that in-app purchase popup presented
        static let AdUpsellShown = Event(category: Category.Purchases, name: "AdUpsellShown")
        static let AdUpsellShownOnFailure = Event(category: Category.Purchases, name: "AdUpsellShownOnFailure")
        static let AdUpsellTapped = Event(category: Category.Purchases, name: "AdUpsellTapped")
    }
    
    struct Navigation {
        static let SettingsOverflow = Event(category: Category.Navigation, name: "SettingsOverflow")
        static let BackupOverflow = Event(category: Category.Navigation, name: "BackupOverflow") // tracks backup action
        static let OcrConfiguration = Event(category: Category.Navigation, name: "OcrConfiguration")
        static let SmartReceiptsPlusOverflow = Event(category: Category.Navigation, name: "SmartReceiptsPlusOverflow") // means that in-app purchase popup presented
    }
    
    struct Reports {
        static let PersistNewReport = Event(category: Category.Reports, name: "PersistNewReport")
        static let PersistUpdateReport = Event(category: Category.Reports, name: "PersistUpdateReport")
    }
    
    struct Receipts {
        static let AddPictureReceipt = Event(category: Category.Receipts, name: "AddPictureReceipt")
        static let AddTextReceipt = Event(category: Category.Receipts, name: "AddTextReceipt")
        static let ImportPictureReceipt = Event(category: Category.Receipts, name: "ImportPictureReceipt")
        static let ReceiptMenuEdit = Event(category: Category.Receipts, name: "ReceiptMenuEdit") // No such menu item, will track "edit" action
        static let ReceiptMenuRetakePhoto = Event(category: Category.Receipts, name: "ReceiptMenuRetakePhoto")
        static let ReceiptMenuViewPdf = Event(category: Category.Receipts, name: "ReceiptMenuViewPdf")
        static let ReceiptMenuViewImage = Event(category: Category.Receipts, name: "ReceiptMenuViewImage")
        static let ReceiptMenuDelete = Event(category: Category.Receipts, name: "ReceiptMenuDelete")
        static let ReceiptMenuMoveCopy = Event(category: Category.Receipts, name: "ReceiptMenuMoveCopy") // in iOS app we have separate "move" and "copy" actions. Currently both are tracked using this event
        static let ReceiptMenuSwapUp = Event(category: Category.Receipts, name: "ReceiptMenuSwapUp")
        static let ReceiptMenuSwapDown = Event(category: Category.Receipts, name: "ReceiptMenuSwapDown")

        static let ReceiptImageViewRotateCcw = Event(category: Category.Receipts, name: "ReceiptImageViewRotateCcw")
        static let ReceiptImageViewRotateCw = Event(category: Category.Receipts, name: "ReceiptImageViewRotateCw")
        static let ReceiptImageViewRetakePhoto = Event(category: Category.Receipts, name: "ReceiptImageViewRetakePhoto")

        static let PersistNewReceipt = Event(category: Category.Receipts, name: "PersistNewReceipt")
        static let PersistUpdateReceipt = Event(category: Category.Receipts, name: "PersistUpdateReceipt")
        static let ManageCategoriesTap = Event(category: Category.Receipts, name: "ManageCategoriesTap")
        static let ManagePaymentMethodsTap = Event(category: Category.Receipts, name: "ManagePaymentMethodsTap")
        
        // FIXME: On iOS we have different exchangeRate request results:
        /*
         public enum ExchangeServiceStatus {
            case notEnabled // <- This one will not be tracked (notEnabled == no valid subscription)
            case success
            case retrieveError
            case unsupportedCurrency
         }
         */
        static let RequestExchangeRate = Event(category: Category.Receipts, name: "RequestExchangeRate")
        static let RequestExchangeRateSuccess = Event(category: Category.Receipts, name: "RequestExchangeRateSuccess")
        static let RequestExchangeRateFailed = Event(category: Category.Receipts, name: "RequestExchangeRateFailed")
        static let RequestExchangeRateFailedWithNull = Event(category: Category.Receipts, name: "RequestExchangeRateFailedWithNull")
    }
    
    struct Distance {
        static let PersistNewDistance = Event(category: Category.Distance, name: "PersistNewDistance")
        static let PersistUpdateDistance = Event(category: Category.Distance, name: "PersistUpdateDistance")
    }
    
    struct Generate {
        static let FullPdfReport = Event(category: Category.Generate, name: "FullPdfReport")
        static let ImagesPdfReport = Event(category: Category.Generate, name: "ImagesPdfReport")
        static let CsvReport = Event(category: Category.Generate, name: "CsvReport")
        static let ZipReport = Event(category: Category.Generate, name: "ZipReport")
        static let StampedZipReport = Event(category: Category.Generate, name: "StampedZipReport")
        static let NothingToGenerateCSV = Event(category: Category.Generate, name: "EmptyReportsAndDisabledDistancesCSV")
    }
    
    struct Ratings {
        static let RatingPromptShown = Event(category: Category.Ratings, name: "RatingPromptShown")
        static let UserSelectedRate = Event(category: Category.Ratings, name: "UserSelectedRate")
        static let UserSelectedNever = Event(category: Category.Ratings, name: "UserSelectedNever")
        static let UserSelectedLater = Event(category: Category.Ratings, name: "UserSelectedLater")
    }
    
    struct Informational {
        static let ConfigureReport = Event(category: Category.Informational, name: "ConfigureReports")
        static let ClickedBackupReminderTip = Event(category: Category.Informational, name: "ClickedBackupReminderTip")
        static let StartDatabaseUpgrade = Event(category: Category.Informational, name: "StartDatabaseUpgrade")
        static let FinishDatabaseUpgrade = Event(category: Category.Informational, name: "FinishDatabaseUpgrade")
        static let FailedDatabaseMigration = Event(category: Category.Informational, name: "FailedDatabaseMigration")
    }
    
    struct OCR {
        static let InfoTooltipShown = Event(category: Category.OCR, name: "OcrInfoTooltipShown")
        static let InfoTooltipOpen = Event(category: Category.OCR, name: "OcrInfoTooltipOpen")
        static let InfoTooltipDismiss = Event(category: Category.OCR, name: "OcrInfoTooltipDismiss")
        static let ViewConfigurationPage = Event(category: Category.OCR, name: "OcrViewConfigurationPage")
        static let PurchaseClicked = Event(category: Category.OCR, name: "OcrPurchaseClicked")
        static let IsEnabledToggled = Event(category: Category.OCR, name: "OcrIsEnabledToggled")
        static let IncognitoModeToggled = Event(category: Category.OCR, name: "OcrIncognitoModeToggled")
        static let RequestStarted = Event(category: Category.OCR, name: "OcrRequestStarted")
        static let PushMessageReceived = Event(category: Category.OCR, name: "OcrPushMessageReceived")
        static let PushMessageTimeOut = Event(category: Category.OCR, name: "OcrPushMessageTimeOut")
        static let RequestSucceeded = Event(category: Category.OCR, name: "OcrRequestSucceeded")
        static let RequestFailed = Event(category: Category.OCR, name: "OcrRequestFailed")
    }
    
    struct Graphs {
        static let GraphsShown = Event(category: .Graphs, name: "GraphsShown")
        static let GraphsShare = Event(category: .Graphs, name: "GraphsShare")
    }
    
    struct Subscription {
        static let SubscriptionShown = Event(category: .Subscription, name: "SubscriptionShown")
        static let SubscriptionClose = Event(category: .Subscription, name: "SubscriptionClose")
        static let SubscriptionShowLogin = Event(category: .Subscription, name: "SubscriptionShowLogin")
        static let SubsctiptionLoginFailed = Event(category: .Subscription, name: "SubscriptionLoginFailed")
        static let SubscriptionLoginButtonTapped = Event(category: .Subscription, name: "SubscriptionLoginButtonTapped")
        static let SubscriptionPurchaseFailed = Event(category: Category.Purchases, name: "SubscriptionPurchaseFailed")
    }
    
    struct SuccessPlan {
        static let SuccessPlanShown = Event(category: .SuccessPlan, name: "SuccessPlanShown")
        static let SuccessPlanClose = Event(category: .SuccessPlan, name: "SuccessPlanClose")
        static let SuccessPlanTappedClose = Event(category: .SuccessPlan, name: "SuccessPlanTappedClose")
        static let SuccessPlanTappedContinue = Event(category: .SuccessPlan, name: "SuccessPlanTappedContinue")
    }
}



// MARK: - Compability trick: Exposing Swift constants to the Objective-C



/// Exposing some of the constants to the Objective-C (Swift structs are not supported in Objective-C)
public extension Event {
    
    // MARK: Event.Receipts (WBReceiptsViewController)
    class func receiptsAddPictureReceipt() -> Event {return Event.Receipts.AddPictureReceipt}
    class func receiptsAddTextReceipt() -> Event {return Event.Receipts.AddTextReceipt}
    class func receiptsImportPictureReceipt() -> Event {return Event.Receipts.ImportPictureReceipt}
    
    // MARK: Event.Receipts - Receipt menu (WBReceiptActionsViewController)
    class func receiptsReceiptMenuEdit() -> Event {return Event.Receipts.ReceiptMenuEdit}
    class func receiptsReceiptMenuRetakePhoto() -> Event {return Event.Receipts.ReceiptMenuRetakePhoto}
    class func receiptsReceiptMenuViewPdf() -> Event {return Event.Receipts.ReceiptMenuViewPdf}
    class func receiptsReceiptMenuViewImage() -> Event {return Event.Receipts.ReceiptMenuViewImage}
    class func receiptsReceiptMenuDelete() -> Event {return Event.Receipts.ReceiptMenuDelete}
    class func receiptsReceiptMenuMoveCopy() -> Event {return Event.Receipts.ReceiptMenuMoveCopy}
    class func receiptsReceiptMenuSwapUp() -> Event {return Event.Receipts.ReceiptMenuSwapUp}
    class func receiptsReceiptMenuSwapDown() -> Event {return Event.Receipts.ReceiptMenuSwapDown}
    
    // MARK: Event.Receipts - ReceiptImageView (WBImageViewController)
    class func receiptsReceiptImageViewRotateCcw() -> Event {return Event.Receipts.ReceiptImageViewRotateCcw}
    class func receiptsReceiptImageViewRotateCw() -> Event {return Event.Receipts.ReceiptImageViewRotateCw}
    class func receiptsReceiptImageViewRetakePhoto() -> Event {return Event.Receipts.ReceiptImageViewRetakePhoto}
    
    // MARK: Event.Receipts - Edit receipt (EditReceiptViewController)
    class func receiptsPersistNewReceipt() -> Event {return Event.Receipts.PersistNewReceipt}
    class func receiptsPersistUpdateReceipt() -> Event {return Event.Receipts.PersistUpdateReceipt}
    class func receiptsManageCategoriesTap() -> Event {return Event.Receipts.ManageCategoriesTap}
    class func receiptsManagePaymentMethodsTap() -> Event {return Event.Receipts.ManagePaymentMethodsTap}
    
    // MARK: - Event.Ratings (RateApplication)
    class func ratingsRatingPromptShown() -> Event {return Event.Ratings.RatingPromptShown}
    class func ratingsUserSelectedRate() -> Event {return Event.Ratings.UserSelectedRate}
    class func ratingsUserSelectedNever() -> Event {return Event.Ratings.UserSelectedNever}
    class func ratingsUserSelectedLater() -> Event {return Event.Ratings.UserSelectedLater}
    
    // MARK: - Event.Distance (EditDistanceViewController)
    class func distancePersistNewDistance() -> Event {return Event.Distance.PersistNewDistance}
    class func distancePersistUpdateDistance() -> Event {return Event.Distance.PersistUpdateDistance}
    
    // MARK: - Event.Reports (EditTripViewController)
    class func reportsPersistNewReport() -> Event {return Event.Reports.PersistNewReport}
    class func reportsPersistUpdateReport() -> Event {return Event.Reports.PersistUpdateReport}
    
    // MARK: - Event.Informational (WBGenerateViewController)
    class func informationalConfigureReport() -> Event {return Event.Informational.ConfigureReport}
    class func clickedBackupReminderTip() -> Event {return Event.Informational.ClickedBackupReminderTip}
    
    // MARK: - Event.OCR (ScanService)
    class func ocrRequestStarted() -> Event {return Event.OCR.RequestStarted}
    class func ocrPushMessageReceived() -> Event {return Event.OCR.PushMessageReceived}
    class func ocrPushMessageTimeOut() -> Event {return Event.OCR.PushMessageTimeOut}
    class func ocrRequestSucceeded() -> Event {return Event.OCR.RequestSucceeded}
    class func ocrRequestFailed() -> Event {return Event.OCR.RequestFailed}
    
    // MARK: - Event.Grpahs
    class func graphsSelection(period: String, model: String) -> Event {
        return .init(category: .Graphs, name: "Graphs.Selection \(period)-\(model)")
    }
    
    // MARK: - Event Subscription
    static func subscriptionShown() -> Event { return Event.Subscription.SubscriptionShown }
    static func subscriptionClose() -> Event { return Event.Subscription.SubscriptionClose }
    static func subscriptionTapped(productId: String) -> Event { return .init(category: .Subscription, name: "Subscription.Selection \(productId)") }
    static func subscriptionShowLogin() -> Event { return Event.Subscription.SubscriptionShowLogin }
    static func subsctiptionLoginFailed() -> Event { return Event.Subscription.SubsctiptionLoginFailed }
    static func subscriptionLoginButtonTapped() -> Event { return Event.Subscription.SubscriptionLoginButtonTapped }
    static func subscriptionPurchaseSuccess(productId: String) -> Event { return .init(category: .Subscription, name: "Subscription.Purchase \(productId)") }
    static func subscriptionPurchaseFailed() -> Event { return Event.Subscription.SubscriptionPurchaseFailed }

    // MARK: - Event Success Plan
    static func successPlanShown() -> Event { return Event.SuccessPlan.SuccessPlanShown }
    static func successPlanClose() -> Event { return Event.SuccessPlan.SuccessPlanClose }
    static func successPlanTappedClose() -> Event { return Event.SuccessPlan.SuccessPlanTappedClose }
    static func successPlanTappedContinue() -> Event { return Event.SuccessPlan.SuccessPlanTappedContinue }
}

// MARK: Database Events
public extension Event {
    private static let VERSION = "version"
    private static let SUCCESS = "success"
    
    class func startDatabaseUpgrade(_ version: Int) -> Event {
        let event = Event.Informational.StartDatabaseUpgrade
        event.dataPoints = [DataPoint(name: VERSION, value: version)]
        return event
    }
    
    class func finishDatabaseUpgrade(_ version: Int, success: Bool) -> Event {
        let event = Event.Informational.FinishDatabaseUpgrade
        event.dataPoints = [
            DataPoint(name: VERSION, value: version),
            DataPoint(name: SUCCESS, value: success)
        ]
        return event
    }
    
    class func failedDatabaseMigration(_ version: UInt) -> Event {
        let event = Event.Informational.FailedDatabaseMigration
        event.dataPoints = [ DataPoint(name: VERSION, value: version) ]
        return event
    }
}

