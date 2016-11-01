//
//  DataUtils.swift
//  TwoTripleThree
//
//  Created by stoprain on 2/4/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import Foundation

import CommonCrypto

public extension NSData {
    
    public func md5() -> String {
        var result = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(self.bytes, CC_LONG(self.length), &result)
        var string = ""
        for i in 0..<result.count {
            string += String(format: "%02x", result[i])
        }
        return string
    }
    
}
