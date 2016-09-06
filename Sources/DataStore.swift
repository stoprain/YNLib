//
//  DataStore.swift
//  YNLib
//
//  Created by stoprain on 9/4/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import CoreData

public class DataStore {
    
    public static let Async = AsyncDataStore.self
    
    public class func contextForThread() -> NSManagedObjectContext? {
        if NSThread.currentThread() == NSThread.mainThread() {
            return CoreDataManager.sharedManager.mainContext
        }
        return CoreDataManager.sharedManager.backgroundContext
    }
    
    public class func performBlock(block: (context: NSManagedObjectContext) -> ()) {
        if let context = contextForThread() {
            context.performDataStoreBlock(self, block: {
                block(context: context)
            })
        }
    }
    
}

public class AsyncDataStore: DataStore {
    
}

public extension NSManagedObjectContext {
    
    public func performDataStoreBlock(aClass: AnyClass, block: () -> ()) {
        if aClass is AsyncDataStore.Type {
            self.performBlock({
                block()
            })
        } else {
            self.performBlockAndWait({
                block()
            })
        }
    }
    
}
