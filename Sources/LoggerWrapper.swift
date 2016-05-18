//
//  LoggerWrapper.swift
//  TwoTripleThree
//
//  Created by stoprain on 4/11/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CocoaLumberjack

public let log = LoggerWrapper()

public struct LoggerWrapper {
    
    public static func setup(level: DDLogLevel, formatter: DDLogFormatter?) {
        if !RunMode.isProd() {
            let ttyLogger = DDTTYLogger.sharedInstance()
            if let f = formatter {
                ttyLogger.logFormatter = f
            }
            DDLog.addLogger(ttyLogger, withLevel: level)
        }
        
        let fileLogger = DDFileLogger()
        if let f = formatter {
            fileLogger.logFormatter = f
        }
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger, withLevel: level)
    }
    
    
    public func verbose(s: String) {
        DDLogVerbose(s)
    }
    
    public func debug(s: String) {
        DDLogDebug(s)
    }
    
    public func info(s: String) {
        DDLogInfo(s)
    }
    
    public func warning(s: String) {
        DDLogWarn(s)
    }
    
    public func error(s: String) {
        DDLogError(s)
    }
}
