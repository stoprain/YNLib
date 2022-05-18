//
//  DateUtils.swift
//  TwoTripleThree
//
//  Created by stoprain on 12/3/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

import Foundation

@objc
open class DateUtils: NSObject {
    
    /**
     Convert GMT date to system time zone date
     
     - parameter date: the GMT date
     
     - returns: system time zone date
     */
    
    open class func currentDateInSystemTimezone(_ date: Date) -> Date {
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = TimeZone.current
        let sourceGMTOffset = sourceTimeZone!.secondsFromGMT(for: date)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: date)
        let interval = destinationGMTOffset - sourceGMTOffset
        let destinationDate = Date(timeInterval: TimeInterval(interval), since: date)
        return destinationDate
    }
    
    open class func dateFromMillisecond(_ value: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(Double(value)/1000000.0))
    }
    
    open class func dateToMillisecond(_ value: Date) -> Int64 {
        return Int64(value.timeIntervalSince1970*1000000)
    }

}
