//
//  UserDataHelper.swift
//  TwoTripleThree
//
//  Created by stoprain on 10/30/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

public class UserDataHelper {
    
    fileprivate static let uploadFolderName = "upload"
    fileprivate static let downloadFolderName = "download"
    
    public static var userDataPath: String = ""
    public static var uploadPath: String = ""
    public static var downloadPath: String = ""
    
    fileprivate static let FileCount = 200
    fileprivate static let FileSize = 1024*1024*200 // 200 MB

    open class func check(_ userId: String) {
        userDataPath = AppSandboxHelper.cachesPath + "/\(userId)"
        self.createPath(userDataPath)
        uploadPath = userDataPath + "/\(uploadFolderName)"
        self.createPath(uploadPath)
        downloadPath = userDataPath + "/\(downloadFolderName)"
        self.createPath(downloadPath)
    }
    
    open class func clearCache(_ all: Bool = true) {
        let fm = FileManager.default
        if all {
            do {
                try fm.removeItem(atPath: userDataPath)
            } catch let e {
                log.error("failed to clearCache: \(userDataPath) \(e)")
            }
        } else {
            do {
                let sp = try fm.contentsOfDirectory(atPath: downloadPath)
                log.info("UserDataHelper, before \(sp.count)")
                if sp.count > FileCount {
                    var pathDateSize = [(path: String, date: TimeInterval, size: Int)]()
                    for p in sp {
                        let dp = downloadPath+"/"+p
                        let properties = try fm.attributesOfItem(atPath: dp)
                        let t = (properties[FileAttributeKey.modificationDate] as! Date).timeIntervalSince1970
                        let size = (properties[FileAttributeKey.size] as! NSNumber).intValue
                        pathDateSize.append((dp, t, size))
                    }
                    pathDateSize = pathDateSize.sorted { $0.date > $1.date }
                    var size = 0
                    var index = -1
                    for i in pathDateSize {
                        index += 1
                        size += i.size
                        if size > FileSize {
                            break
                        }
                    }
                    
                    if index >= 0 && index < pathDateSize.count {
                        for i in index..<pathDateSize.count {
                            try fm.removeItem(atPath: pathDateSize[i].0)
                        }
                        let r = try fm.contentsOfDirectory(atPath: downloadPath)
                        log.info("UserDataHelper, after \(r.count)")
                    }
                }
            } catch let e {
                log.error("failed to clearCache: \(downloadPath) \(e)")
            }
        }
    }
    
    open class func calculateCache() -> String {
        let fm = FileManager.default
        var total = 0
        if let enumerator = fm.enumerator(atPath: downloadPath) {
            for path in enumerator {
                do {
                    let fileInfo = try fm.attributesOfItem(atPath: "\(downloadPath)/\(path)")
                    total += (fileInfo[FileAttributeKey.size] as! NSNumber).intValue
                } catch let e {
                    log.error("failed to calculateCache: \(path) \(e)")
                }
            }
        }
        return FileSizeFormatter.sharedFormatter.string(from: NSNumber(value: total))!
    }
    
    fileprivate class func createPath(_ path: String) {
        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                log.error("failed to create path: \(path) \(e)")
            }
        }
    }
    
}
