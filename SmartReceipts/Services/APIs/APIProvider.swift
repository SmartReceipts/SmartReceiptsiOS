//
//  APIProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift
import Moya
import RxMoya

fileprivate let AUTH_ERROR_CODES = [401,403]

class APIProvider<Target: TargetType>: MoyaProvider<Target> {
    override init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
       
        var modifiedPlugins = plugins
        modifiedPlugins.append(AuthorizationPlugin())
        
        
        if DebugStates.isDebug {
            let logger = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            modifiedPlugins.append(logger)
        }
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, plugins: modifiedPlugins, trackInflights: trackInflights)
    }
    
    public func request(_ token: Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return rx.request(token, callbackQueue: callbackQueue).filterSuccessfulStatusCodes()
    }
}

class AuthorizationPlugin: PluginType {
    private let bag = DisposeBag()
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let response):
            let isAuthError = AUTH_ERROR_CODES.contains(response.statusCode)
            guard isAuthError else { return .success(response) }
            handleTokenError()
            return .failure(MoyaError.statusCode(response))
        }
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    private func handleTokenError() {
        AuthService.shared.logout().subscribe().disposed(by: bag)
    }
}
