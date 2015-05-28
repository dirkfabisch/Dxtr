import CoreData
import QueryKit

@objc(Calibration)
class Calibration: _Calibration {

  // All calculatiosn are one2one from the original dexdrip code.
  // Only adapted for type safty
  
  // all optional values will be explizit unrawpped if needed 
  // every function which is relaying on valid values for unwrapping is private 
  // in this class
  
  convenience init (managedObjectContext: NSManagedObjectContext, newBG :Double) {
    self.init(managedObjectContext: managedObjectContext, newBG :newBG, timeStamp : NSDate().getTime())
  }
  
  convenience init (managedObjectContext: NSManagedObjectContext, newBG :Double, timeStamp newTimeStamp: Double ) {
    let entity = _Calibration.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
    // store all bg in mgdl 
    // convert from mmol if needed
    
    // remove all Calibration Requests
    // TODO: when are calibration request created?
    
    if Sensor.isSensorActive(managedObjectContext) {
      // get last bgReading 
      if let lastBGReading = BGReading.lastBGReading(managedObjectContext) {
        self.sensor = Sensor.currentSensor(managedObjectContext)!
        self.bg = newBG
        self.timeStamp = newTimeStamp
        self.rawValue = lastBGReading.rawData
        self.adjustedRawValue = lastBGReading.ageAdjustedRawValue
        self.slopeConfidence = min(max(((4 - abs((lastBGReading.calculatedValueSlope)!.doubleValue * 60000))/4), 0), 1)
        
        let estimatedRawBG = BGReading.estimatedRawBG(managedObjectContext, timeStamp: NSDate().getTime())
        self.rawTimeStamp = lastBGReading.timeStamp
        if (abs(estimatedRawBG - lastBGReading.ageAdjustedRawValue!.doubleValue) > 20) {
          self.estimateRawAtTimeOfCalibration = lastBGReading.ageAdjustedRawValue
        } else {
          self.estimateRawAtTimeOfCalibration = estimatedRawBG
        }
        self.distanceFromEstimate = abs(self.bg!.doubleValue - lastBGReading.calculatedValue!.doubleValue)

        // approximate parabolic curve of the sensor confidence intervals from dexcom
        self.sensorConfidence = max(((-0.0018 * self.bg!.doubleValue * bg!.doubleValue) + (0.6657 * self.bg!.doubleValue) + 36.7505) / 100, 0)
        self.sensorAgeAtTimeOfEstimation = timeStamp!.doubleValue - sensor!.sensorStarted!.doubleValue
        self.uuid = NSUUID().UUIDString
        lastBGReading.calibration = self
        lastBGReading.calibrationFlag = true
        
        DxtrModel.sharedInstance.saveContext()
       
        //TODO:  BgSendQueue.addToQueue(bgReading, "update", context);
        calculateWLS(managedObjectContext)
        adjustRecentBgReadings(managedObjectContext)
        
        //TODO:        CalibrationSendQueue.addToQueue(calibration, context);
        //TODO:        Notifications.notificationSetter(context);
        
        //        Calibration.requestCalibrationIfRangeTooNarrow();
        
        
      } else {
        logger.error("no bg reading")
      }
    } else {
      logger.error("no sensor avialable")
    }
    
  }
  
  // Calculations !!!!
  //*******************
  
  func rawValueOverride (managedObjectContext: NSManagedObjectContext, rawValue: Double) {
    self.estimateRawAtTimeOfCalibration = rawValue
    calculateWLS(managedObjectContext)
    DxtrModel.sharedInstance.saveContext()
  }
  
