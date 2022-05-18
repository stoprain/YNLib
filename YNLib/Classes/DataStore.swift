//
//  DataStore.swift
//  YNLib
//
//  Created by stoprain on 9/4/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

import CoreData

public class DataStore {
    
    public static let Async = AsyncDataStore.self
    
    public class func contextForThread() -> NSManagedObjectContext? {
        if Thread.current == Thread.main {
            return CoreDataManager.sharedManager.mainContext
        }
        return CoreDataManager.sharedManager.backgroundContext
    }
    
    public class func performBlock(_ block: @escaping (_ context: NSManagedObjectContext) -> ()) {
        if let context = contextForThread() {
            context.performDataStoreBlock(self, block: {
                block(context)
            })
        }
    }
    
}

public class AsyncDataStore: DataStore {
    
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
