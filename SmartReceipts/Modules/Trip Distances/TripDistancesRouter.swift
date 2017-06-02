//
//  TripDistancesRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

final class TripDistancesRouter: Router {
    func showEditDistance(with data: Any?) {
        let module = Module.build(AppModules.editDistance)
        module.router.show(from: _view, embedInNavController: false, setupData: data)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesRouter {
    var presenter: TripDistancesPresenter {
        return _presenter as! TripDistancesPresenter
    }
}
