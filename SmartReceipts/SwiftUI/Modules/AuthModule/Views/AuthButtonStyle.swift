//
//  AuthButtonStyle.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 04.12.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import SwiftUI

struct AuthButtonStyle: SwiftUI.ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(isEnabled ? 1 : 0.5)
            .frame(maxWidth: .infinity, minHeight: 41)
            .foregroundColor(.white)
            .background(Color(UIColor.srViolet))
            .cornerRadius(5)
    }
}
