//
//  Networking.swift
//  YNLib
//
//  Created by stoprain on 27/03/2018.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

open class NetworkingDiskCache {
    
    private var _basePath = ""
    
    open var basePath: String {
        set {
            _basePath = basePath
            self.createFolder()
        }
        get {
            if _basePath.isEmpty {
                _basePath = AppSandboxHelper.cachesPath + "/NetworkingDiskCache"
                self.createFolder()
            }
            return _basePath
        }
    }
    
    private func createFolder() {
        if !FileManager.default.fileExists(atPath: _basePath) {
            try? FileManager.default.createDirectory(atPath: _basePath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    open func path(key: String) -> String {
        if let p = key.data(using: .utf8)?.md5HexString() {
            return self.basePath + "/" + p
        }
        return self.basePath + "/" + NSUUID().uuidString
    }
    
    open func setData(data: Data, key: String) {
        let path = self.path(key: key)
        let url = URL(fileURLWithPath: path)
        try? data.write(to: url)
    }
    
    open func fetchData(key: String) -> Data? {
        let path = self.path(key: key)
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
    
    open func removeData(key: String) {
        let path = self.path(key: key)
        try? FileManager.default.removeItem(atPath: path)
    }

}
