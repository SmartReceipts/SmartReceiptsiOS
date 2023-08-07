//
//  AuthModel.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.07.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import Foundation

struct AuthModel: Equatable {
    var email: String
    var password: String
}

extension AuthModel {
    static var empty = Self(email: "", password: "")
}
