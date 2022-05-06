//
//  CognitoService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import AWSCore
import RxSwift
import AWSCognitoAuth

fileprivate let COGNITO_TOKEN_KEY = "cognito.token"
fileprivate let COGNITO_IDENTITY_ID_KEY = "cognito.identity.id"
fileprivate let POOL_ID = "us-east-1:cdcc971a-b67f-4bc0-9a12-291b5d416518"

class CognitoService: AWSCognitoCredentialsProviderHelper {
    private let bag = DisposeBag()
    
    override init() {
        super.init(
            regionType: .USEast1,
            identityPoolId: POOL_ID,
            useEnhancedFlow: true,
            identityProviderManager: nil
        )
        
        AuthService.shared.loggedInObservable
        .filter { $0 }
        .flatMap { _ in return AuthService.shared.getUser() }
        .subscribe(onNext: { user in
            CognitoService.saveCognitoData(user: user)
        }).disposed(by: bag)
    }
    
    override init(regionType: AWSRegionType, identityPoolId: String, useEnhancedFlow: Bool, identityProviderManager: AWSIdentityProviderManager?) {
        super.init(regionType: regionType, identityPoolId: identityPoolId, useEnhancedFlow: useEnhancedFlow, identityProviderManager: identityProviderManager)
    }
    
    override init(regionType: AWSRegionType, identityPoolId: String, useEnhancedFlow: Bool, identityProviderManager: AWSIdentityProviderManager?, identityPoolConfiguration configuration: AWSServiceConfiguration) {
        super.init(regionType: regionType, identityPoolId: identityPoolId, useEnhancedFlow: useEnhancedFlow, identityProviderManager: identityProviderManager, identityPoolConfiguration: configuration)
    }
    
    override var identityProviderName: String {
        return "cognito-identity.amazonaws.com"
    }
    
    override func token() -> AWSTask<NSString> {
        if AuthService.shared.isLoggedIn, let token = Self.cognitoToken, let id = Self.cognitoIdentityId {
            identityId = id
            return AWSTask(result: NSString(string: token))
        } else {
            return AWSTask(result: nil)
        }
    }
    
    override func logins() -> AWSTask<NSDictionary> {
        if AuthService.shared.isLoggedIn {
            return super.logins()
        } else {
            return AWSTask(result: nil)
        }
    }
    
    override func clear() {
        super.clear()
        Self.cognitoToken = nil
        Self.cognitoIdentityId = nil
    }
    
    // MARK: User Defaults
    class func saveCognitoData(user: User?) {
        cognitoToken = user?.cognitoToken
        cognitoIdentityId = user?.identityId
        UserDefaults.standard.synchronize()
    }
    
    private class var cognitoToken: String? {
        get { return UserDefaults.standard.string(forKey: COGNITO_TOKEN_KEY) }
        set { UserDefaults.standard.set(newValue, forKey: COGNITO_TOKEN_KEY) }
    }
    
    private class var cognitoIdentityId: String? {
        get { return UserDefaults.standard.string(forKey: COGNITO_IDENTITY_ID_KEY) }
        set { UserDefaults.standard.set(newValue, forKey: COGNITO_IDENTITY_ID_KEY) }
    }
}

