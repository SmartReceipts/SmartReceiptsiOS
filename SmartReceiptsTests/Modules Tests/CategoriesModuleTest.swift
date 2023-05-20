//
//  CategoriesModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import RxTest
import XCTest

class CategoriesModuleTest: XCTestCase {
    
    let testCategory = WBCategory(name: "Test", code: "TST")!
    
    var presenter: MockCategoriesPresenter!
    var interactor: MockCategoriesInteractor!
    var router: MockCategoriesRouter!
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        Database.sharedInstance().setNotificationsDisabled(true)
        
        var module = AppModules.categories.build()
        module.injectMock(presenter: MockCategoriesPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockCategoriesInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockCategoriesRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as? MockCategoriesPresenter
        interactor = module.interactor as? MockCategoriesInteractor
        router = module.router as? MockCategoriesRouter
        configureStubs()
    }
    
    func configureStubs() {
        
        stub(interactor) { mock in
            mock.configureSubscribers().then({
                _ = self.presenter.categoryAction
                    .subscribe(onNext: { [unowned self] (category: WBCategory, update: Bool) in
                        self.interactor.save(category: category, update: update)
                    })
                
                _ = self.presenter.deleteSubject
                    .subscribe(onNext: { category in
                        self.interactor.delete(category: category)
                    })
            })
            
            mock.fetchedModelAdapter().thenCallRealImplementation()
            mock.save(category: testCategory, update: true).thenDoNothing()
            mock.delete(category: testCategory).thenDoNothing()
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
            .next(0, (category: testCategory, update: true)),
            .next(1, (category: testCategory, update: false))
        ]).bind(to:presenter.categoryAction)
        
        _ = scheduler.createHotObservable([
            .next(2, testCategory)
        ]).bind(to:presenter.deleteSubject)
        
        scheduler.scheduleAt(3) {
            verify(self.interactor).save(category: self.testCategory, update: true)
            verify(self.interactor).save(category: self.testCategory, update: false)
            verify(self.interactor).delete(category: self.testCategory)
        }
        
        scheduler.start()
    }
    
}
