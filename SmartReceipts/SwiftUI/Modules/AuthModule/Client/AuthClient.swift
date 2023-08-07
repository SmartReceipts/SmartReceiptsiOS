//
//  AuthClient.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.07.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct AuthClient {
    var login: (Credentials) async throws -> LoginResponse
    var signup: (Credentials) async throws -> SignupResponse
}

extension AuthClient: DependencyKey {
    static var liveValue = AuthClient(
        login: { credentials in
            try await AuthService.shared.asyncLogin(credentials: credentials)
        },
        signup: { credentials in
            try await AuthService.shared.asyncSignup(credentials: credentials)
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
