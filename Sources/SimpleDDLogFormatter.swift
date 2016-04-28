//
//  SimpleDDLogFormatter.swift
//  TwoTripleThree
//
//  Created by stoprain on 4/28/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CocoaLumberjack

class SimpleDDLogFormatter: NSObject, DDLogFormatter {
    
    private var atomicLoggerCount: Int32 = 0
    private let threadUnsafeDateFormatter = NSDateFormatter()
    private let dateFormatString = "yyyy/MM/dd HH:mm:ss:SSS"
    
    override init() {
        super.init()
        
        threadUnsafeDateFormatter.formatterBehavior = NSDateFormatterBehavior.Behavior10_4
        threadUnsafeDateFormatter.dateFormat = dateFormatString
    }
    
    func stringFromDate(date: NSDate) -> String {
        let loggerCount = OSAtomicAdd32(0, &atomicLoggerCount)
        if loggerCount <= 1 {
            return threadUnsafeDateFormatter.stringFromDate(date)
        }
        let key = "MyCustomFormatter_NSDateFormatter"
        let threadDictionary = NSThread.currentThread().threadDictionary
        if let dateFormatter = threadDictionary[key] {
            return dateFormatter.stringFromDate(date)
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.formatterBehavior = NSDateFormatterBehavior.Behavior10_4
        dateFormatter.dateFormat = dateFormatString
        threadDictionary[key] = dateFormatter
        return dateFormatter.stringFromDate(date)
    }

    func formatLogMessage(logMessage: DDLogMessage!) -> String! {
        var logLevel = ""
        switch logMessage.flag {
        case DDLogFlag.Verbose:     logLevel = "V"
        case DDLogFlag.Debug:       logLevel = "D"
        case DDLogFlag.Info:        logLevel = "I"
        case DDLogFlag.Warning:     logLevel = "W"
        case DDLogFlag.Error:       logLevel = "E"
        default:
            logLevel = ""
        }
        
        return logLevel + " " + self.stringFromDate(logMessage.timestamp) + " | " + logMessage.message
    }
    
}
