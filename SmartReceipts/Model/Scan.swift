//
//  Scan.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import SwiftyJSON

fileprivate let MINIMUM_DATE_CONFIDENCE: Float = 0.4

class Scan {
    private(set) var image: UIImage!
    private(set) var merchant: String?
    private(set) var taxAmount: Double?
    private(set) var totalAmount: Double?
    private(set) var date: Date?
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(json: JSON, image: UIImage) {
        self.image = image
        
        let recognition = json["recognition"].data["recognition_data"]
        self.merchant = recognition["merchantName"].data.string
        self.totalAmount = recognition["totalAmount"].data.double
        self.taxAmount = recognition["taxAmount"].data.double
        self.date = parseDate(recognition["date"])
    }
    
    private func parseDate(_ json: JSON) -> Date? {
        guard let confidence = json["confidenceLevel"].float else { return nil }
        guard let dateString = json.data.string else { return nil }
        if confidence >= MINIMUM_DATE_CONFIDENCE {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.locale = Locale(identifier: "en_US")
            return formatter.date(from: dateString)
        }
        return nil
    }
}

extension Scan: Equatable {
    static func ==(lhs: Scan, rhs: Scan) -> Bool {
        if lhs === rhs { return true }
        return lhs.merchant == lhs.merchant && lhs.totalAmount == rhs.totalAmount &&
               lhs.taxAmount == lhs.taxAmount && lhs.date == rhs.date
    }
    
    
}

fileprivate extension JSON {
    var data: JSON {
        return self["data"]
    }
}
