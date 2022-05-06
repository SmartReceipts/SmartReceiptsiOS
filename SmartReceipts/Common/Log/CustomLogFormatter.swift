//
//  CustomLogFormatter.swift
//  SmartReceipts
//
//  Created by Victor on 1/15/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift

/**
 * For more information about creating custom formatters, see the wiki article:
 * https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/CustomFormatters.md
 **/
class DDLogCustomFormatter: NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        // Configure logback to format the logs as follows: [ISO8601Z DateTime] <Class Name> VERBOSE/DEBUG/INFO/WARN/ERROR: Log Message
        return NSString(format: "[%@] <%@> %@: %@", logMessage.timestamp.iso8601, logMessage.fileName, logMessage.flag.toString(), logMessage.message) as String
    }
}

// MARK: - Utilites

extension DDLogFlag {
    
    func toString() -> String {
        switch self {
        case DDLogFlag.error:
            return "ERROR"
        case DDLogFlag.warning:
            return "WARNING"
        case DDLogFlag.info:
            return "INFO"
        case DDLogFlag.debug:
            return "DEBUG"
        case DDLogFlag.verbose:
            return "VERBOSE"
        default:
            return "UNKNOWN"
        }
    }
    
}

/// ISO8601Z Date formatter
extension Date {
    
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}
