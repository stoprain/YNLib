//
//  LoggerWrapper.swift
//  TwoTripleThree
//
//  Created by stoprain on 4/11/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CocoaLumberjack

public let log = LoggerWrapper()

@objc
open class LoggerWrapper: NSObject {
    
    open static var oclog = log
    
    open static func setup(_ level: DDLogLevel, formatter: DDLogFormatter = SimpleDDLogFormatter()) {
        if !RunMode.isProd() {
            let ttyLogger = DDTTYLogger.sharedInstance()
            ttyLogger?.logFormatter = formatter
            DDLog.add(ttyLogger, with: level)
            let aslLogger = DDASLLogger.sharedInstance()
            aslLogger?.logFormatter = formatter
            DDLog.add(aslLogger, with: level)
        }
        
        let fileLogger = DDFileLogger()
        fileLogger?.logFormatter = formatter
        fileLogger?.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger?.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: level)
    }
    
    open func verbose(_ s: String) {
        DDLogVerbose(s)
    }
    
    open func debug(_ s: String) {
        DDLogDebug(s)
    }
    
    open func info(_ s: String) {
        DDLogInfo(s)
    }
    
    open func warning(_ s: String) {
        DDLogWarn(s)
    }
    
    open func error(_ s: String) {
        DDLogError(s)
    }
}
