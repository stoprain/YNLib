//
//  Networking.swift
//  YNLib
//
//  Created by stoprain on 9/4/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

import ReactiveSwift
import Result

public protocol ErrorHandlerSet {
    var handlers: [ErrorCode: Networking.ErrorHandler] { get }
    var interrupt: Bool { get }
}

public struct EmptyErrorHandlerSet: ErrorHandlerSet {
    
    public var interrupt: Bool = true
    
    public var handlers: [ErrorCode: Networking.ErrorHandler] {
        return [:]
    }
    
    public init() {
        
    }

}

public struct NormalErrorHandlerSet: ErrorHandlerSet {
    
    public var interrupt: Bool = false
    
    var hs: [ErrorCode : Networking.ErrorHandler]
    public var handlers: [ErrorCode: Networking.ErrorHandler] {
        var ehs = EmptyErrorHandlerSet().handlers
        for k in self.hs.keys {
            ehs[k] = self.hs[k]
        }
        return ehs
    }
    
    public init(hs: [ErrorCode: Networking.ErrorHandler]) {
        self.hs = hs
    }
    
    subscript(key: ErrorCode) -> Networking.ErrorHandler? {
        return hs[key]
    }
    
}

public typealias ErrorCode = Int

class IgnoreCertificateHandler: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential);
        } else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, credential)
        }
    }
    
}

public class Networking {
    
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
    
    public typealias Request = (req: Int, request: URLRequest)
    
    public init () {
        
    }
    
    static let shared = Networking()
    private static var session = URLSession.shared
    private static var ephemeralSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    private static var ignoreCertificateHandler: IgnoreCertificateHandler?
    open static var diskCache = NetworkingDiskCache()
    
