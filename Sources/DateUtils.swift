//
//  DateUtils.swift
//  TwoTripleThree
//
//  Created by stoprain on 12/3/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import Foundation

@objc
public class DateUtils: NSObject {
    
    /**
     Convert GMT date to system time zone date
     
     - parameter date: the GMT date
     
     - returns: system time zone date
     */
    
    public class func currentDateInSystemTimezone(date: NSDate) -> NSDate {
        let sourceTimeZone = NSTimeZone(abbreviation: "GMT")
        let destinationTimeZone = NSTimeZone.systemTimeZone()
        let sourceGMTOffset = sourceTimeZone!.secondsFromGMTForDate(date)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMTForDate(date)
        let interval = destinationGMTOffset - sourceGMTOffset
        let destinationDate = NSDate(timeInterval: NSTimeInterval(interval), sinceDate: date)
        return destinationDate
    }
    
    public class func dateFromMillisecond(value: Int64) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(Double(value)/1000000.0))
    }
    
    public class func dateToMillisecond(value: NSDate) -> Int64 {
        return Int64(value.timeIntervalSince1970*1000000)
    }

}