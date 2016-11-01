//
//  ApplicationUtils.swift
//  heartsquareapp
//
//  Created by stoprain on 3/16/15.
//  Copyright (c) 2015 HeartSquare. All rights reserved.
//

import UIKit

@objc
open class ApplicationUtils: NSObject {
    
    //hack see http://stackoverflow.com/questions/11573582/in-3g-uiapplication-sharedapplication-setidletimerdisabledyes-is-not-worki
    open class func idleTimerDisabled(_ value: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !value
        UIApplication.shared.isIdleTimerDisabled = value
    }
    
    //http://stackoverflow.com/questions/15931017/is-there-an-alternative-to-setting-uiapplication-idletimerdisabled-for-ios-6-1-t
    open class func resetIdleTimerDisabled() {
        UIApplication.shared.isIdleTimerDisabled = true
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
   
}
