//
//  PendingHUDView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import Lottie

class PendingHUDView: UIView {
    private let bag = DisposeBag()
    
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView.play()
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.2
        titleLabel.isHidden = true
    }
    
    class func show(on view: UIView, text: String? = nil) -> PendingHUDView {
        let hud = PendingHUDView.loadInstance()!

        if let text = text, text.isNotEmpty {
            hud.titleLabel.text = text
            hud.titleLabel.isHidden = false
        }
        
        if !isRunningTests {
            view.addSubview(hud)
        }
        
        hud.frame = view.bounds
        hud.layoutIfNeeded()
        return hud
    }

    class func show(on view: UIView, customView: UIView) -> PendingHUDView {
        let hud = PendingHUDView.loadInstance()!

        hud.titleLabel.isHidden = true
        hud.animationView.isHidden = true

        hud.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        customView.layoutIfNeeded()

        hud.frame = view.bounds
        hud.layoutIfNeeded()

        if !isRunningTests {
            view.addSubview(hud)
        }

        return hud
    }
    
    class func showFullScreen(text: String? = nil) -> PendingHUDView {
        let view = UIApplication.shared.keyWindow!
        return PendingHUDView.show(on: view, text: text)
    }

    class func showCustomView(customView: UIView) -> PendingHUDView {
        let view = UIApplication.shared.keyWindow!
        return PendingHUDView.show(on: view, customView: customView)
    }

    func hide() {
        removeFromSuperview()
    }
}

// Status Observer
extension PendingHUDView {
    func observe(status: Observable<ScanStatus>) {
        status.subscribe(onNext: { [weak self] status in
            self?.titleLabel.isHidden = false
            self?.titleLabel.text = status.localizedText
        }).disposed(by: bag)
    }
}


//MARK: Service info
fileprivate var isRunningTests: Bool {
    #if DEBUG
        let environment = ProcessInfo.processInfo.environment
        let injectBundle = environment["XCInjectBundle"]
        return (injectBundle as NSString?)?.pathExtension == "xctest"
    #else
        return false
    #endif
}

