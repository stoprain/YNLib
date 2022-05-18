//
//  SharedDataManager.swift
//  Groubum
//
//  Created by stoprain on 1/6/15.
//  Copyright (c) 2015 stoprain. All rights reserved.
//

import Objective_LevelDB

public class SharedDataKey<T:Any> {
    public let _key: String
    
    public init(_ key: String) {
        self._key = key
    }
    
    public func set(_ v: T) {
        SharedDataManager.setObject(v as AnyObject, key: _key)
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
    
    static let ldb: LevelDB = LevelDB.databaseInLibrary(withName: "shared.ldb") as! LevelDB
    
//    override class func initialize() {
//        
//    }
    
    public class func objectForKey(_ key: String) -> AnyObject? {
        return ldb.object(forKey: key) as AnyObject?
    }
    
    public class func objectForPrefix(_ prefix: String, key: String) -> AnyObject? {
        return ldb.object(forKey: prefix+key) as AnyObject?
    }
    
    public class func setObject(_ object: AnyObject, key: String) {
        ldb.setObject(object, forKey: key)
    }
    
    public class func setObject(_ object: AnyObject, prefix: String, key: String) {
        ldb.setObject(object, forKey: prefix+key)
    }
    
    public class func removeObjectForKey(_ key: String) {
        ldb.removeObject(forKey: key)
    }
    
    public class func removeObjectForPrefix(_ prefix: String, key: String) {
        ldb.removeObject(forKey: prefix+key)
    }
    
    public class func keysForPrefix(_ prefix: String, block: @escaping LevelDBKeyBlock) {
        ldb.enumerateKeysBackward(false, startingAtKey: nil, filteredBy: nil, andPrefix: prefix, using: block)
    }
    
    public class func logAllKeysAndValues() {
        ldb.enumerateKeysAndObjects { (key, value, stop) in
            let s: String = NSStringFromLevelDBKey(key)
            //println("\(s) -> \(value)")
            log.info("\(s) -> \(value)")
        }
    }
    
    
}
