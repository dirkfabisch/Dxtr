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
  
  var managedObjectContext : NSManagedObjectContext?
  
  init() {
    // Watch Scanning
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("btScanning:"), name: BLEDiscoveryScanningNotification, object: nil)
  }
  
  func saveContext () {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error), \(error!.userInfo)")
        abort()
      } else {
        logger.info("data saved !")
      }
    }
  }

  
}
