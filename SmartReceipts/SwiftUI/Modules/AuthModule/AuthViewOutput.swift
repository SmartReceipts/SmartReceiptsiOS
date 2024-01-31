//
//  AuthViewOutput.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 07.08.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import RxSwift
import Toaster

final class AuthViewOutput {
    private let bag = DisposeBag()
    var successAuth: Observable<Void> { return successAuthSubject.asObservable() }
    let successAuthSubject = PublishSubject<Void>()

    weak var viewController: UIViewController?
    
    func close() {
        viewController?.dismiss(animated: true)
    }
    
    func showToast() {
        viewController?.rx.viewWillAppear
            .subscribe(onNext: { _ in
                Toast.show(LocalizedString("subscription_need_authorization"))
        })
        .disposed(by: bag)
    }
}
