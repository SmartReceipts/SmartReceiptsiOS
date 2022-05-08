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

class RemoteConfigService {
    private(set) var subscriptionsEnabled: Bool = false
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
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
    }
    
}

fileprivate extension String {
    static let subscriptionsKey = "subscriptions_enabled"
}
