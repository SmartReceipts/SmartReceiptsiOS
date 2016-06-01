//
//  TripsFetchedModelAdapter.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class TripsFetchedModelAdapter: FetchedModelAdapter {
    func refreshPriceForTrip(trip: WBTrip, inDatabase database: FMDatabase) {
        Log.debug("Refresh price on \(trip.name)")
        timeMeasured("Price update") {
            //TODO jaanus: maybe lighter query - only price/currency/exchangeRate?
            let receipts = database.fetchAllReceiptsForTrip(trip)
            let distances: [Distance]
            if WBPreferences.isTheDistancePriceBeIncludedInReports() {
                //lighter query also here?
                distances = database.fetchAllDistancesForTrip(trip)
            } else {
                distances = []
            }
            
            let collection = PricesCollection()
            // just so that when no receipts we would not end up with blank price
            collection.addPrice(Price(amount: .zero(), currency: trip.defaultCurrency))
            for receipt in receipts {
                collection.addPrice(receipt.targetPrice())
            }
            for distance in distances {
                collection.addPrice(distance.totalRate())
            }
            trip.price = collection
        }
    }
}