  /**
  This just adjust the last 30 bg readings transition from one calibration point to the next
  
  :param: managedObjectContext current managed object context
  */
  private func adjustRecentBgReadings(managedObjectContext : NSManagedObjectContext) {
    //TODO: add some handling around calibration overrides as they come out looking a bit funky
    if let calibrations = Calibration.lastCalibrations(managedObjectContext, numberOfCalibrations: 3){
      if let bgReadings = BGReading.lastBGReadings(managedObjectContext, numberOfBGReadings: 30){
        if calibrations.count == 3 {
          var denom = bgReadings.count
          let latestCalibration = calibrations[0]
          var i = 0
          for bgReading in bgReadings {
            let oldValue = bgReading.calculatedValue!.doubleValue
            let newValue = (bgReading.ageAdjustedRawValue!.doubleValue * latestCalibration.slope!.doubleValue) + latestCalibration.intercept!.doubleValue
            bgReading.calculatedValue = ((newValue * Double(denom - i)) + (oldValue * Double(i))) / Double(denom)
            DxtrModel.sharedInstance.saveContext()
            i += 1
          }
        } else if calibrations.count == 2 {
          let latestCalibration = calibrations[0]
          for bgReading in bgReadings {
            let newValue = (bgReading.ageAdjustedRawValue!.doubleValue * latestCalibration.slope!.doubleValue) + latestCalibration.intercept!.doubleValue
            bgReading.calculatedValue = newValue
            DxtrModel.sharedInstance.saveContext()
          }
        }
        bgReadings[0].findNewRawCurve()
        bgReadings[0].findNewCurve()
      }
    }
  }

  private func calculateWLS(managedObjectContext : NSManagedObjectContext) {
    if (Sensor.isSensorActive(managedObjectContext)) {
      var l : Double = 0
      var m : Double = 0
      var n : Double = 0
      var p : Double = 0
      var q : Double = 0
      var w : Double = 0
      
      if let calibrations = getCalibrationsForCurrentSensor(managedObjectContext, numberOfDays: 4) {
        if calibrations.count == 1 {
          var calibration = calibrations[0]
          calibration.intercept = calibration.bg
          calibration.slope = 0
          DxtrModel.sharedInstance.saveContext()
        } else {
          for calibration in calibrations {
            w = calibration.calculateWeight(managedObjectContext)
            l += w
            m += w * Double(calibration.estimateRawAtTimeOfCalibration!)
            n += w * Double(calibration.estimateRawAtTimeOfCalibration!) * Double(calibration.estimateRawAtTimeOfCalibration!)
            p += w * Double(calibration.bg!)
            q += w * Double(calibration.estimateRawAtTimeOfCalibration!) * Double(calibration.bg!)
          }
          
          if let lastCalibration = Calibration.lastCalibration(managedObjectContext) {
            w = lastCalibration.calculateWeight(managedObjectContext) * Double(calibrations.count) * (0.14)
            l += w
            m += w * Double(lastCalibration.estimateRawAtTimeOfCalibration!)
            n += w * Double(lastCalibration.estimateRawAtTimeOfCalibration!) * Double(lastCalibration.estimateRawAtTimeOfCalibration!)
            p += w * Double(lastCalibration.bg!)
            q += w * Double(lastCalibration.estimateRawAtTimeOfCalibration!) * Double(lastCalibration.bg!)
            
            var d : Double = (l * n) - (m * m)
            
            if let calibration = Calibration.lastCalibration(managedObjectContext) {
              calibration.intercept = ((n * p) - (m * q)) / d
              calibration.slope = ((l * q) - (m * p)) / d
              if (((calibrations.count == 2) && (Double(calibration.slope!) < 0.95)) || (Double(calibration.slope!) < 0.85)) {
                // I have not seen a case where a value below 7.5 proved to be accurate but we should keep an eye on this
                calibration.slope = calibration.slopeOOBHandler(managedObjectContext)
                if (calibrations.count > 2) {
                  calibration.possibleBad = true
                }
                calibration.intercept = Double(calibration.bg!) - (Double(calibration.estimateRawAtTimeOfCalibration!) * Double(calibration.slope!))
                
                // TODO:  CalibrationRequest.createOffset(calibration.bg, 25);

              }
              if (((calibrations.count == 2) && (Double(calibration.slope!) > 1.2)) || (Double(calibration.slope!) > 1.35)) {
                calibration.slope = calibration.slopeOOBHandler(managedObjectContext)
                if (calibrations.count > 2) {
                  calibration.possibleBad = true
                }
                calibration.intercept = Double(calibration.bg!) - (Double(calibration.estimateRawAtTimeOfCalibration!) * Double(calibration.slope!))
                
                // TODO:  CalibrationRequest.createOffset(calibration.bg, 25);
              }
              logger.debug("Calculated Calibration Slope: \(calibration.slope)")
              logger.debug("Calculated Calibration intercept: \(calibration.intercept)")
            }
          }
        }
      }
    } else {
      logger.error("No active sensor")
    }
  }
  
