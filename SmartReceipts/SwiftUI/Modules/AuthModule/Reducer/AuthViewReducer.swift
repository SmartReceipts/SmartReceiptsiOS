//
//  AuthViewReducer.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 22.05.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import ComposableArchitecture
import Moya
import RxSwift

struct AuthViewReducer: ReducerProtocol {
    private let authViewOutput: AuthViewOutput
    @Dependency(\.authClient) var authClient
    
    init(authViewOutput: AuthViewOutput) {
        self.authViewOutput = authViewOutput
    }
    
    
    struct State: Equatable {
        var alert: AlertState<Action>? = nil
        var email: String = ""
        var password: String = ""
        var isLoading: Bool = false
        var isLoginSuccess: Bool = false
        var isSignupSuccess: Bool = false
        var loginFieldsHint: String = LocalizedString("login_fields_hint_email")
        var isValidEmail: Bool = false
        var isValidPassword: Bool = false
    }
    
    enum Action: Equatable {
        case usernameChanged(String)
        case passwordChanged(String)
        case loginButtonTapped
        case signButtonTapped
        case showAlertError(String)
        case alertDismissed
        case didLoginResult
        case didSignupResult
        case isLoadingChanged(Bool)
        case isLoginSuccessChanged(Bool)
        case isSignupSuccessChanged(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .usernameChanged(email):
            state.email = email
            if !state.email.isEmpty && state.email.count >= 6 && state.email.contains("@") && state.email.contains(".") {
                state.isValidEmail = true
            } else {
                state.loginFieldsHint = LocalizedString("login_fields_hint_email")
                state.isValidEmail = false
            }
            return .none
        case let .passwordChanged(password):
            state.password = password
            if !state.password.isEmpty && state.password.count >= 8 {
                state.isValidPassword = true
            } else {
                state.loginFieldsHint = LocalizedString("login_fields_hint_password")
                state.isValidPassword = false
            }
            return .none
        case .loginButtonTapped:
            state.isLoading = true
            if state.isValidEmail && state.isValidPassword {
                state.loginFieldsHint = LocalizedString("login_fields_hint_valid")
            }
            return .task { [email=state.email, password=state.password] in
                do {
                    let response = try await authClient.login(.init(email, password))
                    guard response.token != "" else { return .showAlertError("токен пустой") }
                    return .didLoginResult
                } catch {
                    if let moyaError = error as? MoyaError,
                       let responseCode = moyaError.response?.statusCode,
                       responseCode == Constants.invalidCredentialsCode {
                        return .showAlertError(LocalizedString("login_failure_credentials_toast"))
                    } else {
                        return .showAlertError(error.localizedDescription)
                    }
                }
            }
        case .didLoginResult:
            state.isLoading = false
            state.isLoginSuccess = true
            self.authViewOutput.successAuthSubject.onNext(())
            return .none
        case let .showAlertError(errorMessage):
            state.isLoading = false
            state.alert = AlertState(
                title: TextState(LocalizedString("generic_error_alert_title")),
                message: TextState(errorMessage),
                dismissButton: ButtonState(
                    role: .cancel,
                    action: .send(.alertDismissed, animation: .default)
                ) { TextState(LocalizedString("generic_button_title_ok")) }
            )
            return .none
        case .signButtonTapped:
            state.isLoading = true
            if state.isValidEmail && state.isValidPassword {
                state.loginFieldsHint = LocalizedString("login_fields_hint_valid")
            }
            return .task { [email=state.email, password=state.password] in
                do {
                    let _ = try await authClient.signup(.init(email, password))
                    return .didSignupResult
                } catch {
                    if let moyaError = error as? MoyaError,
                       let responseCode = moyaError.response?.statusCode,
                       responseCode == Constants.accountAlreadyExistCode {
                        return .showAlertError(LocalizedString("sign_up_failure_account_exists_toast"))
                    } else {
                        return .showAlertError(error.localizedDescription)
                    }
                }
            }
        case .didSignupResult:
            state.isLoading = false
            state.isSignupSuccess = true
            self.authViewOutput.successAuthSubject.onNext(())
            return .none
        case .alertDismissed:
            state.alert = nil
            return .none
        case let .isLoadingChanged(flag):
            state.isLoading = flag
            return .none
        case let .isLoginSuccessChanged(flag):
            state.isLoginSuccess = flag
            return .none
        case let .isSignupSuccessChanged(flag):
            state.isSignupSuccess = flag
            return .none
        }
    }
}

private extension AuthViewReducer {
    enum Constants {
        static let accountAlreadyExistCode = 420
        static let invalidCredentialsCode = 401
    }
}
