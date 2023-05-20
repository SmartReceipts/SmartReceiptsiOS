// MARK: - Mocks generated from file: SmartReceipts/Modules/Auth/AuthInteractor.swift
//
//  AuthInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Alamofire
import Foundation
import RxSwift
import Toaster
import Viperit






 class MockAuthInteractor: AuthInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = AuthInteractor
    
     typealias Stubbing = __StubbingProxy_AuthInteractor
     typealias Verification = __VerificationProxy_AuthInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AuthInteractor?

     func enableDefaultImplementation(_ stub: AuthInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var login: AnyObserver<Credentials> {
        get {
            return cuckoo_manager.getter("login",
                superclassCall:
                    
                                    super.login
                    ,
                defaultCall:  __defaultImplStub!.login)
        }
        
    }
    
    
    
    
    
     override var signup: AnyObserver<Credentials> {
        get {
            return cuckoo_manager.getter("signup",
                superclassCall:
                    
                                    super.signup
                    ,
                defaultCall:  __defaultImplStub!.signup)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_AuthInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var login: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthInteractor, AnyObserver<Credentials>> {
            return .init(manager: cuckoo_manager, name: "login")
        }
        
        
        
        
        var signup: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthInteractor, AnyObserver<Credentials>> {
            return .init(manager: cuckoo_manager, name: "signup")
        }
        
        
        
    }

     struct __VerificationProxy_AuthInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var login: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Credentials>> {
            return .init(manager: cuckoo_manager, name: "login", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var signup: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Credentials>> {
            return .init(manager: cuckoo_manager, name: "signup", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


 class AuthInteractorStub: AuthInteractor {
    
    
    
    
     override var login: AnyObserver<Credentials> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Credentials>).self)
        }
        
    }
    
    
    
    
    
     override var signup: AnyObserver<Credentials> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Credentials>).self)
        }
        
    }
    
    

    

    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Auth/AuthPresenter.swift
