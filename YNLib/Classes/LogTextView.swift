//
//  LogTextView.swift
//  ViewLog
//
//  Created by Youssef on 2017/10/13.
//  Copyright © 2017年 Youssef. All rights reserved.
//

import UIKit

class SaveLog: NSObject {
    private var logs = ""
    private let formatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "hh:mm:ss.SSS"
        return d
    }()
    @objc static let shared = SaveLog()
    private override init() {}
    private let lock = NSRecursiveLock()
    
    @objc func setLogs(text: String) {
        lock.lock()
        self.logs = self.logs+"\n"+text
        lock.unlock()
    }
    
    @objc func getLogs() -> String {
        return self.logs
    }
    
    @objc func resetLogs() {
        lock.lock()
        self.logs = ""
        lock.unlock()
    }
    
    @objc func getFormatter() -> DateFormatter {
        return self.formatter
    }
}

@objc protocol LogTextViewDelegate {
    func showMenu()
    func dismissMenu()
}

class LogTextView: UITextView {
    
    weak var textViewDelegate: LogTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        self.textViewDelegate?.showMenu()
        if action == #selector(copy(_:)) || action == #selector(select(_:)) || action == #selector(selectAll(_:)) {
            return true
        }
        return false
    }
    
    override func copy(_ sender: Any?) {
        super.copy(sender)
        self.textViewDelegate?.dismissMenu()
    }
}

class LogView: UIView, LogTextViewDelegate {
    private var logView = LogTextView()
    private var big = UIButton(type: UIButton.ButtonType.custom)
    private var middle = UIButton(type: UIButton.ButtonType.custom)
    private var small = UIButton(type: UIButton.ButtonType.custom)
    private var delete = UIButton(type: UIButton.ButtonType.custom)
    private var bottom = UIButton(type: UIButton.ButtonType.custom)
    private var send = UIButton(type: UIButton.ButtonType.custom)
    private var timer: Timer?
    
    private var documentInteractionController: UIDocumentInteractionController?
    
