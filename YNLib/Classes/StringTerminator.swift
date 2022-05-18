//
//  StringTerminator.swift
//  TwoTripleThree
//
//  Created by Pegaiur on 15/11/16.
//  Copyright © 2015年 stoprain. All rights reserved.
//

import Foundation

@objc
open class StringTerminator: NSObject {
    
    // sub a string to a specific length string, count from start, sub from end
    @objc open  class func subStringToAmount(_ string:String?,amount:Int) -> String? {
        if let s = string {
            var text = s
            while self.countString(text) > amount {
                text = text.substring(to: text.index(before: text.endIndex))
            }
            return text
        }
        return nil
    }
    
    //sub a string to a specific length string, count from start, sub from end. return string end with '...'
    @objc open  class func subStringToAmountWithDot(_ string:String?,amount:Int) -> String? {
        if let s = string {
            var text = s
            if self.countString(text) > amount {
                while self.countString(text) > amount {
                    text = text.substring(to: text.index(before: text.endIndex))
                }
                return "\(text)..."
            } else {
                return text
            }
        }
        return nil
    }
    
    //count a string. ascii character counts 1, chinese character counts 2, emojis have no exact count.
    @objc open  class func countString(_ string:String?) -> Int {
        if let s = string {
            var count = 0
            for s in s.unicodeScalars {
                if s.value >= 0 && s.value <= 255 {
                    count += 1
                } else {
                    count += 2
                }
            }
            return count
        }
        return 0
    }
    
    @objc open  class func eligibleUserName(_ name: String?) -> String? {
        let newName = name?.replacingOccurrences(of: "@", with: "")
        return self.subStringToAmount(newName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), amount: 20)
    }
    
    @objc open  class func eligibleUserDescroption(_ desc: String?) -> String? {
        return self.subStringToAmount(desc?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), amount: 200)
    }
    
    @objc open  class func retrieveUserNameFromMsg(_ msg: NSString?) -> [String] {
        guard let message = msg?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            return []
        }
        let hasSuffix = message.hasSuffix("@")
        var messageArr = message.components(separatedBy: "@")
        messageArr.removeFirst()
        if hasSuffix {
            messageArr.removeLast()
        }
        var userNames = [String]()
        for str in messageArr {
            var userName = str.components(separatedBy: CharacterSet.whitespacesAndNewlines).first
            userName = "@" + userName!
            userNames.append(userName!)
        }
        return userNames
    }
    
}
