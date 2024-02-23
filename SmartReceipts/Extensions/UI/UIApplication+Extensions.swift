//
//  UIApplication+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

extension UIApplication {
    var topViewCtonroller: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
        } else {
            return false
        }
    }
    
    static var topNotchOffset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return 0
        }
    }
    
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
    
    var rootViewController: UIViewController? {
        foregroundActiveScene?
            .windows
            .filter({ $0.isKeyWindow })
            .first?
            .rootViewController
    }
}
