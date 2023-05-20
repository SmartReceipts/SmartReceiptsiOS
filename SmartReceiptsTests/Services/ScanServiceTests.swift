//
//  ScanServiceTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
@testable import Cuckoo
import XCTest
import RxTest
import RxSwift
import RxCocoa

class ScanServiceTests: XCTestCase {
    let bag = DisposeBag()
    let s3ServiceMock = MockS3Service().withEnabledSuperclassSpy()
    let mockRecognitionService = MockRecognitionService()
    let pushService = PushNotificationServiceTestable()
    var scanService: ScanService!
    var authService = AuthServiceTestable()
    var scansPurchaseTracker = ScansPurchaseTracker.shared
    
    let notificationVar = BehaviorRelay(value: RecognitionNotification(code: 10, message: "success"))
    let mockID = "1"
    var mockURL: URL!
    let mockImage = #imageLiteral(resourceName: "generate_pdf")
    var receiptDocument: ReceiptDocument!
    
    
    override func setUp() {
        super.setUp()
        receiptDocument = ReceiptDocument.makeDocumentFrom(image: mockImage)
        mockURL = receiptDocument.localURL
        
        LocalScansTracker.shared.scansCount = 10
        scanService = ScanService(s3Service: s3ServiceMock,
                                  recognitionService: mockRecognitionService,
                                  pushService: pushService,
                                  authService: authService,
                                  scansPurchaseTracker: scansPurchaseTracker)
        pushService.notificationObservable = notificationVar.asObservable()
        authService.isLoggedInValue = true
        configureStubs()
    }
    
    func configureStubs() {
        stub(mockRecognitionService) { mock in
            mock.recognize(url: mockURL, incognito: false).thenReturn(Single<String>.just(mockID))
            mock.getRecognition(mockID).then({ _ -> Single<RecognitionResponse> in
                let response = RecognitionResponse.loadFrom(filename: "RecognitionResponse", type: "json")
                return .just(response)
            })
        }
        
        stub(s3ServiceMock) { mock in
            mock.upload(file: mockURL).thenReturn(Observable<URL>.just(mockURL))
            mock.upload(image: mockImage).thenReturn(Observable<URL>.just(mockURL))
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testScanSuccess() {
        let emptyScan = ScanResult(image: mockImage)
        let scan = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        verify(s3ServiceMock).upload(file: mockURL)
        verify(mockRecognitionService).recognize(url: mockURL, incognito: false)
        verify(mockRecognitionService).getRecognition(mockID)
        
        XCTAssertNotEqual(emptyScan, scan)
    }
    
    func testHasAvailableScans() {
        let emptyScan = ScanResult(image: mockImage)
        let scan1 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        LocalScansTracker.shared.scansCount = 0
        let scan2 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        LocalScansTracker.shared.scansCount = 10
        let scan3 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertNotNil(scan1.recognition)
        XCTAssertNotEqual(emptyScan, scan1)
        XCTAssertNotEqual(scan1, scan2)
        XCTAssertNotEqual(scan2, scan3)
        XCTAssertEqual(scan1, scan3)
    }
    
    func testAutoScansFlag() {
        let emptyScan = ScanResult(image: mockImage)
        let scan1 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        WBPreferences.setAutomaticScansEnabled(false)
        let scan2 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        WBPreferences.setAutomaticScansEnabled(true)
        let scan3 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertNotNil(scan1.recognition)
        XCTAssertNotEqual(emptyScan, scan1)
        XCTAssertNotEqual(scan1, scan2)
        XCTAssertNotEqual(scan2, scan3)
        XCTAssertEqual(scan1, scan3)
    }
    
    func testAuthLogin() {
        let emptyScan = ScanResult(image: #imageLiteral(resourceName: "generate_pdf"))
        let scan1 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        authService.isLoggedInValue = false
        let scan2 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        authService.isLoggedInValue = true
        let scan3 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertNotNil(scan1.recognition)
        XCTAssertNotEqual(emptyScan, scan1)
        XCTAssertNotEqual(scan1, scan2)
        XCTAssertNotEqual(scan2, scan3)
        XCTAssertEqual(scan1, scan3)
    }
    
    func testStatus() {
        let scheduler = TestScheduler(initialClock: 0)
        let statusObserver = scheduler.createObserver(ScanStatus.self)
        
        let statusCheck: [Recorded] = [
            .next(0, ScanStatus.uploading),
            .next(0, ScanStatus.scanning),
            .next(0, ScanStatus.fetching),
            .next(0, ScanStatus.completed),
            .next(0, ScanStatus.completed)
        ]
        scheduler.start()
        scanService.status.bind(to: statusObserver).disposed(by: bag)
        
        _ = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        authService.isLoggedInValue = false
        _ = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertEqual(statusObserver.events, statusCheck)
    }
    
}


