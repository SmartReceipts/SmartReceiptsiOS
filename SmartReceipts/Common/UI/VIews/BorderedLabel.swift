//
//  BorderedLabel.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

class BorderedLabel: UILabel {
    
    var textInsets: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet { setNeedsDisplay() }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        return size
    }
    
}

