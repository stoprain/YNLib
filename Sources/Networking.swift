//
//  Networking.swift
//  YNLib
//
//  Created by stoprain on 9/4/16.
//  Copyright © 2016 yunio. All rights reserved.
//

open class Networking {
    
    public enum Method: String {
        case OPTIONS = "OPTIONS"
        case GET = "GET"
        case HEAD = "HEAD"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
        case TRACE = "TRACE"
        case CONNECT = "CONNECT"
    }
    
    public typealias Request = (req: Int, request: NSMutableURLRequest)
    
    public init () {
        
    }
    
}
