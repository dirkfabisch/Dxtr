//
//  MasterViewController.swift
//  Dxtr
//
//  Created by Dirk on 11/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController {
  
  // set by AppDelegate on application startup
  var managedObjectContext: NSManagedObjectContext?
  
  @IBOutlet weak var btConnectionState: UILabel!
  @IBOutlet weak var startSensorButton: UIButton!
  @IBOutlet weak var stopSensorButton: UIButton!
  @IBOutlet weak var addDoubleCalibrationButton: UIButton!
  @IBOutlet weak var addCalibration: UIButton!
  @IBOutlet weak var logWindow: UITextView!
  
  // all possible states during start of dxtr
  enum proccessState {
    case sensorStopped
    case sensorStarted
    case sensorWarmup
    case firstReading
    case secondReading
    case doubleCalibrated
    case disconected
  }
  
  // initial state of the views
  var currentState : proccessState = .sensorStopped
  // saved state if wixel is disconected
  var savedState : proccessState = .sensorStopped
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Watch Bluetooth connection
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
    // Watch Scanning
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("btScanning:"), name: BLEDiscoveryScanningNotification, object: nil)
    
    setProcessState()
    
    // Start the Bluetooth discovery process
    btDiscoverySharedInstance
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /**
  set the right state for visible buttons
  */
  func setProcessState () {
    switch currentState {
    case .sensorStopped:
      startSensorButton.enabled = true
      stopSensorButton.enabled = false
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
    case .sensorStarted:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
    case .sensorWarmup:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
    case .firstReading:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
    case .secondReading:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = true
      addCalibration.enabled = false
    case .doubleCalibrated:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = true
    case .disconected:
      startSensorButton.enabled = false
      stopSensorButton.enabled = false
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
    }
  }
  
  
  //MARK: Seque control
  
  override func prepareForSegue(segue: (UIStoryboardSegue!),
    sender: AnyObject!) {
      let nav = segue.destinationViewController as UINavigationController
      
      switch segue.identifier! {
      case "startSensorSegue":
        let startSensorView = nav.topViewController as StartSensorViewController
        startSensorView.managedObjectContext = managedObjectContext
        startSensorView.didCancel = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
        }
        startSensorView.didFinish = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
          self.currentState = .sensorStarted
          self.setProcessState()
        }
      default:
        logger.error("wrong segue.identifier \(segue.identifier)")
      }
  }

  
  
  //MARK: Notifications
  
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
          notification.alertBody = "Wixel Connected"
          self.currentState = self.savedState
        } else {
          self.btConnectionState.text = "disconected"
          self.showWaitOverlayWithText("Connecting")
          notification.alertBody = "Wixel Disconnected"
          self.savedState = self.currentState
          self.currentState = .disconected
        }
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        self.setProcessState()
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

