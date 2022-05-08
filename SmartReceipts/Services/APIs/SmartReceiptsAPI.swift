//
//  RecognitionAPI.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import Moya

enum SmartReceiptsAPI {
    case signup(credentials: Credentials)
    case login(credentials: Credentials)
    case logout
    case user
    case subscriptions
    case saveDevice(token: String)
    case recognition(id: String)
    case recognize(url: URL, incognito: Bool)
    case mobileAppPurchases(receipt: String)
    case mobileAppPurchasesV2(receipt: String)
    case organizations
    case saveOrganization(OrganizationModel)
}

extension SmartReceiptsAPI: TargetType {
    var baseURL: URL {
        let prefix = FeatureFlags.useProdEndpoints.isEnabled ? "www" : "beta"
        return URL(string: "https://\(prefix).smartreceipts.co/api")!
    }

    var path: String {
        switch self {
        case .signup: return "/users/sign_up"
        case .login: return "/users/log_in"
        case .logout: return "/users/log_out"
        case .user: return "/users/me"
        case .subscriptions: return "/subscriptions"
        case .saveDevice: return "/users/me"
        case .recognition(let id): return "/recognitions/\(id)"
        case .recognize: return "/recognitions"
        case .mobileAppPurchases: return "/mobile_app_purchases"
        case .mobileAppPurchasesV2: return "/mobile_app_purchases"
        case .organizations: return "/organizations"
        case .saveOrganization(let organization): return "/organizations/\(organization.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup: return .post
        case .login: return .post
        case .logout: return .delete
        case .user: return .get
        case .subscriptions: return .get
        case .saveDevice: return .patch
        case .recognition: return .get
        case .recognize: return .post
        case .mobileAppPurchases: return .post
        case .mobileAppPurchasesV2: return .post
        case .organizations: return .get
        case .saveOrganization: return .put
        }
    }
    
    var headers: [String : String]? { return nil }
    
    var parameters: [String: Any] {
        switch self {
        case .signup(let creds):
            return ["signup_params" : [ "type": "signup", "email" : creds.email, "password": creds.password] ]
        case .login(let creds):
            return ["login_params" : [ "type": "login", "email" : creds.email, "password": creds.password] ]
        case .saveDevice(let token):
            return ["user" : [ "registration_ids": [token] ] ]
        case .recognize(let url, let incognito):
            return ["recognition": [ "s3_path" : "ocr/\(url.lastPathComponent)", "incognito" : incognito] ]
        case .mobileAppPurchases(let receipt):
            return ["encoded_receipt": receipt, "pay_service": "Apple Store", "goal": "Recognition"]
        case .mobileAppPurchasesV2(let receipt):
            return ["encoded_receipt": receipt, "pay_service": "Apple Store"]
        case .saveOrganization(let organization):
            let jsonData = try! JSONEncoder().encode(organization)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            
            let data = try! JSONEncoder().encode(organization)
            let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            
            print("JSON String : " + jsonString!)
            return ["organization": dictionary]
        case .subscriptions,
             .user,
             .recognition,
             .logout,
             .organizations: return [:]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .signup: return URLEncoding.httpBody
        case .login: return URLEncoding.httpBody
        case .logout: return URLEncoding.httpBody
        case .user: return URLEncoding.queryString
        case .subscriptions: return URLEncoding.httpBody
        case .saveDevice: return JSONEncoding.default
        case .recognition: return URLEncoding.httpBody
        case .recognize: return JSONEncoding.default
        case .mobileAppPurchases: return JSONEncoding.default
        case .mobileAppPurchasesV2: return JSONEncoding.default
        case .organizations: return JSONEncoding.default
        case .saveOrganization: return JSONEncoding.default
        }
    }
    
    var authParams: [String: Any] {
        switch self {
        case .user,
             .subscriptions,
             .saveDevice,
             .recognize,
             .recognition,
             .mobileAppPurchases,
             .mobileAppPurchasesV2,
             .logout,
             .organizations:
            return ["auth_params[token]": AuthService.shared.token, "auth_params[id]": AuthService.shared.id]
            
        default:
            return [:]
        }
    }
    
    var task: Task {
        switch self {
        case .organizations,
             .recognition,
             .user,
             .subscriptions:
            return .requestParameters(parameters: authParams, encoding: URLEncoding.queryString)
            
        default:
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: parameterEncoding, urlParameters: authParams)
        }
        
    }
    
    var sampleData: Data { return Data() }
    
}
