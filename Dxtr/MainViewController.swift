//
//  MainViewController.swift
//  Dxtr
//
//  Created by Dirk on 06/04/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import CoreData


class MainViewController: UIViewController, ENSideMenuDelegate, DxtrModelDelegate {
  
  @IBOutlet weak var bgReadingLabel: UILabel!
  @IBOutlet weak var lastReadingLabel: UILabel!
  @IBOutlet weak var logWindow: UITextView!
  @IBOutlet weak var statusLabel: UILabel!

  // set by AppDelegate on application startup
  var managedObjectContext: NSManagedObjectContext?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // prepare Header Area...
    
    // clear log window
    logWindow.text = ""
  
    // get current state and present the next logic step
    var state = StateManager.sharedInstance.currentState()
    writeDisplayLog("Current state: \(state.rawValue)")
    statusLabel.text = state.rawValue
    
  
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   navigationController?.navigationBarHidden = true
  }
  
  @IBAction func configMenuButton(sender: AnyObject) {
    toggleSideMenuView()
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
          //          self.currentState = .sensorStarted
          var sensor = Sensor.currentSensor(self.managedObjectContext!)
          self.writeDisplayLog("Sensor Started: \(sensor!.sensorStarted!.doubleValue.getDate().description)")
          //          self.sensorWarmup()
          //          self.setProcessState()
        }
//      case "addBGReadingSegue":
//        let bGReadingView = nav.topViewController as AddBGReadingViewController
//        bGReadingView.managedObjectContext = managedObjectContext
//        bGReadingView.didCancel = { cont in
//          let loc_nav = self.navigationController!
//          loc_nav.popViewControllerAnimated(true)
//        }
//        bGReadingView.didFinish = { cont in
//          let loc_nav = self.navigationController!
//          loc_nav.popViewControllerAnimated(true)
//          if self.currentState == .firstReading {
//            self.writeDisplayLog("Added first reading")
//            self.currentState = .secondReading
//          } else {
//            if self.currentState  == .secondReading {
//              self.writeDisplayLog("Added second reading")
//              self.currentState = .waitingCalibration
//            } else {
//              if self.currentState == .doubleCalibrated {
//                self.currentState = .readingLoop
//              }
//            }
//          }
//          self.setProcessState()
//        }
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
          //          self.currentState = .doubleCalibrated
          //          self.setProcessState()
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

  

  
  private func writeDisplayLog(message: String) {
    logWindow.text = logWindow.text + "\n" + message
  }
}