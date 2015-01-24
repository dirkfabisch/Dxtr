import CoreData

@objc(TransmitterData)
class TransmitterData: _TransmitterData {

  convenience init (managedObjectContext: NSManagedObjectContext) {
    self.init (managedObjectContext: managedObjectContext, timeStamp: NSDate())
    
  }
  
  convenience init (managedObjectContext: NSManagedObjectContext, timeStamp: NSDate) {
  
    let entity = _TransmitterData.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
    // create a unique id
    uuid = NSUUID().UUIDString

    // create the creation time stamp
    self.timeStamp = timeStamp
    
  }
  
  override var description: String {
    return "UUID: \(uuid)\nTimeStamp: \(timeStamp)\nRaw Value: \(rawData)\nBattery Sensor: \(sensorBatteryLevel)\n"
  }
  
  func sendTDNewValueNotificcation() {
    NSNotificationCenter.defaultCenter().postNotificationName(TDNewValueNotificcation, object: self, userInfo: nil)
  }


}
