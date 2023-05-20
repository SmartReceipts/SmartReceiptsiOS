//
//  PaymentMethodsModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import XCTest
import RxTest
import RxSwift

class PaymentMethodsModuleTest: XCTestCase {
    
    let testPaymentMethod = PaymentMethod(objectId: 0, method: "Card")
    
    var presenter: MockPaymentMethodsPresenter!
    var interactor: MockPaymentMethodsInteractor!
    var router: MockPaymentMethodsRouter!
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        var module = AppModules.paymentMethods.build()
        //module.injectMock(presenter: p)
        module.injectMock(presenter: MockPaymentMethodsPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockPaymentMethodsInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockPaymentMethodsRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as? MockPaymentMethodsPresenter
        interactor = module.interactor as? MockPaymentMethodsInteractor
        router = module.router as? MockPaymentMethodsRouter
        
        configureStubs()
    }
    
    func configureStubs() {
        
        stub(interactor) { mock in
            mock.configureSubscribers().then({
                _ = self.presenter.paymentMethodAction
                    .subscribe(onNext: { [unowned self] (pm: PaymentMethod, update: Bool) in
                        self.interactor.save(paymentMethod: pm, update: update)
                    })
                
                _ = self.presenter.deleteSubject
                    .subscribe(onNext: { method in
                        self.interactor.delete(paymentMethod: method)
                    })
            })
            
            mock.fetchedModelAdapter().thenCallRealImplementation()
            mock.save(paymentMethod: testPaymentMethod, update: true).thenDoNothing()
            mock.delete(paymentMethod: testPaymentMethod).thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
    }
    
    func testPresenterToInteractor() {
        presenter.viewHasLoaded()
        verify(interactor).configureSubscribers()
        
        let adapter = presenter.fetchedModelAdapter()
        verify(interactor).fetchedModelAdapter()
        XCTAssertNotNil(adapter)
        
        let scheduler = TestScheduler(initialClock: 0)
        _ = scheduler.createHotObservable([
            .next(0, (pm: testPaymentMethod, update: true)),
            .next(1, (pm: testPaymentMethod, update: false))
        ]).bind(to:presenter.paymentMethodAction)
        
        _ = scheduler.createHotObservable([
            .next(2, testPaymentMethod)
        ]).bind(to:presenter.deleteSubject)
        
        scheduler.scheduleAt(3) {
            verify(self.interactor).save(paymentMethod: self.testPaymentMethod, update: true)
            verify(self.interactor).save(paymentMethod: self.testPaymentMethod, update: false)
            verify(self.interactor).delete(paymentMethod: self.testPaymentMethod)
        }
        
        scheduler.start()
    }
    
}
