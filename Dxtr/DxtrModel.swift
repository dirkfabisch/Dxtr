//
//  DxtrModel.swift
//  Dxtr
//
//  Created by Dirk on 19/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import CoreData

class DxtrModel 	 {
  
  class var sharedInstance : DxtrModel {
    struct Singleton {
      static let instance : DxtrModel = DxtrModel()
    }
    return Singleton.instance
  }
  
  var context:NSManagedObjectContext?
  let psc:NSPersistentStoreCoordinator?
  let model:NSManagedObjectModel!

  
  // MARK: - Core Data stack
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource("dxtrDBModel", withExtension: "momd")
    return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("dxtr.sqlite")
    logger.verbose("Database Pgath: \(url)")
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
      coordinator = nil
      // Report any error we got.
      let dict = NSMutableDictionary()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
      error = NSError(domain: "base68.com", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext()
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  init() {
    context = managedObjectContext!
    psc = persistentStoreCoordinator!
    model = managedObjectModel
  }
  
  convenience init (moc: NSManagedObjectContext) {
    self.init()
    self.context = moc
  }
  
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.base68.testDB" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1] as NSURL
    }()
  
  func saveContext() {
    var error: NSError?
    if (context?.save(&error) != nil) {
      logger.error("Couldn't save. Error: \(error)")
    } else  {
      logger.verbose("Save!!!")
    }
  }
  
  
}
