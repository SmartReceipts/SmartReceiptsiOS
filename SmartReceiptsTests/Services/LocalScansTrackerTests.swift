//
//  LocalScansTrackerTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 24/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import RxTest
import RxSwift

class LocalScansTrackerTests: XCTestCase {
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        LocalScansTracker.shared.scansCount = 0
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRxScansCount() {
        let scheduler = TestScheduler(initialClock: 0)
        let countObserver = scheduler.createObserver(Int.self)
        
        let countCheck: [Recorded] = [
            .next(0, 0),
            .next(0, 1),
            .next(0, 10),
            .next(0, 20)
        ]
        
        scheduler.start()
        LocalScansTracker.shared.rx.scansCount
            .bind(to: countObserver)
            .disposed(by: bag)
        
        LocalScansTracker.shared.scansCount = 1
        LocalScansTracker.shared.scansCount = 10
        LocalScansTracker.shared.scansCount = 20
        
        XCTAssertEqual(countObserver.events, countCheck)
    }
    
    func testScansCount() {
        XCTAssertEqual(LocalScansTracker.shared.scansCount, 0)
        
        LocalScansTracker.shared.scansCount = 2
        XCTAssertNotEqual(LocalScansTracker.shared.scansCount, 0)
        XCTAssertEqual(LocalScansTracker.shared.scansCount, 2)
        
        LocalScansTracker.shared.scansCount = 3
        XCTAssertNotEqual(LocalScansTracker.shared.scansCount, 2)
        XCTAssertEqual(LocalScansTracker.shared.scansCount, 3)
    }
    
}
    


