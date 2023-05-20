//
//  TaxCalculatorTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts

import XCTest
import RxTest

class TaxCalculatorTests: XCTestCase {
    
    var taxCalculator: TaxCalculator!
    
    override func setUp() {
        super.setUp()
        WBPreferences.setDefaultTaxPercentage(12.5)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPreTaxCalculator() {
        taxCalculator = TaxCalculator(preTax: true)
        
        let scheduler = TestScheduler(initialClock: 0)
        _ = scheduler.createHotObservable([
            .next(100, 100.0),
            .next(200, 0),
            .next(300, nil),
            .next(400, 200.0),
            .next(500, -100.0)
        ]).bind(to:taxCalculator.priceSubject)
        
        let observer = scheduler.createObserver(String.self)
        
        _ = taxCalculator.taxSubject.bind(to: observer)
        scheduler.start()
        
        
        let correctMessages: [Recorded] = [
            .next(100, "12.50"),
            .next(200, "0.00"),
            .next(300, ""),
            .next(400, "25.00"),
            .next(500, "-12.50")
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
    
    func testPostTaxCalculator() {
        taxCalculator = TaxCalculator(preTax: false)
        
        let scheduler = TestScheduler(initialClock: 0)
        _ = scheduler.createHotObservable([
            .next(100, 100.0),
            .next(200, 0),
            .next(300, nil),
            .next(400, 200.0),
            .next(500, -100.0)
        ]).bind(to:taxCalculator.priceSubject)
        
        let observer = scheduler.createObserver(String.self)
        
        _ = taxCalculator.taxSubject.bind(to: observer)
        scheduler.start()
        
        
        let correctMessages: [Recorded] = [
            .next(100, "11.11"),
            .next(200, "0.00"),
            .next(300, ""),
            .next(400, "22.22"),
            .next(500, "-11.11")
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
    
    func testTaxCalculator() {
        let price: Decimal = 100.0
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(String.self)
        
        taxCalculator = TaxCalculator(preTax: true)
        _ = taxCalculator.taxSubject.bind(to: observer)
        
        taxCalculator.taxPercentage = NSDecimalNumber(decimal: 20.25)
        taxCalculator.priceSubject.onNext(price)
        taxCalculator.taxPercentage = NSDecimalNumber(decimal: 50.43)
        taxCalculator.priceSubject.onNext(price)
        
        
        taxCalculator = TaxCalculator(preTax: false)
        _ = taxCalculator.taxSubject.bind(to: observer)
        
        taxCalculator.taxPercentage = NSDecimalNumber(decimal: 20.25)
        taxCalculator.priceSubject.onNext(price)
        taxCalculator.taxPercentage = NSDecimalNumber(decimal: 50.43)
        taxCalculator.priceSubject.onNext(price)
        
        let correctMessages = [
            Recorded.next(0, "20.25"),
            Recorded.next(0, "50.43"),
            Recorded.next(0, "16.84"),
            Recorded.next(0, "33.52")
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
}