  private func slopeOOBHandler(managedObjectContext : NSManagedObjectContext) -> Double? {
      // If the last slope was reasonable and reasonably close, use that, otherwise use a slope that may be a little steep, but its best to play it safe when uncertain
    if let calibrations = Calibration.lastCalibrations(managedObjectContext, numberOfCalibrations: 3) {
      var thisCalibration = calibrations[0]
      if calibrations.count == 3 {
        if (abs(thisCalibration.bg!.doubleValue - thisCalibration.estimateBgAtTimeOfCalibration!.doubleValue) < 30) &&
            ((calibrations[1].possibleBad != nil) && (calibrations[1].possibleBad?.boolValue == true)) {
          return calibrations[1].slope?.doubleValue
        } else {
          return max(((-0.048) * (thisCalibration.sensorAgeAtTimeOfEstimation!.doubleValue / (60000 * 60 * 24))) + 1.1,1)
        }
      } else {
        if calibrations.count == 2 {
          return max(((-0.048) * (thisCalibration.sensorAgeAtTimeOfEstimation!.doubleValue / (60000 * 60 * 24))) + 1.1,1.05)
        }
      }
      return 1
    }
    return 1
  }
  
  private func calculateWeight(managedObjectContext : NSManagedObjectContext) -> Double {
    if let firstTimeStarted : Double = Calibration.firstCalibration(managedObjectContext)?.sensorAgeAtTimeOfEstimation?.doubleValue {
      if let lastTimeStarted : Double = Calibration.lastCalibration(managedObjectContext)?.sensorAgeAtTimeOfEstimation?.doubleValue {
        var timePercentage = min(((Double(sensorAgeAtTimeOfEstimation!) - firstTimeStarted) / (Double(lastTimeStarted) - Double(firstTimeStarted))) / Double(0.85), 1)
        timePercentage = timePercentage + 0.01
        logger.info("CALIBRATIONS TIME PERCENTAGE WEIGHT: \(timePercentage)")
        return max(((((Double(slopeConfidence!) + Double(sensorConfidence!)) * timePercentage) / 2) * 100), 1)
      }
    }
    
    logger.error("Could not calculate weight first or last calibration is missing)")
    return 0.0
  }
  
  /// Gets the first calibration for the active sensor
  /// Only considers calibrations where sensorConfidence != 0 and slopeConfidence != 0
  ///
  /// :param: managedObjectContext the managed object context
  /// :returns: optional calibration
  class func firstCalibration(managedObjectContext : NSManagedObjectContext) -> Calibration? {
    let sensor = Sensor.currentSensor(managedObjectContext)
    
    if (sensor == nil) {
      logger.error("No active Sensor")
      return nil
    }

    var qs = Calibration.queryset(managedObjectContext).filter(
      Calibration.attributes.sensor == sensor &&
        Calibration.attributes.sensorConfidence != 0 &&
        Calibration.attributes.slopeConfidence != 0
    ).orderBy(Calibration.attributes.timeStamp.ascending())
    
    if let count = qs.count() {
      if count > 0 {
        return qs[0]
      }
    }
    return nil
  }
  
