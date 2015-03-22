//
//  StateManager.swift
//  Dxtr
//
//  Created by Rick on 3/21/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import QueryKit

class StateManager: NSObject {
  
  enum State: String {
    case SensorStopped = "SensorStopped"
    case SensorStarted = "SensorStarted"
    //case SensorWarmup = "SensorWarmup"
    case FirstReading = "FirstReading"
    case SecondReading = "SecondReading"
    case WaitingCalibration = "WaitingCalibration"
    //case DoubleCalibrated = "DoubleCalibrated"
    case ReadingLoop = "ReadingLoop"
    //case Disconnected = "Disconnected"
  }

  class var sharedInstance: StateManager {
    struct Singleton {
      static let instance: StateManager = StateManager()
    }
    return Singleton.instance
  }
  
  func currentState() -> State {
    if let currentSensor = Sensor.currentSensor(DxtrModel.sharedInstance.managedObjectContext!) {
      var started = currentSensor.sensorStarted!.doubleValue.getDate()
      if started.dateByAddingTimeInterval(TWO_HOURS_SECONDS).compare(NSDate()) != NSComparisonResult.OrderedDescending {
        // we are past the warmup period
        
        let readings = currentSensor.bgReadings.count
        if readings == 0 {
          return State.FirstReading
        } else if readings == 1 {
          return State.SecondReading
        } else {
          let calibrations = currentSensor.calibrations.count
          if calibrations == 0 || calibrations == 1 {
            return State.WaitingCalibration
          } else {
            return State.ReadingLoop
          }
        }
      } else {
        return State.SensorStarted
      }
    } else {
      return State.SensorStopped
    }
  }
  
}