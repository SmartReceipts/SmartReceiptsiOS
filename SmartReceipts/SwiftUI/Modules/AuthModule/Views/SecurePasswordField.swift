//
//  SecurePasswordField.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 07.08.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import SwiftUI

struct SecurePasswordField: View {
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
            .padding(.trailing, 5)
        }
    }
}
