//
//  EditDistancePresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class EditDistancePresenter: Presenter {
    override func setupView(data: Any) {
        if let inputData = data as? (trip: WBTrip, distance: Distance?) {
            view.setup(trip: inputData.trip, distance: inputData.distance)
        }
    }
    
    override func viewHasLoaded() {
        router.prepareInterstitialAd()
    }
    
    func save(distance: Distance, asNewDistance: Bool) {
        interactor.save(distance: distance, asNewDistance: asNewDistance)
    }
    
    func close() {
        router.close()
    }
    
    func done() {
        router.done(completion: router.openInterstitialAd)
    }
    
    func prepareInterstitialAd() {
        router.prepareInterstitialAd()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistancePresenter {
    var view: EditDistanceViewInterface {
        return _view as! EditDistanceViewInterface
    }
    var interactor: EditDistanceInteractor {
        return _interactor as! EditDistanceInteractor
    }
    var router: EditDistanceRouter {
        return _router as! EditDistanceRouter
    }
}
