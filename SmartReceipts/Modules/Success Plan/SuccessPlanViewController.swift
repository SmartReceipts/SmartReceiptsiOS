//
//  SuccessPlanViewController.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 17.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SuccessPlanViewController: UIViewController {
    private let viewModel: SuccessPlanViewModel
    private let bag = DisposeBag()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "close_circle_icon"), for: .normal)
        button.alpha = 0.5
        
        return button
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "background_image")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = LocalizedString("success_title")
        label.textColor = .white
        label.textAlignment = .center
        label.font = .bold40
        
        return label
    }()
    
    private lazy var purchasedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.alpha = 0.5
        label.textColor = .white
        label.font = .regular16
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let attributedString = NSMutableAttributedString(string: LocalizedString("success_purchased_title"))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style,  range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(LocalizedString("success_continue"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .semibold15
        button.titleLabel?.textAlignment = .center
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    init(viewModel: SuccessPlanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews([
            closeButton,
            backgroundImageView,
            successLabel,
            purchasedLabel,
            continueButton
        ])
        
        commonInit()
        bind()
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .srViolet
        
    }
    
    private func setupLayout() {
        closeButton.snp.makeConstraints { make in
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
    
    private func bind() {
        closeButton.rx
            .tap
            .bind { [weak self] in self?.viewModel.accept(.closeDidTap) }
            .disposed(by: bag)
        
        continueButton.rx
            .tap
            .bind { [weak self] in self?.viewModel.accept(.continueDidTap) }
            .disposed(by: bag)
    }
}
