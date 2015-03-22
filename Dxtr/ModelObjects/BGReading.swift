import CoreData
import QueryKit

@objc(BGReading)
class BGReading: _BGReading {

  // Custom logic goes here.
  convenience init (managedObjectContext: NSManagedObjectContext, rawData :Double) {
    self.init(managedObjectContext: managedObjectContext, timeStamp: NSDate().getTime(),rawData: rawData)
  }
  
  convenience init (managedObjectContext: NSManagedObjectContext, timeStamp newTimeStamp : Double, rawData newRawData :Double) {
    let entity = _BGReading.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)

    if let currentSensor = Sensor.currentSensor(managedObjectContext) {
      self.sensor = currentSensor
      self.rawData = newRawData / 1000
      self.timeStamp = newTimeStamp
      self.uuid = NSUUID().UUIDString
      self.timeSinceSensorStarted = newTimeStamp - currentSensor.sensorStarted!.doubleValue
      self.synced = false
      self.calibrationFlag = false
      
      if let lastCalibration = Calibration.lastCalibration(managedObjectContext) {
        self.calibration = lastCalibration
        
        calculateAgeAdjustedRawValue(newRawData / 1000)
        
        if false { // TODO: should be if calibration.checkIn -- need to add this property
          
        } else {
          
          if let lastBGReading = BGReading.lastBGReading(managedObjectContext) {
            if let lastBGReadingCalibration = lastBGReading.calibration {
              if (lastBGReading.calibrationFlag?.boolValue == true && ((lastBGReading.timeStamp!.doubleValue + (60000 * 20)) > self.timeStamp!.doubleValue) && (lastBGReading.calibration!.timeStamp!.doubleValue + (60000 * 20) > self.timeStamp!.doubleValue)) {
                lastBGReadingCalibration.rawValueOverride(managedObjectContext, rawValue:weightedAverageRaw(lastBGReading.timeStamp!.doubleValue, timeB:self.timeStamp!.doubleValue, calibrationTime:lastBGReading.calibration!.timeStamp!.doubleValue, rawA:lastBGReading.ageAdjustedRawValue!.doubleValue, rawB:self.ageAdjustedRawValue!.doubleValue))
              }
            }
            logger.verbose("Calculated value before: \(self.calculatedValue)")
            logger.verbose("\(lastCalibration.slope!) * \(self.ageAdjustedRawValue) + \(lastCalibration.intercept)")
            self.calculatedValue = (lastCalibration.slope!.doubleValue * self.ageAdjustedRawValue!.doubleValue) + lastCalibration.intercept!.doubleValue
            logger.verbose("Calculated value after: \(self.calculatedValue)")
          }
        }
        
        if self.calculatedValue!.intValue < 40 {
          self.calculatedValue = 40
        } else if self.calculatedValue!.intValue > 400 {
          self.calculatedValue = 400
        }
        
        logger.verbose("New calculated value: \(self.calculatedValue)")
        
        DxtrModel.sharedInstance.saveContext()
        
        performCalculations()
      } else {

        calculateAgeAdjustedRawValue(newRawData / 1000)
        
        performCalculations()
      }
    }
  }

  // MARK: Calculations
    
  func slopeName() -> String {
    let slopeByMinute = self.calculatedValueSlope!.doubleValue * 60000
    if slopeByMinute <= -3.5 {
      return "DoubleDown"
    } else if slopeByMinute <= -2 {
      return "SingleDown"
    } else if slopeByMinute <= -1 {
      return "FortyFiveDown"
    } else if slopeByMinute <= 1 {
      return "Flat"
    } else if slopeByMinute <= 2 {
      return "FortyFiveUp"
    } else if slopeByMinute <= 3.5 {
      return "SingleUp"
    } else {
      return "DoubleUp"
    }
  }
  
  private func calculateAgeAdjustedRawValue(rawData: Double) {
    let adjustFor = (86400000 * 1.9) - self.timeSinceSensorStarted!.doubleValue
    if (adjustFor > 0) {
      self.ageAdjustedRawValue = (0.45 * (adjustFor / (86400000 * 1.9)) * rawData) + rawData
      logger.verbose("raw value adjusted from \(rawData) to \(self.ageAdjustedRawValue)")
    } else {
      self.ageAdjustedRawValue = rawData
    }
  }

  private func weightedAverageRaw(timeA: Double, timeB: Double, calibrationTime: Double, rawA: Double, rawB: Double) -> Double {
    let relativeSlope = (rawB -  rawA) / (timeB - timeA)
    let relativeIntercept = rawA - (relativeSlope * timeA)
    return (relativeSlope * calibrationTime) + relativeIntercept
  }
  
  private func performCalculations() {
    findNewCurve()
    findNewRawCurve()
    findSlope()
  }
  
  func findNewCurve() {
    if let last3 = BGReading.lastBGReadings(DxtrModel.sharedInstance.managedObjectContext!, numberOfBGReadings:3) {
      if last3.count == 3 {
        let secondLatest = last3[1]
        let thirdLatest = last3[2]
        
        let y3 = self.calculatedValue!.doubleValue
        let x3 = self.timeStamp!.doubleValue
        let y2 = secondLatest.calculatedValue!.doubleValue
        let x2 = secondLatest.timeStamp!.doubleValue
        let y1 = thirdLatest.calculatedValue!.doubleValue
        let x1 = thirdLatest.timeStamp!.doubleValue

        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // a = y1 / ((x1 - x2) * (x1 - x3)) + y2 / ((x2 - x1) * (x2 - x3)) + y3 / ((x3 - x1) * (x3 - x2))
        let a1 = y1 / ((x1 - x2) * (x1 - x3))
        let a2 = y2 / ((x2 - x1) * (x2 - x3))
        let a3 = y3 / ((x3 - x1) * (x3 - x2))
        
        self.a = a1 + a2 + a3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // b = (-y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3)) - y2 * (x1 + x3) / ((x2 - x1) * (x2 - x3)) - y3 * (x1 + x2) / ((x3 - x1)*(x3 -x2)))

        let b1 = -y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3))
        let b2 = y2 * (x1 + x3) / ((x2 - x1) * (x2 - x3))
        let b3 = y3 * (x1 + x2) / ((x3 - x1) * (x3 - x2))
        
        self.b = b1 - b2 - b3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // c = (y1 * x2 * x3 / ((x1 - x2) * (x1 - x3)) + y2 * x1 * x3 / ((x2 - x1) * (x2 - x3)) + y3 * x1 * x2/((x3 - x1) * (x3 - x2)))
        
        let c1 = y1 * x2 * x3 / ((x1 - x2) * (x1 - x3))
        let c2 = y2 * x1 * x3 / ((x2 - x1) * (x2 - x3))
        let c3 = y3 * x1 * x2 / ((x3 - x1) * (x3 - x2))
        
        self.c = c1 + c2 + c3

      } else if last3.count == 2 {
        logger.verbose("Not enough data to calculate parabolic rates - assume linear")
        let latest = last3[0]
        let secondLatest = last3[1]
        
        var y2 = latest.calculatedValue!.doubleValue
        var x2 = timeStamp!.doubleValue
        var y1 = calculatedValue!.doubleValue
        var x1 = secondLatest.timeStamp!.doubleValue
        
        if (y1 == y2) {
          self.b = 0
        } else {
          self.b = (y2 - y1) / (x2 - x1)
        }
        self.a = 0
        self.c = -1 * ((latest.b!.doubleValue * x1) - y1)

      } else {
        logger.verbose("Not enough data to calculate parabolic rates - assume static data")
        
        self.a = 0
        self.b = 0
        self.c = self.calculatedValue

      }
      
      logger.verbose("BG parabolic rates: \(self.a) x^2 + \(self.b) x + \(self.c)")
      
      DxtrModel.sharedInstance.saveContext()
    }
  }
  
  func findNewRawCurve() {
    if let last3 = BGReading.lastBGReadings(DxtrModel.sharedInstance.managedObjectContext!, numberOfBGReadings:3) {
      if last3.count == 3 {
        let secondLatest = last3[1]
        let thirdLatest = last3[2]

        var y3 = self.ageAdjustedRawValue!.doubleValue
        var x3 = self.timeStamp!.doubleValue
        var y2 = secondLatest.ageAdjustedRawValue!.doubleValue
        var x2 = secondLatest.timeStamp!.doubleValue
        var y1 = thirdLatest.ageAdjustedRawValue!.doubleValue
        var x1 = thirdLatest.timeStamp!.doubleValue

        // Split because of complexity could not be hadeld by SWIFT compiler: :-( 
        // ra = y1 / ((x1 -   x2) * (x1 - x3)) + y2 / ((x2 - x1) * (x2 - x3)) + y3 / ((x3 - x1) * (x3 - x2))
        
        let ra1 = y1 / ((x1 - x2) * (x1 - x3))
        let ra2 = y2 / ((x2 - x1) * (x2 - x3))
        let ra3 = y3 / ((x3 - x1) * (x3 - x2))
        
        self.ra = ra1 + ra2 + ra3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // rb = (-y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3)) - y2 * (x1 + x3)/((x2 - x1) * (x2 - x3)) - y3 * (x1 + x2)/((x3 - x1) * (x3 - x2)))
        let rb1 = -y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3))
        let rb2 = y2 * (x1 + x3) / ((x2 - x1) * (x2 - x3))
        let rb3 = y3 * (x1 + x2) / ((x3 - x1) * (x3 - x2))
        
        self.rb = rb1 - rb2 - rb3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // rc = (y1 * x2 * x3 / ((x1 - x2) * (x1 - x3)) + y2 * x1 * x3 / ((x2 - x1) * (x2 - x3)) + y3 * x1 * x2/((x3 - x1) * (x3 - x2)))

        let rc1 = y1 * x2 * x3 / ((x1 - x2) * (x1 - x3))
        let rc2 = y2 * x1 * x3 / ((x2 - x1) * (x2 - x3))
        let rc3 = y3 * x1 * x2 / ((x3 - x1) * (x3 - x2))
        
        self.rc = rc1 + rc2 + rc3
        
      } else if last3.count == 2 {
        logger.verbose("Not enough data to calculate parabolic rates - assume linear")

        let latest = last3[0]
        let secondLatest = last3[1]

        var y2 = latest.ageAdjustedRawValue!.doubleValue
        var x2 = timeStamp!.doubleValue
        var y1 = secondLatest.ageAdjustedRawValue!.doubleValue
        var x1 = secondLatest.timeStamp!.doubleValue
        
        if (y1 == y2) {
          self.rb = 0
        } else {
          self.rb = (y2 - y1) / (x2 - x1)
        }
        self.ra = 0
        self.rc = -1 * ((latest.b!.doubleValue * x1) - y1)
        
      } else {
        logger.verbose("Not enough data to calculate parabolic rates - assume static data")
        
        if let reading = BGReading.lastNoSensor(DxtrModel.sharedInstance.managedObjectContext!) {
          self.ra = 0
          self.rb = 0
          self.rc = reading.ageAdjustedRawValue
        }
      }
      
      DxtrModel.sharedInstance.saveContext()
      
      logger.verbose("BG parabolic rates: \(self.ra) x^2 + \(self.rb) x + \(self.rc)")
    }
  }
  
  private func findSlope() {
    if let last2 = BGReading.lastBGReadings(DxtrModel.sharedInstance.managedObjectContext!, numberOfBGReadings:2) {
      if last2.count == 2 {
        let secondLatest = last2[1]
        var y1 = self.calculatedValue!.doubleValue
        var x1 = self.timeStamp!.doubleValue
        var y2 = secondLatest.calculatedValue!.doubleValue
        var x2 = secondLatest.timeStamp!.doubleValue
        if (y1 == y2) {
          self.calculatedValueSlope = 0
        } else {
          self.calculatedValueSlope = (y2 - y1) / (x2 - x1);
        }
      } else if last2.count == 1 {
        self.calculatedValueSlope = 0
      } else {
        logger.error("No BG? Couldn't find slope!")
      }
      
      DxtrModel.sharedInstance.saveContext()
    }
  }
  
  // MARK: Retrieval

  class func lastNoSensor(managedObjectContext: NSManagedObjectContext) -> BGReading? {
    var qs = BGReading.queryset(managedObjectContext).orderBy(BGReading.attributes.timeStamp.descending())
    return qs[0]
  }
  
  /**
  get the last BGReading if their is an active sensor
  
  :param: managedObjectContext curren managed object context
  
  :returns: optional last BGReading
  */
  class func lastBGReading(managedObjectContext: NSManagedObjectContext) -> BGReading? {
    let sensor = Sensor.currentSensor(managedObjectContext)
    
    if (sensor == nil) {
      logger.error("No active Sensor")
      return nil
    }
    var qs = BGReading.queryset(managedObjectContext).filter(
      BGReading.attributes.sensor == sensor
      ).orderBy(BGReading.attributes.timeStamp.descending())

    return qs[0]
  }

  
  /**
  get the last <X> BGReadings for the active sensor
  
  :param: managedObjectContext current managed object context
  :param: numberOfBGReadings number of requested BGReadings
  
  :returns: optional bg
  if no active sensor <nil>
  */
  class func lastBGReadings(
    managedObjectContext : NSManagedObjectContext,
    numberOfBGReadings : Int
    ) -> [BGReading]?
  {
    let sensor = Sensor.currentSensor(managedObjectContext)
    
    if (sensor == nil) {
      logger.error("No active Sensor")
      return nil
    }
    
    var qs = BGReading.queryset(managedObjectContext).filter(
        BGReading.attributes.sensor == sensor
      ).orderBy(BGReading.attributes.timeStamp.descending())
    
    if let count = qs.count() {
      if count < numberOfBGReadings {
        return qs.array()
      } else {
        qs = qs[0...numberOfBGReadings]
        return qs.array()
      }
    }
    return nil
  }

  class func bgReadingsSinceDate(managedObjectContext: NSManagedObjectContext, date: NSDate) -> [BGReading]? {
    var qs = BGReading.queryset(managedObjectContext)
      .filter(BGReading.attributes.timeStamp >= NSNumber(double: date.getTime()))
      .orderBy(BGReading.attributes.timeStamp.ascending())
    return qs.array()
  }
  
  class func estimatedRawBG (managedObjectContext: NSManagedObjectContext, timeStamp: Double) -> Double {
    let ts = timeStamp + READINGS_BESTOFFSET
    var estimate = Double(160)
    if let latestBG = BGReading.lastBGReading(managedObjectContext) {
      estimate = (Double(latestBG.ra!) * ts * ts) + (Double(latestBG.rb!) * ts) + Double(latestBG.rc!)
    } else {
      logger.warning("no data yet, assume perfect!")
      
    }
    logger.info("Estimate RAW BG: \(estimate)")
    return estimate
  }

}
