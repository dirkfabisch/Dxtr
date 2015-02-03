import CoreData

@objc(BGReading)
class BGReading: _BGReading {

	// Custom logic goes here.
  
  convenience init (managedObjectContext: NSManagedObjectContext, rawData :Double) {
    let entity = _Sensor.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
  }

  class func last(managedObjectContext: NSManagedObjectContext) -> BGReading? {
    return nil
  }
  
  class func estimatedRawBG (managedObjectContext: NSManagedObjectContext, timeStamp: Double) -> Double {
    let ts = timeStamp + READINGS_BESTOFFSET
    var estimate = Double(160)
    if let latestBG = BGReading.last(managedObjectContext) {
      estimate = (Double(latestBG.ra!) * ts * ts) + (Double(latestBG.rb!) * ts) + Double(latestBG.rc!)
    } else {
      logger.warning("no data yet, assume perfect!")
      
    }
    logger.info("Estimate RAW BG: \(estimate)")
    return estimate
  }

}
