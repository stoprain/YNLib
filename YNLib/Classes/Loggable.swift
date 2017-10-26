//
//  Loggable.swift
//  Pods
//
//  Created by stoprain on 05/07/2017.
//
//

import UIKit

public protocol LoggableNode {
    func xdebug(_ message: String, file: String?, line: Int32?, function: String?)
    func xinfo(_ message: String, file: String?, line: Int32?, function: String?)
    func xwarning(_ message: String, file: String?, line: Int32?, function: String?)
    func xerror(_ message: String, file: String?, line: Int32?, function: String?)
}

public extension LoggableNode {
    func debug(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        xdebug(message, file: file, line: line, function: function)
    }
    func info(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        xinfo(message, file: file, line: line, function: function)
    }
    func warning(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        xwarning(message, file: file, line: line, function: function)
    }
    func error(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {
        xerror(message, file: file, line: line, function: function)
    }
}

public protocol Loggable: LoggableNode {
    var networking: LoggableNode! { get set }
}

public var log: Loggable!
