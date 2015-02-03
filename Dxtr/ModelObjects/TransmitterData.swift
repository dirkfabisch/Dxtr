import CoreData

@objc(TransmitterData)
class TransmitterData: _TransmitterData {

  convenience init (managedObjectContext: NSManagedObjectContext) {
    self.init (managedObjectContext: managedObjectContext, timeStamp: NSDate().getTime())
    
  }
  
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
    NSNotificationCenter.defaultCenter().postNotificationName(TDNewValueNotificcation, object: self, userInfo: nil)
  }


}
