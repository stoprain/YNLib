//
//  DateUtils.swift
//  TwoTripleThree
//
//  Created by stoprain on 12/3/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

public class DateUtils {
    
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

}