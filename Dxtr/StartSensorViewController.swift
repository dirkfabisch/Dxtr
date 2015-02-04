//
//  StartSensorViewController.swift
//  Dxtr
//
//  Created by Dirk on 04/02/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class StartSensorViewController : UIViewController {

  // custom types for "Cancel" and "Finish" delegates
  typealias DidCancelDelegate = (StartSensorViewController) -> ()
  typealias DidFinishDelegate = (StartSensorViewController) -> ()
  var didCancel: DidCancelDelegate?
  var didFinish: DidFinishDelegate?
  
  var managedObjectContext : NSManagedObjectContext?
  

  
  //MARK: - Exit functions
  // "Cancel" action notifies "Cancel" delegate

  @IBAction func cancel(sender: AnyObject) {
    
    // notify delegate (master list scene view controller)
    self.didCancel!(self)
  }
  
  // "Done" action notifies "Finish" delegate
  @IBAction func done(sender: AnyObject) {
    // Create a new Sensor object and start the sensor
    // TODO: Create Timer for the waiting
    Sensor(managedObjectContext: managedObjectContext!)
    // notify delegate (master list scene view controller)
    self.didFinish!(self)
  }
}
