//
//  ScansPurchaseTrackerTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 25/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import RxTest
import RxSwift

class ScansPurchaseTrackerTests: XCTestCase {
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        LocalScansTracker.shared.scansCount = 0
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRxRemainingScans() {
        let scheduler = TestScheduler(initialClock: 0)
        let countObserver = scheduler.createObserver(Int.self)
        
        let countCheck: [Recorded] = [
            .next(0, 0),
            .next(0, 1),
            .next(0, 5),
            .next(0, 10)
        ]
        
        scheduler.start()
        ScansPurchaseTracker.shared.rx.remainingScans
            .bind(to: countObserver)
            .disposed(by: bag)
        
        LocalScansTracker.shared.scansCount = 1
        LocalScansTracker.shared.scansCount = 5
        LocalScansTracker.shared.scansCount = 10
        
        XCTAssertEqual(countObserver.events, countCheck)
    }
    
    func testDecrement() {
        LocalScansTracker.shared.scansCount = 2
        XCTAssertEqual(ScansPurchaseTracker.shared.remainingScans, 2)
        
        ScansPurchaseTracker.shared.decrementRemainingScans()
        XCTAssertEqual(ScansPurchaseTracker.shared.remainingScans, 1)
    }
    
    func testHasAvailable() {
        LocalScansTracker.shared.scansCount = 1
        XCTAssertTrue(ScansPurchaseTracker.shared.hasAvailableScans)
        
        ScansPurchaseTracker.shared.decrementRemainingScans()
        XCTAssertFalse(ScansPurchaseTracker.shared.hasAvailableScans)
    }
    
    func testRemainingScans() {
        XCTAssertEqual(LocalScansTracker.shared.scansCount, 0)
        XCTAssertEqual(ScansPurchaseTracker.shared.remainingScans, LocalScansTracker.shared.scansCount)
        
        LocalScansTracker.shared.scansCount = 2
        XCTAssertNotEqual(LocalScansTracker.shared.scansCount, 0)
        XCTAssertEqual(LocalScansTracker.shared.scansCount, 2)
        XCTAssertEqual(ScansPurchaseTracker.shared.remainingScans, LocalScansTracker.shared.scansCount)
    }
}
