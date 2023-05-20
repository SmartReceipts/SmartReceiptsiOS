//
//  PurchaseServiceTest.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 03/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import Cuckoo
import RxSwift
import Moya

class PurchaseServiceTest: XCTestCase {
    
    var purchaseService: MockPurchaseService!
    var purchaseServiceSuccess = PurchaseServiceCustomMockSuccess()
    var purchaseServiceFail = PurchaseServiceCustomMockFail()
    var apiProvider: APIProvider<SmartReceiptsAPI>!
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        purchaseService = MockPurchaseService().withEnabledSuperclassSpy()
        
        configureStubs()
    }
    
    func configureStubs() {
        stub(purchaseService) { mock in
            mock.appStoreReceipt().then({ "qwerty" })
            
            mock.validateSubscription().then({ () -> Observable<SubscriptionValidation> in
                return Observable<SubscriptionValidation>.just(
                    SubscriptionValidation(
                        plusValid: true,
                        plusExpireTime: Date(),
                        standardPurchased: false,
                        premiumPurchased: true
                    )
                )
            })
            
        }
    }
    
    override func tearDown() {
        purchaseService.resetCache()
        super.tearDown()
    }
    
    func testSuccessSent() {
        let receiptString = purchaseService.appStoreReceipt()!
        
        stub(purchaseService) { mock in
            mock.sendReceipt().then { UserDefaults.standard.set(true, forKey: receiptString) }
        }
        
        XCTAssertFalse(purchaseService.isReceiptSent(receiptString))
        purchaseService.sendReceipt()
        XCTAssertTrue(purchaseService.isReceiptSent(receiptString))
    }
    
    func testFailSent() {
        let receiptString = purchaseService.appStoreReceipt()!
        
        stub(purchaseService) { mock in
            mock.sendReceipt().then { UserDefaults.standard.set(false, forKey: receiptString) }
        }
        
        XCTAssertFalse(purchaseService.isReceiptSent(receiptString))
        purchaseService.sendReceipt()
        XCTAssertFalse(purchaseService.isReceiptSent(receiptString))
    }
    
    func testValidSubscription() {
        XCTAssertFalse(PurchaseService.hasValidPlusSubscriptionValue)
        purchaseServiceSuccess.cacheSubscriptionValidation()
        XCTAssertTrue(PurchaseService.hasValidPlusSubscriptionValue)
    }
    
    func testResetCache() {
        XCTAssertFalse(PurchaseService.hasValidPlusSubscriptionValue)
        purchaseServiceSuccess.cacheSubscriptionValidation()
        XCTAssertTrue(PurchaseService.hasValidPlusSubscriptionValue)
        purchaseServiceSuccess.resetCache()
        XCTAssertFalse(PurchaseService.hasValidPlusSubscriptionValue)
    }
    
    func testExpiredSubscription() {
        XCTAssertFalse(PurchaseService.hasValidPlusSubscriptionValue)
        purchaseServiceFail.cacheSubscriptionValidation()
        XCTAssertFalse(PurchaseService.hasValidPlusSubscriptionValue)
    }
    
    func testRestoreSubscription() {
        XCTAssertFalse(PurchaseService.hasValidPlusSubscriptionValue)
        
        let responseClosure = { (target: SmartReceiptsAPI) -> Endpoint in
            let jsonData = Data.loadFrom(filename: "Subscriptions", type: "json")
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(200, jsonData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        
        
        let authService = AuthServiceTestable()
        apiProvider = APIProvider<SmartReceiptsAPI>(endpointClosure: responseClosure, stubClosure: MoyaProvider.immediatelyStub)
        _ = PurchaseService(apiProvider: apiProvider, authService: authService)
        
        XCTAssertTrue(PurchaseService.hasValidPlusSubscriptionValue)
    }
}
