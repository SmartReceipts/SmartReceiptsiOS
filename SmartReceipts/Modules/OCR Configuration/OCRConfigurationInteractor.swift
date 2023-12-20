//
//  OCRConfigurationInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import StoreKit
import SwiftyStoreKit
import Toaster

class OCRConfigurationInteractor: Interactor {
    private let bag = DisposeBag()
    private var authService: AuthService!
    
    required init() {
        authService = .shared
    }
    
    init(authService: AuthService = .shared) {
        super.init()
        self.authService = authService
    }
    
    var logout: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { [unowned self] event in
            switch event {
            case .next:
                self.authService.logout()
                    .catch({ error -> Single<Void> in
                        self.presenter.errorHandler.onNext(error.localizedDescription)
                        return .never()
                    }).asObservable()
                    .bind(to: self.presenter.successLogout)
                    .disposed(by: self.bag)
            default: break
            }
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationInteractor {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
}