    //just for dev
    class public func ignoreCertificate() {
        Networking.ignoreCertificateHandler = IgnoreCertificateHandler()
        Networking.session = URLSession(configuration: URLSessionConfiguration.default,
                                               delegate: Networking.ignoreCertificateHandler,
                                               delegateQueue: OperationQueue.main)
        Networking.ephemeralSession = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                                        delegate: Networking.ignoreCertificateHandler,
                                                        delegateQueue: OperationQueue.main)
    }
    
    public struct Error: Swift.Error, CustomStringConvertible {
        
        public var code: ErrorCode
        public var req: Int
        public var message: String
        
        public init(code: ErrorCode, req: Int, message: String = "") {
            self.code = code
            self.req = req
            self.message = message
        }
        
        public var description: String {
            return "req \(self.req), code \(self.code)): \(self.message)"
        }
        
        public static var customErrorHandler: ErrorHandler = { (e) in }
        public static var serverErrorHandler: ErrorHandler = { (e) in }
        public static var systemErrorHandler: ErrorHandler = { (e) in }
        public static var HTTPErrorHandler: ErrorHandler = { (e) in }
        
        
        func canHandleError() -> Bool {
            if CustomizeErrorCode.all.contains(self.code) {
                Error.customErrorHandler(self)
                return true
            }
            if ServerErrorCode.all.contains(self.code) {
                Error.serverErrorHandler(self)
                return true
            }
            if SystemErrorCode.all.contains(self.code) {
                Error.systemErrorHandler(self)
                return true
            }
            if HTTPErrorCode.all.contains(self.code) {
                Error.HTTPErrorHandler(self)
                return true
            }
            return true
        }
    }
    
    public typealias ErrorHandler = (_ e: Networking.Error)->()
    
    public struct ErrorKind {

        public static var Customize = CustomizeErrorCode()
        public static var Server = ServerErrorCode()
        public static var System = SystemErrorCode()
        public static var HTTP = HTTPErrorCode()
        
        //TODO print the error name
    }
    
    public struct CustomizeErrorCode: Loopable {
        public static var all = [ErrorCode]()
        
        public let Unknown = -10001
        public let Timeout = -10002
        public let UnsupportedResponse = -10003
        public let UnsupportedHTTPStatusCode = -10004
        public let UnsupportedServerErrorCode = -10005
        
        public let CannotParseDataToString = -20001
        public let CannotParseDataToModel = -20002
        public let UnsupportedModel = -20003
    }
    
    public struct ServerErrorCode: Loopable {
        public static var all = [ErrorCode]()
        
    }
    
    public struct SystemErrorCode: Loopable {
        public static var all = [ErrorCode]()
        
        public let OperationCouldNotBeCompleted = 1
        public let TimedOut = -1001
        public let NotConnectedToInternet = -1009
        public let CannotConnectToHost = -1004
    }
    
    public struct HTTPErrorCode: Loopable {
        public static var all = [ErrorCode]()
        
        public let Unauthorized = 401
        public let NotFound = 404
        public let InternalServerError = 500
    }
    
    public static func setupErrorCodes(custom: [Int], server: [Int], system: [Int], http: [Int]) {
        CustomizeErrorCode.all = ErrorKind.Customize.allValues() + custom
        ServerErrorCode.all = ErrorKind.Server.allValues() + server
        SystemErrorCode.all = ErrorKind.System.allValues() + system
        HTTPErrorCode.all = ErrorKind.HTTP.allValues() + http
    }
    
    public class ErrorParser {
        
        class func parse(e: NSError, req: Int) -> Error {
            if SystemErrorCode.all.contains(e.code) {
                return Error(code: e.code, req: req)
            }
            return Error(code: ErrorKind.Customize.Timeout, req: req, message: e.localizedDescription)
        }
        
        public typealias CustomDataParser = (Data?, Int) -> (Error?)
        
        public static var dataParser: CustomDataParser?
        
        class func parse(r: URLResponse, req: Int) -> Error? {
            guard let res = r as? HTTPURLResponse else {
                return Error(code: Networking.ErrorKind.Customize.UnsupportedResponse, req: req)
            }
            
            if HTTPErrorCode.all.contains(res.statusCode) {
                return Error(code: res.statusCode, req: req)
            }
            
            if res.statusCode == HTTPStatusCode.ok.rawValue {
                return nil
            }
            
            return Error(code: Networking.ErrorKind.Customize.UnsupportedHTTPStatusCode, req: req)
        }
    }
    
    private class func getRawDataTask(session: URLSession, request: Request, cacheKey: String? = nil, errorHandlerSet: ErrorHandlerSet? = nil) -> SignalProducer<Data, Error> {
        let req = request.req
        log.networking.info("req \(request.req), \(request.request.curlDesc)")
        let producer = session.reactive.data(with: request.request)
            .mapError { (error) -> Error in
                return ErrorParser.parse(e: (error as AnyError).error as NSError, req: req)
            }.flatMap(FlattenStrategy.latest) { (data, response) -> SignalProducer<Data, Error> in
                if let r = response as? HTTPURLResponse {
                    log.networking.info("req \(req), code: \(r.statusCode)")
                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        log.networking.info("req \(req), data: \(string)")
                    }
                }
                if let e = ErrorParser.dataParser?(data, req) {
                    return SignalProducer(error: e)
                }
                if let e = ErrorParser.parse(r: response, req: req) {
                    log.networking.warning("\(e)")
                    return SignalProducer(error: e)
                }
                // Otherwise the data and response are valid.
                if let key = cacheKey, request.request.httpMethod == Method.GET.rawValue  {
                    Networking.diskCache.setData(data: data, key: key)
                }

                return SignalProducer(value: data)
                
            }.mapError { (error) -> Error in
                if let handlers = errorHandlerSet?.handlers, let handler = handlers[error.code] {
                    DispatchQueue.main.async {
                        handler(error)
                    }
                    return error
                }

                if let set = errorHandlerSet, set.interrupt {
                    return error
                }
                
                if error.canHandleError() {
                    return error
                }
                return Error(code: Networking.ErrorKind.Customize.Timeout, req: req)
        }
        return producer
    }
    
    public class func getEphemeralRawDataTask(request: Request, cacheKey: String? = nil, errorHandlerSet: ErrorHandlerSet? = nil) -> SignalProducer<Data, Error> {
        return self.getRawDataTask(session: Networking.ephemeralSession,
                                   request: request,
                                   cacheKey: cacheKey,
                                   errorHandlerSet: errorHandlerSet)
    }
    
    public class func getRawDataTask(request: Request, cacheKey: String? = nil, errorHandlerSet: ErrorHandlerSet? = nil) -> SignalProducer<Data, Error> {
        return self.getRawDataTask(session: Networking.session,
                                   request: request,
                                   cacheKey: cacheKey,
                                   errorHandlerSet: errorHandlerSet)
    }
    
    public class func getDataTask(request: Request, cacheKey: String? = nil, errorHandlerSet: ErrorHandlerSet? = nil) -> SignalProducer<String, Error> {
        return self.getRawDataTask(request: request, cacheKey: cacheKey, errorHandlerSet: errorHandlerSet)
            .flatMap(FlattenStrategy.latest, { (data) -> SignalProducer<String, Error> in
                guard let string = String(data: data as Data, encoding: String.Encoding.utf8) else {
                    //log.warning("\(request.URL!.absoluteString) | ServerError")
                    return SignalProducer(error: Error(code: Networking.ErrorKind.Customize.CannotParseDataToString, req: request.req))
                }
                return SignalProducer(value: string)
            })
    }
    
    public class func buildBaseRequest(apiServer: String, accessToken: String?, authorizationTypeKey: String?, resource: String, method: Method = .GET, body: Any? = nil) -> Request {
        let req = AsyncOperation.getSeqSeed()
        let request = URLRequest.createRequest(apiServer, token: accessToken, tokenType: authorizationTypeKey,
                                               resource: resource, method: method.rawValue, body: body)
        return (req, request)

    }

}

public protocol Loopable {
    func allValues() -> [ErrorCode]
    func allProperties() throws -> [String: Any]
}

private var xoAssociationKey = "xoAssociationKey"

public extension Loopable {
    
    func allValues() -> [ErrorCode] {
        var values = [ErrorCode]()
        do {
            if let all = try self.allProperties() as? [String: ErrorCode] {
                for v in all.values {
                    values.append(v)
                }
            }
        } catch {}
        return values
    }

    func allProperties() throws -> [String: Any] {
        
        var result: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            
            result[property] = value
        }
        
        return result
    }
    
}

