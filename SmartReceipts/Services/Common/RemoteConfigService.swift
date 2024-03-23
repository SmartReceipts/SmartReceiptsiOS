//
//  RemoteConfigService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07.05.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import Firebase
import StoreKit

final class RemoteConfigService {
    private(set) var subscriptionsEnabled: Bool = false
    private(set) var numberOfShowAd: Int? = nil
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    static let shared = RemoteConfigService()
    
    func setup() {
        updateValues()
        remoteConfig.fetchAndActivate { [weak self] status, error in
            if let error = error {
                Logger.debug(error.localizedDescription)
                return
            }
            self?.updateValues()
        }
    }
    
    private func updateValues() {
        let subscriptionsRemoteValue = remoteConfig.configValue(forKey: .subscriptionsKey).boolValue
        subscriptionsEnabled = subscriptionsRemoteValue ? subscriptionsRemoteValue : FeatureFlags.newSubscription.isEnabled
        let numberOfShowAdValue = remoteConfig.configValue(forKey: .numberOfShowAd).numberValue 
        numberOfShowAd = numberOfShowAdValue.intValue
    }
    
}

fileprivate extension String {
    static let subscriptionsKey = "subscriptions_enabled"
    static let numberOfShowAd = "number_of_show_dd"
}
