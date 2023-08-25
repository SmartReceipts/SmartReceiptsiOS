//
//  HudSUIView.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 25.08.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import SwiftUI
import UIKit
import Lottie

struct HudSUIView: UIViewRepresentable {
    @Binding var isLoading: Bool
    let animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<HudSUIView>) -> UIView {
        let view = UIView()
        animationView.animation = LottieAnimation.named("lamp_lottie")
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.2
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<HudSUIView>) {
        isLoading ?
        context.coordinator.parent.animationView.play() :
        context.coordinator.parent.animationView.stop()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: HudSUIView
        
        init(_ parent: HudSUIView) {
            self.parent = parent
        }
    }
}
