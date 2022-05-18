//
//  CoreDataManager.swift
//  YNLib
//
//  Created by stoprain on 10/8/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

import CoreData

@objc
open class CoreDataManager: NSObject {
    
    open var modelName = "Model"
    
    /// create in memory db
    public var isTestMode = false
    
    open static let sharedManager = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        if self.isTestMode {
            return NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
        }
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(self.modelName).sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        let optionsDictionary = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        let storeType = self.isTestMode ? NSInMemoryStoreType : NSSQLiteStoreType
        do {
            try coordinator!.addPersistentStore(ofType: storeType, configurationName: nil, at: url, options: nil)
        } catch {
            do {
                try coordinator!.addPersistentStore(ofType: storeType, configurationName: nil, at: url, options: optionsDictionary)
            } catch {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    do {
                        try coordinator!.addPersistentStore(ofType: storeType, configurationName: nil, at: url, options: nil)
                    } catch {
                        // Report any error we got.
                        var dict = [String: AnyObject]()
                        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                        dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                        
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
    open lazy var backgroundContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()
    
    // for main queue read task only
    open lazy var mainContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var mainContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        mainContext.parent = self.backgroundContext
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(backgroundContextDidSave(_:)),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: nil)
        
        return mainContext
        }()
    
    // in memory content for temp usage only
    open lazy var inMemoryMainContext: NSManagedObjectContext? = {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: self.isTestMode ? Bundle.allBundles : nil) else {
            return nil
        }
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {}
        
        return nil
    }()
    
    @objc
    fileprivate func backgroundContextDidSave(_ notification: Notification) {
        DispatchQueue.main.async(execute: { () -> Void in
            if let context = self.mainContext {
                context.performAndWait({ () -> Void in
                    context.mergeChanges(fromContextDidSave: notification)
                })
            }
        })
    }

}
