//
//  ApplicationUtils.swift
//  heartsquareapp
//
//  Created by stoprain on 3/16/15.
//  Copyright (c) 2015 HeartSquare. All rights reserved.
//

import UIKit

@objc
public class ApplicationUtils: NSObject {
    
    //hack see http://stackoverflow.com/questions/11573582/in-3g-uiapplication-sharedapplication-setidletimerdisabledyes-is-not-worki
    public class func idleTimerDisabled(value: Bool) {
        UIApplication.sharedApplication().idleTimerDisabled = !value
        UIApplication.sharedApplication().idleTimerDisabled = value
    }
    
    //http://stackoverflow.com/questions/15931017/is-there-an-alternative-to-setting-uiapplication-idletimerdisabled-for-ios-6-1-t
    public class func resetIdleTimerDisabled() {
        UIApplication.sharedApplication().idleTimerDisabled = true
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
    }
   
}
