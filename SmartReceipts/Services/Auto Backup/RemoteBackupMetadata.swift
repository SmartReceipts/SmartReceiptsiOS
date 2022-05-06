//
//  RemoteBackupMetadata.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST_Drive

protocol RemoteBackupMetadata {
    var id: String { get }
    var syncDeviceId: String { get }
    var syncDeviceName: String { get }
    var lastModifiedDate: Date? { get }
}

class DefaultRemoteBackupMetadata: RemoteBackupMetadata {
    private var _id: String
    private var _syncDeviceId: String
    private var _syncDeviceName: String
    private var _lastModifiedDate: Date?
    
    var id: String { return _id }
    var syncDeviceId: String { return _syncDeviceId }
    var syncDeviceName: String { return _syncDeviceName }
    var lastModifiedDate: Date? { return _lastModifiedDate }
    
    init(file: GTLRDrive_File) {
        _id = file.identifier ?? ""
        _syncDeviceId = file.properties?.json?.object(forKey: SYNC_UDID_PROPERTY) as? String ?? ""
        _syncDeviceName = file.descriptionProperty ?? ""
        _lastModifiedDate = file.modifiedTime?.date
    }
}
