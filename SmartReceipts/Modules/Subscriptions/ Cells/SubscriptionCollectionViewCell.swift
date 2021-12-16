//
//  StandardCollectionViewCell.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 13.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class SubscriptionCollectionViewCell: UICollectionViewCell {
    private let bag = DisposeBag()
    
    static var identifier: String {
        return String(describing: self)
    }

    private lazy var nameLabel: UILabel = {
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = .bold28
        nameLabel.textColor = .srViolet
        
        return nameLabel
    }()
    
    private lazy var functionLabel: UILabel = {
        functionLabel = UILabel(frame: .zero)
        functionLabel.font = .regular14
        functionLabel.textColor = .srViolet

        return functionLabel
    }()
    
    private lazy var stackView: UIStackView = {
        stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            functionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var premiumImageView: UIImageView = {
        premiumImageView = UIImageView(frame: .zero)
        premiumImageView.image = UIImage(named: "premium_icon")
        premiumImageView.isHidden = true
        
        return premiumImageView
    }()
    
    private lazy var priceLabel: BorderedLabel = {
        priceLabel = BorderedLabel(frame: .zero)
        priceLabel.textColor = .white
        priceLabel.backgroundColor = .srViolet
        priceLabel.numberOfLines = 0
        priceLabel.textAlignment = .center
        
        priceLabel.clipsToBounds = true
        priceLabel.layer.cornerRadius = 12
        
        priceLabel.textInsets = UIEdgeInsets(top: 7, left: 31, bottom: 7, right: 31)
        
        return priceLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([
            stackView,
            premiumImageView,
            priceLabel,
        ])
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        configureUI()
        setupLayout()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        clipsToBounds = true
        layer.cornerRadius = 20
    }
    
    private func setupLayout() {
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.top.equalTo(contentView.snp.top).offset(24)
            make.bottom.equalTo(contentView.snp.bottom).offset(-22)
            make.trailing.equalTo(premiumImageView.snp.leading).offset(-6)
        }
        
        premiumImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(29)
            make.leading.equalTo(stackView.snp.trailing).offset(6)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(25)
            make.leading.equalTo(premiumImageView.snp.trailing).offset(22)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-26)
            make.width.equalTo(126)
        }
    }
    
    func configureCell(with subscription: Subscription) {
        switch subscription.kind {
        case .standard:
            nameLabel.text = subscription.name
            functionLabel.text = subscription.functionDescription
            priceLabel.text = "$\(subscription.price) per month"
        case .premium:
            nameLabel.text = subscription.name
            functionLabel.text = subscription.functionDescription
            priceLabel.text = "$\(subscription.price) per month"
            premiumImageView.isHidden = false
        }
    }
}
