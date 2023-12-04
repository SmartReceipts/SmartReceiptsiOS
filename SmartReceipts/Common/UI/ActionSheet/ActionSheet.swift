//
//  ActionSheet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/11/2019.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class ActionSheet {
    private(set) var sheetViewController: ActionSheetViewController
    
    init(closable: Bool = true) {
        sheetViewController = ActionSheetViewController.create()
        sheetViewController.closable = closable
        sheetViewController.modalPresentationStyle = .custom
        sheetViewController.loadViewIfNeeded()
    }
    
    @discardableResult
    func addAction(title: String, image: UIImage? = nil, style: ActionButtonView.Style = .normal) -> Observable<Void> {
        return sheetViewController.addAction(title: title, image: image, style: style)
    }
    
    func show() {
        UIApplication.shared.topViewCtonroller?.present(sheetViewController, animated: true, completion: nil)
    }
}

class ActionSheetViewController: UIViewController, Storyboardable, Containerable {
    private (set) var bag = DisposeBag()
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private var separator: UIView!
    @IBOutlet private var closeButton: UIButton!
    
    @IBOutlet private weak var tapGesture: UITapGestureRecognizer!
    
    private let transitionDelegate = BottomSheetTransitionDelegate()
    fileprivate var closable: Bool = true
    
    var container: UIView { return backView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = transitionDelegate
        
        backView.layer.cornerRadius = 24
        backView.layer.shadowRadius = 32
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = .init(width: 0, height: 4)
        backView.layer.shadowOpacity = 0.24
        
        stackView.arrangedSubviews
            .forEach { $0.removeFromSuperview() }
        
        separator.isHidden = !closable
        closeButton.isHidden = !closable
        closeButton.set(title: LocalizedString("DIALOG_CANCEL"))
        
        Observable.merge(closeButton.rx.tap.asObservable(), tapGesture.rx.event.map({ _ in }))
            .filter { [weak self] in self?.closable == true }
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.bag = DisposeBag()
                })
            }).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(closeButton)
    }
    
    func addAction(title: String, image: UIImage? = nil, style: ActionButtonView.Style) -> Observable<Void> {
        let buttonView = ActionButtonView(title: title, image: image, style: style)
        stackView.addArrangedSubview(buttonView)
        
        return buttonView.rx.tap.flatMap { _ -> Observable<Void> in
            return .create { [weak self] observer -> Disposable in
                self?.dismiss(animated: true, completion: { observer.onNext() })
                return Disposables.create()
            }
        }
    }
}

class ActionButtonView: UIButton {
    
    convenience init(title: String, image: UIImage? = nil, style: Style, isEnabledGradient: Bool = false) {
        self.init(type: .system)
        setImage(image, for: .normal)
        tintColor = style.color
        setTitle(title, for: .normal)
        
        titleLabel?.font = .regular16
        
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 12
        
        heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.sizeToFit()
        titleLabel?.frame.origin.x = UI_MARGIN_16
        
        titleLabel?.center.y = bounds.midY
        
        guard let imageView = imageView else { return }
        imageView.center.y = bounds.midY
        imageView.frame.origin.x = bounds.width - imageView.bounds.width - Constants.imageRightMargin
    }
    
    private enum Constants {
        static let imageRightMargin: CGFloat = 19
        static let buttonHeight: CGFloat = 52
    }
    
    enum Style {
        case normal, destructive, violet
        
        var color: UIColor {
            switch self {
            case .normal: return .srViolet2
            case .destructive: return .red
            case .violet: return .white
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .normal, .destructive: return .srBGR
            case .violet: return .srViolet
            }
        }
    }
}

class BottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let transition = BottomSheetAnimationTransitioning()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition.forPresenting(true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition.forPresenting(false)
    }
    
}

class BottomSheetAnimationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private var presenting = false
    private var fadeView: UIView? = nil
    
    func forPresenting(_ presenting: Bool) -> Self {
        self.presenting = presenting
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated == true ? DEFAULT_ANIMATION_DURATION: 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        presenting
            ? present(transitionContext: transitionContext)
            : dismiss(transitionContext: transitionContext)
    }
    
    func present(transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)

        let to = transitionContext.viewController(forKey: .to)!
        let fromView = transitionContext.viewController(forKey: .from)!.view
        transitionContext.containerView.frame = to.view.frame
        to.view.frame = to.view.bounds

        fadeView = UIView(frame: UIScreen.main.bounds)
        fadeView?.backgroundColor = .clear
        fromView?.insertSubview(fadeView!, belowSubview: transitionContext.containerView)
        
        let toContainer = transitionContext.containerView
        let container = (toContainer as? Containerable)?.container ?? toContainer

        toContainer.addSubview(to.view)

        toContainer.frame = toContainer.frame.offsetBy(dx: 0, dy: container.bounds.height)
        UIView.animate(withDuration: duration, animations: {
            toContainer.frame = toContainer.frame.offsetBy(dx: 0, dy: -toContainer.bounds.height)
            self.fadeView?.backgroundColor = UIColor.srBlack.withAlphaComponent(0.4)
        }, completion: { completed in
            transitionContext.completeTransition(completed)
        })
    }

    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)

        let from = transitionContext.viewController(forKey: .from)!
        let fromContainer = from.view!
        
        let container = (fromContainer as? Containerable)?.container ?? fromContainer

        UIView.animate(withDuration: duration, animations: {
            transitionContext.containerView.frame = fromContainer.frame.offsetBy(dx: 0, dy: container.bounds.height)
            self.fadeView?.backgroundColor = .clear
        }, completion: { completed in
            self.fadeView?.removeFromSuperview()
            transitionContext.completeTransition(completed)
        })
    }
}

protocol Containerable {
    var container: UIView { get }
}
