//
//  MasterViewController.swift
//  Dxtr
//
//  Created by Dirk on 11/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import CoreData
import SwiftOverlays

class MasterViewController: UIViewController, UIAlertViewDelegate, DxtrModelDelegate {
  
  // set by AppDelegate on application startup
  var managedObjectContext: NSManagedObjectContext?
  
  @IBOutlet weak var btConnectionState: UILabel!
  @IBOutlet weak var startSensorButton: UIButton!
  @IBOutlet weak var stopSensorButton: UIButton!
  @IBOutlet weak var addDoubleCalibrationButton: UIButton!
  @IBOutlet weak var addCalibration: UIButton!
  @IBOutlet weak var logWindow: UITextView!
  @IBOutlet weak var startSensorActivity: UIActivityIndicatorView!
  @IBOutlet weak var createReadingButton: UIButton!
  @IBOutlet weak var viewChartButton: UIButton!
  
  // all possible states during start of dxtr
  enum proccessState {
    case sensorStopped
    case sensorStarted
    case sensorWarmup
    case firstReading
    case secondReading
    case waitingCalibration
    case doubleCalibrated
    case readingLoop
    case disconnected
  }
  
  // initial state of the views
  var currentState : proccessState = .sensorStopped
  // saved state if wixel is disconnected
  var savedState : proccessState = .sensorStopped
  
  // Counter for Sensor Warmup (2h == 7200 seconds
  var sensorWarmupCounter = 7200
  
