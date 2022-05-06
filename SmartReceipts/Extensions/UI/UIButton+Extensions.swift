//
//  UIButton+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIButton {
    func set(title: String?, for state: UIButton.State = .normal, animated: Bool = false) {
        if !animated { titleLabel?.text = title }
        setTitle(title, for: state)
    }
}

extension Reactive where Base: UIButton {
    public func titleBinder(for controlState: UIControl.State = [], animated: Bool = false) -> Binder<String?> {
        return Binder(self.base) { button, title -> Void in
            button.set(title: title, for: controlState, animated: animated)
        }
    }
}
