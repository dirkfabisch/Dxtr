
//
//  DxtrModel.swift
//  Dxtr
//
//  Created by Dirk on 19/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import CoreData


// set up the DxtrModelDelegate protocol
@objc protocol DxtrModelDelegate{
  /**
  Will be called when the underyling data model has changed
  */
  optional func modelChanged()
}

class DxtrModel : NSObject 	 {

  // this is where we declare our protocol
  var delegate:DxtrModelDelegate?
  
  class var sharedInstance : DxtrModel {
    struct Singleton {
      static let instance : DxtrModel = DxtrModel()
    }
    return Singleton.instance
  }
  
  override init () {
    super.init()
    // Watch Scanning
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addNewBGReading:"), name: TDNewValueNotification, object: nil)
  }
  
  var managedObjectContext : NSManagedObjectContext?
  
  func saveContext () {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error), \(error!.userInfo)")
        abort()
      } 
    }
    //  inform delegate the model changed
    delegate?.modelChanged!()
  }

  
  /**
  When ever we get a new reading from the transmitter create a new BG reading and invlidate the view for an update
  sends to the delegate a model changed
  
  :param: notification NSNotification
  */
  func addNewBGReading(notification: NSNotification) {
    logger.verbose("New transitter reading")
    // extract transmitter object
    let td = notification.object as! TransmitterData
    // create new BG Reading
    let reading = BGReading(managedObjectContext: managedObjectContext!, timeStamp: td.timeStamp!.doubleValue, rawData: td.rawData!.doubleValue)
    DxtrModel.sharedInstance.saveContext()
    
    // Upload to Nightscout
    NightscoutUploader.sharedInstance.uploadReading(reading)
  }
  
}
