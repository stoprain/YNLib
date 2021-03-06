//
//  DataStore.swift
//  YNLib
//
//  Created by stoprain on 9/4/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CoreData

open class DataStore {
    
    open static let Async = AsyncDataStore.self
    
    open class func contextForThread() -> NSManagedObjectContext? {
        if Thread.current == Thread.main {
            return CoreDataManager.sharedManager.mainContext
        }
        return CoreDataManager.sharedManager.backgroundContext
    }
    
    open class func performBlock(_ block: @escaping (_ context: NSManagedObjectContext) -> ()) {
        if let context = contextForThread() {
            context.performDataStoreBlock(self, block: {
                block(context)
            })
        }
    }
    
}

open class AsyncDataStore: DataStore {
    
}

public extension NSManagedObjectContext {
    
    public func performDataStoreBlock(_ aClass: AnyClass, block: @escaping () -> ()) {
        if aClass is AsyncDataStore.Type {
            self.perform({
                block()
            })
        } else {
            self.performAndWait({
                block()
            })
        }
    }
    
}
