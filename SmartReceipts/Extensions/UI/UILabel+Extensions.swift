//
//  UILabel+Extensions.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 17.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setAttributedTitle(bigText: String, smallText: String) {
        let fullText = "\(bigText)\n\(smallText)"
        let fontBig = UIFont.systemFont(ofSize: 22, weight: .bold)
        let fontSmall = UIFont.systemFont(ofSize: 12, weight: .regular)
        let attributedString = NSMutableAttributedString(string: fullText, attributes: nil)
        
        let bigRange = (attributedString.string as NSString).range(of: bigText)
        let smallRange = (attributedString.string as NSString).range(of: smallText)
        attributedString.setAttributes([
            NSAttributedString.Key.font : fontBig,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ],
            range: bigRange
        )
        attributedString.setAttributes([
            NSAttributedString.Key.font : fontSmall,
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.6)
        ],
            range: smallRange
        )

        attributedText = attributedString
    }
    
    func setAttributedImage(leftImage: UIImage?, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = leftImage
        attachment.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        mutableAttributedString.append(NSAttributedString(string: " "))
        
        let textString = NSAttributedString(string: text)
        mutableAttributedString.append(textString)
        
        attributedText = mutableAttributedString
    }
}
