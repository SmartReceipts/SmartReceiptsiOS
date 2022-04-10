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
    var output: Driver<SubscriptionViewModel.Action> {
        outputReplay.asDriver(onErrorDriveWith: .empty())
    }
    
    private let outputReplay = PublishRelay<SubscriptionViewModel.Action>()
    let bag = DisposeBag()

    private let dataSource: SubscriptionDataSource
        
    private lazy var choosePlanLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .bold40
        label.textColor = .white
        label.text = LocalizedString("subscription_plan_label")
        
        return label
    }()
    
    private lazy var firstCheckImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "check_icon")
        
        return imageView
    }()
    
    private lazy var secondCheckImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "check_icon")
        
        return imageView
    }()
    
    private lazy var thirdCheckImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "check_icon")
        
        return imageView
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstCheckImageView,
            secondCheckImageView,
            thirdCheckImageView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private lazy var firstFunctionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .regular16
        label.textColor = .white
        label.text = LocalizedString("subscription_first_function")
        
        return label
    }()
    
    private lazy var secondFunctionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .regular16
        label.textColor = .white
        label.text = LocalizedString("subscription_second_function")
        
        return label
    }()
    
    private lazy var thirdFunctionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .regular16
        label.textColor = .white
        label.text = LocalizedString("subscription_third_function")
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstFunctionLabel,
            secondFunctionLabel,
            thirdFunctionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: .zero, left: .zero, bottom: .spacing, right: .zero)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .srViolet
        collectionView.contentInset = .init(top: .spacing, left: .padding, bottom: .spacing, right: .padding)
        
        return collectionView
    }()
    
    private lazy var cancelPlanLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .regular12
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0.5
        label.isHidden = true
        label.numberOfLines = 0
        label.text = LocalizedString("subscription_cancel_plan")
        
        return label
    }()
    
    init(dataSource: SubscriptionDataSource) {
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
        outputReplay.accept(.viewDidLoad)
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
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
    
    func bind(_ viewState: Driver<SubscriptionViewController.ViewState>) {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        viewState
            .asObservable()
            .subscribe(onNext: { [weak self] viewState in
                self?.renderState(viewState)
                self?.collectionView.reloadData()
            }).disposed(by: bag)
                
        viewState.map(\.collection)
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func renderState(_ viewState: SubscriptionViewController.ViewState) {
        let hud = PendingHUDView.showFullScreen()
        switch viewState {
        case .content:
            hud.hide()
        case .loading:
            hud.hide()
        case .error:
            hud.hide()
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
        let item = dataSource.sectionModels[indexPath.section].items[indexPath.item]
//        viewModel.accept(.didSelect(item))
    }
}

extension SubscriptionViewController {
    
//    private func setupWithPurchasedPlan() {
//        viewModel.items
//            .asObservable()
//            .subscribe(onNext: { [weak self] plans in
//                guard let self = self else { return }
//                for plan in plans {
//                    for item in plan.items {
//                        if item.isPurchased {
//                            self.firstFunctionLabel.text = LocalizedString("subscription_first_function_active")
//                            self.secondFunctionLabel.text = LocalizedString("subscription_second_function_active")
//                            self.thirdFunctionLabel.text = LocalizedString("subscription_third_function_active")
//                            self.cancelPlanLabel.isHidden = !item.isPurchased
//                        }
//                    }
//                }
//            })
//            .disposed(by: bag)
//    }
}

private extension CGFloat {
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
}

