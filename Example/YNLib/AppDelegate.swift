//
//  AppDelegate.swift
//  YNLib
//
//  Created by stoprain on 06/27/2017.
//  Copyright (c) 2017 stoprain. All rights reserved.
//

import UIKit
import YNLib

public class ExampleMarsLog: Marslog {
    
    var zimsdkNode: LoggableNode!
    var analyticsNode: LoggableNode!
    var emMessageNode: LoggableNode!
    override init(module: String) {
        super.init(module: module)
        self.zimsdkNode = MarslogNode(module: "zimsdk")
        self.analyticsNode = MarslogNode(module: "analytics")
        self.emMessageNode = MarslogNode(module: "EMMessage")
    }
    
}

extension Loggable {
    var zimsdk: LoggableNode    { return (log as! ExampleMarsLog).zimsdkNode }
    var analytics: LoggableNode { return (log as! ExampleMarsLog).analyticsNode }
    var emMessage: LoggableNode { return (log as! ExampleMarsLog).emMessageNode }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NetworkingTest().run()

        log = ExampleMarsLog(module: "")
        MarsBridge.initXlogger("/Logs", prefix: "YNLib")

        log.debug("debug")
        log.zimsdk.info("zimsdk")
        log.analytics.warning("analytics")
        log.emMessage.error("emMessage")

        Hello.oclogtest()

        let outputFormat = PinyinOutputFormat(toneType: .none, vCharType: .vCharacter, caseType: .lowercase)
        log.info("我爱中文 我愛說中國話".toPinyin(withFormat: outputFormat, separator: " "))
        log.info("我爱中文 我愛說中國話".toPinyinAcronym())
        log.info("I love Chinese.".toPinyin())
        "我爱中文".toPinyin { (pinyin) in
            log.info("toPinyin async \(pinyin)")
        }
        "我爱中文".toPinyinAcronym { (pinyin) in
            log.info("toPinyinAcronym async \(pinyin)")
        }
        log.info("我爱中文 hasChineseCharacter \("我爱中文".hasChineseCharacter)")
        log.info("I love Chinese. hasChineseCharacter \("I love Chinese.".hasChineseCharacter)")
        
//        let outputFormat = PinyinOutputFormat(toneType: .none, vCharType: .vCharacter, caseType: .lowercase)
        //let test = ["aimee 备注", "备注1", "啊1备注1啊"];
        let test = ["本等你拿", "啦啦啦"]//bengdengnina
        for t in test {
            let p = t.toPinyin(withFormat: outputFormat, separator: "")
            //let r = (p as NSString).range(of: "beiz")
            let r = (p as NSString).range(of: "a")
            log.info("\(p) \(r) > \(AppDelegate.chineseRange(s: t, range: r))")
        }
//        let test = ["计算机"];
//        for t in test {
//            let p = t.toPinyin(withFormat: outputFormat, separator: "")
//            let r = (p as NSString).range(of: "a")
//            log.info("\(p) \(r) > \(AppDelegate.chineseRange(s: t, range: r))")
//        }

        MarsBridge.flushSyncXlogger()
        
        
        return true
    }
    
    class func chineseRange(s: String, range: NSRange) -> NSRange {
        if range.length == 0 {
            return range
        }
        var result = NSMakeRange(NSNotFound, NSNotFound)
        if range.location == 0 {
            result.location = 0
        }
        if s.hasChineseCharacter {
            var pingyinCount = 0
            var chineseCount = 0
            for i in s.characters.indices {
                let c = String(s[i])
                pingyinCount += (c.hasChineseCharacter ? c.toPinyin().characters.count : c.characters.count )
                if pingyinCount >= range.location && result.location == NSNotFound {
                    result.location = chineseCount
                }
                chineseCount += 1
                if result.location != NSNotFound && pingyinCount >= (range.location + range.length) && chineseCount - result.location > 0 {
                    result.length = chineseCount - result.location
                    break
                }
            }
        } else {
            return range
        }
        return result
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MarsBridge.deinitXlogger()
    }


}

