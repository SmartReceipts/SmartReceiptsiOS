//
//  CurrencyExchangeService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class CurrencyExchangeService {
    func exchangeRate(_ base: String, target: String, onDate date: Date, forceRefresh: Bool = false) -> Observable<ExchangeResponse> {
        return Observable<ExchangeResponse>.create { observer -> Disposable in
            if !PurchaseService.hasValidAllSubscription {
                Logger.debug("No subscription, no exchange")
                observer.onNext(ExchangeResponse(value: nil, error: .notEnabled))
                return Disposables.create()
            }
        
            let dateToUse = (date as NSDate).earlierDate(Date())
            AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRate)
            OpenExchangeRates.sharedInstance.exchangeRate(base, target: target, onDate: dateToUse, forceRefresh: forceRefresh) {
                rate, error in
                
                if let error = error {
                    Logger.error("Exchange rate error: \(error)")
                    observer.onNext(ExchangeResponse(value: nil, error: .retriveError))
                    return
                }
                
                guard let rate = rate else {
                    AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRateFailed)
                    observer.onNext(ExchangeResponse(value: nil, error: .retriveError))
                    return
                }
                
                if rate.compare(NSDecimalNumber.minusOne()) == .orderedSame {
                    AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRateFailedWithNull)
                    observer.onNext(ExchangeResponse(value: nil, error: .unsupportedCurrency))
                    return
                }
                
                AnalyticsManager.sharedManager.record(event: Event.Receipts.RequestExchangeRateSuccess)
                observer.onNext(ExchangeResponse(value: rate, error: nil))
            }
            return Disposables.create()
        }
    }
}

struct ExchangeResponse: Equatable {
    private(set) var value: NSDecimalNumber?
    private(set) var error: CurrencyExchangeError?
    
    init(value: NSDecimalNumber?, error: CurrencyExchangeError?) {
        self.value = value
        self.error = error
    }
    
    public static func ==(lhs: ExchangeResponse, rhs: ExchangeResponse) -> Bool {
        return lhs.value == rhs.value && lhs.error == rhs.error
    }
}

enum CurrencyExchangeError: Error {
    case retriveError
    case unsupportedCurrency
    case notEnabled
}
