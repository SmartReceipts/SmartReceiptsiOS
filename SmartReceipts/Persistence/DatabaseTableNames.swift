//
//  DatabaseTableNames.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

// Currently it will mirror the other table names file. In future this should replace other one

enum ReceiptsTable {
    static let Name = "receipts"
    
    enum Column {
        static let Id = "id"
        static let Path = "path"
        static let Name = "name"
        static let Parent = "parent"
        static let Category = "category"
        static let Price = "price"
        static let Tax = "tax"
        static let ExchangeRate = "exchange_rate"
        static let Date = "rcpt_date"
        static let Timezone = "timezone"
        static let Comment = "comment"
        static let Expenseable = "expenseable"
        static let ISO4217 = "isocode"
        static let PaymentMethodId = "paymentMethodKey"
        static let NotFullPageImage = "fullpageimage"
        static let ProcessingStatus = "receipt_processing_status"
        static let ExtraEditText1 = "extra_edittext_1"
        static let ExtraEditText2 = "extra_edittext_2"
        static let ExtraEditText3 = "extra_edittext_3"

        
        @available(*, unavailable, message="paymentmethod is deprecated, use paymentMethodKey")
        static let PaymentMethod = "paymentmethod"
    }
}

enum CategoriesTable {
    static let Name = "categories"
    
    enum Column {
        static let Name = "name"
        static let code = "code"
        static let Breakdown = "breakdown"
    }
}

enum TripsTable {
    static let Name = "trips"
        
    enum Column {
        static let Name = "name"
        static let From = "from_date"
        static let To = "to_date"
        static let FromTimezone = "from_timezone"
        static let ToTimezone = "to_timezone"
        static let Mileage = "miles_new"
        static let Comment = "trips_comment"
        static let CostCenter = "trips_cost_center"
        static let DefaultCurrency = "trips_default_currency"
        static let Filters = "trips_filters"
        static let ProcessingStatus = "trip_processing_status"
        
        @available(*, unavailable)
        static let Price = "price"
    }
}