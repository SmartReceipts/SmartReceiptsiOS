//
//  SuccessPlanViewController.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 17.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import SnapKit

class SuccessPlanViewController: UIViewController {
    
    private lazy var leftButton: UIButton = {
        leftButton = UIButton(frame: .zero)
        leftButton.setImage(UIImage(named: "close_circle_icon"), for: .normal)
        leftButton.alpha = 0.5
        leftButton.addTarget(self, action: #selector(closeTapButton), for: .touchUpInside)
        
        return leftButton
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = UIImage(named: "background_image")
        backgroundImageView.contentMode = .scaleAspectFit
        
        return backgroundImageView
    }()
    
    private lazy var successLabel: UILabel = {
        successLabel = UILabel(frame: .zero)
        successLabel.text = LocalizedString("success_title")
        successLabel.textColor = .white
        successLabel.textAlignment = .center
        successLabel.font = .bold40
        
        return successLabel
    }()
    
    private lazy var purchasedLabel: UILabel = {
        purchasedLabel = UILabel(frame: .zero)
        purchasedLabel.alpha = 0.5
        purchasedLabel.textColor = .white
        purchasedLabel.font = .regular16
        purchasedLabel.numberOfLines = 0
        purchasedLabel.lineBreakMode = .byWordWrapping
        let attributedString = NSMutableAttributedString(string: LocalizedString("success_purchased_title"))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style,  range: NSRange(location: 0, length: attributedString.length))
        purchasedLabel.attributedText = attributedString
        
        return purchasedLabel
    }()
    
    private lazy var continueButton: UIButton = {
        continueButton = UIButton(frame: .zero)
        continueButton.setTitle(LocalizedString("success_continue"), for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.backgroundColor = .white
        continueButton.titleLabel?.font = .semibold15
        continueButton.titleLabel?.textAlignment = .center
        
        continueButton.clipsToBounds = true
        continueButton.layer.cornerRadius = 12
        
        return continueButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews([
            leftButton,
            backgroundImageView,
            successLabel,
            purchasedLabel,
            continueButton
        ])
        
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .srViolet
        
    }
    
    private func setupLayout() {
        leftButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(83)
            make.trailing.equalToSuperview().offset(-18)
            make.leading.equalToSuperview()
            make.bottom.equalTo(successLabel.snp.top).offset(-56)
        }
        
        successLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.bottom).offset(56)
            make.bottom.equalTo(purchasedLabel.snp.top).offset(-12)
        }
        
        purchasedLabel.snp.makeConstraints { make in
            make.top.equalTo(successLabel.snp.bottom).offset(12)
            make.bottom.equalTo(continueButton.snp.top).offset(-40)
            make.leading.equalToSuperview().offset(69)
            make.trailing.equalToSuperview().offset(-67)
        }
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(purchasedLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(50)
        }
    }
}

extension SuccessPlanViewController {
    @objc func closeTapButton() {
        dismiss(animated: true)
    }
}
