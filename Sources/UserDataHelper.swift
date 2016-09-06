//
//  UserDataHelper.swift
//  TwoTripleThree
//
//  Created by stoprain on 10/30/15.
//  Copyright © 2015 yunio. All rights reserved.
//

public class UserDataHelper {
    
    private static let uploadFolderName = "upload"
    private static let downloadFolderName = "download"
    
    public static var userDataPath: String = ""
    public static var uploadPath: String = ""
    public static var downloadPath: String = ""
    
    private static let FileCount = 200
    private static let FileSize = 1024*1024*200 // 200 MB

    public class func check(userId: String) {
        userDataPath = AppSandboxHelper.cachesPath.stringByAppendingString("/\(userId)")
        self.createPath(userDataPath)
        uploadPath = userDataPath.stringByAppendingString("/\(uploadFolderName)")
        self.createPath(uploadPath)
        downloadPath = userDataPath.stringByAppendingString("/\(downloadFolderName)")
        self.createPath(downloadPath)
    }
    
    public class func clearCache(all: Bool = true) {
        let fm = NSFileManager.defaultManager()
        if all {
            do {
                try fm.removeItemAtPath(userDataPath)
            } catch let e {
                log.error("failed to clearCache: \(userDataPath) \(e)")
            }
        } else {
            do {
                let sp = try fm.contentsOfDirectoryAtPath(downloadPath)
                log.info("UserDataHelper, before \(sp.count)")
                if sp.count > FileCount {
                    var pathDateSize = [(path: String, date: NSTimeInterval, size: Int)]()
                    for p in sp {
                        let dp = downloadPath+"/"+p
                        let properties = try fm.attributesOfItemAtPath(dp)
                        let t = (properties[NSFileModificationDate] as! NSDate).timeIntervalSince1970
                        let size = (properties[NSFileSize] as! NSNumber).integerValue
                        pathDateSize.append((dp, t, size))
                    }
                    pathDateSize = pathDateSize.sort { $0.date > $1.date }
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
                            try fm.removeItemAtPath(pathDateSize[i].0)
                        }
                        let r = try fm.contentsOfDirectoryAtPath(downloadPath)
                        log.info("UserDataHelper, after \(r.count)")
                    }
                }
            } catch let e {
                log.error("failed to clearCache: \(downloadPath) \(e)")
            }
        }
    }
    
    public class func calculateCache() -> String {
        let fm = NSFileManager.defaultManager()
        var total = 0
        if let enumerator = fm.enumeratorAtPath(downloadPath) {
            for path in enumerator {
                do {
                    let fileInfo = try fm.attributesOfItemAtPath("\(downloadPath)/\(path)")
                    total += (fileInfo[NSFileSize] as! NSNumber).integerValue
                } catch let e {
                    log.error("failed to calculateCache: \(path) \(e)")
                }
            }
        }
        return FileSizeFormatter.sharedFormatter.stringFromNumber(total)!
    }
    
    private class func createPath(path: String) {
        let fm = NSFileManager.defaultManager()
        if !fm.fileExistsAtPath(path) {
            do {
                try fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                log.error("failed to create path: \(path) \(e)")
            }
        }
    }
    
}