  /// Gets the last calibration for the active sensor
  /// Only considers calibrations where sensorConfidence != 0 and slopeConfidence != 0
  ///
  /// :param: managedObjectContext the managed object context
  /// :returns: optional calibration
  class func lastCalibration(managedObjectContext : NSManagedObjectContext) -> Calibration? {
    let sensor = Sensor.currentSensor(managedObjectContext)
    
    if (sensor == nil) {
      logger.error("No active Sensor")
      return nil
    }
    
    var qs = Calibration.queryset(managedObjectContext).filter(
      Calibration.attributes.sensor == sensor &&
        Calibration.attributes.sensorConfidence != 0 &&
        Calibration.attributes.slopeConfidence != 0
      ).orderBy(Calibration.attributes.timeStamp.descending())
    
    if let count = qs.count() {
      if count > 0 {
        return qs[0]
      }
    }
    return nil
  }

  /// Gets the last number calibration for the active sensor
  /// Only considers calibrations where sensorConfidence != 0 and slopeConfidence != 0
  ///
  /// :param: managedObjectContext the managed object context
  /// :param: numberOfCalibrations the number of calibrations to limit
  /// :returns: optional calibration
  class func lastCalibrations(managedObjectContext: NSManagedObjectContext, numberOfCalibrations: Int) -> [Calibration]? {
    let sensor = Sensor.currentSensor(managedObjectContext)

    if (sensor == nil) {
      logger.error("No active Sensor")
      return nil
    }
    
    var qs = Calibration.queryset(managedObjectContext).filter(
      Calibration.attributes.sensor == sensor &&
        Calibration.attributes.sensorConfidence != 0 &&
        Calibration.attributes.slopeConfidence != 0
      ).orderBy(Calibration.attributes.timeStamp.descending())
    
    if let count = qs.count() {
      if count < numberOfCalibrations {
        return qs.array()
      } else {
        qs = qs[0...numberOfCalibrations]
        return qs.array()
      }
    }
    return nil
  }
  
  /// Gets the calibrations for the last number of days for the current sensor
  /// Only considers calibrations where sensorConfidence != 0 and slopeConfidence != 0
  ///
  /// :param: managedObjectContext the managed object context
  /// :param: numberOfDays the number of days back (> 0)
  /// :returns: optional calibration
  func getCalibrationsForCurrentSensor(managedObjectContext: NSManagedObjectContext, numberOfDays: Int) -> [Calibration]? {
    if let sensor = Sensor.currentSensor(managedObjectContext) {
      return getCalibrations(managedObjectContext, sensor: sensor, numberOfDays: numberOfDays)
    }
    logger.error("No active sensor")
    return nil
  }
  
  /// Gets the calibrations for the last number of days for the given sensor
  /// Only considers calibrations where sensorConfidence != 0 and slopeConfidence != 0
  ///
  /// :param: managedObjectContext the managed object context
  /// :param: sensor the sensor to get the calibrations for
  /// :param: numberOfDays the number of days back (> 0)
  /// :returns: optional calibration
  func getCalibrations(managedObjectContext: NSManagedObjectContext, sensor: Sensor, numberOfDays: Int) -> [Calibration]? {
    if numberOfDays <= 0 {
      logger.error("number of days equal or less than 0")
      return nil
    }
    
    let searchTimeStamp: Double = round(NSDate().getTime() - Double(60000 * 60 * 24 * numberOfDays))
    
    var qs = Calibration.queryset(managedObjectContext).filter(
      Calibration.attributes.sensor == sensor &&
        Calibration.attributes.sensorConfidence != 0 &&
        Calibration.attributes.slopeConfidence != 0 &&
        Calibration.attributes.timeStamp > NSNumber(double: searchTimeStamp)
      ).orderBy(Calibration.attributes.timeStamp.descending())
    
    return qs.array()
  }
}
