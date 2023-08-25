//
//  ToastSUIView.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 25.08.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import Toaster
import SwiftUI

struct ToastSUIView: UIViewRepresentable {
    let toast: Toast
    
    func makeUIView(context: UIViewRepresentableContext<ToastSUIView>) -> ToastView {
        toast.show()
        return toast.view
    }
    
    func updateUIView(_ uiView: ToastView, context: UIViewRepresentableContext<ToastSUIView>) { }
}