//
//  AuthPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Toaster
import Viperit






 class MockAuthModuleInterface: AuthModuleInterface, Cuckoo.ProtocolMock {
    
     typealias MocksType = AuthModuleInterface
    
     typealias Stubbing = __StubbingProxy_AuthModuleInterface
     typealias Verification = __VerificationProxy_AuthModuleInterface

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AuthModuleInterface?

     func enableDefaultImplementation(_ stub: AuthModuleInterface) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var successAuth: Observable<Void> {
        get {
            return cuckoo_manager.getter("successAuth",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.successAuth)
        }
        
    }
    
    

    

    
    
    
    
     func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_AuthModuleInterface: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var successAuth: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthModuleInterface, Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "successAuth")
        }
        
        
        
        
        
        func close() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAuthModuleInterface.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AuthModuleInterface: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var successAuth: Cuckoo.VerifyReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "successAuth", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AuthModuleInterfaceStub: AuthModuleInterface {
    
    
    
    
     var successAuth: Observable<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Void>).self)
        }
        
    }
    
    

    

    
    
    
    
     func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}










 class MockAuthPresenter: AuthPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = AuthPresenter
    
     typealias Stubbing = __StubbingProxy_AuthPresenter
     typealias Verification = __VerificationProxy_AuthPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AuthPresenter?

     func enableDefaultImplementation(_ stub: AuthPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var successLogin: AnyObserver<Void> {
        get {
            return cuckoo_manager.getter("successLogin",
                superclassCall:
                    
                                    super.successLogin
                    ,
                defaultCall:  __defaultImplStub!.successLogin)
        }
        
    }
    
    
    
    
    
     override var successSignup: AnyObserver<Void> {
        get {
            return cuckoo_manager.getter("successSignup",
                superclassCall:
                    
                                    super.successSignup
                    ,
                defaultCall:  __defaultImplStub!.successSignup)
        }
        
    }
    
    
    
    
    
     override var errorHandler: AnyObserver<String> {
        get {
            return cuckoo_manager.getter("errorHandler",
                superclassCall:
                    
                                    super.errorHandler
                    ,
                defaultCall:  __defaultImplStub!.errorHandler)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    

     struct __StubbingProxy_AuthPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var successLogin: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "successLogin")
        }
        
        
        
        
        var successSignup: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "successSignup")
        }
        
        
        
        
        var errorHandler: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<String>> {
            return .init(manager: cuckoo_manager, name: "errorHandler")
        }
        
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAuthPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AuthPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var successLogin: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "successLogin", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var successSignup: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "successSignup", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var errorHandler: Cuckoo.VerifyReadOnlyProperty<AnyObserver<String>> {
            return .init(manager: cuckoo_manager, name: "errorHandler", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AuthPresenterStub: AuthPresenter {
    
    
    
    
     override var successLogin: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
    
    
    
    
     override var successSignup: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
    
    
    
    
     override var errorHandler: AnyObserver<String> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<String>).self)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Auth/AuthRouter.swift
//
//  AuthRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockAuthRouter: AuthRouter, Cuckoo.ClassMock {
    
     typealias MocksType = AuthRouter
    
     typealias Stubbing = __StubbingProxy_AuthRouter
     typealias Verification = __VerificationProxy_AuthRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AuthRouter?

     func enableDefaultImplementation(_ stub: AuthRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_AuthRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAuthRouter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AuthRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AuthRouterStub: AuthRouter {
    

    

    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesInteractor.swift
//
//  CategoriesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockCategoriesInteractor: CategoriesInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = CategoriesInteractor
    
     typealias Stubbing = __StubbingProxy_CategoriesInteractor
     typealias Verification = __VerificationProxy_CategoriesInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CategoriesInteractor?

     func enableDefaultImplementation(_ stub: CategoriesInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func save(category: WBCategory, update: Bool)  {
        
    return cuckoo_manager.call(
    """
    save(category: WBCategory, update: Bool)
    """,
            parameters: (category, update),
            escapingParameters: (category, update),
            superclassCall:
                
                super.save(category: category, update: update)
                ,
            defaultCall: __defaultImplStub!.save(category: category, update: update))
        
    }
    
    
    
    
    
     override func reorder(categoryLeft: WBCategory, categoryRight: WBCategory)  {
        
    return cuckoo_manager.call(
    """
    reorder(categoryLeft: WBCategory, categoryRight: WBCategory)
    """,
            parameters: (categoryLeft, categoryRight),
            escapingParameters: (categoryLeft, categoryRight),
            superclassCall:
                
                super.reorder(categoryLeft: categoryLeft, categoryRight: categoryRight)
                ,
            defaultCall: __defaultImplStub!.reorder(categoryLeft: categoryLeft, categoryRight: categoryRight))
        
    }
    
    
    
    
    
     override func delete(category: WBCategory)  {
        
    return cuckoo_manager.call(
    """
    delete(category: WBCategory)
    """,
            parameters: (category),
            escapingParameters: (category),
            superclassCall:
                
                super.delete(category: category)
                ,
            defaultCall: __defaultImplStub!.delete(category: category))
        
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter? {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchedModelAdapter()
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter())
        
    }
    
    

     struct __StubbingProxy_CategoriesInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(category: M1, update: M2) -> Cuckoo.ClassStubNoReturnFunction<(WBCategory, Bool)> where M1.MatchedType == WBCategory, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory, Bool)>] = [wrap(matchable: category) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method:
    """
    save(category: WBCategory, update: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(categoryLeft: M1, categoryRight: M2) -> Cuckoo.ClassStubNoReturnFunction<(WBCategory, WBCategory)> where M1.MatchedType == WBCategory, M2.MatchedType == WBCategory {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory, WBCategory)>] = [wrap(matchable: categoryLeft) { $0.0 }, wrap(matchable: categoryRight) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method:
    """
    reorder(categoryLeft: WBCategory, categoryRight: WBCategory)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func delete<M1: Cuckoo.Matchable>(category: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBCategory)> where M1.MatchedType == WBCategory {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory)>] = [wrap(matchable: category) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method:
    """
    delete(category: WBCategory)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method:
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CategoriesInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(category: M1, update: M2) -> Cuckoo.__DoNotUse<(WBCategory, Bool), Void> where M1.MatchedType == WBCategory, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory, Bool)>] = [wrap(matchable: category) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return cuckoo_manager.verify(
    """
    save(category: WBCategory, update: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(categoryLeft: M1, categoryRight: M2) -> Cuckoo.__DoNotUse<(WBCategory, WBCategory), Void> where M1.MatchedType == WBCategory, M2.MatchedType == WBCategory {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory, WBCategory)>] = [wrap(matchable: categoryLeft) { $0.0 }, wrap(matchable: categoryRight) { $0.1 }]
            return cuckoo_manager.verify(
    """
    reorder(categoryLeft: WBCategory, categoryRight: WBCategory)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(category: M1) -> Cuckoo.__DoNotUse<(WBCategory), Void> where M1.MatchedType == WBCategory {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory)>] = [wrap(matchable: category) { $0 }]
            return cuckoo_manager.verify(
    """
    delete(category: WBCategory)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CategoriesInteractorStub: CategoriesInteractor {
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func save(category: WBCategory, update: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func reorder(categoryLeft: WBCategory, categoryRight: WBCategory)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func delete(category: WBCategory)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter?  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesPresenter.swift
//
//  CategoriesPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockCategoriesPresenter: CategoriesPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = CategoriesPresenter
    
     typealias Stubbing = __StubbingProxy_CategoriesPresenter
     typealias Verification = __VerificationProxy_CategoriesPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CategoriesPresenter?

     func enableDefaultImplementation(_ stub: CategoriesPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter? {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchedModelAdapter()
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter())
        
    }
    
    

     struct __StubbingProxy_CategoriesPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCategoriesPresenter.self, method:
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CategoriesPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CategoriesPresenterStub: CategoriesPresenter {
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter?  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesRouter.swift
//
//  CategoriesRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockCategoriesRouter: CategoriesRouter, Cuckoo.ClassMock {
    
     typealias MocksType = CategoriesRouter
    
     typealias Stubbing = __StubbingProxy_CategoriesRouter
     typealias Verification = __VerificationProxy_CategoriesRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CategoriesRouter?

     func enableDefaultImplementation(_ stub: CategoriesRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

     struct __StubbingProxy_CategoriesRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

     struct __VerificationProxy_CategoriesRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


 class CategoriesRouterStub: CategoriesRouter {
    

    

    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsInteractor.swift
//
//  ColumnsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockColumnsInteractor: ColumnsInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = ColumnsInteractor
    
     typealias Stubbing = __StubbingProxy_ColumnsInteractor
     typealias Verification = __VerificationProxy_ColumnsInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ColumnsInteractor?

     func enableDefaultImplementation(_ stub: ColumnsInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func columns(forCSV: Bool) -> Observable<[Column]> {
        
    return cuckoo_manager.call(
    """
    columns(forCSV: Bool) -> Observable<[Column]>
    """,
            parameters: (forCSV),
            escapingParameters: (forCSV),
            superclassCall:
                
                super.columns(forCSV: forCSV)
                ,
            defaultCall: __defaultImplStub!.columns(forCSV: forCSV))
        
    }
    
    
    
    
    
     override func addColumn(_ column: Column, isCSV: Bool)  {
        
    return cuckoo_manager.call(
    """
    addColumn(_: Column, isCSV: Bool)
    """,
            parameters: (column, isCSV),
            escapingParameters: (column, isCSV),
            superclassCall:
                
                super.addColumn(column, isCSV: isCSV)
                ,
            defaultCall: __defaultImplStub!.addColumn(column, isCSV: isCSV))
        
    }
    
    
    
    
    
     override func removeColumn(_ column: Column, isCSV: Bool)  {
        
    return cuckoo_manager.call(
    """
    removeColumn(_: Column, isCSV: Bool)
    """,
            parameters: (column, isCSV),
            escapingParameters: (column, isCSV),
            superclassCall:
                
                super.removeColumn(column, isCSV: isCSV)
                ,
            defaultCall: __defaultImplStub!.removeColumn(column, isCSV: isCSV))
        
    }
    
    
    
    
    
     override func reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)  {
        
    return cuckoo_manager.call(
    """
    reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)
    """,
            parameters: (columnLeft, columnRight, isCSV),
            escapingParameters: (columnLeft, columnRight, isCSV),
            superclassCall:
                
                super.reorder(columnLeft: columnLeft, columnRight: columnRight, isCSV: isCSV)
                ,
            defaultCall: __defaultImplStub!.reorder(columnLeft: columnLeft, columnRight: columnRight, isCSV: isCSV))
        
    }
    
    

     struct __StubbingProxy_ColumnsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func columns<M1: Cuckoo.Matchable>(forCSV: M1) -> Cuckoo.ClassStubFunction<(Bool), Observable<[Column]>> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forCSV) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method:
    """
    columns(forCSV: Bool) -> Observable<[Column]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func addColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.ClassStubNoReturnFunction<(Column, Bool)> where M1.MatchedType == Column, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method:
    """
    addColumn(_: Column, isCSV: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.ClassStubNoReturnFunction<(Column, Bool)> where M1.MatchedType == Column, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method:
    """
    removeColumn(_: Column, isCSV: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(columnLeft: M1, columnRight: M2, isCSV: M3) -> Cuckoo.ClassStubNoReturnFunction<(Column, Column, Bool)> where M1.MatchedType == Column, M2.MatchedType == Column, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Column, Column, Bool)>] = [wrap(matchable: columnLeft) { $0.0 }, wrap(matchable: columnRight) { $0.1 }, wrap(matchable: isCSV) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method:
    """
    reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ColumnsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func columns<M1: Cuckoo.Matchable>(forCSV: M1) -> Cuckoo.__DoNotUse<(Bool), Observable<[Column]>> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forCSV) { $0 }]
            return cuckoo_manager.verify(
    """
    columns(forCSV: Bool) -> Observable<[Column]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func addColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.__DoNotUse<(Column, Bool), Void> where M1.MatchedType == Column, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
            return cuckoo_manager.verify(
    """
    addColumn(_: Column, isCSV: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.__DoNotUse<(Column, Bool), Void> where M1.MatchedType == Column, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
            return cuckoo_manager.verify(
    """
    removeColumn(_: Column, isCSV: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(columnLeft: M1, columnRight: M2, isCSV: M3) -> Cuckoo.__DoNotUse<(Column, Column, Bool), Void> where M1.MatchedType == Column, M2.MatchedType == Column, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Column, Column, Bool)>] = [wrap(matchable: columnLeft) { $0.0 }, wrap(matchable: columnRight) { $0.1 }, wrap(matchable: isCSV) { $0.2 }]
            return cuckoo_manager.verify(
    """
    reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ColumnsInteractorStub: ColumnsInteractor {
    

    

    
    
    
    
     override func columns(forCSV: Bool) -> Observable<[Column]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Column]>).self)
    }
    
    
    
    
    
     override func addColumn(_ column: Column, isCSV: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func removeColumn(_ column: Column, isCSV: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsPresenter.swift
//
//  ColumnsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockColumnsPresenter: ColumnsPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = ColumnsPresenter
    
     typealias Stubbing = __StubbingProxy_ColumnsPresenter
     typealias Verification = __VerificationProxy_ColumnsPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ColumnsPresenter?

     func enableDefaultImplementation(_ stub: ColumnsPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func nextObjectID() -> Int {
        
    return cuckoo_manager.call(
    """
    nextObjectID() -> Int
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.nextObjectID()
                ,
            defaultCall: __defaultImplStub!.nextObjectID())
        
    }
    
    
    
    
    
     override func updateData()  {
        
    return cuckoo_manager.call(
    """
    updateData()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.updateData()
                ,
            defaultCall: __defaultImplStub!.updateData())
        
    }
    
    

     struct __StubbingProxy_ColumnsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func nextObjectID() -> Cuckoo.ClassStubFunction<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method:
    """
    nextObjectID() -> Int
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func updateData() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method:
    """
    updateData()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ColumnsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func nextObjectID() -> Cuckoo.__DoNotUse<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    nextObjectID() -> Int
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func updateData() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    updateData()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ColumnsPresenterStub: ColumnsPresenter {
    

    

    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func nextObjectID() -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    
    
    
    
     override func updateData()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsRouter.swift
//
//  ColumnsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockColumnsRouter: ColumnsRouter, Cuckoo.ClassMock {
    
     typealias MocksType = ColumnsRouter
    
     typealias Stubbing = __StubbingProxy_ColumnsRouter
     typealias Verification = __VerificationProxy_ColumnsRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ColumnsRouter?

     func enableDefaultImplementation(_ stub: ColumnsRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

     struct __StubbingProxy_ColumnsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

     struct __VerificationProxy_ColumnsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


 class ColumnsRouterStub: ColumnsRouter {
    

    

    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceInteractor.swift
//
//  EditDistanceInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Toaster
import Viperit






 class MockEditDistanceInteractor: EditDistanceInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = EditDistanceInteractor
    
     typealias Stubbing = __StubbingProxy_EditDistanceInteractor
     typealias Verification = __VerificationProxy_EditDistanceInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditDistanceInteractor?

     func enableDefaultImplementation(_ stub: EditDistanceInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func save(distance: Distance, asNewDistance: Bool)  {
        
    return cuckoo_manager.call(
    """
    save(distance: Distance, asNewDistance: Bool)
    """,
            parameters: (distance, asNewDistance),
            escapingParameters: (distance, asNewDistance),
            superclassCall:
                
                super.save(distance: distance, asNewDistance: asNewDistance)
                ,
            defaultCall: __defaultImplStub!.save(distance: distance, asNewDistance: asNewDistance))
        
    }
    
    

     struct __StubbingProxy_EditDistanceInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.ClassStubNoReturnFunction<(Distance, Bool)> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditDistanceInteractor.self, method:
    """
    save(distance: Distance, asNewDistance: Bool)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditDistanceInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.__DoNotUse<(Distance, Bool), Void> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return cuckoo_manager.verify(
    """
    save(distance: Distance, asNewDistance: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditDistanceInteractorStub: EditDistanceInteractor {
    

    

    
    
    
    
     override func save(distance: Distance, asNewDistance: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistancePresenter.swift
//
//  EditDistancePresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockEditDistancePresenter: EditDistancePresenter, Cuckoo.ClassMock {
    
     typealias MocksType = EditDistancePresenter
    
     typealias Stubbing = __StubbingProxy_EditDistancePresenter
     typealias Verification = __VerificationProxy_EditDistancePresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditDistancePresenter?

     func enableDefaultImplementation(_ stub: EditDistancePresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func save(distance: Distance, asNewDistance: Bool)  {
        
    return cuckoo_manager.call(
    """
    save(distance: Distance, asNewDistance: Bool)
    """,
            parameters: (distance, asNewDistance),
            escapingParameters: (distance, asNewDistance),
            superclassCall:
                
                super.save(distance: distance, asNewDistance: asNewDistance)
                ,
            defaultCall: __defaultImplStub!.save(distance: distance, asNewDistance: asNewDistance))
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_EditDistancePresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditDistancePresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.ClassStubNoReturnFunction<(Distance, Bool)> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditDistancePresenter.self, method:
    """
    save(distance: Distance, asNewDistance: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditDistancePresenter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditDistancePresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.__DoNotUse<(Distance, Bool), Void> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return cuckoo_manager.verify(
    """
    save(distance: Distance, asNewDistance: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditDistancePresenterStub: EditDistancePresenter {
    

    

    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func save(distance: Distance, asNewDistance: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceRouter.swift
//
//  EditDistanceRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockEditDistanceRouter: EditDistanceRouter, Cuckoo.ClassMock {
    
     typealias MocksType = EditDistanceRouter
    
     typealias Stubbing = __StubbingProxy_EditDistanceRouter
     typealias Verification = __VerificationProxy_EditDistanceRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditDistanceRouter?

     func enableDefaultImplementation(_ stub: EditDistanceRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_EditDistanceRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditDistanceRouter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditDistanceRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditDistanceRouterStub: EditDistanceRouter {
    

    

    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptInteractor.swift
//
//  EditReceiptInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Toaster
import Viperit






 class MockEditReceiptInteractor: EditReceiptInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = EditReceiptInteractor
    
     typealias Stubbing = __StubbingProxy_EditReceiptInteractor
     typealias Verification = __VerificationProxy_EditReceiptInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditReceiptInteractor?

     func enableDefaultImplementation(_ stub: EditReceiptInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var receiptFilePath: URL? {
        get {
            return cuckoo_manager.getter("receiptFilePath",
                superclassCall:
                    
                                    super.receiptFilePath
                    ,
                defaultCall:  __defaultImplStub!.receiptFilePath)
        }
        
        set {
            cuckoo_manager.setter("receiptFilePath",
                value: newValue,
                superclassCall:
                    
                    super.receiptFilePath = newValue
                    ,
                defaultCall: __defaultImplStub!.receiptFilePath = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func tooltipText() -> String? {
        
    return cuckoo_manager.call(
    """
    tooltipText() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.tooltipText()
                ,
            defaultCall: __defaultImplStub!.tooltipText())
        
    }
    
    

     struct __StubbingProxy_EditReceiptInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var receiptFilePath: Cuckoo.ClassToBeStubbedOptionalProperty<MockEditReceiptInteractor, URL> {
            return .init(manager: cuckoo_manager, name: "receiptFilePath")
        }
        
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func tooltipText() -> Cuckoo.ClassStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptInteractor.self, method:
    """
    tooltipText() -> String?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditReceiptInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var receiptFilePath: Cuckoo.VerifyOptionalProperty<URL> {
            return .init(manager: cuckoo_manager, name: "receiptFilePath", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func tooltipText() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    tooltipText() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditReceiptInteractorStub: EditReceiptInteractor {
    
    
    
    
     override var receiptFilePath: URL? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL?).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func tooltipText() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptPresenter.swift
//
//  EditReceiptPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import UserNotifications
import Viperit






 class MockEditReceiptModuleInterface: EditReceiptModuleInterface, Cuckoo.ProtocolMock {
    
     typealias MocksType = EditReceiptModuleInterface
    
     typealias Stubbing = __StubbingProxy_EditReceiptModuleInterface
     typealias Verification = __VerificationProxy_EditReceiptModuleInterface

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: EditReceiptModuleInterface?

     func enableDefaultImplementation(_ stub: EditReceiptModuleInterface) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var removeAction: Observable<WBReceipt> {
        get {
            return cuckoo_manager.getter("removeAction",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.removeAction)
        }
        
    }
    
    
    
    
    
     var showAttachmentAction: Observable<WBReceipt> {
        get {
            return cuckoo_manager.getter("showAttachmentAction",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.showAttachmentAction)
        }
        
    }
    
    

    

    
    
    
    
     func disableFirstResponder()  {
        
    return cuckoo_manager.call(
    """
    disableFirstResponder()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.disableFirstResponder())
        
    }
    
    
    
    
    
     func makeNameFirstResponder()  {
        
    return cuckoo_manager.call(
    """
    makeNameFirstResponder()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.makeNameFirstResponder())
        
    }
    
    

     struct __StubbingProxy_EditReceiptModuleInterface: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var removeAction: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockEditReceiptModuleInterface, Observable<WBReceipt>> {
            return .init(manager: cuckoo_manager, name: "removeAction")
        }
        
        
        
        
        var showAttachmentAction: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockEditReceiptModuleInterface, Observable<WBReceipt>> {
            return .init(manager: cuckoo_manager, name: "showAttachmentAction")
        }
        
        
        
        
        
        func disableFirstResponder() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptModuleInterface.self, method:
    """
    disableFirstResponder()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func makeNameFirstResponder() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptModuleInterface.self, method:
    """
    makeNameFirstResponder()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditReceiptModuleInterface: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var removeAction: Cuckoo.VerifyReadOnlyProperty<Observable<WBReceipt>> {
            return .init(manager: cuckoo_manager, name: "removeAction", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var showAttachmentAction: Cuckoo.VerifyReadOnlyProperty<Observable<WBReceipt>> {
            return .init(manager: cuckoo_manager, name: "showAttachmentAction", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func disableFirstResponder() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    disableFirstResponder()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func makeNameFirstResponder() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    makeNameFirstResponder()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditReceiptModuleInterfaceStub: EditReceiptModuleInterface {
    
    
    
    
     var removeAction: Observable<WBReceipt> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<WBReceipt>).self)
        }
        
    }
    
    
    
    
    
     var showAttachmentAction: Observable<WBReceipt> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<WBReceipt>).self)
        }
        
    }
    
    

    

    
    
    
    
     func disableFirstResponder()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func makeNameFirstResponder()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}










 class MockEditReceiptPresenter: EditReceiptPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = EditReceiptPresenter
    
     typealias Stubbing = __StubbingProxy_EditReceiptPresenter
     typealias Verification = __VerificationProxy_EditReceiptPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditReceiptPresenter?

     func enableDefaultImplementation(_ stub: EditReceiptPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    
    
    
    
     override func present(errorDescription: String)  {
        
    return cuckoo_manager.call(
    """
    present(errorDescription: String)
    """,
            parameters: (errorDescription),
            escapingParameters: (errorDescription),
            superclassCall:
                
                super.present(errorDescription: errorDescription)
                ,
            defaultCall: __defaultImplStub!.present(errorDescription: errorDescription))
        
    }
    
    
    
    
    
     override func tooltipText() -> String? {
        
    return cuckoo_manager.call(
    """
    tooltipText() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.tooltipText()
                ,
            defaultCall: __defaultImplStub!.tooltipText())
        
    }
    
    

     struct __StubbingProxy_EditReceiptPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func present<M1: Cuckoo.Matchable>(errorDescription: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: errorDescription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method:
    """
    present(errorDescription: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func tooltipText() -> Cuckoo.ClassStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method:
    """
    tooltipText() -> String?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditReceiptPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func present<M1: Cuckoo.Matchable>(errorDescription: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: errorDescription) { $0 }]
            return cuckoo_manager.verify(
    """
    present(errorDescription: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func tooltipText() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    tooltipText() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditReceiptPresenterStub: EditReceiptPresenter {
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func present(errorDescription: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func tooltipText() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptRouter.swift
//
//  EditReceiptRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockEditReceiptRouter: EditReceiptRouter, Cuckoo.ClassMock {
    
     typealias MocksType = EditReceiptRouter
    
     typealias Stubbing = __StubbingProxy_EditReceiptRouter
     typealias Verification = __VerificationProxy_EditReceiptRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditReceiptRouter?

     func enableDefaultImplementation(_ stub: EditReceiptRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func openSettings()  {
        
    return cuckoo_manager.call(
    """
    openSettings()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openSettings()
                ,
            defaultCall: __defaultImplStub!.openSettings())
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    
    
    
    
     override func openAuth() -> AuthModuleInterface {
        
    return cuckoo_manager.call(
    """
    openAuth() -> AuthModuleInterface
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openAuth()
                ,
            defaultCall: __defaultImplStub!.openAuth())
        
    }
    
    
    
    
    
     override func openAutoScans()  {
        
    return cuckoo_manager.call(
    """
    openAutoScans()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openAutoScans()
                ,
            defaultCall: __defaultImplStub!.openAutoScans())
        
    }
    
    
    
    
    
     override func openPaymentMethods()  {
        
    return cuckoo_manager.call(
    """
    openPaymentMethods()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openPaymentMethods()
                ,
            defaultCall: __defaultImplStub!.openPaymentMethods())
        
    }
    
    
    
    
    
     override func openCategories()  {
        
    return cuckoo_manager.call(
    """
    openCategories()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openCategories()
                ,
            defaultCall: __defaultImplStub!.openCategories())
        
    }
    
    

     struct __StubbingProxy_EditReceiptRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func openSettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method:
    """
    openSettings()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openAuth() -> Cuckoo.ClassStubFunction<(), AuthModuleInterface> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method:
    """
    openAuth() -> AuthModuleInterface
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openAutoScans() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method:
    """
    openAutoScans()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openPaymentMethods() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method:
    """
    openPaymentMethods()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openCategories() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method:
    """
    openCategories()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditReceiptRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func openSettings() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openSettings()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openAuth() -> Cuckoo.__DoNotUse<(), AuthModuleInterface> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openAuth() -> AuthModuleInterface
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openAutoScans() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openAutoScans()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openPaymentMethods() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openPaymentMethods()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openCategories() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openCategories()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditReceiptRouterStub: EditReceiptRouter {
    

    

    
    
    
    
     override func openSettings()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openAuth() -> AuthModuleInterface  {
        return DefaultValueRegistry.defaultValue(for: (AuthModuleInterface).self)
    }
    
    
    
    
    
     override func openAutoScans()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openPaymentMethods()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openCategories()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripInteractor.swift
//
//  EditTripInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockEditTripInteractor: EditTripInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = EditTripInteractor
    
     typealias Stubbing = __StubbingProxy_EditTripInteractor
     typealias Verification = __VerificationProxy_EditTripInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditTripInteractor?

     func enableDefaultImplementation(_ stub: EditTripInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func save(trip: WBTrip, update: Bool)  {
        
    return cuckoo_manager.call(
    """
    save(trip: WBTrip, update: Bool)
    """,
            parameters: (trip, update),
            escapingParameters: (trip, update),
            superclassCall:
                
                super.save(trip: trip, update: update)
                ,
            defaultCall: __defaultImplStub!.save(trip: trip, update: update))
        
    }
    
    

     struct __StubbingProxy_EditTripInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditTripInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(trip: M1, update: M2) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip, Bool)> where M1.MatchedType == WBTrip, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip, Bool)>] = [wrap(matchable: trip) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditTripInteractor.self, method:
    """
    save(trip: WBTrip, update: Bool)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditTripInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(trip: M1, update: M2) -> Cuckoo.__DoNotUse<(WBTrip, Bool), Void> where M1.MatchedType == WBTrip, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip, Bool)>] = [wrap(matchable: trip) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return cuckoo_manager.verify(
    """
    save(trip: WBTrip, update: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditTripInteractorStub: EditTripInteractor {
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func save(trip: WBTrip, update: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripPresenter.swift
//
//  EditTripPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockEditTripPresenter: EditTripPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = EditTripPresenter
    
     typealias Stubbing = __StubbingProxy_EditTripPresenter
     typealias Verification = __VerificationProxy_EditTripPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditTripPresenter?

     func enableDefaultImplementation(_ stub: EditTripPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_EditTripPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditTripPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockEditTripPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditTripPresenter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditTripPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditTripPresenterStub: EditTripPresenter {
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripRouter.swift
//
//  EditTripRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockEditTripRouter: EditTripRouter, Cuckoo.ClassMock {
    
     typealias MocksType = EditTripRouter
    
     typealias Stubbing = __StubbingProxy_EditTripRouter
     typealias Verification = __VerificationProxy_EditTripRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EditTripRouter?

     func enableDefaultImplementation(_ stub: EditTripRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_EditTripRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockEditTripRouter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_EditTripRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class EditTripRouterStub: EditTripRouter {
    

    

    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportInteractor.swift
//
//  GenerateReportInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import MessageUI
import RxCocoa
import RxSwift
import Toaster
import Viperit






 class MockGenerateReportInteractor: GenerateReportInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = GenerateReportInteractor
    
     typealias Stubbing = __StubbingProxy_GenerateReportInteractor
     typealias Verification = __VerificationProxy_GenerateReportInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: GenerateReportInteractor?

     func enableDefaultImplementation(_ stub: GenerateReportInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var generator: ReportAssetsGenerator? {
        get {
            return cuckoo_manager.getter("generator",
                superclassCall:
                    
                                    super.generator
                    ,
                defaultCall:  __defaultImplStub!.generator)
        }
        
        set {
            cuckoo_manager.setter("generator",
                value: newValue,
                superclassCall:
                    
                    super.generator = newValue
                    ,
                defaultCall: __defaultImplStub!.generator = newValue)
        }
        
    }
    
    
    
    
    
     override var shareService: GenerateReportShareService? {
        get {
            return cuckoo_manager.getter("shareService",
                superclassCall:
                    
                                    super.shareService
                    ,
                defaultCall:  __defaultImplStub!.shareService)
        }
        
        set {
            cuckoo_manager.setter("shareService",
                value: newValue,
                superclassCall:
                    
                    super.shareService = newValue
                    ,
                defaultCall: __defaultImplStub!.shareService = newValue)
        }
        
    }
    
    
    
    
    
     override var trip: WBTrip! {
        get {
            return cuckoo_manager.getter("trip",
                superclassCall:
                    
                                    super.trip
                    ,
                defaultCall:  __defaultImplStub!.trip)
        }
        
        set {
            cuckoo_manager.setter("trip",
                value: newValue,
                superclassCall:
                    
                    super.trip = newValue
                    ,
                defaultCall: __defaultImplStub!.trip = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func configure(with trip: WBTrip)  {
        
    return cuckoo_manager.call(
    """
    configure(with: WBTrip)
    """,
            parameters: (trip),
            escapingParameters: (trip),
            superclassCall:
                
                super.configure(with: trip)
                ,
            defaultCall: __defaultImplStub!.configure(with: trip))
        
    }
    
    
    
    
    
     override func trackConfigureReportEvent()  {
        
    return cuckoo_manager.call(
    """
    trackConfigureReportEvent()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.trackConfigureReportEvent()
                ,
            defaultCall: __defaultImplStub!.trackConfigureReportEvent())
        
    }
    
    
    
    
    
     override func trackGeneratorEvents(selection: GenerateReportSelection)  {
        
    return cuckoo_manager.call(
    """
    trackGeneratorEvents(selection: GenerateReportSelection)
    """,
            parameters: (selection),
            escapingParameters: (selection),
            superclassCall:
                
                super.trackGeneratorEvents(selection: selection)
                ,
            defaultCall: __defaultImplStub!.trackGeneratorEvents(selection: selection))
        
    }
    
    
    
    
    
     override func generateReport(selection: GenerateReportSelection)  {
        
    return cuckoo_manager.call(
    """
    generateReport(selection: GenerateReportSelection)
    """,
            parameters: (selection),
            escapingParameters: (selection),
            superclassCall:
                
                super.generateReport(selection: selection)
                ,
            defaultCall: __defaultImplStub!.generateReport(selection: selection))
        
    }
    
    
    
    
    
     override func validate(selection: GenerateReportSelection) -> Bool {
        
    return cuckoo_manager.call(
    """
    validate(selection: GenerateReportSelection) -> Bool
    """,
            parameters: (selection),
            escapingParameters: (selection),
            superclassCall:
                
                super.validate(selection: selection)
                ,
            defaultCall: __defaultImplStub!.validate(selection: selection))
        
    }
    
    

     struct __StubbingProxy_GenerateReportInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var generator: Cuckoo.ClassToBeStubbedOptionalProperty<MockGenerateReportInteractor, ReportAssetsGenerator> {
            return .init(manager: cuckoo_manager, name: "generator")
        }
        
        
        
        
        var shareService: Cuckoo.ClassToBeStubbedOptionalProperty<MockGenerateReportInteractor, GenerateReportShareService> {
            return .init(manager: cuckoo_manager, name: "shareService")
        }
        
        
        
        
        var trip: Cuckoo.ClassToBeStubbedOptionalProperty<MockGenerateReportInteractor, WBTrip> {
            return .init(manager: cuckoo_manager, name: "trip")
        }
        
        
        
        
        
        func configure<M1: Cuckoo.Matchable>(with trip: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method:
    """
    configure(with: WBTrip)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func trackConfigureReportEvent() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method:
    """
    trackConfigureReportEvent()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func trackGeneratorEvents<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.ClassStubNoReturnFunction<(GenerateReportSelection)> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method:
    """
    trackGeneratorEvents(selection: GenerateReportSelection)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func generateReport<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.ClassStubNoReturnFunction<(GenerateReportSelection)> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method:
    """
    generateReport(selection: GenerateReportSelection)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validate<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.ClassStubFunction<(GenerateReportSelection), Bool> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method:
    """
    validate(selection: GenerateReportSelection) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GenerateReportInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var generator: Cuckoo.VerifyOptionalProperty<ReportAssetsGenerator> {
            return .init(manager: cuckoo_manager, name: "generator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var shareService: Cuckoo.VerifyOptionalProperty<GenerateReportShareService> {
            return .init(manager: cuckoo_manager, name: "shareService", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var trip: Cuckoo.VerifyOptionalProperty<WBTrip> {
            return .init(manager: cuckoo_manager, name: "trip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func configure<M1: Cuckoo.Matchable>(with trip: M1) -> Cuckoo.__DoNotUse<(WBTrip), Void> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify(
    """
    configure(with: WBTrip)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func trackConfigureReportEvent() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    trackConfigureReportEvent()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func trackGeneratorEvents<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.__DoNotUse<(GenerateReportSelection), Void> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return cuckoo_manager.verify(
    """
    trackGeneratorEvents(selection: GenerateReportSelection)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func generateReport<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.__DoNotUse<(GenerateReportSelection), Void> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return cuckoo_manager.verify(
    """
    generateReport(selection: GenerateReportSelection)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validate<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.__DoNotUse<(GenerateReportSelection), Bool> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return cuckoo_manager.verify(
    """
    validate(selection: GenerateReportSelection) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GenerateReportInteractorStub: GenerateReportInteractor {
    
    
    
    
     override var generator: ReportAssetsGenerator? {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReportAssetsGenerator?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
     override var shareService: GenerateReportShareService? {
        get {
            return DefaultValueRegistry.defaultValue(for: (GenerateReportShareService?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
     override var trip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip?).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func configure(with trip: WBTrip)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func trackConfigureReportEvent()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func trackGeneratorEvents(selection: GenerateReportSelection)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func generateReport(selection: GenerateReportSelection)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func validate(selection: GenerateReportSelection) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportPresenter.swift
//
//  GenerateReportPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockGenerateReportPresenter: GenerateReportPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = GenerateReportPresenter
    
     typealias Stubbing = __StubbingProxy_GenerateReportPresenter
     typealias Verification = __VerificationProxy_GenerateReportPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: GenerateReportPresenter?

     func enableDefaultImplementation(_ stub: GenerateReportPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    
    
    
    
     override func generateReport(selection: GenerateReportSelection)  {
        
    return cuckoo_manager.call(
    """
    generateReport(selection: GenerateReportSelection)
    """,
            parameters: (selection),
            escapingParameters: (selection),
            superclassCall:
                
                super.generateReport(selection: selection)
                ,
            defaultCall: __defaultImplStub!.generateReport(selection: selection))
        
    }
    
    
    
    
    
     override func presentAlert(title: String, message: String)  {
        
    return cuckoo_manager.call(
    """
    presentAlert(title: String, message: String)
    """,
            parameters: (title, message),
            escapingParameters: (title, message),
            superclassCall:
                
                super.presentAlert(title: title, message: message)
                ,
            defaultCall: __defaultImplStub!.presentAlert(title: title, message: message))
        
    }
    
    
    
    
    
     override func presentSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        
    return cuckoo_manager.call(
    """
    presentSheet(title: String?, message: String?, actions: [UIAlertAction])
    """,
            parameters: (title, message, actions),
            escapingParameters: (title, message, actions),
            superclassCall:
                
                super.presentSheet(title: title, message: message, actions: actions)
                ,
            defaultCall: __defaultImplStub!.presentSheet(title: title, message: message, actions: actions))
        
    }
    
    
    
    
    
     override func present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        
    return cuckoo_manager.call(
    """
    present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)
    """,
            parameters: (vc, animated, isPopover, completion),
            escapingParameters: (vc, animated, isPopover, completion),
            superclassCall:
                
                super.present(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
                ,
            defaultCall: __defaultImplStub!.present(vc: vc, animated: animated, isPopover: isPopover, completion: completion))
        
    }
    
    
    
    
    
     override func presentOutputSettings()  {
        
    return cuckoo_manager.call(
    """
    presentOutputSettings()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.presentOutputSettings()
                ,
            defaultCall: __defaultImplStub!.presentOutputSettings())
        
    }
    
    
    
    
    
     override func hideHudFromView()  {
        
    return cuckoo_manager.call(
    """
    hideHudFromView()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.hideHudFromView()
                ,
            defaultCall: __defaultImplStub!.hideHudFromView())
        
    }
    
    
    
    
    
     override func presentEnableDistances()  {
        
    return cuckoo_manager.call(
    """
    presentEnableDistances()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.presentEnableDistances()
                ,
            defaultCall: __defaultImplStub!.presentEnableDistances())
        
    }
    
    
    
    
    
     override func presentInterstitialAd()  {
        
    return cuckoo_manager.call(
    """
    presentInterstitialAd()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.presentInterstitialAd()
                ,
            defaultCall: __defaultImplStub!.presentInterstitialAd())
        
    }
    
    

     struct __StubbingProxy_GenerateReportPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func generateReport<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.ClassStubNoReturnFunction<(GenerateReportSelection)> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    generateReport(selection: GenerateReportSelection)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.ClassStubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    presentAlert(title: String, message: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentSheet<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.ClassStubNoReturnFunction<(String?, String?, [UIAlertAction])> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    presentSheet(title: String?, message: String?, actions: [UIAlertAction])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func present<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.ClassStubNoReturnFunction<(UIViewController, Bool, Bool, (() -> Void)?)> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentOutputSettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    presentOutputSettings()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func hideHudFromView() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    hideHudFromView()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentEnableDistances() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    presentEnableDistances()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentInterstitialAd() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method:
    """
    presentInterstitialAd()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GenerateReportPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func generateReport<M1: Cuckoo.Matchable>(selection: M1) -> Cuckoo.__DoNotUse<(GenerateReportSelection), Void> where M1.MatchedType == GenerateReportSelection {
            let matchers: [Cuckoo.ParameterMatcher<(GenerateReportSelection)>] = [wrap(matchable: selection) { $0 }]
            return cuckoo_manager.verify(
    """
    generateReport(selection: GenerateReportSelection)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.__DoNotUse<(String, String), Void> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return cuckoo_manager.verify(
    """
    presentAlert(title: String, message: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentSheet<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.__DoNotUse<(String?, String?, [UIAlertAction]), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return cuckoo_manager.verify(
    """
    presentSheet(title: String?, message: String?, actions: [UIAlertAction])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func present<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.__DoNotUse<(UIViewController, Bool, Bool, (() -> Void)?), Void> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return cuckoo_manager.verify(
    """
    present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentOutputSettings() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    presentOutputSettings()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func hideHudFromView() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    hideHudFromView()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentEnableDistances() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    presentEnableDistances()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentInterstitialAd() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    presentInterstitialAd()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GenerateReportPresenterStub: GenerateReportPresenter {
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func generateReport(selection: GenerateReportSelection)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentAlert(title: String, message: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentSheet(title: String?, message: String?, actions: [UIAlertAction])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentOutputSettings()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func hideHudFromView()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentEnableDistances()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentInterstitialAd()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportRouter.swift
//
//  GenerateReportRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import GoogleMobileAds
import Viperit






 class MockGenerateReportRouter: GenerateReportRouter, Cuckoo.ClassMock {
    
     typealias MocksType = GenerateReportRouter
    
     typealias Stubbing = __StubbingProxy_GenerateReportRouter
     typealias Verification = __VerificationProxy_GenerateReportRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: GenerateReportRouter?

     func enableDefaultImplementation(_ stub: GenerateReportRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func prepareAds()  {
        
    return cuckoo_manager.call(
    """
    prepareAds()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.prepareAds()
                ,
            defaultCall: __defaultImplStub!.prepareAds())
        
    }
    
    
    
    
    
     override func updateAd()  {
        
    return cuckoo_manager.call(
    """
    updateAd()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.updateAd()
                ,
            defaultCall: __defaultImplStub!.updateAd())
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    
    
    
    
     override func openSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        
    return cuckoo_manager.call(
    """
    openSheet(title: String?, message: String?, actions: [UIAlertAction])
    """,
            parameters: (title, message, actions),
            escapingParameters: (title, message, actions),
            superclassCall:
                
                super.openSheet(title: title, message: message, actions: actions)
                ,
            defaultCall: __defaultImplStub!.openSheet(title: title, message: message, actions: actions))
        
    }
    
    
    
    
    
     override func openSettingsOnDisatnce()  {
        
    return cuckoo_manager.call(
    """
    openSettingsOnDisatnce()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openSettingsOnDisatnce()
                ,
            defaultCall: __defaultImplStub!.openSettingsOnDisatnce())
        
    }
    
    
    
    
    
     override func openSettingsOnReportLayout()  {
        
    return cuckoo_manager.call(
    """
    openSettingsOnReportLayout()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openSettingsOnReportLayout()
                ,
            defaultCall: __defaultImplStub!.openSettingsOnReportLayout())
        
    }
    
    
    
    
    
     override func openSettings(option: ShowSettingsOption)  {
        
    return cuckoo_manager.call(
    """
    openSettings(option: ShowSettingsOption)
    """,
            parameters: (option),
            escapingParameters: (option),
            superclassCall:
                
                super.openSettings(option: option)
                ,
            defaultCall: __defaultImplStub!.openSettings(option: option))
        
    }
    
    
    
    
    
     override func open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        
    return cuckoo_manager.call(
    """
    open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)
    """,
            parameters: (vc, animated, isPopover, completion),
            escapingParameters: (vc, animated, isPopover, completion),
            superclassCall:
                
                super.open(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
                ,
            defaultCall: __defaultImplStub!.open(vc: vc, animated: animated, isPopover: isPopover, completion: completion))
        
    }
    
    
    
    
    
     override func openInterstitialAd()  {
        
    return cuckoo_manager.call(
    """
    openInterstitialAd()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openInterstitialAd()
                ,
            defaultCall: __defaultImplStub!.openInterstitialAd())
        
    }
    
    

     struct __StubbingProxy_GenerateReportRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func prepareAds() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    prepareAds()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func updateAd() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    updateAd()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSheet<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.ClassStubNoReturnFunction<(String?, String?, [UIAlertAction])> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    openSheet(title: String?, message: String?, actions: [UIAlertAction])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettingsOnDisatnce() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    openSettingsOnDisatnce()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettingsOnReportLayout() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    openSettingsOnReportLayout()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettings<M1: Cuckoo.Matchable>(option: M1) -> Cuckoo.ClassStubNoReturnFunction<(ShowSettingsOption)> where M1.MatchedType == ShowSettingsOption {
            let matchers: [Cuckoo.ParameterMatcher<(ShowSettingsOption)>] = [wrap(matchable: option) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    openSettings(option: ShowSettingsOption)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func open<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.ClassStubNoReturnFunction<(UIViewController, Bool, Bool, (() -> Void)?)> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openInterstitialAd() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method:
    """
    openInterstitialAd()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GenerateReportRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func prepareAds() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    prepareAds()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func updateAd() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    updateAd()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSheet<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.__DoNotUse<(String?, String?, [UIAlertAction]), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return cuckoo_manager.verify(
    """
    openSheet(title: String?, message: String?, actions: [UIAlertAction])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSettingsOnDisatnce() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openSettingsOnDisatnce()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSettingsOnReportLayout() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openSettingsOnReportLayout()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSettings<M1: Cuckoo.Matchable>(option: M1) -> Cuckoo.__DoNotUse<(ShowSettingsOption), Void> where M1.MatchedType == ShowSettingsOption {
            let matchers: [Cuckoo.ParameterMatcher<(ShowSettingsOption)>] = [wrap(matchable: option) { $0 }]
            return cuckoo_manager.verify(
    """
    openSettings(option: ShowSettingsOption)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func open<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.__DoNotUse<(UIViewController, Bool, Bool, (() -> Void)?), Void> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return cuckoo_manager.verify(
    """
    open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openInterstitialAd() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openInterstitialAd()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GenerateReportRouterStub: GenerateReportRouter {
    

    

    
    
    
    
     override func prepareAds()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func updateAd()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openSheet(title: String?, message: String?, actions: [UIAlertAction])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openSettingsOnDisatnce()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openSettingsOnReportLayout()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openSettings(option: ShowSettingsOption)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openInterstitialAd()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/OCR Configuration/OCRConfigurationInteractor.swift
//
//  OCRConfigurationInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import StoreKit
import SwiftyStoreKit
import Toaster
import Viperit






 class MockOCRConfigurationInteractor: OCRConfigurationInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = OCRConfigurationInteractor
    
     typealias Stubbing = __StubbingProxy_OCRConfigurationInteractor
     typealias Verification = __VerificationProxy_OCRConfigurationInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: OCRConfigurationInteractor?

     func enableDefaultImplementation(_ stub: OCRConfigurationInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var logout: AnyObserver<Void> {
        get {
            return cuckoo_manager.getter("logout",
                superclassCall:
                    
                                    super.logout
                    ,
                defaultCall:  __defaultImplStub!.logout)
        }
        
    }
    
    

    

    
    
    
    
     override func requestProducts() -> Observable<SKProduct> {
        
    return cuckoo_manager.call(
    """
    requestProducts() -> Observable<SKProduct>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.requestProducts()
                ,
            defaultCall: __defaultImplStub!.requestProducts())
        
    }
    
    
    
    
    
     override func purchase(product: String) -> Observable<PurchaseDetails> {
        
    return cuckoo_manager.call(
    """
    purchase(product: String) -> Observable<PurchaseDetails>
    """,
            parameters: (product),
            escapingParameters: (product),
            superclassCall:
                
                super.purchase(product: product)
                ,
            defaultCall: __defaultImplStub!.purchase(product: product))
        
    }
    
    

     struct __StubbingProxy_OCRConfigurationInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var logout: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockOCRConfigurationInteractor, AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "logout")
        }
        
        
        
        
        
        func requestProducts() -> Cuckoo.ClassStubFunction<(), Observable<SKProduct>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockOCRConfigurationInteractor.self, method:
    """
    requestProducts() -> Observable<SKProduct>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func purchase<M1: Cuckoo.Matchable>(product: M1) -> Cuckoo.ClassStubFunction<(String), Observable<PurchaseDetails>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: product) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockOCRConfigurationInteractor.self, method:
    """
    purchase(product: String) -> Observable<PurchaseDetails>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_OCRConfigurationInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var logout: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "logout", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func requestProducts() -> Cuckoo.__DoNotUse<(), Observable<SKProduct>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestProducts() -> Observable<SKProduct>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func purchase<M1: Cuckoo.Matchable>(product: M1) -> Cuckoo.__DoNotUse<(String), Observable<PurchaseDetails>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: product) { $0 }]
            return cuckoo_manager.verify(
    """
    purchase(product: String) -> Observable<PurchaseDetails>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class OCRConfigurationInteractorStub: OCRConfigurationInteractor {
    
    
    
    
     override var logout: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
    

    

    
    
    
    
     override func requestProducts() -> Observable<SKProduct>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<SKProduct>).self)
    }
    
    
    
    
    
     override func purchase(product: String) -> Observable<PurchaseDetails>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<PurchaseDetails>).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/OCR Configuration/OCRConfigurationPresenter.swift
//
//  OCRConfigurationPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import StoreKit
import Viperit






 class MockOCRConfigurationPresenter: OCRConfigurationPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = OCRConfigurationPresenter
    
     typealias Stubbing = __StubbingProxy_OCRConfigurationPresenter
     typealias Verification = __VerificationProxy_OCRConfigurationPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: OCRConfigurationPresenter?

     func enableDefaultImplementation(_ stub: OCRConfigurationPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var errorHandler: AnyObserver<String> {
        get {
            return cuckoo_manager.getter("errorHandler",
                superclassCall:
                    
                                    super.errorHandler
                    ,
                defaultCall:  __defaultImplStub!.errorHandler)
        }
        
    }
    
    
    
    
    
     override var successLogout: AnyObserver<Void> {
        get {
            return cuckoo_manager.getter("successLogout",
                superclassCall:
                    
                                    super.successLogout
                    ,
                defaultCall:  __defaultImplStub!.successLogout)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    

     struct __StubbingProxy_OCRConfigurationPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var errorHandler: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockOCRConfigurationPresenter, AnyObserver<String>> {
            return .init(manager: cuckoo_manager, name: "errorHandler")
        }
        
        
        
        
        var successLogout: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockOCRConfigurationPresenter, AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "successLogout")
        }
        
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockOCRConfigurationPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_OCRConfigurationPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var errorHandler: Cuckoo.VerifyReadOnlyProperty<AnyObserver<String>> {
            return .init(manager: cuckoo_manager, name: "errorHandler", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var successLogout: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
            return .init(manager: cuckoo_manager, name: "successLogout", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class OCRConfigurationPresenterStub: OCRConfigurationPresenter {
    
    
    
    
     override var errorHandler: AnyObserver<String> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<String>).self)
        }
        
    }
    
    
    
    
    
     override var successLogout: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/OCR Configuration/OCRConfigurationRouter.swift
//
//  OCRConfigurationRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockOCRConfigurationRouter: OCRConfigurationRouter, Cuckoo.ClassMock {
    
     typealias MocksType = OCRConfigurationRouter
    
     typealias Stubbing = __StubbingProxy_OCRConfigurationRouter
     typealias Verification = __VerificationProxy_OCRConfigurationRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: OCRConfigurationRouter?

     func enableDefaultImplementation(_ stub: OCRConfigurationRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

     struct __StubbingProxy_OCRConfigurationRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

     struct __VerificationProxy_OCRConfigurationRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


 class OCRConfigurationRouterStub: OCRConfigurationRouter {
    

    

    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsInteractor.swift
//
//  PaymentMethodsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockPaymentMethodsInteractor: PaymentMethodsInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = PaymentMethodsInteractor
    
     typealias Stubbing = __StubbingProxy_PaymentMethodsInteractor
     typealias Verification = __VerificationProxy_PaymentMethodsInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PaymentMethodsInteractor?

     func enableDefaultImplementation(_ stub: PaymentMethodsInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter? {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchedModelAdapter()
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter())
        
    }
    
    
    
    
    
     override func save(paymentMethod: PaymentMethod, update: Bool)  {
        
    return cuckoo_manager.call(
    """
    save(paymentMethod: PaymentMethod, update: Bool)
    """,
            parameters: (paymentMethod, update),
            escapingParameters: (paymentMethod, update),
            superclassCall:
                
                super.save(paymentMethod: paymentMethod, update: update)
                ,
            defaultCall: __defaultImplStub!.save(paymentMethod: paymentMethod, update: update))
        
    }
    
    
    
    
    
     override func delete(paymentMethod: PaymentMethod)  {
        
    return cuckoo_manager.call(
    """
    delete(paymentMethod: PaymentMethod)
    """,
            parameters: (paymentMethod),
            escapingParameters: (paymentMethod),
            superclassCall:
                
                super.delete(paymentMethod: paymentMethod)
                ,
            defaultCall: __defaultImplStub!.delete(paymentMethod: paymentMethod))
        
    }
    
    

     struct __StubbingProxy_PaymentMethodsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method:
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(paymentMethod: M1, update: M2) -> Cuckoo.ClassStubNoReturnFunction<(PaymentMethod, Bool)> where M1.MatchedType == PaymentMethod, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod, Bool)>] = [wrap(matchable: paymentMethod) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method:
    """
    save(paymentMethod: PaymentMethod, update: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func delete<M1: Cuckoo.Matchable>(paymentMethod: M1) -> Cuckoo.ClassStubNoReturnFunction<(PaymentMethod)> where M1.MatchedType == PaymentMethod {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod)>] = [wrap(matchable: paymentMethod) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method:
    """
    delete(paymentMethod: PaymentMethod)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_PaymentMethodsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(paymentMethod: M1, update: M2) -> Cuckoo.__DoNotUse<(PaymentMethod, Bool), Void> where M1.MatchedType == PaymentMethod, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod, Bool)>] = [wrap(matchable: paymentMethod) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return cuckoo_manager.verify(
    """
    save(paymentMethod: PaymentMethod, update: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(paymentMethod: M1) -> Cuckoo.__DoNotUse<(PaymentMethod), Void> where M1.MatchedType == PaymentMethod {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod)>] = [wrap(matchable: paymentMethod) { $0 }]
            return cuckoo_manager.verify(
    """
    delete(paymentMethod: PaymentMethod)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PaymentMethodsInteractorStub: PaymentMethodsInteractor {
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter?  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
    }
    
    
    
    
    
     override func save(paymentMethod: PaymentMethod, update: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func delete(paymentMethod: PaymentMethod)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsPresenter.swift
//
//  PaymentMethodsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockPaymentMethodsPresenter: PaymentMethodsPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = PaymentMethodsPresenter
    
     typealias Stubbing = __StubbingProxy_PaymentMethodsPresenter
     typealias Verification = __VerificationProxy_PaymentMethodsPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PaymentMethodsPresenter?

     func enableDefaultImplementation(_ stub: PaymentMethodsPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter? {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchedModelAdapter()
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter())
        
    }
    
    

     struct __StubbingProxy_PaymentMethodsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsPresenter.self, method:
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_PaymentMethodsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PaymentMethodsPresenterStub: PaymentMethodsPresenter {
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter?  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsRouter.swift
//
//  PaymentMethodsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockPaymentMethodsRouter: PaymentMethodsRouter, Cuckoo.ClassMock {
    
     typealias MocksType = PaymentMethodsRouter
    
     typealias Stubbing = __StubbingProxy_PaymentMethodsRouter
     typealias Verification = __VerificationProxy_PaymentMethodsRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PaymentMethodsRouter?

     func enableDefaultImplementation(_ stub: PaymentMethodsRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

     struct __StubbingProxy_PaymentMethodsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

     struct __VerificationProxy_PaymentMethodsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


 class PaymentMethodsRouterStub: PaymentMethodsRouter {
    

    

    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyInteractor.swift
//
//  ReceiptMoveCopyInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockReceiptMoveCopyInteractor: ReceiptMoveCopyInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = ReceiptMoveCopyInteractor
    
     typealias Stubbing = __StubbingProxy_ReceiptMoveCopyInteractor
     typealias Verification = __VerificationProxy_ReceiptMoveCopyInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ReceiptMoveCopyInteractor?

     func enableDefaultImplementation(_ stub: ReceiptMoveCopyInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func fetchedModelAdapter(for receipt: WBReceipt) -> FetchedModelAdapter {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.fetchedModelAdapter(for: receipt)
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter(for: receipt))
        
    }
    
    

     struct __StubbingProxy_ReceiptMoveCopyInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubFunction<(WBReceipt), FetchedModelAdapter> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyInteractor.self, method:
    """
    fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ReceiptMoveCopyInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), FetchedModelAdapter> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ReceiptMoveCopyInteractorStub: ReceiptMoveCopyInteractor {
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter(for receipt: WBReceipt) -> FetchedModelAdapter  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyPresenter.swift
//
//  ReceiptMoveCopyPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockReceiptMoveCopyPresenter: ReceiptMoveCopyPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = ReceiptMoveCopyPresenter
    
     typealias Stubbing = __StubbingProxy_ReceiptMoveCopyPresenter
     typealias Verification = __VerificationProxy_ReceiptMoveCopyPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ReceiptMoveCopyPresenter?

     func enableDefaultImplementation(_ stub: ReceiptMoveCopyPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var isCopy: Bool! {
        get {
            return cuckoo_manager.getter("isCopy",
                superclassCall:
                    
                                    super.isCopy
                    ,
                defaultCall:  __defaultImplStub!.isCopy)
        }
        
        set {
            cuckoo_manager.setter("isCopy",
                value: newValue,
                superclassCall:
                    
                    super.isCopy = newValue
                    ,
                defaultCall: __defaultImplStub!.isCopy = newValue)
        }
        
    }
    
    
    
    
    
     override var receipt: WBReceipt! {
        get {
            return cuckoo_manager.getter("receipt",
                superclassCall:
                    
                                    super.receipt
                    ,
                defaultCall:  __defaultImplStub!.receipt)
        }
        
        set {
            cuckoo_manager.setter("receipt",
                value: newValue,
                superclassCall:
                    
                    super.receipt = newValue
                    ,
                defaultCall: __defaultImplStub!.receipt = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_ReceiptMoveCopyPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var isCopy: Cuckoo.ClassToBeStubbedOptionalProperty<MockReceiptMoveCopyPresenter, Bool> {
            return .init(manager: cuckoo_manager, name: "isCopy")
        }
        
        
        
        
        var receipt: Cuckoo.ClassToBeStubbedOptionalProperty<MockReceiptMoveCopyPresenter, WBReceipt> {
            return .init(manager: cuckoo_manager, name: "receipt")
        }
        
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyPresenter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ReceiptMoveCopyPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var isCopy: Cuckoo.VerifyOptionalProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isCopy", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var receipt: Cuckoo.VerifyOptionalProperty<WBReceipt> {
            return .init(manager: cuckoo_manager, name: "receipt", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ReceiptMoveCopyPresenterStub: ReceiptMoveCopyPresenter {
    
    
    
    
     override var isCopy: Bool! {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
     override var receipt: WBReceipt! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBReceipt?).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyRouter.swift
//
//  ReceiptMoveCopyRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockReceiptMoveCopyRouter: ReceiptMoveCopyRouter, Cuckoo.ClassMock {
    
     typealias MocksType = ReceiptMoveCopyRouter
    
     typealias Stubbing = __StubbingProxy_ReceiptMoveCopyRouter
     typealias Verification = __VerificationProxy_ReceiptMoveCopyRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ReceiptMoveCopyRouter?

     func enableDefaultImplementation(_ stub: ReceiptMoveCopyRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func close()  {
        
    return cuckoo_manager.call(
    """
    close()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    

     struct __StubbingProxy_ReceiptMoveCopyRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyRouter.self, method:
    """
    close()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ReceiptMoveCopyRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    close()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ReceiptMoveCopyRouterStub: ReceiptMoveCopyRouter {
    

    

    
    
    
    
     override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsInteractor.swift
//
//  ReceiptsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockReceiptsInteractor: ReceiptsInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = ReceiptsInteractor
    
     typealias Stubbing = __StubbingProxy_ReceiptsInteractor
     typealias Verification = __VerificationProxy_ReceiptsInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ReceiptsInteractor?

     func enableDefaultImplementation(_ stub: ReceiptsInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var fetchedModelAdapter: FetchedModelAdapter! {
        get {
            return cuckoo_manager.getter("fetchedModelAdapter",
                superclassCall:
                    
                                    super.fetchedModelAdapter
                    ,
                defaultCall:  __defaultImplStub!.fetchedModelAdapter)
        }
        
        set {
            cuckoo_manager.setter("fetchedModelAdapter",
                value: newValue,
                superclassCall:
                    
                    super.fetchedModelAdapter = newValue
                    ,
                defaultCall: __defaultImplStub!.fetchedModelAdapter = newValue)
        }
        
    }
    
    
    
    
    
     override var trip: WBTrip! {
        get {
            return cuckoo_manager.getter("trip",
                superclassCall:
                    
                                    super.trip
                    ,
                defaultCall:  __defaultImplStub!.trip)
        }
        
        set {
            cuckoo_manager.setter("trip",
                value: newValue,
                superclassCall:
                    
                    super.trip = newValue
                    ,
                defaultCall: __defaultImplStub!.trip = newValue)
        }
        
    }
    
    
    
    
    
     override var scanService: ScanService! {
        get {
            return cuckoo_manager.getter("scanService",
                superclassCall:
                    
                                    super.scanService
                    ,
                defaultCall:  __defaultImplStub!.scanService)
        }
        
        set {
            cuckoo_manager.setter("scanService",
                value: newValue,
                superclassCall:
                    
                    super.scanService = newValue
                    ,
                defaultCall: __defaultImplStub!.scanService = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func distanceReceipts() -> [WBReceipt] {
        
    return cuckoo_manager.call(
    """
    distanceReceipts() -> [WBReceipt]
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.distanceReceipts()
                ,
            defaultCall: __defaultImplStub!.distanceReceipts())
        
    }
    
    
    
    
    
     override func fetchedAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        
    return cuckoo_manager.call(
    """
    fetchedAdapter(for: WBTrip) -> FetchedModelAdapter
    """,
            parameters: (trip),
            escapingParameters: (trip),
            superclassCall:
                
                super.fetchedAdapter(for: trip)
                ,
            defaultCall: __defaultImplStub!.fetchedAdapter(for: trip))
        
    }
    
    
    
    
    
     override func swapUpReceipt(_ receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    swapUpReceipt(_: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.swapUpReceipt(receipt)
                ,
            defaultCall: __defaultImplStub!.swapUpReceipt(receipt))
        
    }
    
    
    
    
    
     override func swapDownReceipt(_ receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    swapDownReceipt(_: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.swapDownReceipt(receipt)
                ,
            defaultCall: __defaultImplStub!.swapDownReceipt(receipt))
        
    }
    
    
    
    
    
     override func attachAppInputFile(to receipt: WBReceipt) -> Bool {
        
    return cuckoo_manager.call(
    """
    attachAppInputFile(to: WBReceipt) -> Bool
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.attachAppInputFile(to: receipt)
                ,
            defaultCall: __defaultImplStub!.attachAppInputFile(to: receipt))
        
    }
    
    
    
    
    
     override func attachImage(_ image: UIImage, to receipt: WBReceipt) -> Bool {
        
    return cuckoo_manager.call(
    """
    attachImage(_: UIImage, to: WBReceipt) -> Bool
    """,
            parameters: (image, receipt),
            escapingParameters: (image, receipt),
            superclassCall:
                
                super.attachImage(image, to: receipt)
                ,
            defaultCall: __defaultImplStub!.attachImage(image, to: receipt))
        
    }
    
    

     struct __StubbingProxy_ReceiptsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var fetchedModelAdapter: Cuckoo.ClassToBeStubbedOptionalProperty<MockReceiptsInteractor, FetchedModelAdapter> {
            return .init(manager: cuckoo_manager, name: "fetchedModelAdapter")
        }
        
        
        
        
        var trip: Cuckoo.ClassToBeStubbedOptionalProperty<MockReceiptsInteractor, WBTrip> {
            return .init(manager: cuckoo_manager, name: "trip")
        }
        
        
        
        
        var scanService: Cuckoo.ClassToBeStubbedOptionalProperty<MockReceiptsInteractor, ScanService> {
            return .init(manager: cuckoo_manager, name: "scanService")
        }
        
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func distanceReceipts() -> Cuckoo.ClassStubFunction<(), [WBReceipt]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    distanceReceipts() -> [WBReceipt]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.ClassStubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    fetchedAdapter(for: WBTrip) -> FetchedModelAdapter
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func swapUpReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    swapUpReceipt(_: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func swapDownReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    swapDownReceipt(_: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func attachAppInputFile<M1: Cuckoo.Matchable>(to receipt: M1) -> Cuckoo.ClassStubFunction<(WBReceipt), Bool> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    attachAppInputFile(to: WBReceipt) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func attachImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ image: M1, to receipt: M2) -> Cuckoo.ClassStubFunction<(UIImage, WBReceipt), Bool> where M1.MatchedType == UIImage, M2.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage, WBReceipt)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: receipt) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method:
    """
    attachImage(_: UIImage, to: WBReceipt) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ReceiptsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var fetchedModelAdapter: Cuckoo.VerifyOptionalProperty<FetchedModelAdapter> {
            return .init(manager: cuckoo_manager, name: "fetchedModelAdapter", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var trip: Cuckoo.VerifyOptionalProperty<WBTrip> {
            return .init(manager: cuckoo_manager, name: "trip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var scanService: Cuckoo.VerifyOptionalProperty<ScanService> {
            return .init(manager: cuckoo_manager, name: "scanService", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func distanceReceipts() -> Cuckoo.__DoNotUse<(), [WBReceipt]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    distanceReceipts() -> [WBReceipt]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchedAdapter(for: WBTrip) -> FetchedModelAdapter
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func swapUpReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    swapUpReceipt(_: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func swapDownReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    swapDownReceipt(_: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func attachAppInputFile<M1: Cuckoo.Matchable>(to receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Bool> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    attachAppInputFile(to: WBReceipt) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func attachImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ image: M1, to receipt: M2) -> Cuckoo.__DoNotUse<(UIImage, WBReceipt), Bool> where M1.MatchedType == UIImage, M2.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage, WBReceipt)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: receipt) { $0.1 }]
            return cuckoo_manager.verify(
    """
    attachImage(_: UIImage, to: WBReceipt) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ReceiptsInteractorStub: ReceiptsInteractor {
    
    
    
    
     override var fetchedModelAdapter: FetchedModelAdapter! {
        get {
            return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
     override var trip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
     override var scanService: ScanService! {
        get {
            return DefaultValueRegistry.defaultValue(for: (ScanService?).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func distanceReceipts() -> [WBReceipt]  {
        return DefaultValueRegistry.defaultValue(for: ([WBReceipt]).self)
    }
    
    
    
    
    
     override func fetchedAdapter(for trip: WBTrip) -> FetchedModelAdapter  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter).self)
    }
    
    
    
    
    
     override func swapUpReceipt(_ receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func swapDownReceipt(_ receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func attachAppInputFile(to receipt: WBReceipt) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
     override func attachImage(_ image: UIImage, to receipt: WBReceipt) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsPresenter.swift
//
//  ReceiptsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxCocoa
import RxSwift
import Viperit






 class MockReceiptsPresenter: ReceiptsPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = ReceiptsPresenter
    
     typealias Stubbing = __StubbingProxy_ReceiptsPresenter
     typealias Verification = __VerificationProxy_ReceiptsPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ReceiptsPresenter?

     func enableDefaultImplementation(_ stub: ReceiptsPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var tooltipPresenter: TooltipPresenter! {
        get {
            return cuckoo_manager.getter("tooltipPresenter",
                superclassCall:
                    
                                    super.tooltipPresenter
                    ,
                defaultCall:  __defaultImplStub!.tooltipPresenter)
        }
        
    }
    
    
    
    
    
     override var scanService: ScanService {
        get {
            return cuckoo_manager.getter("scanService",
                superclassCall:
                    
                                    super.scanService
                    ,
                defaultCall:  __defaultImplStub!.scanService)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func onReceiptImageTap(receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    onReceiptImageTap(receipt: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.onReceiptImageTap(receipt: receipt)
                ,
            defaultCall: __defaultImplStub!.onReceiptImageTap(receipt: receipt))
        
    }
    
    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    
    
    
    
     override func presentAttachment(for receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    presentAttachment(for: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.presentAttachment(for: receipt)
                ,
            defaultCall: __defaultImplStub!.presentAttachment(for: receipt))
        
    }
    
    
    
    
    
     override func presentBackups()  {
        
    return cuckoo_manager.call(
    """
    presentBackups()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.presentBackups()
                ,
            defaultCall: __defaultImplStub!.presentBackups())
        
    }
    
    

     struct __StubbingProxy_ReceiptsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var tooltipPresenter: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockReceiptsPresenter, TooltipPresenter?> {
            return .init(manager: cuckoo_manager, name: "tooltipPresenter")
        }
        
        
        
        
        var scanService: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockReceiptsPresenter, ScanService> {
            return .init(manager: cuckoo_manager, name: "scanService")
        }
        
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func onReceiptImageTap<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method:
    """
    onReceiptImageTap(receipt: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentAttachment<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method:
    """
    presentAttachment(for: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentBackups() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method:
    """
    presentBackups()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ReceiptsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var tooltipPresenter: Cuckoo.VerifyReadOnlyProperty<TooltipPresenter?> {
            return .init(manager: cuckoo_manager, name: "tooltipPresenter", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var scanService: Cuckoo.VerifyReadOnlyProperty<ScanService> {
            return .init(manager: cuckoo_manager, name: "scanService", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func onReceiptImageTap<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    onReceiptImageTap(receipt: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentAttachment<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    presentAttachment(for: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentBackups() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    presentBackups()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ReceiptsPresenterStub: ReceiptsPresenter {
    
    
    
    
     override var tooltipPresenter: TooltipPresenter! {
        get {
            return DefaultValueRegistry.defaultValue(for: (TooltipPresenter?).self)
        }
        
    }
    
    
    
    
    
     override var scanService: ScanService {
        get {
            return DefaultValueRegistry.defaultValue(for: (ScanService).self)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func onReceiptImageTap(receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentAttachment(for receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentBackups()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsRouter.swift
//
//  ReceiptsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockReceiptsRouter: ReceiptsRouter, Cuckoo.ClassMock {
    
     typealias MocksType = ReceiptsRouter
    
     typealias Stubbing = __StubbingProxy_ReceiptsRouter
     typealias Verification = __VerificationProxy_ReceiptsRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ReceiptsRouter?

     func enableDefaultImplementation(_ stub: ReceiptsRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var moduleTrip: WBTrip! {
        get {
            return cuckoo_manager.getter("moduleTrip",
                superclassCall:
                    
                                    super.moduleTrip
                    ,
                defaultCall:  __defaultImplStub!.moduleTrip)
        }
        
        set {
            cuckoo_manager.setter("moduleTrip",
                value: newValue,
                superclassCall:
                    
                    super.moduleTrip = newValue
                    ,
                defaultCall: __defaultImplStub!.moduleTrip = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func openDistances()  {
        
    return cuckoo_manager.call(
    """
    openDistances()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openDistances()
                ,
            defaultCall: __defaultImplStub!.openDistances())
        
    }
    
    
    
    
    
     override func openImageViewer(for receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    openImageViewer(for: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.openImageViewer(for: receipt)
                ,
            defaultCall: __defaultImplStub!.openImageViewer(for: receipt))
        
    }
    
    
    
    
    
     override func openPDFViewer(for receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    openPDFViewer(for: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.openPDFViewer(for: receipt)
                ,
            defaultCall: __defaultImplStub!.openPDFViewer(for: receipt))
        
    }
    
    
    
    
    
     override func openGenerateReport()  {
        
    return cuckoo_manager.call(
    """
    openGenerateReport()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openGenerateReport()
                ,
            defaultCall: __defaultImplStub!.openGenerateReport())
        
    }
    
    
    
    
    
     override func openBackups()  {
        
    return cuckoo_manager.call(
    """
    openBackups()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openBackups()
                ,
            defaultCall: __defaultImplStub!.openBackups())
        
    }
    
    
    
    
    
     override func openCreateReceipt()  {
        
    return cuckoo_manager.call(
    """
    openCreateReceipt()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openCreateReceipt()
                ,
            defaultCall: __defaultImplStub!.openCreateReceipt())
        
    }
    
    
    
    
    
     override func openCreatePhotoReceipt()  {
        
    return cuckoo_manager.call(
    """
    openCreatePhotoReceipt()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openCreatePhotoReceipt()
                ,
            defaultCall: __defaultImplStub!.openCreatePhotoReceipt())
        
    }
    
    
    
    
    
     override func openImportReceiptFile()  {
        
    return cuckoo_manager.call(
    """
    openImportReceiptFile()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openImportReceiptFile()
                ,
            defaultCall: __defaultImplStub!.openImportReceiptFile())
        
    }
    
    
    
    
    
     override func openMove(receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    openMove(receipt: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.openMove(receipt: receipt)
                ,
            defaultCall: __defaultImplStub!.openMove(receipt: receipt))
        
    }
    
    
    
    
    
     override func openCopy(receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    openCopy(receipt: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.openCopy(receipt: receipt)
                ,
            defaultCall: __defaultImplStub!.openCopy(receipt: receipt))
        
    }
    
    
    
    
    
     override func openEdit(receipt: WBReceipt)  {
        
    return cuckoo_manager.call(
    """
    openEdit(receipt: WBReceipt)
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.openEdit(receipt: receipt)
                ,
            defaultCall: __defaultImplStub!.openEdit(receipt: receipt))
        
    }
    
    

     struct __StubbingProxy_ReceiptsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var moduleTrip: Cuckoo.ClassToBeStubbedOptionalProperty<MockReceiptsRouter, WBTrip> {
            return .init(manager: cuckoo_manager, name: "moduleTrip")
        }
        
        
        
        
        
        func openDistances() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openDistances()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openImageViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openImageViewer(for: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openPDFViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openPDFViewer(for: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openGenerateReport() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openGenerateReport()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openBackups() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openBackups()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openCreateReceipt() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openCreateReceipt()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openCreatePhotoReceipt() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openCreatePhotoReceipt()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openImportReceiptFile() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openImportReceiptFile()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openMove<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openMove(receipt: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openCopy<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openCopy(receipt: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openEdit<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method:
    """
    openEdit(receipt: WBReceipt)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ReceiptsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var moduleTrip: Cuckoo.VerifyOptionalProperty<WBTrip> {
            return .init(manager: cuckoo_manager, name: "moduleTrip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func openDistances() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openDistances()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openImageViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    openImageViewer(for: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openPDFViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    openPDFViewer(for: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openGenerateReport() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openGenerateReport()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openBackups() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openBackups()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openCreateReceipt() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openCreateReceipt()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openCreatePhotoReceipt() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openCreatePhotoReceipt()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openImportReceiptFile() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openImportReceiptFile()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openMove<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    openMove(receipt: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openCopy<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    openCopy(receipt: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openEdit<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<(WBReceipt), Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    openEdit(receipt: WBReceipt)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ReceiptsRouterStub: ReceiptsRouter {
    
    
    
    
     override var moduleTrip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip?).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func openDistances()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openImageViewer(for receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openPDFViewer(for receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openGenerateReport()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openBackups()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openCreateReceipt()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openCreatePhotoReceipt()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openImportReceiptFile()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openMove(receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openCopy(receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openEdit(receipt: WBReceipt)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesInteractor.swift
//
//  TripDistancesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit






 class MockTripDistancesInteractor: TripDistancesInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = TripDistancesInteractor
    
     typealias Stubbing = __StubbingProxy_TripDistancesInteractor
     typealias Verification = __VerificationProxy_TripDistancesInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: TripDistancesInteractor?

     func enableDefaultImplementation(_ stub: TripDistancesInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var trip: WBTrip! {
        get {
            return cuckoo_manager.getter("trip",
                superclassCall:
                    
                                    super.trip
                    ,
                defaultCall:  __defaultImplStub!.trip)
        }
        
        set {
            cuckoo_manager.setter("trip",
                value: newValue,
                superclassCall:
                    
                    super.trip = newValue
                    ,
                defaultCall: __defaultImplStub!.trip = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter
    """,
            parameters: (trip),
            escapingParameters: (trip),
            superclassCall:
                
                super.fetchedModelAdapter(for: trip)
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter(for: trip))
        
    }
    
    
    
    
    
     override func totalDistancePrice() -> String {
        
    return cuckoo_manager.call(
    """
    totalDistancePrice() -> String
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.totalDistancePrice()
                ,
            defaultCall: __defaultImplStub!.totalDistancePrice())
        
    }
    
    
    
    
    
     override func delete(distance: Distance)  {
        
    return cuckoo_manager.call(
    """
    delete(distance: Distance)
    """,
            parameters: (distance),
            escapingParameters: (distance),
            superclassCall:
                
                super.delete(distance: distance)
                ,
            defaultCall: __defaultImplStub!.delete(distance: distance))
        
    }
    
    

     struct __StubbingProxy_TripDistancesInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var trip: Cuckoo.ClassToBeStubbedOptionalProperty<MockTripDistancesInteractor, WBTrip> {
            return .init(manager: cuckoo_manager, name: "trip")
        }
        
        
        
        
        
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.ClassStubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesInteractor.self, method:
    """
    fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func totalDistancePrice() -> Cuckoo.ClassStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesInteractor.self, method:
    """
    totalDistancePrice() -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.ClassStubNoReturnFunction<(Distance)> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesInteractor.self, method:
    """
    delete(distance: Distance)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_TripDistancesInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var trip: Cuckoo.VerifyOptionalProperty<WBTrip> {
            return .init(manager: cuckoo_manager, name: "trip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func totalDistancePrice() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    totalDistancePrice() -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.__DoNotUse<(Distance), Void> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return cuckoo_manager.verify(
    """
    delete(distance: Distance)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class TripDistancesInteractorStub: TripDistancesInteractor {
    
    
    
    
     override var trip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip?).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter).self)
    }
    
    
    
    
    
     override func totalDistancePrice() -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
     override func delete(distance: Distance)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesPresenter.swift
//
//  TripDistancesPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockTripDistancesPresenter: TripDistancesPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = TripDistancesPresenter
    
     typealias Stubbing = __StubbingProxy_TripDistancesPresenter
     typealias Verification = __VerificationProxy_TripDistancesPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: TripDistancesPresenter?

     func enableDefaultImplementation(_ stub: TripDistancesPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter
    """,
            parameters: (trip),
            escapingParameters: (trip),
            superclassCall:
                
                super.fetchedModelAdapter(for: trip)
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter(for: trip))
        
    }
    
    
    
    
    
     override func delete(distance: Distance)  {
        
    return cuckoo_manager.call(
    """
    delete(distance: Distance)
    """,
            parameters: (distance),
            escapingParameters: (distance),
            superclassCall:
                
                super.delete(distance: distance)
                ,
            defaultCall: __defaultImplStub!.delete(distance: distance))
        
    }
    
    
    
    
    
     override func presentEditDistance(with data: Any?)  {
        
    return cuckoo_manager.call(
    """
    presentEditDistance(with: Any?)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.presentEditDistance(with: data)
                ,
            defaultCall: __defaultImplStub!.presentEditDistance(with: data))
        
    }
    
    
    
    
    
     override func totalDistancePrice() -> String {
        
    return cuckoo_manager.call(
    """
    totalDistancePrice() -> String
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.totalDistancePrice()
                ,
            defaultCall: __defaultImplStub!.totalDistancePrice())
        
    }
    
    
    
    
    
     override func setupView(data: Any)  {
        
    return cuckoo_manager.call(
    """
    setupView(data: Any)
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.setupView(data: data)
                ,
            defaultCall: __defaultImplStub!.setupView(data: data))
        
    }
    
    

     struct __StubbingProxy_TripDistancesPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.ClassStubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method:
    """
    fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.ClassStubNoReturnFunction<(Distance)> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method:
    """
    delete(distance: Distance)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentEditDistance<M1: Cuckoo.OptionalMatchable>(with data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any?)> where M1.OptionalMatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method:
    """
    presentEditDistance(with: Any?)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func totalDistancePrice() -> Cuckoo.ClassStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method:
    """
    totalDistancePrice() -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method:
    """
    setupView(data: Any)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_TripDistancesPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.__DoNotUse<(Distance), Void> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return cuckoo_manager.verify(
    """
    delete(distance: Distance)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentEditDistance<M1: Cuckoo.OptionalMatchable>(with data: M1) -> Cuckoo.__DoNotUse<(Any?), Void> where M1.OptionalMatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    presentEditDistance(with: Any?)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func totalDistancePrice() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    totalDistancePrice() -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    setupView(data: Any)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class TripDistancesPresenterStub: TripDistancesPresenter {
    

    

    
    
    
    
     override func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter).self)
    }
    
    
    
    
    
     override func delete(distance: Distance)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentEditDistance(with data: Any?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func totalDistancePrice() -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
     override func setupView(data: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsInteractor.swift
//
//  TripsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit






 class MockTripsInteractor: TripsInteractor, Cuckoo.ClassMock {
    
     typealias MocksType = TripsInteractor
    
     typealias Stubbing = __StubbingProxy_TripsInteractor
     typealias Verification = __VerificationProxy_TripsInteractor

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: TripsInteractor?

     func enableDefaultImplementation(_ stub: TripsInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func configureSubscribers()  {
        
    return cuckoo_manager.call(
    """
    configureSubscribers()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.configureSubscribers()
                ,
            defaultCall: __defaultImplStub!.configureSubscribers())
        
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter? {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchedModelAdapter()
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter())
        
    }
    
    

     struct __StubbingProxy_TripsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsInteractor.self, method:
    """
    configureSubscribers()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsInteractor.self, method:
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_TripsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    configureSubscribers()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class TripsInteractorStub: TripsInteractor {
    

    

    
    
    
    
     override func configureSubscribers()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter?  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsPresenter.swift
//
//  TripsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import UserNotifications
import Viperit






 class MockTripsModuleInterface: TripsModuleInterface, Cuckoo.ProtocolMock {
    
     typealias MocksType = TripsModuleInterface
    
     typealias Stubbing = __StubbingProxy_TripsModuleInterface
     typealias Verification = __VerificationProxy_TripsModuleInterface

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: TripsModuleInterface?

     func enableDefaultImplementation(_ stub: TripsModuleInterface) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var tripSelected: Observable<WBTrip> {
        get {
            return cuckoo_manager.getter("tripSelected",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.tripSelected)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_TripsModuleInterface: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var tripSelected: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTripsModuleInterface, Observable<WBTrip>> {
            return .init(manager: cuckoo_manager, name: "tripSelected")
        }
        
        
        
    }

     struct __VerificationProxy_TripsModuleInterface: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var tripSelected: Cuckoo.VerifyReadOnlyProperty<Observable<WBTrip>> {
            return .init(manager: cuckoo_manager, name: "tripSelected", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


 class TripsModuleInterfaceStub: TripsModuleInterface {
    
    
    
    
     var tripSelected: Observable<WBTrip> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<WBTrip>).self)
        }
        
    }
    
    

    

    
}










 class MockTripsPresenter: TripsPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = TripsPresenter
    
     typealias Stubbing = __StubbingProxy_TripsPresenter
     typealias Verification = __VerificationProxy_TripsPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: TripsPresenter?

     func enableDefaultImplementation(_ stub: TripsPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var lastOpenedTrip: WBTrip? {
        get {
            return cuckoo_manager.getter("lastOpenedTrip",
                superclassCall:
                    
                                    super.lastOpenedTrip
                    ,
                defaultCall:  __defaultImplStub!.lastOpenedTrip)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()  {
        
    return cuckoo_manager.call(
    """
    viewHasLoaded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewHasLoaded()
                ,
            defaultCall: __defaultImplStub!.viewHasLoaded())
        
    }
    
    
    
    
    
     override func presentAddTrip()  {
        
    return cuckoo_manager.call(
    """
    presentAddTrip()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.presentAddTrip()
                ,
            defaultCall: __defaultImplStub!.presentAddTrip())
        
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter? {
        
    return cuckoo_manager.call(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchedModelAdapter()
                ,
            defaultCall: __defaultImplStub!.fetchedModelAdapter())
        
    }
    
    

     struct __StubbingProxy_TripsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var lastOpenedTrip: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTripsPresenter, WBTrip?> {
            return .init(manager: cuckoo_manager, name: "lastOpenedTrip")
        }
        
        
        
        
        
        func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method:
    """
    viewHasLoaded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func presentAddTrip() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method:
    """
    presentAddTrip()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method:
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_TripsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var lastOpenedTrip: Cuckoo.VerifyReadOnlyProperty<WBTrip?> {
            return .init(manager: cuckoo_manager, name: "lastOpenedTrip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    viewHasLoaded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func presentAddTrip() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    presentAddTrip()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<(), FetchedModelAdapter?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchedModelAdapter() -> FetchedModelAdapter?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class TripsPresenterStub: TripsPresenter {
    
    
    
    
     override var lastOpenedTrip: WBTrip? {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip?).self)
        }
        
    }
    
    

    

    
    
    
    
     override func viewHasLoaded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func presentAddTrip()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func fetchedModelAdapter() -> FetchedModelAdapter?  {
        return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter?).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsRouter.swift
//
//  TripsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import SafariServices
import Viperit






 class MockTripsRouter: TripsRouter, Cuckoo.ClassMock {
    
     typealias MocksType = TripsRouter
    
     typealias Stubbing = __StubbingProxy_TripsRouter
     typealias Verification = __VerificationProxy_TripsRouter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: TripsRouter?

     func enableDefaultImplementation(_ stub: TripsRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func openPrivacySettings()  {
        
    return cuckoo_manager.call(
    """
    openPrivacySettings()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openPrivacySettings()
                ,
            defaultCall: __defaultImplStub!.openPrivacySettings())
        
    }
    
    
    
    
    
     override func openEdit(trip: WBTrip)  {
        
    return cuckoo_manager.call(
    """
    openEdit(trip: WBTrip)
    """,
            parameters: (trip),
            escapingParameters: (trip),
            superclassCall:
                
                super.openEdit(trip: trip)
                ,
            defaultCall: __defaultImplStub!.openEdit(trip: trip))
        
    }
    
    
    
    
    
     override func openAddTrip()  {
        
    return cuckoo_manager.call(
    """
    openAddTrip()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openAddTrip()
                ,
            defaultCall: __defaultImplStub!.openAddTrip())
        
    }
    
    
    
    
    
     override func openNoTrips()  {
        
    return cuckoo_manager.call(
    """
    openNoTrips()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openNoTrips()
                ,
            defaultCall: __defaultImplStub!.openNoTrips())
        
    }
    
    

     struct __StubbingProxy_TripsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func openPrivacySettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method:
    """
    openPrivacySettings()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openEdit<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method:
    """
    openEdit(trip: WBTrip)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openAddTrip() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method:
    """
    openAddTrip()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openNoTrips() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method:
    """
    openNoTrips()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_TripsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func openPrivacySettings() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openPrivacySettings()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openEdit<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.__DoNotUse<(WBTrip), Void> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify(
    """
    openEdit(trip: WBTrip)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openAddTrip() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openAddTrip()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openNoTrips() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openNoTrips()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class TripsRouterStub: TripsRouter {
    

    

    
    
    
    
     override func openPrivacySettings()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openEdit(trip: WBTrip)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openAddTrip()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func openNoTrips()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Services/Common/PurchaseService.swift
//
//  PurchaseService.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 02/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Moya
import RxSwift
import StoreKit
import SwiftyStoreKit






 class MockPurchaseService: PurchaseService, Cuckoo.ClassMock {
    
     typealias MocksType = PurchaseService
    
     typealias Stubbing = __StubbingProxy_PurchaseService
     typealias Verification = __VerificationProxy_PurchaseService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PurchaseService?

     func enableDefaultImplementation(_ stub: PurchaseService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func cacheProducts()  {
        
    return cuckoo_manager.call(
    """
    cacheProducts()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.cacheProducts()
                ,
            defaultCall: __defaultImplStub!.cacheProducts())
        
    }
    
    
    
    
    
     override func requestProducts() -> Observable<SKProduct> {
        
    return cuckoo_manager.call(
    """
    requestProducts() -> Observable<SKProduct>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.requestProducts()
                ,
            defaultCall: __defaultImplStub!.requestProducts())
        
    }
    
    
    
    
    
     override func getSubscriptions() -> Single<[SubscriptionModel]> {
        
    return cuckoo_manager.call(
    """
    getSubscriptions() -> Single<[SubscriptionModel]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getSubscriptions()
                ,
            defaultCall: __defaultImplStub!.getSubscriptions())
        
    }
    
    
    
    
    
     override func restorePurchases() -> Observable<[Purchase]> {
        
    return cuckoo_manager.call(
    """
    restorePurchases() -> Observable<[Purchase]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.restorePurchases()
                ,
            defaultCall: __defaultImplStub!.restorePurchases())
        
    }
    
    
    
    
    
     override func restorePlusSubscription() -> Observable<Bool> {
        
    return cuckoo_manager.call(
    """
    restorePlusSubscription() -> Observable<Bool>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.restorePlusSubscription()
                ,
            defaultCall: __defaultImplStub!.restorePlusSubscription())
        
    }
    
    
    
    
    
     override func purchasePlusSubscription() -> Observable<PurchaseDetails> {
        
    return cuckoo_manager.call(
    """
    purchasePlusSubscription() -> Observable<PurchaseDetails>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.purchasePlusSubscription()
                ,
            defaultCall: __defaultImplStub!.purchasePlusSubscription())
        
    }
    
    
    
    
    
     override func purchase(prodcutID: String) -> Observable<PurchaseDetails> {
        
    return cuckoo_manager.call(
    """
    purchase(prodcutID: String) -> Observable<PurchaseDetails>
    """,
            parameters: (prodcutID),
            escapingParameters: (prodcutID),
            superclassCall:
                
                super.purchase(prodcutID: prodcutID)
                ,
            defaultCall: __defaultImplStub!.purchase(prodcutID: prodcutID))
        
    }
    
    
    
    
    
     override func price(productID: String) -> Observable<String> {
        
    return cuckoo_manager.call(
    """
    price(productID: String) -> Observable<String>
    """,
            parameters: (productID),
            escapingParameters: (productID),
            superclassCall:
                
                super.price(productID: productID)
                ,
            defaultCall: __defaultImplStub!.price(productID: productID))
        
    }
    
    
    
    
    
     override func completeTransactions()  {
        
    return cuckoo_manager.call(
    """
    completeTransactions()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.completeTransactions()
                ,
            defaultCall: __defaultImplStub!.completeTransactions())
        
    }
    
    
    
    
    
     override func appStoreReceipt() -> String? {
        
    return cuckoo_manager.call(
    """
    appStoreReceipt() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.appStoreReceipt()
                ,
            defaultCall: __defaultImplStub!.appStoreReceipt())
        
    }
    
    
    
    
    
     override func isReceiptSent(_ receipt: String) -> Bool {
        
    return cuckoo_manager.call(
    """
    isReceiptSent(_: String) -> Bool
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.isReceiptSent(receipt)
                ,
            defaultCall: __defaultImplStub!.isReceiptSent(receipt))
        
    }
    
    
    
    
    
     override func logPurchases()  {
        
    return cuckoo_manager.call(
    """
    logPurchases()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.logPurchases()
                ,
            defaultCall: __defaultImplStub!.logPurchases())
        
    }
    
    
    
    
    
     override func getProducts() -> Single<[SKProduct]> {
        
    return cuckoo_manager.call(
    """
    getProducts() -> Single<[SKProduct]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getProducts()
                ,
            defaultCall: __defaultImplStub!.getProducts())
        
    }
    
    
    
    
    
     override func sendReceipt()  {
        
    return cuckoo_manager.call(
    """
    sendReceipt()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.sendReceipt()
                ,
            defaultCall: __defaultImplStub!.sendReceipt())
        
    }
    
    
    
    
    
     override func requestMobilePurchasesV2(receiptString: String) -> Single<[PurchaseModel]> {
        
    return cuckoo_manager.call(
    """
    requestMobilePurchasesV2(receiptString: String) -> Single<[PurchaseModel]>
    """,
            parameters: (receiptString),
            escapingParameters: (receiptString),
            superclassCall:
                
                super.requestMobilePurchasesV2(receiptString: receiptString)
                ,
            defaultCall: __defaultImplStub!.requestMobilePurchasesV2(receiptString: receiptString))
        
    }
    
    
    
    
    
     override func resetCache()  {
        
    return cuckoo_manager.call(
    """
    resetCache()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.resetCache()
                ,
            defaultCall: __defaultImplStub!.resetCache())
        
    }
    
    
    
    
    
     override func cacheSubscriptionValidation()  {
        
    return cuckoo_manager.call(
    """
    cacheSubscriptionValidation()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.cacheSubscriptionValidation()
                ,
            defaultCall: __defaultImplStub!.cacheSubscriptionValidation())
        
    }
    
    
    
    
    
     override func hasValidSubscription() -> Observable<Bool> {
        
    return cuckoo_manager.call(
    """
    hasValidSubscription() -> Observable<Bool>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.hasValidSubscription()
                ,
            defaultCall: __defaultImplStub!.hasValidSubscription())
        
    }
    
    
    
    
    
     override func subscriptionExpirationDate() -> Observable<Date?> {
        
    return cuckoo_manager.call(
    """
    subscriptionExpirationDate() -> Observable<Date?>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.subscriptionExpirationDate()
                ,
            defaultCall: __defaultImplStub!.subscriptionExpirationDate())
        
    }
    
    
    
    
    
     override func validateSubscription() -> Observable<SubscriptionValidation> {
        
    return cuckoo_manager.call(
    """
    validateSubscription() -> Observable<SubscriptionValidation>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.validateSubscription()
                ,
            defaultCall: __defaultImplStub!.validateSubscription())
        
    }
    
    
    
    
    
     override func forceValidateSubscription() -> Observable<SubscriptionValidation> {
        
    return cuckoo_manager.call(
    """
    forceValidateSubscription() -> Observable<SubscriptionValidation>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.forceValidateSubscription()
                ,
            defaultCall: __defaultImplStub!.forceValidateSubscription())
        
    }
    
    
    
    
    
     override func verifySubscription(receipt: ReceiptInfo) -> SubscriptionValidation {
        
    return cuckoo_manager.call(
    """
    verifySubscription(receipt: ReceiptInfo) -> SubscriptionValidation
    """,
            parameters: (receipt),
            escapingParameters: (receipt),
            superclassCall:
                
                super.verifySubscription(receipt: receipt)
                ,
            defaultCall: __defaultImplStub!.verifySubscription(receipt: receipt))
        
    }
    
    
    
    
    
     override func markAppStoreInteracted()  {
        
    return cuckoo_manager.call(
    """
    markAppStoreInteracted()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.markAppStoreInteracted()
                ,
            defaultCall: __defaultImplStub!.markAppStoreInteracted())
        
    }
    
    
    
    
    
     override func isAppStoreInteracted() -> Bool {
        
    return cuckoo_manager.call(
    """
    isAppStoreInteracted() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.isAppStoreInteracted()
                ,
            defaultCall: __defaultImplStub!.isAppStoreInteracted())
        
    }
    
    

     struct __StubbingProxy_PurchaseService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func cacheProducts() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    cacheProducts()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestProducts() -> Cuckoo.ClassStubFunction<(), Observable<SKProduct>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    requestProducts() -> Observable<SKProduct>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getSubscriptions() -> Cuckoo.ClassStubFunction<(), Single<[SubscriptionModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    getSubscriptions() -> Single<[SubscriptionModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func restorePurchases() -> Cuckoo.ClassStubFunction<(), Observable<[Purchase]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    restorePurchases() -> Observable<[Purchase]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func restorePlusSubscription() -> Cuckoo.ClassStubFunction<(), Observable<Bool>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    restorePlusSubscription() -> Observable<Bool>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func purchasePlusSubscription() -> Cuckoo.ClassStubFunction<(), Observable<PurchaseDetails>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    purchasePlusSubscription() -> Observable<PurchaseDetails>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func purchase<M1: Cuckoo.Matchable>(prodcutID: M1) -> Cuckoo.ClassStubFunction<(String), Observable<PurchaseDetails>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: prodcutID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    purchase(prodcutID: String) -> Observable<PurchaseDetails>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func price<M1: Cuckoo.Matchable>(productID: M1) -> Cuckoo.ClassStubFunction<(String), Observable<String>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: productID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    price(productID: String) -> Observable<String>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func completeTransactions() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    completeTransactions()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func appStoreReceipt() -> Cuckoo.ClassStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    appStoreReceipt() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isReceiptSent<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.ClassStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    isReceiptSent(_: String) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logPurchases() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    logPurchases()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getProducts() -> Cuckoo.ClassStubFunction<(), Single<[SKProduct]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    getProducts() -> Single<[SKProduct]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendReceipt() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    sendReceipt()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestMobilePurchasesV2<M1: Cuckoo.Matchable>(receiptString: M1) -> Cuckoo.ClassStubFunction<(String), Single<[PurchaseModel]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: receiptString) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    requestMobilePurchasesV2(receiptString: String) -> Single<[PurchaseModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func resetCache() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    resetCache()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func cacheSubscriptionValidation() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    cacheSubscriptionValidation()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func hasValidSubscription() -> Cuckoo.ClassStubFunction<(), Observable<Bool>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    hasValidSubscription() -> Observable<Bool>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func subscriptionExpirationDate() -> Cuckoo.ClassStubFunction<(), Observable<Date?>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    subscriptionExpirationDate() -> Observable<Date?>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateSubscription() -> Cuckoo.ClassStubFunction<(), Observable<SubscriptionValidation>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    validateSubscription() -> Observable<SubscriptionValidation>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func forceValidateSubscription() -> Cuckoo.ClassStubFunction<(), Observable<SubscriptionValidation>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    forceValidateSubscription() -> Observable<SubscriptionValidation>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func verifySubscription<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubFunction<(ReceiptInfo), SubscriptionValidation> where M1.MatchedType == ReceiptInfo {
            let matchers: [Cuckoo.ParameterMatcher<(ReceiptInfo)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    verifySubscription(receipt: ReceiptInfo) -> SubscriptionValidation
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func markAppStoreInteracted() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    markAppStoreInteracted()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isAppStoreInteracted() -> Cuckoo.ClassStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method:
    """
    isAppStoreInteracted() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_PurchaseService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func cacheProducts() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    cacheProducts()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestProducts() -> Cuckoo.__DoNotUse<(), Observable<SKProduct>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestProducts() -> Observable<SKProduct>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getSubscriptions() -> Cuckoo.__DoNotUse<(), Single<[SubscriptionModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getSubscriptions() -> Single<[SubscriptionModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func restorePurchases() -> Cuckoo.__DoNotUse<(), Observable<[Purchase]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    restorePurchases() -> Observable<[Purchase]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func restorePlusSubscription() -> Cuckoo.__DoNotUse<(), Observable<Bool>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    restorePlusSubscription() -> Observable<Bool>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func purchasePlusSubscription() -> Cuckoo.__DoNotUse<(), Observable<PurchaseDetails>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    purchasePlusSubscription() -> Observable<PurchaseDetails>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func purchase<M1: Cuckoo.Matchable>(prodcutID: M1) -> Cuckoo.__DoNotUse<(String), Observable<PurchaseDetails>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: prodcutID) { $0 }]
            return cuckoo_manager.verify(
    """
    purchase(prodcutID: String) -> Observable<PurchaseDetails>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func price<M1: Cuckoo.Matchable>(productID: M1) -> Cuckoo.__DoNotUse<(String), Observable<String>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: productID) { $0 }]
            return cuckoo_manager.verify(
    """
    price(productID: String) -> Observable<String>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func completeTransactions() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    completeTransactions()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func appStoreReceipt() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    appStoreReceipt() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isReceiptSent<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    isReceiptSent(_: String) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logPurchases() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    logPurchases()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getProducts() -> Cuckoo.__DoNotUse<(), Single<[SKProduct]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getProducts() -> Single<[SKProduct]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendReceipt() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    sendReceipt()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestMobilePurchasesV2<M1: Cuckoo.Matchable>(receiptString: M1) -> Cuckoo.__DoNotUse<(String), Single<[PurchaseModel]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: receiptString) { $0 }]
            return cuckoo_manager.verify(
    """
    requestMobilePurchasesV2(receiptString: String) -> Single<[PurchaseModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func resetCache() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    resetCache()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func cacheSubscriptionValidation() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    cacheSubscriptionValidation()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func hasValidSubscription() -> Cuckoo.__DoNotUse<(), Observable<Bool>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    hasValidSubscription() -> Observable<Bool>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func subscriptionExpirationDate() -> Cuckoo.__DoNotUse<(), Observable<Date?>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    subscriptionExpirationDate() -> Observable<Date?>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateSubscription() -> Cuckoo.__DoNotUse<(), Observable<SubscriptionValidation>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    validateSubscription() -> Observable<SubscriptionValidation>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func forceValidateSubscription() -> Cuckoo.__DoNotUse<(), Observable<SubscriptionValidation>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    forceValidateSubscription() -> Observable<SubscriptionValidation>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func verifySubscription<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<(ReceiptInfo), SubscriptionValidation> where M1.MatchedType == ReceiptInfo {
            let matchers: [Cuckoo.ParameterMatcher<(ReceiptInfo)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify(
    """
    verifySubscription(receipt: ReceiptInfo) -> SubscriptionValidation
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func markAppStoreInteracted() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    markAppStoreInteracted()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isAppStoreInteracted() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isAppStoreInteracted() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PurchaseServiceStub: PurchaseService {
    

    

    
    
    
    
     override func cacheProducts()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func requestProducts() -> Observable<SKProduct>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<SKProduct>).self)
    }
    
    
    
    
    
     override func getSubscriptions() -> Single<[SubscriptionModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Single<[SubscriptionModel]>).self)
    }
    
    
    
    
    
     override func restorePurchases() -> Observable<[Purchase]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Purchase]>).self)
    }
    
    
    
    
    
     override func restorePlusSubscription() -> Observable<Bool>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Bool>).self)
    }
    
    
    
    
    
     override func purchasePlusSubscription() -> Observable<PurchaseDetails>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<PurchaseDetails>).self)
    }
    
    
    
    
    
     override func purchase(prodcutID: String) -> Observable<PurchaseDetails>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<PurchaseDetails>).self)
    }
    
    
    
    
    
     override func price(productID: String) -> Observable<String>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<String>).self)
    }
    
    
    
    
    
     override func completeTransactions()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func appStoreReceipt() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
     override func isReceiptSent(_ receipt: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
     override func logPurchases()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func getProducts() -> Single<[SKProduct]>  {
        return DefaultValueRegistry.defaultValue(for: (Single<[SKProduct]>).self)
    }
    
    
    
    
    
     override func sendReceipt()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func requestMobilePurchasesV2(receiptString: String) -> Single<[PurchaseModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Single<[PurchaseModel]>).self)
    }
    
    
    
    
    
     override func resetCache()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func cacheSubscriptionValidation()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func hasValidSubscription() -> Observable<Bool>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Bool>).self)
    }
    
    
    
    
    
     override func subscriptionExpirationDate() -> Observable<Date?>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Date?>).self)
    }
    
    
    
    
    
     override func validateSubscription() -> Observable<SubscriptionValidation>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<SubscriptionValidation>).self)
    }
    
    
    
    
    
     override func forceValidateSubscription() -> Observable<SubscriptionValidation>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<SubscriptionValidation>).self)
    }
    
    
    
    
    
     override func verifySubscription(receipt: ReceiptInfo) -> SubscriptionValidation  {
        return DefaultValueRegistry.defaultValue(for: (SubscriptionValidation).self)
    }
    
    
    
    
    
     override func markAppStoreInteracted()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func isAppStoreInteracted() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Services/Scan/RecognitionService.swift
//
//  RecognitionService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Moya
import RxSwift






 class MockRecognitionService: RecognitionService, Cuckoo.ClassMock {
    
     typealias MocksType = RecognitionService
    
     typealias Stubbing = __StubbingProxy_RecognitionService
     typealias Verification = __VerificationProxy_RecognitionService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: RecognitionService?

     func enableDefaultImplementation(_ stub: RecognitionService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getRecognition(_ id: String) -> Single<RecognitionResponse> {
        
    return cuckoo_manager.call(
    """
    getRecognition(_: String) -> Single<RecognitionResponse>
    """,
            parameters: (id),
            escapingParameters: (id),
            superclassCall:
                
                super.getRecognition(id)
                ,
            defaultCall: __defaultImplStub!.getRecognition(id))
        
    }
    
    
    
    
    
     override func recognize(url: URL, incognito: Bool) -> Single<String> {
        
    return cuckoo_manager.call(
    """
    recognize(url: URL, incognito: Bool) -> Single<String>
    """,
            parameters: (url, incognito),
            escapingParameters: (url, incognito),
            superclassCall:
                
                super.recognize(url: url, incognito: incognito)
                ,
            defaultCall: __defaultImplStub!.recognize(url: url, incognito: incognito))
        
    }
    
    

     struct __StubbingProxy_RecognitionService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getRecognition<M1: Cuckoo.Matchable>(_ id: M1) -> Cuckoo.ClassStubFunction<(String), Single<RecognitionResponse>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRecognitionService.self, method:
    """
    getRecognition(_: String) -> Single<RecognitionResponse>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func recognize<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(url: M1, incognito: M2) -> Cuckoo.ClassStubFunction<(URL, Bool), Single<String>> where M1.MatchedType == URL, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(URL, Bool)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: incognito) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRecognitionService.self, method:
    """
    recognize(url: URL, incognito: Bool) -> Single<String>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_RecognitionService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getRecognition<M1: Cuckoo.Matchable>(_ id: M1) -> Cuckoo.__DoNotUse<(String), Single<RecognitionResponse>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return cuckoo_manager.verify(
    """
    getRecognition(_: String) -> Single<RecognitionResponse>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func recognize<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(url: M1, incognito: M2) -> Cuckoo.__DoNotUse<(URL, Bool), Single<String>> where M1.MatchedType == URL, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(URL, Bool)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: incognito) { $0.1 }]
            return cuckoo_manager.verify(
    """
    recognize(url: URL, incognito: Bool) -> Single<String>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class RecognitionServiceStub: RecognitionService {
    

    

    
    
    
    
     override func getRecognition(_ id: String) -> Single<RecognitionResponse>  {
        return DefaultValueRegistry.defaultValue(for: (Single<RecognitionResponse>).self)
    }
    
    
    
    
    
     override func recognize(url: URL, incognito: Bool) -> Single<String>  {
        return DefaultValueRegistry.defaultValue(for: (Single<String>).self)
    }
    
    
}





// MARK: - Mocks generated from file: SmartReceipts/Services/Scan/S3Service.swift
//
//  S3Service.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import AWSS3
import Foundation
import RxSwift






 class MockS3Service: S3Service, Cuckoo.ClassMock {
    
     typealias MocksType = S3Service
    
     typealias Stubbing = __StubbingProxy_S3Service
     typealias Verification = __VerificationProxy_S3Service

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: S3Service?

     func enableDefaultImplementation(_ stub: S3Service) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func upload(image: UIImage) -> Observable<URL> {
        
    return cuckoo_manager.call(
    """
    upload(image: UIImage) -> Observable<URL>
    """,
            parameters: (image),
            escapingParameters: (image),
            superclassCall:
                
                super.upload(image: image)
                ,
            defaultCall: __defaultImplStub!.upload(image: image))
        
    }
    
    
    
    
    
     override func upload(file url: URL) -> Observable<URL> {
        
    return cuckoo_manager.call(
    """
    upload(file: URL) -> Observable<URL>
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.upload(file: url)
                ,
            defaultCall: __defaultImplStub!.upload(file: url))
        
    }
    
    
    
    
    
     override func downloadImage(_ url: URL, folder: String) -> Observable<UIImage> {
        
    return cuckoo_manager.call(
    """
    downloadImage(_: URL, folder: String) -> Observable<UIImage>
    """,
            parameters: (url, folder),
            escapingParameters: (url, folder),
            superclassCall:
                
                super.downloadImage(url, folder: folder)
                ,
            defaultCall: __defaultImplStub!.downloadImage(url, folder: folder))
        
    }
    
    

     struct __StubbingProxy_S3Service: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func upload<M1: Cuckoo.Matchable>(image: M1) -> Cuckoo.ClassStubFunction<(UIImage), Observable<URL>> where M1.MatchedType == UIImage {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage)>] = [wrap(matchable: image) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockS3Service.self, method:
    """
    upload(image: UIImage) -> Observable<URL>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func upload<M1: Cuckoo.Matchable>(file url: M1) -> Cuckoo.ClassStubFunction<(URL), Observable<URL>> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockS3Service.self, method:
    """
    upload(file: URL) -> Observable<URL>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func downloadImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ url: M1, folder: M2) -> Cuckoo.ClassStubFunction<(URL, String), Observable<UIImage>> where M1.MatchedType == URL, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(URL, String)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: folder) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockS3Service.self, method:
    """
    downloadImage(_: URL, folder: String) -> Observable<UIImage>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_S3Service: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func upload<M1: Cuckoo.Matchable>(image: M1) -> Cuckoo.__DoNotUse<(UIImage), Observable<URL>> where M1.MatchedType == UIImage {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage)>] = [wrap(matchable: image) { $0 }]
            return cuckoo_manager.verify(
    """
    upload(image: UIImage) -> Observable<URL>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func upload<M1: Cuckoo.Matchable>(file url: M1) -> Cuckoo.__DoNotUse<(URL), Observable<URL>> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    upload(file: URL) -> Observable<URL>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func downloadImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ url: M1, folder: M2) -> Cuckoo.__DoNotUse<(URL, String), Observable<UIImage>> where M1.MatchedType == URL, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(URL, String)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: folder) { $0.1 }]
            return cuckoo_manager.verify(
    """
    downloadImage(_: URL, folder: String) -> Observable<UIImage>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class S3ServiceStub: S3Service {
    

    

    
    
    
    
     override func upload(image: UIImage) -> Observable<URL>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<URL>).self)
    }
    
    
    
    
    
     override func upload(file url: URL) -> Observable<URL>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<URL>).self)
    }
    
    
    
    
    
     override func downloadImage(_ url: URL, folder: String) -> Observable<UIImage>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<UIImage>).self)
    }
    
    
}




