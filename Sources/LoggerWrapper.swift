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
    
    public static func setup(level: DDLogLevel) {
        if !RunMode.isProd() {
            let ttyLogger = DDTTYLogger.sharedInstance()
            DDLog.addLogger(ttyLogger, withLevel: level)
        }
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger, withLevel: level)
    }
    
    
    func verbose(s: String) {
        DDLogVerbose(s)
    }
    
    func debug(s: String) {
        DDLogDebug(s)
    }
    
    func info(s: String) {
        DDLogInfo(s)
    }
    
    func warning(s: String) {
        DDLogWarn(s)
    }
    
    func error(s: String) {
        DDLogError(s)
    }
}
