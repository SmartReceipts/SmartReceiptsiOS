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

class SubscriptionViewController: UIViewController {
    private let bag = DisposeBag()
    private let subscriptionDataSource = SubscriptionDataSource()
    private let plans = PlanAPI.getPlans()
    
    
    private lazy var choosePlanLabel: UILabel = {
        choosePlanLabel = UILabel(frame: .zero)
        choosePlanLabel.font = .bold40
        choosePlanLabel.textColor = .white
        choosePlanLabel.text = LocalizedString("subscription_plan_label")
        
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
        firstFunctionLabel.text = LocalizedString("subscription_first_function")
        
        return firstFunctionLabel
    }()
    
    private lazy var secondFunctionLabel: UILabel = {
        secondFunctionLabel = UILabel(frame: .zero)
        secondFunctionLabel.font = .regular16
        secondFunctionLabel.textColor = .white
        secondFunctionLabel.text = LocalizedString("subscription_second_function")
        
        return secondFunctionLabel
    }()
    
    private lazy var thirdFunctionLabel: UILabel = {
        thirdFunctionLabel = UILabel(frame: .zero)
        thirdFunctionLabel.font = .regular16
        thirdFunctionLabel.textColor = .white
        thirdFunctionLabel.text = LocalizedString("subscription_third_function")
        
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
        collectionView.backgroundColor = .srViolet
        
        return collectionView
    }()
    
    private lazy var cancelPlanLabel: UILabel = {
        cancelPlanLabel = UILabel(frame: .zero)
        cancelPlanLabel.font = .regular12
        cancelPlanLabel.textColor = .white
        cancelPlanLabel.textAlignment = .center
        cancelPlanLabel.alpha = 0.5
        cancelPlanLabel.isHidden = true
        cancelPlanLabel.numberOfLines = 0
        let text = LocalizedString("subscription_cancel_plan")
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 37, length: 15))
        cancelPlanLabel.attributedText = attributedText
        
        return cancelPlanLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSet = PlanDateSet(plans: plans)
        subscriptionDataSource.update(with: dataSet)
                
        view.addSubviews([
            choosePlanLabel,
            imageStackView,
            labelStackView,
            collectionView,
            cancelPlanLabel
        ])
        
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
        setupWithPurchasedPlan()
    }
    
    private func setupViews() {
        title = LocalizedString("subscription_title")
        view.backgroundColor = .srViolet
        
        collectionView.dataSource = subscriptionDataSource
        collectionView.delegate = self
        
        collectionView.register(
            PlanCollectionViewCell.self,
            forCellWithReuseIdentifier: PlanCollectionViewCell.identifier
        )
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
            make.bottom.equalToSuperview()
        }
        
        cancelPlanLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

extension SubscriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = round(UIScreen.main.bounds.width -  2 * .padding)
        return CGSize(width: width, height: round(width / 3.33))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let successVc = SuccessPlanViewController()
        successVc.modalPresentationStyle = .fullScreen
        present(successVc, animated: true, completion: nil)
    }
}

extension SubscriptionViewController {
    
    private func setupWithPurchasedPlan() {
        let isPurchased = plans.contains { $0.isPurchased == true }
        
        if isPurchased == true {
            firstFunctionLabel.text = LocalizedString("subscription_first_function_active")
            secondFunctionLabel.text = LocalizedString("subscription_second_function_active")
            thirdFunctionLabel.text = LocalizedString("subscription_third_function_active")
            cancelPlanLabel.isHidden = !isPurchased
        }
    }
}

private extension CGFloat {
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
}

