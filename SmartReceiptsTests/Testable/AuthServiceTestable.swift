//
//  AuthServiceTestable.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 06/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxSwift

class AuthServiceTestable: AuthServiceInterface {
    var negative = false
    
    var isLoggedInValue = true
    var isLoggedIn: Bool {
        return isLoggedInValue
    }
    
    var token: String { return "token"}
    
    var email: String { return TEST_CREDENTIALS.email }
    
    var id: String { return "id" }
    
    var loggedInObservable: Observable<Bool> {
        return negative ? .error(MockAuthError.testError) : .just(isLoggedIn)
    }
    
    var tokenObservable: Observable<String> {
        return negative ? .error(MockAuthError.testError) : .just(token)
    }
    
    func login(credentials: Credentials) -> Single<LoginResponse> {
        return negative ? .error(MockAuthError.testError) : .just(LoginResponse(id: id, token: token))
    }
    
    func signup(credentials: Credentials) -> Single<SignupResponse> {
        return negative ? .error(MockAuthError.testError) : .just(SignupResponse(id: id, token: token))
    }
    
    func login(credentials: SmartReceipts.Credentials) async throws -> SmartReceipts.LoginResponse {
        if negative {
            throw MockAuthError.testError
        } else {
            LoginResponse(id: id, token: token)
        }
    }
    
    func signup(credentials: SmartReceipts.Credentials) async throws -> SmartReceipts.SignupResponse {
        if negative {
            throw MockAuthError.testError
        } else {
            SignupResponse(id: id, token: token)
        }
    }

    func logout() -> Single<Void> {
        return negative ? .error(MockAuthError.testError) : .just(())
    }
    
    func getUser() -> Single<User> {
        return negative ? .error(MockAuthError.testError) : .never()
    }
    
    func saveDevice(token: String) -> Single<Void> {
        return negative ? .error(MockAuthError.testError) : .just(())
    }
    
    enum MockAuthError: Error {
        case testError
    }
}
