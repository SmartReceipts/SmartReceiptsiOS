//
//  CurrencyExchangeServiceHandler.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

public enum ExchangeServiceStatus {
    case notEnabled
    case success
    case retrieveError
    case unsupportedCurrency
}

public typealias ExchangeResultClosure = (ExchangeServiceStatus, NSDecimalNumber?) -> ()

/// Public protocol with default implementation in public extension.
public protocol CurrencyExchangeServiceHandler {
    // Swift 3 issue: this func signature should be hidden
//    func exchangeRate(_ base: String, target: String, onDate date: Date, forceRefresh: Bool, completion: ExchangeResultClosure)
}

public extension CurrencyExchangeServiceHandler {
    // For some reason it only works if the function isn't declared as part of the protocol, but is defined in an extension to the protocol.
    func exchangeRate(_ base: String, target: String, onDate date: Date, forceRefresh: Bool = false, completion: @escaping ExchangeResultClosure) {
        if (!PurchaseService.hasValidAllSubscription) {
            Logger.debug("No subscription, no exchange")
            completion(.notEnabled, nil)
            return
        }
        
        let dateToUse = (date as NSDate).earlierDate(Date())
        
        AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRate)
        
        OpenExchangeRates.sharedInstance.exchangeRate(base, target: target, onDate: dateToUse, forceRefresh: forceRefresh) {
            rate, error in
            
            if let error = error {
                Logger.error("Exchange rate error: \(error)")                
            }
            
            guard let rate = rate else {
                AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRateFailed)
                completion(.retrieveError, nil)
                return
            }
            
            if rate.compare(NSDecimalNumber.minusOne()) == .orderedSame {
                AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRateFailedWithNull)
                completion(.unsupportedCurrency, nil)
                return
            }
            
            AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRateSuccess)
            completion(.success, rate)
        }
    }
}
