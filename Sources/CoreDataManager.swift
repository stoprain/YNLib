//
//  CoreDataManager.swift
//  YNLib
//
//  Created by stoprain on 10/8/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import CoreData

@objc
public class CoreDataManager: NSObject {
    
    public var modelName = "Model"
    
    public static let sharedManager = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.modelName).sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        let optionsDictionary = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            do {
                try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: optionsDictionary)
            } catch {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(url)
                } catch {
                    do {
                        try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
                    } catch {
                        // Report any error we got.
                        var dict = [String: AnyObject]()
                        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                        dict[NSLocalizedFailureReasonErrorKey] = failureReason
                        
                        dict[NSUnderlyingErrorKey] = error as NSError
                        let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                        // Replace this with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                        abort()
                    }
                }
            }
        }
        
        return coordinator
        }()
    
    // for background queue read and write task
    public lazy var backgroundContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()
    
    // for main queue read task only
    public lazy var mainContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var mainContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        mainContext.parentContext = self.backgroundContext
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(backgroundContextDidSave(_:)),
            name: NSManagedObjectContextDidSaveNotification,
            object: nil)
        
        return mainContext
        }()
    
    // in memory content for temp usage only
    public lazy var inMemoryMainContext: NSManagedObjectContext? = {
        guard let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil) else {
            return nil
        }
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {}
        
        return nil
    }()
    
    @objc
    private func backgroundContextDidSave(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let context = self.mainContext {
                context.performBlockAndWait({ () -> Void in
                    context.mergeChangesFromContextDidSaveNotification(notification)
                })
            }
        })
    }

}
