//
//  SharedDataManager.swift
//  Groubum
//
//  Created by stoprain on 1/6/15.
//  Copyright (c) 2015 yunio. All rights reserved.
//

import Objective_LevelDB

public enum SharedDataKey : String {
    case Setting = "setting_"
}

let ldb: LevelDB = LevelDB.databaseInLibraryWithName("shared.ldb") as! LevelDB

public class SharedDataManager: NSObject {
    
//    override class func initialize() {
//        
//    }
    
    public class func objectForKey(key: String) -> AnyObject? {
        return ldb.objectForKey(key)
    }
    
    public class func objectForPrefix(prefix: SharedDataKey, key: String) -> AnyObject? {
        return ldb.objectForKey(prefix.rawValue+key)
    }
    
    public class func setObject(object: AnyObject, key: String) {
        ldb.setObject(object, forKey: key)
    }
    
    public class func setObject(object: AnyObject, prefix: SharedDataKey, key: String) {
        ldb.setObject(object, forKey: prefix.rawValue+key)
    }
    
    public class func removeObjectForKey(key: String) {
        ldb.removeObjectForKey(key)
    }
    
    public class func removeObjectForPrefix(prefix: SharedDataKey, key: String) {
        ldb.removeObjectForKey(prefix.rawValue+key)
    }
    
    public class func keysForPrefix(prefix: SharedDataKey, block: LevelDBKeyBlock) {
        ldb.enumerateKeysBackward(false, startingAtKey: nil, filteredByPredicate: nil, andPrefix: prefix.rawValue, usingBlock: block)
    }
    
    public class func logAllKeysAndValues() {
        ldb.enumerateKeysAndObjectsUsingBlock { (key: UnsafeMutablePointer<LevelDBKey>, value: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            let s: String = NSStringFromLevelDBKey(key)
            //println("\(s) -> \(value)")
            log.info("\(s) -> \(value)")
        }
    }
    
    
}