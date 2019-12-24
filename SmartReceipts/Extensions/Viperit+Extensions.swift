//
//  Viperit+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit
import RxSwift

extension Module {
    func interface<T>(_ type: T.Type) -> T {
        return presenter as! T
    }
}

extension PresenterProtocol {
    func presentAlert(title: String?, message: String) {
        _router.openAlert(title: title, message: message)
    }
}

extension RouterProtocol {
    func openAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
        _view.viewController.present(alert, animated: true, completion: nil)
    }
    
    func pushTo(controller: UINavigationController, animated: Bool = true, setupData: Any? = nil) {
        if let data = setupData {
            _presenter.setupView(data: data)
        }
        controller.pushViewController(_view.viewController, animated: animated)
    }
    
    func openModal(module: Module) {
        module.router.show(from: _view.viewController, embedInNavController: true)
    }
    
    func show(from: UIViewController, embedInNavController: Bool = false, setupData data: Any? = nil) {
        (self as? Router)?.show(from: from, embedInNavController: embedInNavController, setupData: data)
    }
}

extension UIViewController {
    func interface<T>(_ type: T.Type) -> T? {
        if let presenter = (self as? UserInterface)?._presenter {
            return presenter as? T
        }
        return nil
    }
}


