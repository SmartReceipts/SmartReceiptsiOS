//
//  AuthService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire
import Moya

fileprivate let AUTH_TOKEN_KEY = "auth.token"
fileprivate let AUTH_EMAIL_KEY = "auth.email"
fileprivate let AUTH_ID_KEY = "auth.id"

protocol AuthServiceInterface {
    var isLoggedIn: Bool { get }
    var loggedInObservable: Observable<Bool> { get}
    var tokenObservable: Observable<String> { get }
    var token: String { get }
    var email: String { get }
    var id: String { get }
    
    func login(credentials: Credentials) -> Single<LoginResponse>
    func signup(credentials: Credentials) -> Single<SignupResponse>
    func logout() -> Single<Void>
    func getUser() -> Single<User>
    func saveDevice(token: String) -> Single<Void>
    
    func login(credentials: Credentials) async throws -> LoginResponse
    func signup(credentials: Credentials) async throws -> SignupResponse
}

final class AuthService: AuthServiceInterface {
    private let tokenVar = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: AUTH_TOKEN_KEY) ?? "")
    private let emailVar = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: AUTH_EMAIL_KEY) ?? "")
    private let idVar = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: AUTH_ID_KEY) ?? "")
    
    private let isLoggedInVar: BehaviorRelay<Bool>!
    private let apiProvider: APIProvider<SmartReceiptsAPI>
    
    init(apiProvider: APIProvider<SmartReceiptsAPI> = .init()) {
        self.apiProvider = apiProvider

        let defaults = UserDefaults.standard
        defaults.synchronize()
        let loggedIn = defaults.hasObject(forKey: AUTH_TOKEN_KEY) && defaults.hasObject(forKey: AUTH_EMAIL_KEY)
        isLoggedInVar = BehaviorRelay<Bool>(value: loggedIn)
    }
    
    deinit {
        Logger.debug("AuthService deinit")
    }
    
    static let shared = AuthService()
    
    var loggedInObservable: Observable<Bool> {
        return isLoggedInVar.asObservable()
    }
    
    var isLoggedIn: Bool {
        return isLoggedInVar.value
    }
    
    var tokenObservable: Observable<String> {
        return tokenVar.asObservable().filter({ !$0.isEmpty })
    }
    
    var token: String {
        let value = tokenVar.value
        if value.isEmpty {
            Logger.warning("Token is Empty")
        }
        return value
    }
    
    var email: String {
        let value = emailVar.value
        if value.isEmpty {
            Logger.warning("Email is Empty")
        }
        return value
    }
    
    var id: String {
        let value = idVar.value
        if value.isEmpty {
            Logger.warning("ID is Empty")
        }
        return value
    }
    
    func login(credentials: Credentials) -> Single<LoginResponse> {
       return apiProvider.request(.login(credentials: credentials))
            .mapModel(LoginResponse.self)
            .do(onSuccess: { [weak self] response in
                self?.save(token: response.token, email: credentials.email, id: response.id)
            })
    }
    
    func signup(credentials: Credentials) -> Single<SignupResponse> {
        return apiProvider.request(.signup(credentials: credentials))
            .mapModel(SignupResponse.self)
            .do(onSuccess: { [weak self] response in
                self?.save(token: response.token, email: credentials.email, id: response.id)
            })
    }
    
    func logout() -> Single<Void> {
        guard isLoggedIn else { return .error(RequestError.notLoggedInError) }
        
        return apiProvider.request(.logout)
            .map({ _ in  })
            .do(onSuccess: { self.clear() })
            .do(onError: { _ in self.clear() })
    }
    
    func getUser() -> Single<User> {
        return apiProvider.request(.user)
            .mapModel(UserResponse.self)
            .map { $0.user }
    }
    
    func saveDevice(token: String) -> Single<Void> {
        return apiProvider.request(.saveDevice(token: token)).map({ _ in  })
    }
    
    func login(credentials: Credentials) async throws -> LoginResponse {
        do {
            let loginResponse = try await loginRequest(credentials: credentials)
            save(token: loginResponse.token, email: credentials.email, id: loginResponse.id)
            return loginResponse
        } catch {
            throw error
        }
    }
    
    private func loginRequest(credentials: Credentials) async throws -> LoginResponse {
        try await apiProvider.asyncRequest(.login(credentials: credentials))
    }
    
    func signup(credentials: Credentials) async throws -> SignupResponse {
        do {
            let signupResponse = try await signupRequest(credentials: credentials)
            save(token: signupResponse.token, email: credentials.email, id: signupResponse.id)
            return signupResponse
        } catch {
            throw error
        }
    }
    
    private func signupRequest(credentials: Credentials) async throws -> SignupResponse {
        try await apiProvider.asyncRequest(.signup(credentials: credentials))
    }
    
    private func save(token: String, email: String, id: String?) {
        Logger.debug("Authorized - Token: \(token) Email: \(email), ID: \(id ?? "null")")
        tokenVar.accept(token)
        emailVar.accept(email)
        idVar.accept(id ?? "")
        UserDefaults.standard.set(token, forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.set(email, forKey: AUTH_EMAIL_KEY)
        UserDefaults.standard.set(id, forKey: AUTH_ID_KEY)
        isLoggedInVar.accept(true)
    }
    
    private func clear() {
        UserDefaults.standard.removeObject(forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: AUTH_EMAIL_KEY)
        UserDefaults.standard.removeObject(forKey: AUTH_ID_KEY)
        tokenVar.accept("")
        emailVar.accept("")
        idVar.accept("")
        isLoggedInVar.accept(false)
        PurchaseService.shared.resetCache()
    }
}

struct Credentials {
    var email: String
    var password: String
    
    init(_ email: String, _ password: String) {
        self.email = email
        self.password = password
    }
}

