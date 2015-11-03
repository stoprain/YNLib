//
//  CoreDataHelper.swift
//  YNLib
//
//  Created by stoprain on 10/8/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataHelper {
    
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
    
    public class func getManagedObjects<T: NSManagedObject>(entityClass: T.Type, context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) -> [T] {
        let request = NSFetchRequest(entityName: self.getEntityName(entityClass))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            let result = try context.executeFetchRequest(request)
            return result as! [T]
        } catch {
            debugPrint("Failed to getManagedObjects")
        }
        return [T]()
    }
    
    public class func countManagedObjects<T: NSManagedObject>(entityClass: T.Type, context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int {
        let request = NSFetchRequest(entityName: self.getEntityName(entityClass))
        request.predicate = predicate
        var error: NSError?
        let result = context.countForFetchRequest(request, error: &error)
        if error != nil {
            debugPrint("Failed to countManagedObjects")
        }
        return result
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