    @objc static let shared = LogView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height/2))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = 10086
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.logView.textViewDelegate = self
        self.logView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.logView.textColor = UIColor.white
        self.logView.textAlignment = .left
        self.logView.font = UIFont.systemFont(ofSize: 12)
        self.logView.backgroundColor = UIColor.clear
        self.logView.isEditable = false
        self.logView.layoutManager.allowsNonContiguousLayout = false
        self.addSubview(self.logView)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LogView.writeLog), userInfo: nil, repeats: true)
        
        self.big.frame = CGRect(x: UIScreen.main.bounds.width-40, y: 0, width: 30, height: 30)
        self.big.setTitle("大", for: .normal)
        self.big.setTitleColor(UIColor.green, for: .normal)
        self.big.addTarget(self, action: #selector(LogView.bigTap), for: .touchUpInside)
        self.addSubview(self.big)
        
        self.middle.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 0, width: 30, height: 30)
        self.middle.setTitle("半", for: .normal)
        self.middle.setTitleColor(UIColor.red, for: .normal)
        self.middle.addTarget(self, action: #selector(LogView.middleTap), for: .touchUpInside)
        self.addSubview(self.middle)
        
        self.small.frame = CGRect(x: UIScreen.main.bounds.width-120, y: 0, width: 30, height: 30)
        self.small.setTitle("小", for: .normal)
        self.small.setTitleColor(UIColor.yellow, for: .normal)
        self.small.addTarget(self, action: #selector(LogView.smallTap), for: .touchUpInside)
        self.addSubview(self.small)
        
        self.delete.frame = CGRect(x: UIScreen.main.bounds.width-160, y: 0, width: 30, height: 30)
        self.delete.setTitle("删", for: .normal)
        self.delete.setTitleColor(UIColor.blue, for: .normal)
        self.delete.addTarget(self, action: #selector(LogView.deleteTap), for: .touchUpInside)
        self.addSubview(self.delete)
        
        self.bottom.frame = CGRect(x: UIScreen.main.bounds.width-200, y: 0, width: 30, height: 30)
        self.bottom.setTitle("底", for: .normal)
        self.bottom.setTitleColor(UIColor.cyan, for: .normal)
        self.bottom.addTarget(self, action: #selector(LogView.bottomTap), for: .touchUpInside)
        self.addSubview(self.bottom)
        
        self.send.frame = CGRect(x: UIScreen.main.bounds.width-240, y: 0, width: 30, height: 30)
        self.send.setTitle("传", for: .normal)
        self.send.setTitleColor(UIColor.orange, for: .normal)
        self.send.addTarget(self, action: #selector(LogView.sendFile), for: .touchUpInside)
        self.addSubview(self.send)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMenu() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func dismissMenu() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LogView.writeLog), userInfo: nil, repeats: true)
    }
    
    @objc func bigTap() {
        let fixHeight = UIApplication.shared.statusBarFrame.height
        self.frame = CGRect(x: 0, y: fixHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-fixHeight)
        self.logView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-fixHeight)
        self.big.frame = CGRect(x: UIScreen.main.bounds.width-40, y: 0, width: 30, height: 30)
        self.middle.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 0, width: 30, height: 30)
        self.small.frame = CGRect(x: UIScreen.main.bounds.width-120, y: 0, width: 30, height: 30)
        self.delete.frame = CGRect(x: UIScreen.main.bounds.width-160, y: 0, width: 30, height: 30)
        self.bottom.frame = CGRect(x: UIScreen.main.bounds.width-200, y: 0, width: 30, height: 30)
        self.send.frame = CGRect(x: UIScreen.main.bounds.width-240, y: 0, width: 30, height: 30)
        self.small.isHidden = false
        self.middle.isHidden = false
        self.bottom.isHidden = false
        self.delete.isHidden = false
        self.send.isHidden = false
    }
    
    @objc func middleTap() {
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        self.logView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        self.small.isHidden = false
        self.middle.isHidden = false
        self.bottom.isHidden = false
        self.delete.isHidden = false
        self.send.isHidden = false
    }
    
    @objc func smallTap() {
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-40, width: 30, height: 30)
        self.logView.frame = CGRect.zero
        self.big.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.small.isHidden = true
        self.middle.isHidden = true
        self.bottom.isHidden = true
        self.delete.isHidden = true
        self.send.isHidden = true
    }
    
    @objc func deleteTap() {
        self.logView.text = ""
        SaveLog.shared.resetLogs()
    }
    
    @objc func bottomTap() {
        self.logView.scrollRangeToVisible(NSMakeRange(self.logView.text.count, 1))
    }
    
    @objc func sendFile() {
        self.smallTap()
        let manager = FileManager.default
        let filePath: String = NSHomeDirectory() + "/Documents/logFile.txt"
        if manager.fileExists(atPath: filePath) {
            try! manager.removeItem(atPath: filePath)
        }
        try! SaveLog.shared.getLogs().write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        
        DispatchQueue.main.async {
            self.documentInteractionController = UIDocumentInteractionController(url: URL(fileURLWithPath: filePath))
            self.documentInteractionController?.presentOptionsMenu(from: CGRect.zero, in: self.getCurrentViewController().view, animated: true)
        }
    }
    
    @objc class func startView() {
        if let v = UIApplication.shared.keyWindow?.viewWithTag(10086) as? LogView {
            v.writeLog()
            return
        }
        UIApplication.shared.keyWindow?.addSubview(LogView.shared)
    }
    
    @objc func writeLog() {
        DispatchQueue.main.async {
            self.logView.text = SaveLog.shared.getLogs()
        }
    }
    
    func getCurrentViewController() -> UIViewController {
        var result = UIViewController()
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for temp in windows {
                if temp.windowLevel == UIWindow.Level.normal {
                    window = temp
                    break
                }
            }
        }
        
        if let appRootVC = window?.rootViewController {
            if let frontView = window?.subviews.first {
                if var nextResponder = frontView.next  {
                    if let _ = appRootVC.presentedViewController {
                        nextResponder = appRootVC.presentedViewController!
                    }
                    
                    if nextResponder is UITabBarController {
                        let tabbar = nextResponder as! UITabBarController
                        let nav = tabbar.viewControllers![tabbar.selectedIndex] as! UINavigationController
                        result = nav.children.last!
                    } else if nextResponder is UINavigationController {
                        let nav = nextResponder as! UINavigationController
                        result = nav.children.last!
                    } else {
                        result = nextResponder as! UIViewController
                    }
                }
            }
        }
        return result
    }
}

