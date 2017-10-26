//
//  DataUtils.swift
//  TwoTripleThree
//
//  Created by stoprain on 2/4/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import Foundation

import CommonCrypto

public extension Data {
    
    public func md5HexString() -> String {
        var result = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = self.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(self.count), &result)
        }
        var string = ""
        for i in 0..<result.count {
            string += String(format: "%02x", result[i])
        }
        return string
    }
    
}
