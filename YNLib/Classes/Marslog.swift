//
//  Marslog.swift
//  Mata
//
//  Created by stoprain on 09/01/2017.
//  Copyright © 2017 Mata. All rights reserved.
//

import UIKit

open class Marslog: MarslogNode, Loggable {
    //modules
    public var networking: LoggableNode!

    public override init(module: String) {
        super.init(module: module)
        self.networking = MarslogNode(module: "networking")
    }
}

open class MarslogNode: LoggableNode {
    
    var module = ""
    
    public init(module: String) {
        self.module = module
    }

    public func xdebug(_ message: String, file: String?, line: Int32?, function: String?) {
        LogHelper.xdebug(self.module, fileName: file, lineNumber: line ?? 0, functionName: function, message: message)
    }
    
    public func xinfo(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        LogHelper.xinfo(self.module, fileName: file, lineNumber: line ?? 0, functionName: function, message: message)
    }
    
    public func xwarning(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        LogHelper.xwarning(self.module, fileName: file, lineNumber: line ?? 0, functionName: function, message: message)
    }
    
    public func xerror(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        LogHelper.xerror(self.module, fileName: file, lineNumber: line ?? 0, functionName: function , message: message)
    }
    
}
