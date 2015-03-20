import CoreData

@objc(TransmitterData)
class TransmitterData: _TransmitterData {

  
  /**
  init a transmitter data object with current time
  
  :param: managedObjectContext current managed object context
  :param: rawData              raw data from the transmitter
  
  :returns: created transmitter data instance
  */
  convenience init (managedObjectContext: NSManagedObjectContext, rawData: Double) {
    self.init(managedObjectContext: managedObjectContext)
    self.rawData = rawData
  }
  
  /**
  init a empty transmitter data object with current time
  
  :param: managedObjectContext current managed object context
  
  :returns: created empty transmitter data instance
  */
  convenience init (managedObjectContext: NSManagedObjectContext) {
    self.init (managedObjectContext: managedObjectContext, timeStamp: NSDate().getTime())
    
  }
  
  /**
  init a empty transmitter data object 
  
  :param: managedObjectContext current managed object context
  :param: timeStamp            creation time
  
  :returns: created empty transmitter data instance
  */
  convenience init (managedObjectContext: NSManagedObjectContext, timeStamp: Double) {
  
    let entity = _TransmitterData.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
    // create a unique id
    uuid = NSUUID().UUIDString

    // create the creation time stamp
    self.timeStamp = timeStamp
  }
  
  override var description: String {
    return "\nUUID: \(uuid)\nTimeStamp: \(timeStamp)\nRaw Value: \(rawData)\nBattery Sensor: \(sensorBatteryLevel)\n"
  }
  
  func sendTDNewValueNotificcation() {
    NSNotificationCenter.defaultCenter().postNotificationName(TDNewValueNotification, object: self, userInfo: nil)
  }


}
