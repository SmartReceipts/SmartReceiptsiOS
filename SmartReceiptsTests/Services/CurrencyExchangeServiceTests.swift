//
//  CurrencyExchangeServiceTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts

import XCTest
import RxTest

class CurrencyExchangeServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExchangeRate() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ExchangeResponse.self)
        _ = CurrencyExchangeService().exchangeRate("USD", target: "RUB", onDate: Date())
            .bind(to: observer)
        scheduler.start()
        
        let correctMessages: [Recorded] = [
            .next(0, ExchangeResponse(value: nil, error: .notEnabled))
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
}
