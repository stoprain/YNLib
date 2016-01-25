//
//  StringTerminator.swift
//  TwoTripleThree
//
//  Created by Pegaiur on 15/11/16.
//  Copyright © 2015年 yunio. All rights reserved.
//

import Foundation

@objc
class StringTerminator: NSObject {
    
    @objc class func subStringToAmount(string:String?,amount:Int) -> String? {
        if let s = string {
            var text = s
            while self.countString(text) > amount {
                text = text.substringToIndex(text.endIndex.predecessor())
            }
            return text
        }
        return nil
    }
    
    @objc class func subStringToAmountWithDot(string:String?,amount:Int) -> String? {
        if let s = string {
            var text = s
            if self.countString(text) > amount {
                while self.countString(text) > amount {
                    text = text.substringToIndex(text.endIndex.predecessor())
                }
                return "\(text)..."
            } else {
                return text
            }
        }
        return nil
    }
    
    @objc class func countString(string:String?) -> Int {
        if let s = string {
            var count = 0
            for s in s.unicodeScalars {
                if s.value >= 0 && s.value <= 255 {
                    count++
                } else {
                    count += 2
                }
            }
            return count
        }
        return 0
    }
    
    
    @objc class func eligibleUserName(name: String?) -> String? {
        let newName = name?.stringByReplacingOccurrencesOfString("@", withString: "")
        return self.subStringToAmount(newName?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), amount: 20)
    }
    
    @objc class func eligibleUserDescroption(desc: String?) -> String? {
        return self.subStringToAmount(desc?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), amount: 200)
    }
    
    @objc class func retrieveUserNameFromMsg(msg: NSString?) -> [String] {
        guard let message = msg?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) else {
            return []
        }
        let hasSuffix = message.hasSuffix("@")
        var messageArr = message.componentsSeparatedByString("@")
        messageArr.removeFirst()
        if hasSuffix {
            messageArr.removeLast()
        }
        var userNames = [String]()
        for str in messageArr {
            var userName = str.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).first
            userName = "@" + userName!
            userNames.append(userName!)
        }
        return userNames
    }
    
}