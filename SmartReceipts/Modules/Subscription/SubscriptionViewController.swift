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
import RxCocoa

final class SubscriptionViewController: UIViewController {
    var output: Driver<SubscriptionViewModel.Action> { outputEvents.asDriver(onErrorDriveWith: .empty()) }
    private let outputEvents = PublishRelay<SubscriptionViewModel.Action>()



    private let viewModel: SubscriptionViewModel
    private let dataSource: SubscriptionDataSource
    
    private let bag = DisposeBag()
    
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
        layout.sectionInset = .init(top: .zero, left: .zero, bottom: .spacing, right: .zero)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .srViolet
        collectionView.contentInset = .init(top: .spacing, left: .padding, bottom: .spacing, right: .padding)
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
        cancelPlanLabel.text = LocalizedString("subscription_cancel_plan")
        
        return cancelPlanLabel
    }()
    
    init(viewModel: SubscriptionViewModel, dataSource: SubscriptionDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubviews([
            choosePlanLabel,
            imageStackView,
            labelStackView,
            collectionView,
            cancelPlanLabel
        ])
        
        commonInit()
        bindCollectionView()
        viewModel.accept(.viewDidLoad)
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
        setupWithPurchasedPlan()
    }
    
    private func setupViews() {
        title = LocalizedString("subscription_title")
        view.backgroundColor = .srViolet
                
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
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        cancelPlanLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func bindCollectionView() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
                
        viewModel.items
            .map { $0 }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bind() {
        
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
        let item = dataSource.sectionModels[indexPath.section].items[indexPath.item]
        viewModel.accept(.didSelect(item))
    }
}

extension SubscriptionViewController {
    
    private func setupWithPurchasedPlan() {
        viewModel.items
            .asObservable()
            .subscribe(onNext: { [weak self] plans in
                guard let self = self else { return }
                for plan in plans {
                    for item in plan.items {
                        if item.isPurchased {
                            self.firstFunctionLabel.text = LocalizedString("subscription_first_function_active")
                            self.secondFunctionLabel.text = LocalizedString("subscription_second_function_active")
                            self.thirdFunctionLabel.text = LocalizedString("subscription_third_function_active")
                            self.cancelPlanLabel.isHidden = !item.isPurchased
                        }
                    }
                }
            })
            .disposed(by: bag)
    }
}

private extension CGFloat {
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
}

