//
//  UIView+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit

extension UIView {
    func layoutIfNeededAnimated(duration: TimeInterval = DEFAULT_ANIMATION_DURATION) {
        UIView.animate(withDuration: duration, animations: { self.layoutIfNeeded() })
    }
    
    func layoutSubviewsAnimated(duration: TimeInterval = DEFAULT_ANIMATION_DURATION) {
        UIView.animate(withDuration: duration, animations: { self.layoutSubviews() })
    }
    
    func iOS10_safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    class func initFromNib() -> Self {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! Self
    }
    
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach{
            addSubview($0)
        }
    }
}
