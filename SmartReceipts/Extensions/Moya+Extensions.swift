//
//  Moya+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapModel<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = .iso8601, failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap { response -> Single<D> in
            return Single.just(try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData))
        }
    }
}

extension JSONDecoder {
    static let iso8601: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601)
        return decoder
    }()
}