  // timer for sensor warmup
  var sensorTimer = NSTimer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Watch Bluetooth connection
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEConnectionChangedNotification, object: nil)
    // Watch Scanning
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("btScanning:"), name: BLEDiscoveryScanningNotification, object: nil)
    
    // Nightscout upload status
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("nightscoutStatus:"), name: NightscoutUploadSuccessNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("nightscoutStatus:"), name: NightscoutUploadErrorNotification, object: nil)
    
    setProcessState()
  
    logWindow.text = ""
    startSensorActivity.stopAnimating()
  
    // assign delegate
    var dxtrModel = DxtrModel.sharedInstance
    dxtrModel.delegate = self

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    // check if EULA is accepted
    let defaults = NSUserDefaults.standardUserDefaults()
    if !defaults.boolForKey(USER_SETTING_EULA_CHECKED) {
      // present EULA
      performSegueWithIdentifier("eulaSegue", sender: self)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - DxtrModelDelegate implementation
  func modelChanged() {
    logger.verbose("Model Changed")
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
      createReadingButton.enabled = false
    case .sensorStarted:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
      createReadingButton.enabled = false
    case .sensorWarmup:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
      createReadingButton.enabled = false
    case .firstReading:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
      createReadingButton.enabled = true
    case .secondReading:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
      createReadingButton.enabled = true
    case .waitingCalibration:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = true
      addCalibration.enabled = false
      createReadingButton.enabled = false
    case .doubleCalibrated:
      startSensorButton.enabled = false
      stopSensorButton.enabled = true
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = true
      createReadingButton.enabled = true
    case .readingLoop:
      startSensorButton.enabled = false
      stopSensorButton.enabled = false
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
      createReadingButton.enabled = true
    case .disconnected:
      startSensorButton.enabled = false
      stopSensorButton.enabled = false
      addDoubleCalibrationButton.enabled = false
      addCalibration.enabled = false
      createReadingButton.enabled = false
    }
  }
  
  
  //MARK: Seque control
  
  override func prepareForSegue(segue: (UIStoryboardSegue!),
    sender: AnyObject!) {
      let nav = segue.destinationViewController as! UINavigationController
      
      switch segue.identifier! {
      case "startSensorSegue":
        let startSensorView = nav.topViewController as! StartSensorViewController
        startSensorView.managedObjectContext = managedObjectContext
        startSensorView.didCancel = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
        }
        startSensorView.didFinish = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
          self.currentState = .sensorStarted
          var sensor = Sensor.currentSensor(self.managedObjectContext!)
          self.writeDisplayLog("Sensor Started: \(sensor!.sensorStarted!.doubleValue.getDate().description)")
          self.sensorWarmup()
          self.setProcessState()
        }
      case "addBGReadingSegue":
        let bGReadingView = nav.topViewController as! AddBGReadingViewController
        bGReadingView.managedObjectContext = managedObjectContext
        bGReadingView.didCancel = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
        }
        bGReadingView.didFinish = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
          if self.currentState == .firstReading {
            self.writeDisplayLog("Added first reading")
            self.currentState = .secondReading
          } else {
            if self.currentState  == .secondReading {
              self.writeDisplayLog("Added second reading")
              self.currentState = .waitingCalibration
            } else {
              if self.currentState == .doubleCalibrated {
                self.currentState = .readingLoop
              }
            }
          }
          self.setProcessState()
        }
      case "addDoubleCalibrationSegue":
        let doubleCalibrationView = nav.topViewController as! AddDoubleCalibrationViewController
        doubleCalibrationView.managedObjectContext = managedObjectContext
        doubleCalibrationView.didCancel = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
        }
        doubleCalibrationView.didFinish = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
          self.writeDisplayLog("Double Calibration Done")
          self.currentState = .doubleCalibrated
          self.setProcessState()
        }
      case "viewChartSegue":
        let chartView = nav.topViewController as! ChartViewController
        chartView.managedObjectContext = managedObjectContext
      case "eulaSegue":
        let eulaView = nav.topViewController as! EulaViewController
        eulaView.managedObjectContext = managedObjectContext
        eulaView.didFinish = { cont in
          let loc_nav = self.navigationController!
          loc_nav.popViewControllerAnimated(true)
          self.writeDisplayLog("EULA Accepted")
        }
      default:
        logger.error("wrong segue.identifier \(segue.identifier)")
      }
  }

  
  //MARK: Sensor handling
  
  func sensorWarmup() {
    var sensor = Sensor.currentSensor(managedObjectContext!)
    var sensorStart = sensor!.sensorStarted!.doubleValue.getDate()
    logger.verbose("\(sensor?.sensorStarted?.doubleValue)")
    if (sensorStart.timeIntervalSinceNow > -7200) {
      // the sensor is warming up
      // set sensor wamup counter
      sensorWarmupCounter = sensorWarmupCounter + Int(sensorStart.timeIntervalSinceNow)
      sensorTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("sensorWarmupActivity"), userInfo: nil, repeats: true)
        startSensorActivity.startAnimating()
    } else {
      sensorWarmupCounter = 0
      sensorWarmupActivity()
    }
  }
  
  func sensorWarmupActivity() {
    if sensorWarmupCounter != 0 {
      sensorWarmupCounter--
      if sensorWarmupCounter % 60 == 0 {
        var minutes = sensorWarmupCounter / 60
        writeDisplayLog("Sensor Warmup: \(minutes) minutes remaining")
      }
    } else {
      sensorTimer.invalidate()
      writeDisplayLog("Sensor Warmup: Done!\nWaiting for the first reading")
      startSensorActivity.stopAnimating()
      currentState = .firstReading
      setProcessState()
    }
  }
  
  //MARK: IBActions
  
  @IBAction func stopSensor(sender: AnyObject) {
    let confirmAlert = UIAlertView(title: "Stop Sensor", message: "Are you sure you want to stop the sensor?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
    confirmAlert.show()
  }
  
  //MARK: UIAlertViewDelegate
  
  func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
    if buttonIndex == 1 {
      if let currentSensor = Sensor.currentSensor(self.managedObjectContext!) {
        currentSensor.stopSensor()
        DxtrModel.sharedInstance.saveContext()
        startSensorActivity.stopAnimating()
        startSensorActivity.stopAnimating()
        writeDisplayLog("Sensor Stopped: \(currentSensor.sensorStopped!.doubleValue.getDate().description)")
        self.currentState = .sensorStopped
        setProcessState()
      }
    }
  }
  
  //MARK: Notifications
  
  /**
  Display of the connection state
  
  :param: notification notification description
  */
  func connectionChanged(notification: NSNotification) {
    // Connection status changed. Indicate on GUI.
    let userInfo = notification.userInfo as! [String: Bool]
    
    dispatch_async(dispatch_get_main_queue(), {
      // Set image based on connection status
      if let isConnected: Bool = userInfo["isConnected"] {
        let notification = UILocalNotification()
        if isConnected {
          self.btConnectionState.text = "Connected"
          notification.alertBody = "Wixel Connected"
          self.currentState = self.savedState
        } else {
          self.btConnectionState.text = "Disconnected"
          self.showWaitOverlayWithText("Connecting...")
          notification.alertBody = "Wixel Disconnected"
          self.savedState = self.currentState
          self.currentState = .disconnected
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
    let userInfo = notification.userInfo as! [String: Bool]
    
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
  
  func nightscoutStatus(notification: NSNotification) {
    if notification.name == NightscoutUploadSuccessNotification {
      let userInfo = notification.userInfo as! [String: AnyObject]
      if let entity: AnyObject = userInfo["entity"] {
        if let reading = entity as? BGReading {
          dispatch_async(dispatch_get_main_queue(), {
            var message = NSDate().description + ": Uploaded reading to Nightscout"
            if let payload: AnyObject = userInfo["payload"] {
              message += ": \(payload)"
            }
            self.writeDisplayLog(message)
          })
        } else if let calibration = entity as? Calibration {
          dispatch_async(dispatch_get_main_queue(), {
            var message = NSDate().description + ": Uploaded calibration to Nightscout"
            if let payload: AnyObject = userInfo["payload"] {
              message += ": \(payload)"
            }
            self.writeDisplayLog(message)
          })
        }
      }
    } else if notification.name == NightscoutUploadErrorNotification {
      let userInfo = notification.userInfo as! [String: NSError]
      if let error: NSError = userInfo["error"] {
        dispatch_async(dispatch_get_main_queue(), {
          self.writeDisplayLog("Error uploading to Nightscout: \(error)")
        })
      }
    }
  }
  
  private func writeDisplayLog(message: String) {
    logWindow.text = logWindow.text + "\n" + message
  }
 
}

