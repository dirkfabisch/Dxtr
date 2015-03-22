import CoreData
import QueryKit


@objc(Sensor)
class Sensor: _Sensor {

	// Custom logic goes here.
  convenience init (managedObjectContext: NSManagedObjectContext) {
    self.init(managedObjectContext: managedObjectContext, timeStamp: NSDate().getTime())
    
  }

  convenience init (managedObjectContext: NSManagedObjectContext, timeStamp: Double) {
    let entity = _Sensor.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
    // check if an sensor is active an stop sensor.
    if let cSensor = Sensor.currentSensor(managedObjectContext) {
      cSensor.stopSensor()
    }
    sensorStarted = round(timeStamp) // make sure we get only defined timestamps
    uuid = NSUUID().UUIDString
  }
  
  class func currentSensor(managedObjectContext: NSManagedObjectContext) -> Sensor? {
    var qs = Sensor.queryset(managedObjectContext).filter(
        Sensor.attributes.sensorStarted != 0 &&
        Sensor.attributes.sensorStopped == 0)
    
    if (qs.count() != nil) {
      return qs[0]
    }
    return nil
  }
  
  /// Stops the sensor
  func stopSensor() {
    self.sensorStopped = round(NSDate().getTime())
  }

  override var description: String {
    return "\nUUID: \(uuid)\nsensor started: \(sensorStarted)\nsensor Stopped: \(sensorStopped)\nBattery Sensor: \(lastBatteryLevel)\n"
  }
  
  // MARK: Class methods
  
  /// Returns whether or not there is currently an active sensor
  ///
  /// :param: managedObjectContext the managed object context
  /// :returns: true if there is currently an active sensor, otherwise false
  class func isSensorActive(managedObjectContext: NSManagedObjectContext) -> Bool {
    if let currentSensor = Sensor.currentSensor(managedObjectContext) {
      return true
    }
    return false
  }
}
