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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NetworkingTest().run()

        log = ExampleMarsLog(module: "")
        MarsBridge.initXlogger("/Logs", prefix: "YNLib")

        log.debug("debug")
        log.zimsdk.info("zimsdk")
        log.analytics.warning("analytics")
        log.emMessage.error("emMessage")

        Hello.oclogtest()

        MarsBridge.flushSyncXlogger()
        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MarsBridge.deinitXlogger()
    }


}

