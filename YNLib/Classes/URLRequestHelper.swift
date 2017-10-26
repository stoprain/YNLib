//
//  URLRequestHelper.swift
//  YNLib
//
//  Created by stoprain on 3/10/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


public extension URLRequest {
    
    public enum LogStyle {
        case curl
        case httpie
    }
    
    public static var logStyle: LogStyle = .curl
    
    public var curlDesc : String {
        if URLRequest.logStyle == .httpie {
            var s = ""
            if let url = self.url?.absoluteString {
                s += "http \(self.httpMethod!) '\(url)'"
            }
            if self.allHTTPHeaderFields?.count > 0 {
                for (key, value) in self.allHTTPHeaderFields! {
                    s += " '\(key):\(value)'"
                }
            }
            if let d = self.httpBody {
                if let t = NSString(data: d, encoding: String.Encoding.utf8.rawValue) {
                    s += " body='\(t)'"
                }
            }
            return s
        }
        var s = ""
        if let url = self.url?.absoluteString {
            s += "curl -i '\(url)' -X \(self.httpMethod!)"
        }
        if self.allHTTPHeaderFields?.count > 0 {
            for (key, value) in self.allHTTPHeaderFields! {
                s += " -H '\(key)':'\(value)'"
            }
        }
        if let d = self.httpBody {
            if let t = NSString(data: d, encoding: String.Encoding.utf8.rawValue) {
                s += " -d '\(t)'"
            }
        }
        return s
    }
    
    static func createRequest(_ server: String, token: String?, tokenType: String?,
                              resource: String, method: String, body: Any? = nil) -> URLRequest {
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: .urlQueryAllowed)
        characterSet.removeCharacters(in: "+")
        let s = resource.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!
        var request = URLRequest(url: URL(string: server+s)!)
        request.httpMethod = method
        request.timeoutInterval = 30
        if let t = token, let _ = tokenType {
            request.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
        }
        if let b = body {
            if b is Data {
                request.httpBody = b as? Data
            } else {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: b, options: JSONSerialization.WritingOptions.prettyPrinted)
                } catch {
                    print("Failed to build requeset \(resource)")
                }
            }
        }
        return request
    }
    
}
