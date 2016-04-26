//
//  LoggerWrapper.swift
//  TwoTripleThree
//
//  Created by stoprain on 4/11/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CocoaLumberjack

let log = LoggerWrapper()

struct LoggerWrapper {
    
    static func setup(level: DDLogLevel) {
        if !RunMode.isProd() {
            let f = SimpleDDLogFormatter()
            let ttyLogger = DDTTYLogger.sharedInstance()
            ttyLogger.logFormatter = f
            DDLog.addLogger(ttyLogger, withLevel: level)
        }
        
        let ff = SimpleDDLogFormatter()
        let fileLogger = DDFileLogger()
        fileLogger.logFormatter = ff
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
