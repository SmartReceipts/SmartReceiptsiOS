//
//  SubscriptionViewController.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class SubscriptionsViewController: UIViewController {
    private let bag = DisposeBag()
    private let subscriptionDataSource = SubscriptionsDataSource()
    private let subscriptions = SubscriptionAPI.getSubscriptions()
    
    private lazy var choosePlanLabel: UILabel = {
        choosePlanLabel = UILabel(frame: .zero)
        choosePlanLabel.font = .bold40
        choosePlanLabel.textColor = .white
        choosePlanLabel.text = "Choose Plan"
        
        return choosePlanLabel
    }()
    
    private lazy var firstCheckImageView: UIImageView = {
        firstCheckImageView = UIImageView(frame: .zero)
        firstCheckImageView.image = #imageLiteral(resourceName: "check_icon")
        
        return firstCheckImageView
    }()
    
    private lazy var secondCheckImageView: UIImageView = {
        secondCheckImageView = UIImageView(frame: .zero)
        secondCheckImageView.image = #imageLiteral(resourceName: "check_icon")
        
        return secondCheckImageView
    }()
    
    private lazy var thirdCheckImageView: UIImageView = {
        thirdCheckImageView = UIImageView(frame: .zero)
        thirdCheckImageView.image = #imageLiteral(resourceName: "check_icon")
        
        return thirdCheckImageView
    }()
    
    private lazy var imageStackView: UIStackView = {
        imageStackView = UIStackView(arrangedSubviews: [
            firstCheckImageView,
            secondCheckImageView,
            thirdCheckImageView
        ])
        imageStackView.axis = .vertical
        imageStackView.spacing = 8
        imageStackView.distribution = .fillProportionally
        imageStackView.alignment = .fill
        
        return imageStackView
    }()
    
    private lazy var firstFunctionLabel: UILabel = {
        firstFunctionLabel = UILabel(frame: .zero)
        firstFunctionLabel.font = .regular16
        firstFunctionLabel.textColor = .white
        firstFunctionLabel.text = "Automatically scan your receipts"
        
        return firstFunctionLabel
    }()
    
    private lazy var secondFunctionLabel: UILabel = {
        secondFunctionLabel = UILabel(frame: .zero)
        secondFunctionLabel.font = .regular16
        secondFunctionLabel.textColor = .white
        secondFunctionLabel.text = "Safely backup your data"
        
        return secondFunctionLabel
    }()
    
    private lazy var thirdFunctionLabel: UILabel = {
        thirdFunctionLabel = UILabel(frame: .zero)
        thirdFunctionLabel.font = .regular16
        thirdFunctionLabel.textColor = .white
        thirdFunctionLabel.text = "Full report customization"
        
        return thirdFunctionLabel
    }()
    
    private lazy var labelStackView: UIStackView = {
        labelStackView = UIStackView(arrangedSubviews: [
            firstFunctionLabel,
            secondFunctionLabel,
            thirdFunctionLabel
        ])
        labelStackView.axis = .vertical
        labelStackView.spacing = 11
        labelStackView.distribution = .fillEqually
        
        return labelStackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSet = SubscriptionDateSet(subscriptions: subscriptions)
        subscriptionDataSource.update(dataSet: dataSet)
                
        view.addSubviews([
            choosePlanLabel,
            imageStackView,
            labelStackView,
            collectionView
        ])
        
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        title = "Subscription"
        view.backgroundColor = .srViolet
        
        collectionView.dataSource = subscriptionDataSource
        collectionView.delegate = self
        collectionView.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: SubscriptionCollectionViewCell.identifier)
    }
    
    private func setupLayout() {
        choosePlanLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(68)
        }
        
        firstCheckImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        secondCheckImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        thirdCheckImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(choosePlanLabel.snp.bottom).offset(8)
            make.trailing.equalTo(labelStackView.snp.leading).offset(-12)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageStackView.snp.trailing).offset(12)
            make.top.equalTo(choosePlanLabel.snp.bottom).offset(9.5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(25.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(343)
            make.height.equalTo(103)
        }
    }
}

extension SubscriptionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = round(UIScreen.main.bounds.width -  2 * .padding)
        return CGSize(width: 343, height: 103)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .spacing
    }
}

private extension CGFloat {
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
}

