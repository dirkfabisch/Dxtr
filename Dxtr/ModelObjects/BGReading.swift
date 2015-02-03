import CoreData
import QueryKit

@objc(BGReading)
class BGReading: _BGReading {

  // Custom logic goes here.
  convenience init (managedObjectContext: NSManagedObjectContext, rawData :Double) {
    self.init(managedObjectContext: managedObjectContext, timeStamp: NSDate().getTime(),rawData: rawData)
  }
  
  convenience init (managedObjectContext: NSManagedObjectContext, timeStamp : Double, rawData :Double) {
    let entity = _BGReading.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)

    if let currentSensor = Sensor.currentSensor(managedObjectContext) {
      if let lastCalibration = Calibration.lastCalibration(managedObjectContext) {
        self.sensor = currentSensor
        calibration = lastCalibration
        self.rawData = rawData / 1000
        self.timeStamp = NSDate().getTime()
        uuid = NSUUID().UUIDString
        timeSinceSensorStarted = self.timeStamp!.doubleValue - currentSensor.sensorStarted!.doubleValue
        synced = false

        //TODO: THIS IS A BIG SILLY IDEA, THIS WILL HAVE TO CHANGE ONCE WE GET SOME REAL DATA FROM THE START OF SENSOR LIFE
        var adjustFor = (86400000 * 1.9) -  timeSinceSensorStarted!.doubleValue
        if (adjustFor > 0) {
          ageAdjustedRawValue = (((0.45) * (adjustFor / (86400000 * 1.9))) * (rawData/1000)) + (rawData/1000);
          logger.verbose("RAW VALUE ADJUSTMENT: FROM: \(rawData/1000) TO: \(ageAdjustedRawValue)")
        } else {
          ageAdjustedRawValue = rawData / 1000
        }
        
        if let lastBGReading = BGReading.lastBGReading(managedObjectContext) {
          if lastBGReading.calibration != nil {
            if (lastBGReading.calibrationFlag?.boolValue == true && ((lastBGReading.timeStamp!.doubleValue + (60000 * 20)) > self.timeStamp!.doubleValue) && (lastBGReading.calibration!.timeStamp!.doubleValue + (60000 * 20) > self.timeStamp!.doubleValue)) {
              var weightedAverageRawValue = weightedAverageRaw(lastBGReading.timeStamp!.doubleValue, timeB: self.timeStamp!.doubleValue, calibrationTime: lastBGReading.calibration!.timeStamp!.doubleValue, rawA: lastBGReading.ageAdjustedRawValue!.doubleValue, rawB: ageAdjustedRawValue!.doubleValue)
              lastBGReading.calibration!.rawValueOverride(managedObjectContext, rawValue: weightedAverageRawValue)
            }
          }
        }
        //TODO: Support for Dexcom 505 calibration readings missing
//        if(calibration.check_in) {
//          double firstAdjSlope = calibration.first_slope + (calibration.first_decay * (Math.ceil(new Date().getTime() - calibration.timestamp)/(1000 * 60 * 10)));
//          //                    double secondAdjSlope = calibration.first_slope + (calibration.first_decay * ((new Date().getTime() - calibration.timestamp)/(1000 * 60 * 10)));
//          double calSlope = (calibration.first_scale / firstAdjSlope)*1000;
//          double calIntercept = ((calibration.first_scale * calibration.first_intercept) / firstAdjSlope)*-1;
//          //                    double calSlope = ((calibration.second_scale / secondAdjSlope) + (3 * calibration.first_scale / firstAdjSlope)) * 250;
//          //                    double calIntercept = (((calibration.second_scale * calibration.second_intercept) / secondAdjSlope) + ((3 * calibration.first_scale * calibration.first_intercept) / firstAdjSlope)) / -4;
//          
//          bgReading.calculated_value = (((calSlope * bgReading.raw_data) + calIntercept) - 5);
//        } else {
//          bgReading.calculated_value = ((calibration.slope * bgReading.age_adjusted_raw_value) + calibration.intercept);
//        }
        calculatedValue = ((calibration!.slope!.doubleValue * ageAdjustedRawValue!.doubleValue) + calibration!.intercept!.doubleValue)
        if (calculatedValue!.doubleValue <= 40) {
          calculatedValue = 40
        } else  {
          if (calculatedValue!.doubleValue >= 400) {
            calculatedValue = 400
          }
        }
        logger.verbose("NEW VALUE CALCULATED AT: \(calculatedValue)")

        DxtrModel.sharedInstance.saveContext()
        performCalculations(managedObjectContext)

        //TODO: Send notification we have a new BGReading

      } else {
        
        logger.verbose("current Sensor\(currentSensor.description)")

        self.sensor = currentSensor
        self.rawData = rawData / 1000
        self.timeStamp = NSDate().getTime()
        uuid = NSUUID().UUIDString
        timeSinceSensorStarted = self.timeStamp!.doubleValue - currentSensor.sensorStarted!.doubleValue
        synced = false
        calibrationFlag = false
        
        //TODO: THIS IS A BIG SILLY IDEA, THIS WILL HAVE TO CHANGE ONCE WE GET SOME REAL DATA FROM THE START OF SENSOR LIFE
        var adjustFor = (86400000 * 1.8) -  timeSinceSensorStarted!.doubleValue
        if (adjustFor > 0) {
          ageAdjustedRawValue = ((50 / 20) * (adjustFor / (86400000 * 1.8))) * (rawData / 1000)
          logger.verbose("RAW VALUE ADJUSTMENT: FROM: \(rawData) TO: \(ageAdjustedRawValue)")
        } else {
          ageAdjustedRawValue = rawData / 1000
        }

        
        performCalculations(managedObjectContext)
        
      }
    }
    
//          BgReading lastBgReading = BgReading.last();
//          if (lastBgReading != null && lastBgReading.calibration != null) {
//            if (lastBgReading.calibration_flag == true && ((lastBgReading.timestamp + (60000 * 20)) > bgReading.timestamp) && ((lastBgReading.calibration.timestamp + (60000 * 20)) > bgReading.timestamp)) {
//              lastBgReading.calibration.rawValueOverride(BgReading.weightedAverageRaw(lastBgReading.timestamp, bgReading.timestamp, lastBgReading.calibration.timestamp, lastBgReading.age_adjusted_raw_value, bgReading.age_adjusted_raw_value), context);
//            }
//          }
//          
//          if(calibration.check_in) {
//            double firstAdjSlope = calibration.first_slope + (calibration.first_decay * (Math.ceil(new Date().getTime() - calibration.timestamp)/(1000 * 60 * 10)));
//            //                    double secondAdjSlope = calibration.first_slope + (calibration.first_decay * ((new Date().getTime() - calibration.timestamp)/(1000 * 60 * 10)));
//            double calSlope = (calibration.first_scale / firstAdjSlope)*1000;
//            double calIntercept = ((calibration.first_scale * calibration.first_intercept) / firstAdjSlope)*-1;
//            //                    double calSlope = ((calibration.second_scale / secondAdjSlope) + (3 * calibration.first_scale / firstAdjSlope)) * 250;
//            //                    double calIntercept = (((calibration.second_scale * calibration.second_intercept) / secondAdjSlope) + ((3 * calibration.first_scale * calibration.first_intercept) / firstAdjSlope)) / -4;
//            
//            bgReading.calculated_value = (((calSlope * bgReading.raw_data) + calIntercept) - 5);
//          } else {
//            bgReading.calculated_value = ((calibration.slope * bgReading.age_adjusted_raw_value) + calibration.intercept);
//          }
//          if (bgReading.calculated_value <= 40) {
//            bgReading.calculated_value = 40;
//          } else if (bgReading.calculated_value >= 400) {
//            bgReading.calculated_value = 400;
//          }
//          Log.w(TAG, "NEW VALUE CALCULATED AT: " + bgReading.calculated_value);
//          
//          bgReading.save();
//          bgReading.perform_calculations();
//          Notifications.notificationSetter(context);
//          BgSendQueue.addToQueue(bgReading, "create", context);
//        }
//      }
//      Log.w("BG GSON: ",bgReading.toS());
//      
//      return bgReading;
//    }
  }


  // Calculations !!!!
  //*******************

  func weightedAverageRaw (timeA : Double,
                           timeB : Double,
                 calibrationTime : Double,
                            rawA : Double,
                            rawB : Double)
  -> Double
  {
    var relativeSlope = (rawB -  rawA)/(timeB - timeA)
    var relativeIntercept = rawA - (relativeSlope * timeA)
    return ((relativeSlope * calibrationTime) + relativeIntercept)
  }
  
