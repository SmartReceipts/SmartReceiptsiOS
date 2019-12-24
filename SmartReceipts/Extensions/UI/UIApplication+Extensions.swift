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
}
