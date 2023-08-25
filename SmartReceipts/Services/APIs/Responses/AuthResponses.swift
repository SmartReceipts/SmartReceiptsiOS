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

struct LoginResponse: Codable {
    private(set) var id: String
    private(set) var token: String
}
