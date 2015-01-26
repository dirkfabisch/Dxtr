import CoreData
@objc(Calibration)
class Calibration: _Calibration {

	// Custom logic goes here.
  
  convenience init (managedObjectContext: NSManagedObjectContext, newBG :Double) {
    let entity = _Sensor.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
    // store all bg in mgdl 
    // convert from mmol if needed
    
    // remove all Calibration Requests
    // TODO: when are calibration request created?
    
    if Sensor.isSensorActive(managedObjectContext) {
      // get last bgReading 
      if let lastBGReading = BGReading.last(managedObjectContext) {
        sensor = Sensor.currentSensor(managedObjectContext)!
        bg = newBG
        timeStamp = NSDate().getTime()
        rawValue = lastBGReading.rawData
        slopeConfidence = min(max(((4 - abs((lastBGReading.calculatedValueSlope)!.doubleValue * 60000))/4), 0), 1)
        
        let estimated_raw_bg = BGReading.estimatedRawBG(managedObjectContext, timeStamp: NSDate().getTime())
        rawTimeStamp = lastBGReading.timeStamp
        if (abs(estimated_raw_bg - lastBGReading.ageAdjustedRawValue!.doubleValue) > 20) {
          estimateRawAtTimeOfCalibration = lastBGReading.ageAdjustedRawValue
        } else {
          estimateRawAtTimeOfCalibration = estimated_raw_bg
        }
        distanceFromEstimate = abs(bg!.doubleValue - lastBGReading.calculatedValue!.doubleValue)
        // approximate parabolic curve of the sensor confidence intervals from dexcom
        sensorConfidence = max(((-0.0018 * bg!.doubleValue * bg!.doubleValue) + (0.6657 * bg!.doubleValue) + 36.7505) / 100, 0)
        sensorAgeAtTimeOfEstimation = timeStamp!.doubleValue - sensor!.sensorStarted!.doubleValue
        uuid = NSUUID().UUIDString
        lastBGReading.calibration = self
        lastBGReading.calibrationFlag = true
        
        calculate_w_l_s(managedObjectContext)
        
        
      } else {
      }
    } else {
      logger.error("no sensor avialable")
    }
    
  }
  
//  calculate_w_l_s();
//  adjustRecentBgReadings();
//  CalibrationSendQueue.addToQueue(calibration, context);
//  Notifications.notificationSetter(context);
//  Calibration.requestCalibrationIfRangeTooNarrow();
//  }
//  } else {
//  Log.w("CALIBRATION", "No sensor, cant save!");
//  }
//  return Calibration.last();
//  }
//
//  
  
  func calculate_w_l_s(managedObjectContext : NSManagedObjectContext) {
    if (Sensor.isSensorActive(managedObjectContext)) {
      var l : Double = 0
      var m : Double = 0
      var n : Double = 0
      var p : Double = 0
      var q : Double = 0
      var w : Double
    }
  }
  
//  public static void calculate_w_l_s() {
//  if (Sensor.isActive()) {
//  double l = 0;
//  double m = 0;
//  double n = 0;
//  double p = 0;
//  double q = 0;
//  double w;
//  List<Calibration> calibrations = allForSensorInLastFourDays(); //5 days was a bit much, dropped this to 4
//  if (calibrations.size() == 1) {
//  Calibration calibration = Calibration.last();
//  calibration.intercept = calibration.bg;
//  calibration.slope = 0;
//  calibration.save();
//  } else {
//  for (Calibration calibration : calibrations) {
//  w = calibration.calculateWeight();
//  l += (w);
//  m += (w * calibration.estimate_raw_at_time_of_calibration);
//  n += (w * calibration.estimate_raw_at_time_of_calibration * calibration.estimate_raw_at_time_of_calibration);
//  p += (w * calibration.bg);
//  q += (w * calibration.estimate_raw_at_time_of_calibration * calibration.bg);
//  }
//  
//  Calibration last_calibration = Calibration.last();
//  w = (last_calibration.calculateWeight() * (calibrations.size() * 0.14));
//  l += (w);
//  m += (w * last_calibration.estimate_raw_at_time_of_calibration);
//  n += (w * last_calibration.estimate_raw_at_time_of_calibration * last_calibration.estimate_raw_at_time_of_calibration);
//  p += (w * last_calibration.bg);
//  q += (w * last_calibration.estimate_raw_at_time_of_calibration * last_calibration.bg);
//  
//  double d = (l * n) - (m * m);
//  Calibration calibration = Calibration.last();
//  calibration.intercept = ((n * p) - (m * q)) / d;
//  calibration.slope = ((l * q) - (m * p)) / d;
//  if ((calibrations.size() == 2 && calibration.slope < 0.95) || (calibration.slope < 0.85)) { // I have not seen a case where a value below 7.5 proved to be accurate but we should keep an eye on this
//  calibration.slope = calibration.slopeOOBHandler();
//  if(calibrations.size() > 2) { calibration.possible_bad = true; }
//  calibration.intercept = calibration.bg - (calibration.estimate_raw_at_time_of_calibration * calibration.slope);
//  CalibrationRequest.createOffset(calibration.bg, 25);
//  }
//  if ((calibrations.size() == 2 && calibration.slope > 1.2) || (calibration.slope > 1.35)) {
//  calibration.slope = calibration.slopeOOBHandler();
//  if(calibrations.size() > 2) { calibration.possible_bad = true; }
//  calibration.intercept = calibration.bg - (calibration.estimate_raw_at_time_of_calibration * calibration.slope);
//  CalibrationRequest.createOffset(calibration.bg, 25);
//  }
//  Log.d(TAG, "Calculated Calibration Slope: " + calibration.slope);
//  Log.d(TAG, "Calculated Calibration intercept: " + calibration.intercept);
//  calibration.save();
//  }
//  } else {
//  Log.w(TAG, "NO Current active sensor found!!");
//  }
//  }

  
}
