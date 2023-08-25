//
//  AuthViewScreen.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 22.05.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Toaster

struct AuthViewScreen: View {
    var store: StoreOf<AuthViewReducer>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    Text(LocalizedString("login_title"))
                        .multilineTextAlignment(.center)
                    
                    Text(viewStore.loginFieldsHint)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    
                    TextField(
                        LocalizedString("login_field_email_hint"),
                        text: viewStore.binding(
                            get: \.email,
                            send: AuthViewReducer.Action.usernameChanged
                        )
                    )
                    .font(.system(size: 14))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    SecurePasswordField(
                        LocalizedString("login_field_password_hint"),
                        text: viewStore.binding(
                            get: \.password,
                            send: AuthViewReducer.Action.passwordChanged
                        )
                    )
                    .font(.system(size: 14))
                    
                    HStack {
                        Button {
                            viewStore.send(.loginButtonTapped)
                        } label: {
                            Text(LocalizedString("login_button_text"))
                        }
                        .opacity(viewStore.isValidEmail && viewStore.isValidPassword ? 1 : 0.5)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 41)
                        .background(Color(UIColor.srViolet))
                        .cornerRadius(5)
                        
                        Button {
                            viewStore.send(.signButtonTapped)
                        } label: {
                            Text(LocalizedString("sign_up_button_text"))
                        }
                        .opacity(viewStore.isValidEmail && viewStore.isValidPassword ? 1 : 0.5)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 41)
                        .background(Color(UIColor.srViolet))
                        .cornerRadius(5)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                .overlay {
                    if viewStore.isLoading {
                        HudSUIView(
                            isLoading: viewStore.binding(
                                get: \.isLoading,
                                send: AuthViewReducer.Action.isLoadingChanged
                            )
                        )
                        .frame(width: 58, height: 87)
                    }
                }
                .overlay {
                    if let toast = viewStore.toast {
                        ToastSUIView(toast: toast)
                    }
                }
                .alert(
                    self.store.scope(state: \.alert, action: { $0 }),
                    dismiss: .alertDismissed
                )
                .padding([.top, .horizontal], 24)
                .textFieldStyle(.roundedBorder)
                .navigationBarTitle(LocalizedString("menu_main_auth"), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image("close_button")
                        }
                    }
                }
            }
        }
    }
}

struct AuthViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthViewScreen(store: Store(initialState: AuthViewReducer.State()) {
            AuthViewReducer(authViewOutput: AuthViewOutput())
        })
    }
}
