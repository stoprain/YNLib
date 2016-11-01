//
//  SimpleDDLogFormatter.swift
//  TwoTripleThree
//
//  Created by stoprain on 4/28/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CocoaLumberjack

open class SimpleDDLogFormatter: NSObject, DDLogFormatter {
    
    fileprivate var atomicLoggerCount: Int32 = 0
    fileprivate let threadUnsafeDateFormatter = DateFormatter()
    fileprivate let dateFormatString = "yyyy/MM/dd HH:mm:ss:SSS"
    
    override init() {
        super.init()
        
        threadUnsafeDateFormatter.formatterBehavior = DateFormatter.Behavior.behavior10_4
        threadUnsafeDateFormatter.dateFormat = dateFormatString
    }
    
    func stringFromDate(_ date: Date) -> String {
        let loggerCount = OSAtomicAdd32(0, &atomicLoggerCount)
        if loggerCount <= 1 {
            return threadUnsafeDateFormatter.string(from: date)
        }
        let key = "MyCustomFormatter_NSDateFormatter"
        let threadDictionary = Thread.current.threadDictionary
        if let dateFormatter = threadDictionary[key] {
            return (dateFormatter as AnyObject).stringFromDate(date)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = DateFormatter.Behavior.behavior10_4
        dateFormatter.dateFormat = dateFormatString
        threadDictionary[key] = dateFormatter
        return dateFormatter.string(from: date)
    }

    open func format(message logMessage: DDLogMessage!) -> String! {
        var logLevel = ""
        switch logMessage.flag {
        case DDLogFlag.verbose:     logLevel = "V"
        case DDLogFlag.debug:       logLevel = "D"
        case DDLogFlag.info:        logLevel = "I"
        case DDLogFlag.warning:     logLevel = "W"
        case DDLogFlag.error:       logLevel = "E"
        default:
            logLevel = ""
        }
        
        return logLevel + " " + self.stringFromDate(logMessage.timestamp) + " | " + logMessage.message
    }
    
}
