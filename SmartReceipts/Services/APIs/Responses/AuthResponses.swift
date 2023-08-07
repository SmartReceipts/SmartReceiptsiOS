//
//  SignupResponse.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 17/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

struct SignupResponse: Codable {
    private(set) var id: String
    private(set) var token: String
}

extension SignupResponse: Equatable {
    static var empty = Self(
        id: "",
        token: ""
    )
}

struct LoginResponse: Codable {
    private(set) var id: String
    private(set) var token: String
}

extension LoginResponse: Equatable {
    static var empty = Self(
        id: "",
        token: ""
    )
}
