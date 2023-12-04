//
//  PlanCollectionViewCell.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 13.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

final class PlanCollectionViewCell: UICollectionViewCell {
    private let bag = DisposeBag()
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private var model: PlanModel! {
        didSet {
            model.isPurchased ? updateStateCellPurchased() : updateStateCellNotPurchased()
            updateState()
        }
    }

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .bold28
        label.textColor = .srViolet
        
        return label
    }()
    
    private lazy var functionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .regular14
        label.textColor = .srViolet

        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            functionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var premiumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "premium_icon")
        
        return imageView
    }()
    
    private lazy var priceLabel: BorderedLabel = {
        let label = BorderedLabel(frame: .zero)
        label.textColor = .white
        label.backgroundColor = .srViolet
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
                
        return label
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
        backgroundColor = .white
        
        clipsToBounds = true
        layer.cornerRadius = 24
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
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
            make.bottom.equalTo(contentView.snp.bottom).offset(-26)
        }
    }
    
    private func updateState() {
        switch model.kind {
        case .standard:
            functionLabel.text = model.functionDescription
            premiumImageView.isHidden = true
        case .premium:
            functionLabel.setAttributedImage(
                leftImage: UIImage(named: "plus"),
                with: model.functionDescription
            )
            premiumImageView.isHidden = false
        }
    }
    
    private func updateStateCellPurchased() {
        priceLabel.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        priceLabel.text = LocalizedString("subscription_your_plan")
        priceLabel.textColor = .srViolet
        priceLabel.font = .bold20
    }
    
    private func updateStateCellNotPurchased() {
        priceLabel.backgroundColor = .srViolet
        priceLabel.textColor = .white
        priceLabel.setAttributedTitle(
            bigText: model.price,
            smallText: LocalizedString("subscription_price")
        )
    }
    
    func configure(with model: PlanModel) {
        self.model = model
        nameLabel.text = model.name
    }
}
