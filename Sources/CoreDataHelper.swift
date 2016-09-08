//
//  CoreDataHelper.swift
//  YNLib
//
//  Created by stoprain on 10/8/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import CoreData

@objc
public class CoreDataHelper: NSObject {
    
    private class func getEntityName<T: NSManagedObject>(entityClass: T.Type) -> String {
        let nameSpaceClassName = NSStringFromClass(T)
        let className = nameSpaceClassName.componentsSeparatedByString(".").last! as String
        return className
    }
    
    public class func createEntityForClass<T: NSManagedObject>(entityClass: T.Type,
        context: NSManagedObjectContext) -> T {
            return NSEntityDescription.insertNewObjectForEntityForName(self.getEntityName(entityClass),
                inManagedObjectContext: context) as! T
    }
    
    public class func getManagedObjects<T: NSManagedObject>(entityClass: T.Type, context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil, fetchOffset: Int? = nil, fetchLimit: Int? = nil) -> [T] {
        let request = NSFetchRequest(entityName: self.getEntityName(entityClass))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let offset = fetchOffset where offset >= 0 {
            request.fetchOffset = offset
        }
        if let limit = fetchLimit where limit >= 0 {
            request.fetchLimit = limit
        }
        do {
            let result = try context.executeFetchRequest(request)
            return result as! [T]
        } catch {
            debugPrint("Failed to getManagedObjects")
        }
        return [T]()
    }
    
    public class func countManagedObjects<T: NSManagedObject>(entityClass: T.Type, context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int? {
        let request = NSFetchRequest(entityName: self.getEntityName(entityClass))
        request.predicate = predicate
        do {
            let result = try context.countForFetchRequest(request)
            return result
        } catch {
            debugPrint("Failed to countManagedObjects")
        }
        return nil
    }
    
    public class func deleteAllManagedObjects<T: NSManagedObject>(entityClass: T.Type, context: NSManagedObjectContext) {
        let objects = self.getManagedObjects(entityClass, context: context)
        for o in objects {
            context.deleteObject(o)
        }
    }

}

public extension NSManagedObjectContext {
    func saveIgnoreError() {
        do {
            try self.save()
        } catch {
        }
    }
    
    func saveIgnoreErrorWithParentContextAndWait() {
        self.saveIgnoreError()
        self.parentContext?.performBlockAndWait({ () -> Void in
            self.parentContext?.saveIgnoreError()
        })
    }
}

public extension NSManagedObject {
    public func isValid() -> Bool {
        if self.managedObjectContext == nil {
            return false
        }
        
        do {
            if let _ = try self.managedObjectContext?.existingObjectWithID(self.objectID) {
                return true
            }
        } catch {
            return false
        }

        return self.managedObjectContext != nil && !self.deleted
    }
}