//  public static double weightedAverageRaw(double timeA, double timeB, double calibrationTime, double rawA, double rawB) {
//  double relativeSlope = (rawB -  rawA)/(timeB - timeA);
//  double relativeIntercept = rawA - (relativeSlope * timeA);
//  return ((relativeSlope * calibrationTime) + relativeIntercept);
//  }

  private func performCalculations(managedObjectContext: NSManagedObjectContext) {
    findRawCurve(managedObjectContext)
    findNewRawCurve(managedObjectContext)
    findSlope(managedObjectContext)
  }

  func findSlope(managedObjectContext: NSManagedObjectContext) {
    if let last2 = BGReading.lastBGReadings(managedObjectContext, numberOfBGReadings: 2) {
      if (last2.count == 2) {
        let secondLatest = last2[1]
        var y1 = calculatedValue!.doubleValue
        var x1 = timeStamp!.doubleValue
        var y2 = secondLatest.calculatedValue!.doubleValue
        var x2 = secondLatest.timeStamp!.doubleValue
        if (y1 == y2) {
          calculatedValueSlope = 0
        } else {
          calculatedValueSlope = (y2 - y1)/(x2 - x1);
        }
      } else {
        calculatedValueSlope = 0
      }
    } else {
      logger.error("NO BG? COULDNT FIND SLOPE!")
    }
  }
  
  func findNewRawCurve(managedObjectContext: NSManagedObjectContext) {
    if let last3 = BGReading.lastBGReadings(managedObjectContext, numberOfBGReadings: 3) {
      if last3.count == 3 {
        let secondLatest = last3[1]
        let thirdLatest = last3[2]

        var y3 = calculatedValue!.doubleValue
        var x3 = timeStamp!.doubleValue
        var y2 = secondLatest.calculatedValue!.doubleValue
        var x2 = secondLatest.timeStamp!.doubleValue
        var y1 = thirdLatest.calculatedValue!.doubleValue
        var x1 = thirdLatest.timeStamp!.doubleValue

        // Split because of complexity could not be hadeld by SWIFT compiler: :-( 
        // a = y1 / ((x1 -   x2) * (x1 - x3)) + y2 / ((x2 - x1) * (x2 - x3)) + y3 / ((x3 - x1) * (x3 - x2))
        
        let a1 = y1 / ((x1 - x2) * (x1 - x3))
        let a2 = y2 / ((x2 - x1) * (x2 - x3))
        let a3 = y3 / ((x3 - x1) * (x3 - x2))
        a = a1 + a2 + a3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // b = (-y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3)) - y2 * (x1 + x3)/((x2 - x1) * (x2 - x3)) - y3 * (x1 + x2)/((x3 - x1) * (x3 - x2)))
        let b1 = -y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3))
        let b2 = y2 * (x1 + x3) / ((x2 - x1) * (x2 - x3))
        let b3 = y3 * (x1 + x2) / ((x3 - x1) * (x3 - x2))
        
        b = b1 - b2 - b3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // c = (y1 * x2 * x3 / ((x1 - x2) * (x1 - x3)) + y2 * x1 * x3 / ((x2 - x1) * (x2 - x3)) + y3 * x1 * x2/((x3 - x1) * (x3 - x2)))

        let c1 = y1 * x2 * x3 / ((x1 - x2) * (x1 - x3))
        let c2 = y2 * x1 * x3 / ((x2 - x1) * (x2 - x3))
        let c3 = y3 * x1 * x2 / ((x3 - x1) * (x3 - x2))
        
        c = c1 + c2 + c3
        
        logger.verbose("BG PARABOLIC RATES: \(a) x^2 + \(b) x + \(c)")
        
        DxtrModel.sharedInstance.saveContext()

      } else {
        if last3.count == 2 {
          logger.verbose("Not enough data to calculate parabolic rates - assume Linear")
          let latest = last3[0]
          let secondLatest = last3[1]

          var y2 = latest.calculatedValue!.doubleValue
          var x2 = timeStamp!.doubleValue
          var y1 = secondLatest.calculatedValue!.doubleValue
          var x1 = secondLatest.timeStamp!.doubleValue
          
          if (y1 == y2) {
            b = 0
          } else {
            b = (y2 - y1) / (x2 - x1)
          }
          a = 0
          c = -1 * ((latest.b!.doubleValue * x1) - y1)
          
          logger.verbose("\(latest.a) x^2 + \(latest.b) x + \(latest.c)")

          DxtrModel.sharedInstance.saveContext()
          
        } else {
          logger.verbose("Not enough data to calculate parabolic rates - assume static data")
          
          a = 0
          b = 0
          c = calculatedValue
          logger.verbose("\(a) x^2 + \(b) x + \(c)")
          
          DxtrModel.sharedInstance.saveContext()
        }
      }
    }
  }
  
  
  func findRawCurve(managedObjectContext: NSManagedObjectContext) {
    if let last3 = BGReading.lastBGReadings(managedObjectContext, numberOfBGReadings: 3) {
      if last3.count == 3 {
        let secondLatest = last3[1]
        let thirdLatest = last3[2]
        
        var y3 = ageAdjustedRawValue!.doubleValue
        var x3 = timeStamp!.doubleValue
        var y2 = secondLatest.ageAdjustedRawValue!.doubleValue
        var x2 = secondLatest.timeStamp!.doubleValue
        var y1 = thirdLatest.ageAdjustedRawValue!.doubleValue
        var x1 = thirdLatest.timeStamp!.doubleValue

        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // ra = y1 / ((x1 - x2) * (x1 - x3)) + y2 / ((x2 - x1) * (x2 - x3)) + y3 / ((x3 - x1) * (x3 - x2))
        let ra1 = y1 / ((x1 - x2) * (x1 - x3))
        let ra2 = y2 / ((x2 - x1) * (x2 - x3))
        let ra3 = y3 / ((x3 - x1) * (x3 - x2))
        ra = ra1 + ra2 + ra3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // rb = (-y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3)) - y2 * (x1 + x3) / ((x2 - x1) * (x2 - x3)) - y3 * (x1 + x2) / ((x3 - x1)*(x3 -x2)))

        let rb1 = -y1 * (x2 + x3) / ((x1 - x2) * (x1 - x3))
        let rb2 = y2 * (x1 + x3) / ((x2 - x1) * (x2 - x3))
        let rb3 = y3 * (x1 + x2) / ((x3 - x1) * (x3 - x2))
        
        rb = rb1 - rb2 - rb3
        
        // Split because of complexity could not be hadeld by SWIFT compiler: :-(
        // rc = (y1 * x2 * x3 / ((x1 - x2) * (x1 - x3)) + y2 * x1 * x3 / ((x2 - x1) * (x2 - x3)) + y3 * x1 * x2/((x3 - x1) * (x3 - x2)))
        
        let rc1 = y1 * x2 * x3 / ((x1 - x2) * (x1 - x3))
        let rc2 = y2 * x1 * x3 / ((x2 - x1) * (x2 - x3))
        let rc3 = y3 * x1 * x2 / ((x3 - x1) * (x3 - x2))
        
        rc = rc1 + rc2 + rc3

        logger.verbose("BG PARABOLIC RATES: \(ra) x^2 + \(rb) x + \(rc)")
        
        DxtrModel.sharedInstance.saveContext()

      } else {
        if last3.count == 2 {
          logger.verbose("Not enough data to calculate parabolic rates - assume Linear")
          let latest = last3[0]
          let secondLatest = last3[1]
          
          var y2 = latest.ageAdjustedRawValue!.doubleValue
          var x2 = timeStamp!.doubleValue
          var y1 = secondLatest.ageAdjustedRawValue!.doubleValue
          var x1 = secondLatest.timeStamp!.doubleValue
          
          if (y1 == y2) {
            rb = 0
          } else {
            rb = (y2 - y1) / (x2 - x1)
          }
          ra = 0
          rc = -1 * ((latest.rb!.doubleValue * x1) - y1)
          
          logger.verbose("LINEAR RAW RATES: \(ra) x^2 + \(rb) x + \(rc)")
          
          DxtrModel.sharedInstance.saveContext()
          
        } else {
          logger.verbose("Not enough data to calculate parabolic rates - assume static data")
          if let latestEntry = BGReading.lastNoSensor(managedObjectContext) {
            ra = 0
            rb = 0
            rc = latestEntry.ageAdjustedRawValue

            logger.verbose("STATIC RAW RATES: \(ra) x^2 + \(rb) x + \(rc)")

            DxtrModel.sharedInstance.saveContext()
          }
        }
      }
    }
    
  }

  
  // retriving BGReading data
  // **************************

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
