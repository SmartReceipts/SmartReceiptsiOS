//
//  FeatureManager.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class FeatureFlags {
    static let loginSupport = Feature(true)
    static let ocrSupport   = Feature(true)
    static var organizationsSupport = Feature(true)
    static var useProdEndpoints = Feature(true)
    static var driveAppDataFolder = Feature(true)
    static var graphs = Feature(true)
}

class Feature {
    private(set) var isEnabled: Bool
    
    init(_ enabled: Bool) {
        isEnabled = enabled
    }
}