extension LogHelper {
    @objc open class func start() {
        if let m1 = class_getClassMethod(self, #selector(xdebug(_:fileName:lineNumber:functionName:message:))) {
            if let m2 = class_getClassMethod(self, #selector(lp_xdebug(_:fileName:lineNumber:functionName:message:))) {
                method_exchangeImplementations(m1, m2)
            }
        }
        
        if let m1 = class_getClassMethod(self, #selector(xinfo(_:fileName:lineNumber:functionName:message:))) {
            if let m2 = class_getClassMethod(self, #selector(lp_xinfo(_:fileName:lineNumber:functionName:message:))) {
                method_exchangeImplementations(m1, m2)
            }
        }
        
        if let m1 = class_getClassMethod(self, #selector(xwarning(_:fileName:lineNumber:functionName:message:))) {
            if let m2 = class_getClassMethod(self, #selector(lp_xwarning(_:fileName:lineNumber:functionName:message:))) {
                method_exchangeImplementations(m1, m2)
            }
        }
        
        if let m1 = class_getClassMethod(self, #selector(xerror(_:fileName:lineNumber:functionName:message:))) {
            if let m2 = class_getClassMethod(self, #selector(lp_xerror(_:fileName:lineNumber:functionName:message:))) {
                method_exchangeImplementations(m1, m2)
            }
        }
        LogView.startView()
    }
    
    @objc dynamic class func lp_xdebug(_ module: String, fileName: String, lineNumber: Int32, functionName: String, message: String) {
        if let file = fileName.components(separatedBy: "/").last {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [D][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, file, functionName, lineNumber, message) as String)
        }else {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [D][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, "", functionName, lineNumber, message) as String)
        }
        LogHelper.lp_xdebug(module, fileName: fileName, lineNumber: lineNumber, functionName: functionName, message: message)
    }
    
    @objc dynamic class func lp_xinfo(_ module: String, fileName: String, lineNumber: Int32, functionName: String, message: String) {
        if let file = fileName.components(separatedBy: "/").last {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [I][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, file, functionName, lineNumber, message) as String)
        }else {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [I][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, "", functionName, lineNumber, message) as String)
        }
        LogHelper.lp_xinfo(module, fileName: fileName, lineNumber: lineNumber, functionName: functionName, message: message)
    }
    
    @objc dynamic class func lp_xwarning(_ module: String, fileName: String, lineNumber: Int32, functionName: String, message: String) {
        if let file = fileName.components(separatedBy: "/").last {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [W][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, file, functionName, lineNumber, message) as String)
        }else {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [W][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, "", functionName, lineNumber, message) as String)
        }
        LogHelper.lp_xwarning(module, fileName: fileName, lineNumber: lineNumber, functionName: functionName, message: message)
    }
    
    @objc dynamic class func lp_xerror(_ module: String, fileName: String, lineNumber: Int32, functionName: String, message: String) {
        if let file = fileName.components(separatedBy: "/").last {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [E][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, file, functionName, lineNumber, message) as String)
        }else {
            SaveLog.shared.setLogs(text: NSString(format: "%@ [E][%@][%@, %@, %d][%@", SaveLog.shared.getFormatter().string(from: Date()), module, "", functionName, lineNumber, message) as String)
        }
        LogHelper.lp_xerror(module, fileName: fileName, lineNumber: lineNumber, functionName: functionName, message: message)
    }
}

