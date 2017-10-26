//
//  NetworkingTest.swift
//  YNLib
//
//  Created by stoprain on 04/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import YNLib

class Testslog: TestslogNode, Loggable {
    var networking: LoggableNode!
    var zimsdk: LoggableNode!
    var analytics: LoggableNode!
    var emMessage: LoggableNode!
    override init(module: String) {
        super.init(module: module)
        self.networking = TestslogNode(module: "networking")
        self.zimsdk = TestslogNode(module: "zimsdk")
        self.analytics = TestslogNode(module: "analytics")
        self.emMessage = TestslogNode(module: "EMMessage")
    }
}

class TestslogNode: LoggableNode {
    var module = ""
    init(module: String) {
        self.module = module
    }
    func xdebug(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {print(message)}
    func xinfo(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {print(message)}
    func xwarning(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {print(message)}
    func xerror(_ message: String, file: String? = #file, line: Int32? = #line, function: String? = #function) {print(message)}
}


/* 自定义错误码
 
 ServerErrorCode
 CustomizeErrorCode
 SystemErrorCode
 HTTPErrorCode
 
 */

public struct TestServerErrorCode: Loopable {
    let InternalSystemError = -99999
    let SourceInvalid = 20001
}

extension Networking.ErrorKind {
    public static var TestServer = TestServerErrorCode()
}

extension Networking {
    
    /* 自定义请求
     
     */
    
    class func buildRequest(resource: String, method: Method = .GET, body: Any? = nil) -> Request {
//        guard let apiServer = Networking.apiServer, let apiSource = Networking.apiSource else {
//            fatalError("Missing networking settings")
//        }
//        let req = AsyncOperation.getSeqSeed()
//        request.setValue(apiSource, forHTTPHeaderField: sourceKey)
//        request.setValue(jsonMimeType, forHTTPHeaderField: contentTypeKey)
//        request.setValue(appVersion, forHTTPHeaderField: appVersionKey)
//        return (req, request)
        
        return Networking.buildBaseRequest(apiServer: "https://api.urdoctor.cn/1.0/",
                                           accessToken: nil, authorizationTypeKey: nil,
                                           resource: "user", method: Networking.Method.GET, body: nil)
    }
    
}

class NetworkingTest: NSObject {
    
    func run() {
        
        /* 初始化日志
         
         Loggable
         LoggableNode
         
         测试和YNLib可用日志
 
        */
        
        log = Testslog(module: "")
        
        /* 自定义错误码

         */
        Networking.setupErrorCodes(custom: [ErrorCode](),
                                   server: TestServerErrorCode().allValues(),
                                   system: [ErrorCode](),
                                   http: [ErrorCode]())
        
        /* 自定义错误解析
         
         */
        Networking.ErrorParser.dataParser = { (data, req) -> Networking.Error? in
            if let d = data, d.count > 0 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        if let code = json["code"] as? Int, let message = json["message"] as? String, code != 0 {
                            if Networking.ServerErrorCode.all.contains(code) {
                                return Networking.Error(code: code, req: req, message: message)
                            }
                            return Networking.Error(code: Networking.ErrorKind.Customize.UnsupportedServerErrorCode, req: req, message: message)
                        }
                        return nil
                    }
                } catch {
                    return Networking.Error(code: Networking.ErrorKind.Customize.CannotParseDataToModel, req: req)
                }
            }
            return nil
        }
        
        /* 自定义错误处理
         
         */
        let errorHandler = { (e: Networking.Error) in
            log.info("Networking.ErrorKind.Server.SourceInvalid error handler")
            } as Networking.ErrorHandler
        let es = [
            Networking.ErrorKind.TestServer.SourceInvalid: errorHandler
        ]
        let hs = NormalErrorHandlerSet(hs: es)
        
        // make the request
        let r = Networking.buildRequest(resource: "user")
        Networking.getDataTask(request: r, errorHandlerSet: hs).startWithResult { (result) in
            if let v = result.value {
                print("\(v)")
            } else {
                print("\(result.error.debugDescription)")
            }
        }
        
    }
    

}
