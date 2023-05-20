//
//  ExchangeRateCalculatorTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 21/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

@testable import SmartReceipts

import XCTest
import RxTest
import RxSwift

class ExchangeRateCalculatorTests: XCTestCase {
    let calculator = ExchangeRateCalculator()
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        calculator.price = 0
        calculator.exchangeRate = 0
        calculator.baseCurrencyPrice = 0
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExchangeRateChanges() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Double.self)
        
        calculator.price = 10
    
        calculator.baseCurrencyPriceUpdate.bind(to: observer).disposed(by: bag)
        scheduler.start()
        
        calculator.exchangeRate = 2
        calculator.exchangeRate = 1.5
        calculator.exchangeRate = -2.57
        calculator.exchangeRate = 0
        
        let correctMessages: [Recorded] = [
            .next(0, 20.0),
            .next(0, 15.0),
            .next(0, -25.7),
            .next(0, 0)
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
    
    func testBaseCurrencyPriceChanges() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Double.self)
        
        calculator.exchangeRateUpdate.bind(to: observer).disposed(by: bag)
        scheduler.start()
        
        // Should be ignored to avoid division by zero
        calculator.price = 0
        calculator.baseCurrencyPrice = 1
        calculator.baseCurrencyPrice = 2
        
        calculator.price = 5
        
        calculator.baseCurrencyPrice = 20
        calculator.baseCurrencyPrice = 15.20
        calculator.baseCurrencyPrice = -25.50
        calculator.baseCurrencyPrice = 0
        
        let correctMessages: [Recorded] = [
            .next(0, 4.0),
            .next(0, 3.04),
            .next(0, -5.1),
            .next(0, 0)
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
    
    func testPriceChanges() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Double.self)
        
        calculator.exchangeRate = 0.5
        
        calculator.baseCurrencyPriceUpdate.bind(to: observer).disposed(by: bag)
        scheduler.start()
        
        calculator.price = 20
        calculator.price = 16.20
        calculator.price = -30.60
        calculator.price = 0
        
        let correctMessages: [Recorded] = [
            .next(0, 10.0),
            .next(0, 8.10),
            .next(0, -15.30),
            .next(0, 0)
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }

}
