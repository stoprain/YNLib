//
//  CoreDataHelper.swift
//  YNLib
//
//  Created by stoprain on 10/8/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import CoreData

@objc
open class CoreDataHelper: NSObject {
    
    fileprivate class func getEntityName<T: NSManagedObject>(_ entityClass: T.Type) -> String {
        let nameSpaceClassName = NSStringFromClass(T)
        let className = nameSpaceClassName.components(separatedBy: ".").last! as String
        return className
    }
    
    open class func createEntityForClass<T: NSManagedObject>(_ entityClass: T.Type,
        context: NSManagedObjectContext) -> T {
            return NSEntityDescription.insertNewObject(forEntityName: self.getEntityName(entityClass),
                into: context) as! T
    }
    
    open class func getManagedObjects<T: NSManagedObject>(_ entityClass: T.Type, context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil, fetchOffset: Int? = nil, fetchLimit: Int? = nil) -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.getEntityName(entityClass))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let offset = fetchOffset, offset >= 0 {
            request.fetchOffset = offset
        }
        if let limit = fetchLimit, limit >= 0 {
            request.fetchLimit = limit
        }
        do {
            let result = try context.fetch(request)
            return result as! [T]
        } catch {
            debugPrint("Failed to getManagedObjects")
        }
        return [T]()
    }
    
    open class func countManagedObjects<T: NSManagedObject>(_ entityClass: T.Type, context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.getEntityName(entityClass))
        request.predicate = predicate
        do {
            let result = try context.count(for: request)
            return result
        } catch {
            debugPrint("Failed to countManagedObjects")
        }
        return 0
    }
    
    open class func deleteAllManagedObjects<T: NSManagedObject>(_ entityClass: T.Type, context: NSManagedObjectContext) {
        let objects = self.getManagedObjects(entityClass, context: context)
        for o in objects {
            context.delete(o)
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
        self.parent?.performAndWait({ () -> Void in
            self.parent?.saveIgnoreError()
        })
    }
}

public extension NSManagedObject {
    public func isValid() -> Bool {
        if self.managedObjectContext == nil {
            return false
        }
        
        do {
            if let _ = try self.managedObjectContext?.existingObject(with: self.objectID) {
                return true
            }
        } catch {
            return false
        }

        return self.managedObjectContext != nil && !self.isDeleted
    }
}

