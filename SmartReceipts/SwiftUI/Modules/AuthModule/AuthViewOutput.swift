//
//  AuthViewOutput.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 07.08.2023.
//  Copyright © 2023 Will Baumann. All rights reserved.
//

import RxSwift

final class AuthViewOutput {
    var successAuth: Observable<Void> { return successAuthSubject.asObservable() }
    let successAuthSubject = PublishSubject<Void>()

    weak var viewController: UIViewController?
    
    func close() {
        viewController?.dismiss(animated: true)
    }
}
