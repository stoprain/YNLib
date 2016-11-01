//
//  SharedDataManager.swift
//  Groubum
//
//  Created by stoprain on 1/6/15.
//  Copyright (c) 2015 yunio. All rights reserved.
//

import Objective_LevelDB

open class SharedDataKey<T:Any> {
    open let _key: String
    
    public init(_ key: String) {
        self._key = key
    }
    
    open func set(_ v: T) {
        guard let vv = v as? AnyObject else {
            assert(false, "SharedDataManager: Faile to convert \(v) to AnyObject")
            return
        }
        SharedDataManager.setObject(vv, key: _key)
    }
    
    open func get() -> T? {
        return SharedDataManager.objectForKey(_key) as? T
    }
    
    open func remove() {
        SharedDataManager.removeObjectForKey(_key)
    }
    
}

@objc
open class SharedDataManager: NSObject {
    
    static let ldb: LevelDB = LevelDB.databaseInLibrary(withName: "shared.ldb") as! LevelDB
    
//    override class func initialize() {
//        
//    }
    
    open class func objectForKey(_ key: String) -> AnyObject? {
        return ldb.object(forKey: key) as AnyObject?
    }
    
    open class func objectForPrefix(_ prefix: String, key: String) -> AnyObject? {
        return ldb.object(forKey: prefix+key) as AnyObject?
    }
    
    open class func setObject(_ object: AnyObject, key: String) {
        ldb.setObject(object, forKey: key)
    }
    
    open class func setObject(_ object: AnyObject, prefix: String, key: String) {
        ldb.setObject(object, forKey: prefix+key)
    }
    
    open class func removeObjectForKey(_ key: String) {
        ldb.removeObject(forKey: key)
    }
    
    open class func removeObjectForPrefix(_ prefix: String, key: String) {
        ldb.removeObject(forKey: prefix+key)
    }
    
    open class func keysForPrefix(_ prefix: String, block: @escaping LevelDBKeyBlock) {
        ldb.enumerateKeysBackward(false, startingAtKey: nil, filteredBy: nil, andPrefix: prefix, using: block)
    }
    
    open class func logAllKeysAndValues() {
        ldb.enumerateKeysAndObjects { (key, value, stop) in
            let s: String = NSStringFromLevelDBKey(key)
            //println("\(s) -> \(value)")
            log.info("\(s) -> \(value)")
        }
    }
    
    
}
