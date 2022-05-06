//
//  AuthInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Alamofire
import Toaster

fileprivate let ACCOUNT_ALREADY_EXISTS_CODE = 420
fileprivate let INVALID_CREDENTIALS_CODE = 401

class AuthInteractor: Interactor {
    private var authService: AuthServiceInterface
    private let bag = DisposeBag()
    
    init(authService: AuthServiceInterface = AuthService.shared) {
        self.authService = authService
        super.init()
    }
    
    required init() {
        self.authService = AuthService.shared
    }
    
    var login: AnyObserver<Credentials> {
        return AnyObserver<Credentials>(eventHandler: { [unowned self] event in
            switch event {
            case .next(let credentials):
                self.authService.login(credentials: credentials)
                    .catchError({ error -> Single<LoginResponse> in
                        if let afError = error as? AFError, afError.responseCode == INVALID_CREDENTIALS_CODE {
                            self.presenter.errorHandler.onNext(LocalizedString("login_failure_credentials_toast"))
                        } else {
                            self.presenter.errorHandler.onNext(error.localizedDescription)
                        }
                        return .never()
                    }).filter({ $0.token != "" })
                    .map({ _ in })
                    .do(onNext: { [weak self] _ in
                        self?.presenter.successAuthSubject.onNext(())
                    }).asObservable()
                    .bind(to: self.presenter.successLogin)
                    .disposed(by: self.bag)
            default: break
            }
        })
    }
    
    var signup: AnyObserver<Credentials> {
        return AnyObserver<Credentials>(eventHandler: { [unowned self] event in
            switch event {
            case .next(let credentials):
                self.authService.signup(credentials: credentials)
                    .catchError({ error -> Single<SignupResponse> in
                        if let afError = error as? AFError, afError.responseCode == ACCOUNT_ALREADY_EXISTS_CODE {
                            self.presenter.errorHandler.onNext(LocalizedString("sign_up_failure_account_exists_toast"))
                        } else {
                            self.presenter.errorHandler.onNext(error.localizedDescription)
                        }
                        return .never()
                    }).map({ _ in })
                    .do(onSuccess: { [weak self] _ in
                        self?.presenter.successAuthSubject.onNext(())
                    }).asObservable()
                    .bind(to: self.presenter.successSignup)
                    .disposed(by: self.bag)
            default: break
            }
        })
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension AuthInteractor {
    var presenter: AuthPresenter {
        return _presenter as! AuthPresenter
    }
}
