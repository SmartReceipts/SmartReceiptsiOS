//
//  SuccessPlanViewModel.swift
//  SmartReceipts
//
//  Created by a.agataev on 27.03.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SuccessPlanViewModel {
    private let router: SuccessPlanRouter
    
    init(router: SuccessPlanRouter) {
        self.router = router
    }
    
    func accept(_ action: Action) {
        switch action {
        case .closeDidTap:
            router.open(route: .close)
        case .continueDidTap:
            router.open(route: .close)
        }
        
    }
}

extension SuccessPlanViewModel {
    enum Action {
        case closeDidTap
        case continueDidTap
    }
}
