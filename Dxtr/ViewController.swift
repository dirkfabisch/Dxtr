//
//  ViewController.swift
//  Dxtr
//
//  Created by Dirk on 11/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  // set by AppDelegate on application startup
  var managedObjectContext: NSManagedObjectContext?
  
  @IBOutlet weak var btConnectionState: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Watch Bluetooth connection
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
    // Watch Scanning
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("btScanning:"), name: BLEDiscoveryScanningNotification, object: nil)
    
    
    // Start the Bluetooth discovery process
    btDiscoverySharedInstance
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  /**
  Display of the connection state
  
  :param: notification notification description
  */
  func connectionChanged(notification: NSNotification) {
    // Connection status changed. Indicate on GUI.
    let userInfo = notification.userInfo as [String: Bool]
    
    dispatch_async(dispatch_get_main_queue(), {
      // Set image based on connection status
      if let isConnected: Bool = userInfo["isConnected"] {
        let notification = UILocalNotification()
        if isConnected {
          self.btConnectionState.text = "Connected"
          //                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Connected")
          notification.alertBody = "Wixel Connected"
          // Send current slider position
          //                    self.sendPosition(UInt8( self.positionSlider.value))
        } else {
          self.btConnectionState.text = "disconected"
          self.showWaitOverlayWithText("Connecting")
          notification.alertBody = "Wixel Disconnected"
          //    image                self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Disconnected")
        }
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
      }
    })
  }
  /**
  Display of the connection state
  
  :param: notification notification description
  */
  func btScanning(notification: NSNotification) {
    // Connection status changed. Indicate on GUI.
    let userInfo = notification.userInfo as [String: Bool]
    
    dispatch_async(dispatch_get_main_queue(), {
      // Set image based on connection status
      if let isScanning: Bool = userInfo["isScanning"] {
        if isScanning {
          logger.verbose("display animation")
          self.showWaitOverlayWithText("Connecting")
        } else {
          logger.verbose("end animation")
          SwiftOverlays.removeAllOverlaysFromView(self.view)
        }
      }
    })
  }
 
}

