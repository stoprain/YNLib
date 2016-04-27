//
//  DataUtils.swift
//  TwoTripleThree
//
//  Created by stoprain on 2/4/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit
import CommonCrypto

extension NSData {
    
    func md5() -> String {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        CC_MD5(self.bytes, CC_LONG(self.length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
        var string = String()
        for i in UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(result.bytes), count: result.length) {
            string += NSString(format: "%02x", Int(i)) as String
        }
        return string
    }
    
}
