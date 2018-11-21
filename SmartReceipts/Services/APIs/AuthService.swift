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
}

class AuthService: AuthServiceInterface {
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
       return apiProvider.rx.request(.login(credentials: credentials))
            .mapModel(LoginResponse.self)
            .do(onSuccess: { [weak self] response in
                self?.save(token: response.token, email: credentials.email, id: response.id)
            })
    }
    
    func signup(credentials: Credentials) -> Single<SignupResponse> {
        return apiProvider.rx.request(.signup(credentials: credentials))
            .mapModel(SignupResponse.self)
            .do(onSuccess: { [weak self] response in
                self?.save(token: response.token, email: credentials.email, id: response.id)
            })
    }
    
    func logout() -> Single<Void> {
        guard isLoggedIn else { return .error(RequestError.notLoggedInError) }
        
        return apiProvider.rx.request(.logout)
            .map({ _ in  })
            .do(onSuccess: { self.clear() })
            .do(onError: { _ in self.clear() })
    }
    
    func getUser() -> Single<User> {
        return apiProvider.rx.request(.user)
            .mapModel(UserResponse.self)
            .map { $0.user }
    }
    
    func saveDevice(token: String) -> Single<Void> {
        return apiProvider.rx.request(.saveDevice(token: token)).map({ _ in  })
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

