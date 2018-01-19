//
//  PinyinSearchHelper.swift
//  pinyin
//
//  Created by Rain Qian on 23/12/2017.
//  Copyright © 2017 Rain Qian. All rights reserved.
//

import UIKit

@objc open class PinyinSearchHelper: NSObject {
    
    @objc open static func search(source: String, criteria: String) -> [NSRange] {
        var results = [NSRange]()
        let cri = criteria.lowercased()
        var index = 0
        // literal
        if criteria.hasChineseCharacter {
            var cur = source as NSString
            while true {
                let range = cur.range(of: cri)
                if range.location != NSNotFound {
                    results.append(NSMakeRange(range.location+index, range.length))
                    cur = cur.substring(from: range.location+range.length) as NSString
                    index = index + range.location + range.length
                } else {
                    break
                }
            }
        // pinyin
        } else {
            var cur = Array(source)
            while true {
                if let range = String(cur).toPinyin(separator: "").range(of: cri) {
                    // match the first letter of pinyin
                    var pinyin = [Int]()
                    var scalar = [Int]()
                    var j = 0
                    var k = 0
                    for i in cur {
                        pinyin.append(j)
                        scalar.append(k)
                        let length = (String(i) == " " ? 1 : (String(i).toPinyin() as NSString).length)
                        j = j + length
                        k = k + (String(i).hasChineseCharacter ? 1 : length)
                    }
                    pinyin.append(j)
                    scalar.append(k)
                    
                    //print("==================")
                    //print("cur \(String(cur))")
                    //print("pinyin \(pinyin)")
                    //print("scalar \(scalar)")
                    
                    if let location = pinyin.index(of: range.lowerBound.encodedOffset) {
                        var length = 1
                        var count = 0
                        for (i, j) in pinyin.enumerated() {
                            if j >= range.upperBound.encodedOffset {
                                //print("i \(i) j \(j)")
                                length = scalar[i] - scalar[location]
                                count = i
                                break
                            } else if i == pinyin.count - 1 {
                                //print("last i \(i) j \(j)")
                                length = scalar[i] - scalar[location]
                                count = location + 1
                            }
                        }
                        //print("location \(location) count \(count) length \(length) (\(range.lowerBound.encodedOffset), \(range.upperBound.encodedOffset))")
                        //print("\(index) + \(NSMakeRange(scalar[location], length))")
                        
                        results.append(NSMakeRange(scalar[location]+index, length))
                        cur = [String.Element](cur[(count)...])
                        index = index + scalar[location] + length
                    } else {
                        for (i, j) in pinyin.enumerated() {
                            if j > range.lowerBound.encodedOffset {
                                cur = [String.Element](cur[(i)...])
                                index = index + scalar[i]
                                break
                            }
                        }
                    }
                } else {
                    break
                }
            }

        }
        return results
    }


}

