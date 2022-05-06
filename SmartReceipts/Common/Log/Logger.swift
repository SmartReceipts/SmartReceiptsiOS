//
//  Logger.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import FirebaseCrashlytics

/// Logger wrapper
/// 
/// Notes:
/// * iOS 10 CocoaLumberjack bug - all logs are duplicated, waiting for new release
/// more info: https://github.com/CocoaLumberjack/CocoaLumberjack/issues/765
///
@objcMembers
final class Logger: NSObject {
    
    private static let sharedInstance = Logger()
    private let fileLogger = DDFileLogger()          // File logger instance
    
    // MARK: -
    
    /// Initial setup, call it if you want to enable logger
    private override init() {
        // Default level:
        // Variables are setted in Project Build Settings, “Swift Compiler – Custom Flags” section, “Other Swift Flags”
        // “-DDEBUG” to the Debug section
        // “-DRELEASE” to the Release section
        #if DEBUG
            dynamicLogLevel = .all
        #else
            dynamicLogLevel = .info
        #endif
        
        // custom formatter
        let formatter = DDLogCustomFormatter()
        
        // Loggers:
        // TTY = Xcode console
        if let ttyLogger = DDTTYLogger.sharedInstance {
            ttyLogger.logFormatter = formatter
            DDLog.add(ttyLogger, with: dynamicLogLevel)
        }
        
        // ASL = Apple System Logs
        DDOSLogger.sharedInstance.logFormatter = formatter
        DDLog.add(DDOSLogger.sharedInstance, with: dynamicLogLevel)
        
        // Persistent log file that saves up to 1MB of logs to disk, which can be attached as part of the support email.
        fileLogger.logFormatter = formatter
        fileLogger.rollingFrequency = 0 // no limits
        fileLogger.maximumFileSize = UInt64(1024 * 1024 * 1) // 1 MB
        fileLogger.logFileManager.maximumNumberOfLogFiles = 0
        fileLogger.logFileManager.logFilesDiskQuota = UInt64(1024 * 1024 * 2) // quota is 2 MB max
        DDLog.add(fileLogger, with: dynamicLogLevel)
    }
    
    /// Log files
    ///
    /// - Returns: An array of DDLogFileInfo instances
    class func logFiles() -> [DDLogFileInfo] {
        return sharedInstance.fileLogger.logFileManager.sortedLogFileInfos
    }
    
    // MARK: - Log levels
    
    /// Verbose logging
    ///
    /// - Parameters:
    ///   - message: Descriptive message
    class func verbose(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        sharedInstance.logMacro(message: message, flag: .verbose, file: file, function: function, line: line)
    }
    
    /// Diagnosing details
    ///
    /// - Parameters:
    ///   - message: Descriptive message
    class func debug(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        sharedInstance.logMacro(message: message, flag: .debug, file: file, function: function, line: line)
    }
    
    /// Confirmation, that things are working as expected
    ///
    /// - Parameters:
    ///   - message: Descriptive message
    class func info(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        sharedInstance.logMacro(message: message, flag: .info, file: file, function: function, line: line)
    }
    
    /// An indication that something unexpected happened, or indicative of some problem in the near future (e.g. ‘disk space low’). The software is still working as expected.
    ///
    /// - Parameters:
    ///   - message: Descriptive message
    class func warning(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        sharedInstance.logMacro(message: message, flag: .warning, file: file, function: function, line: line)
    }
    
    /// Due to a more serious problem, the software has not been able to perform some function.
    ///
    /// - Parameters:
    ///   - message: Descriptive message
    class func error(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        sharedInstance.logMacro(message: message, flag: .error, file: file, function: function, line: line)
    }
    
    // MARK: - Private
    
    /// Log message constructor
    private func logMacro(message: String, flag: DDLogFlag, file: String, function: String, line: UInt) {
        
        let message = DDLogMessage(message: message,
                                   level: dynamicLogLevel,
                                   flag: flag,
                                   context: 0,
                                   file: file,
                                   function: function,
                                   line: line,
                                   tag: nil,
                                   options: [.copyFunction, .copyFile],
                                   timestamp: Date())
        
        // The default philosophy for asynchronous logging is very simple:
        // Log messages with errors should be executed synchronously.
        // All other log messages, such as debug output, are executed asynchronously.
        let trueForErrors = (flag == DDLogFlag.error) ? true : false
        
        DDLog.log(asynchronous: trueForErrors, message: message)
    }
    

    class func logCrashlytics(_ string: String) {
        Crashlytics.crashlytics().log(format: "%@", arguments: getVaList([string]))
    }
}
