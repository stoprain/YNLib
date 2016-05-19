//
//  LogArchiverHelper.swift
//  TwoTripleThree
//
//  Created by stoprain on 5/18/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import ZipArchive

public struct LogArchiverHelper {
    
    static let DesktopServicesStore = ".DS_Store"
    
    public static func packageLogs() -> NSURL {
        let manager = NSFileManager.defaultManager()
        let zipPath = AppSandboxHelper.cachesPath + "/LogArchive.zip"
        
        do {
           try manager.removeItemAtPath(zipPath)
        } catch { }
        
        let zip = ZipArchive()
        var ret = zip.CreateZipFile2(zipPath)
        
        let logPath = AppSandboxHelper.cachesPath + "/Logs"
        if let logEnumerator = manager.enumeratorAtPath(logPath) {
            logEnumerator.skipDescendants()
            for logDate in logEnumerator {
                if let d = logDate as? String where d != DesktopServicesStore {
                    ret = zip.addFileToZip(logPath+"/"+d, newname: (d as NSString).lastPathComponent)
                }
            }
        }
        
        let dbPath = AppSandboxHelper.documentsPath
        if let dbEnumerator = manager.enumeratorAtPath(dbPath) {
            dbEnumerator.skipDescendants()
            for dbFileName in dbEnumerator {
                if let d = dbFileName as? String where d != DesktopServicesStore {
                    ret = zip.addFileToZip(dbPath+"/"+d, newname: (d as NSString).lastPathComponent)
                }
            }
        }
        
        log.info("packageLogs \(ret)")
        
        let crashLog = CrashReportWrapper.handleCrashReport()
        if crashLog != "" {
            zip.addFileToZip(crashLog, newname: (crashLog as NSString).lastPathComponent)
        }
        
        return NSURL(fileURLWithPath: zipPath)
    }

}
