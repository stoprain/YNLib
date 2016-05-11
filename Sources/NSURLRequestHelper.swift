//
//  NSURLRequestHelper.swift
//  YNLib
//
//  Created by stoprain on 3/10/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import Foundation

public extension NSURLRequest {
    
    override var description : String {
        var s = ""
        if let url = self.URL?.absoluteString {
            s += "curl -i '\(url)' -X \(self.HTTPMethod!)"
        }
        if self.allHTTPHeaderFields?.count > 0 {
            for (key, value) in self.allHTTPHeaderFields! {
                s += " -H '\(key)':'\(value)'"
            }
        }
        if let d = self.HTTPBody {
            if let t = NSString(data: d, encoding: NSUTF8StringEncoding) {
                s += " -d '\(t)'"
            }
        }
        return s
    }
    
    static func createRequest(server: String, token: String?, tokenType: String?,
        resource: String, method: String, body: AnyObject? = nil) -> NSMutableURLRequest {
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnionWithCharacterSet(.URLQueryAllowedCharacterSet())
        characterSet.removeCharactersInString("+")
        let s = resource.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
        let request = NSMutableURLRequest(URL: NSURL(string: server+s)!)
        request.HTTPMethod = method
        request.timeoutInterval = 30
        if let t = token, _ = tokenType {
            request.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
        }
        if let b = body {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(b, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                
                print("Failed to build requeset \(resource)")
            }
        }
        return request
    }
    
}
