//
//  AuthViewBuilder.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 29.01.2024.
//  Copyright © 2024 Will Baumann. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

enum AuthViewBuilder {
    static func build(from viewController: UIViewController?) -> AuthViewOutput {
        let authViewOutput = AuthViewOutput()
        let authView = AuthViewScreen(
            store: Store(initialState: AuthViewReducer.State()) {
            AuthViewReducer(authViewOutput: authViewOutput)
        })
        let authController = UIHostingController(rootView: authView)
        authViewOutput.viewController = authController
        authViewOutput.showToast()
        viewController?.present(authController, animated: true)
        return authViewOutput
    }
}
