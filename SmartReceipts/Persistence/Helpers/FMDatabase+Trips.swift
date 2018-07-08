//
//  FMDatabase+Trips.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

extension FMDatabase: RefreshTripPriceHandler {
    func tripWithName(_ name: String) -> WBTrip? {
        if let select = DatabaseQueryBuilder.selectAllStatement(forTable: TripsTable.Name) {
            select.`where`(TripsTable.Column.Name, value: name as NSObject)
            return fetchSingle(select) {
                trip in
                
                self.refreshPriceForTrip(trip, inDatabase: self)
            }
        } else {
            return nil
        }
    }
}
