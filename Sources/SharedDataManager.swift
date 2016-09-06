//
//  SharedDataManager.swift
//  Groubum
//
//  Created by stoprain on 1/6/15.
//  Copyright (c) 2015 yunio. All rights reserved.
//

import Objective_LevelDB

public class SharedDataKey<T:Any> {
    public let _key: String
    
    public init(_ key: String) {
        self._key = key
    }
    
    public func set(v: T) {
        guard let vv = v as? AnyObject else {
            assert(false, "SharedDataManager: Faile to convert \(v) to AnyObject")
            return
        }
        SharedDataManager.setObject(vv, key: _key)
    }
    
    public func get() -> T? {
        return SharedDataManager.objectForKey(_key) as? T
    }
    
    public func remove() {
        SharedDataManager.removeObjectForKey(_key)
    }
    
}

@objc
public class SharedDataManager: NSObject {
    
    static let ldb: LevelDB = LevelDB.databaseInLibraryWithName("shared.ldb") as! LevelDB
    
//    override class func initialize() {
//        
//    }
    
    public class func objectForKey(key: String) -> AnyObject? {
        return ldb.objectForKey(key)
    }
    
    public class func objectForPrefix(prefix: String, key: String) -> AnyObject? {
        return ldb.objectForKey(prefix+key)
    }
    
    public class func setObject(object: AnyObject, key: String) {
        ldb.setObject(object, forKey: key)
    }
    
    public class func setObject(object: AnyObject, prefix: String, key: String) {
        ldb.setObject(object, forKey: prefix+key)
    }
    
    public class func removeObjectForKey(key: String) {
        ldb.removeObjectForKey(key)
    }
    
    public class func removeObjectForPrefix(prefix: String, key: String) {
        ldb.removeObjectForKey(prefix+key)
    }
    
    public class func keysForPrefix(prefix: String, block: LevelDBKeyBlock) {
        ldb.enumerateKeysBackward(false, startingAtKey: nil, filteredByPredicate: nil, andPrefix: prefix, usingBlock: block)
    }
    
    public class func logAllKeysAndValues() {
        ldb.enumerateKeysAndObjectsUsingBlock { (key: UnsafeMutablePointer<LevelDBKey>, value: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            let s: String = NSStringFromLevelDBKey(key)
            //println("\(s) -> \(value)")
            log.info("\(s) -> \(value)")
        }
    }
    
    
}