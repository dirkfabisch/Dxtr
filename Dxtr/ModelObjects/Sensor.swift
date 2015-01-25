import CoreData

@objc(Sensor)
class Sensor: _Sensor {

	// Custom logic goes here.
  convenience init (managedObjectContext: NSManagedObjectContext) {
    self.init(managedObjectContext: managedObjectContext, timeStamp: NSDate())
    
  }

  convenience init (managedObjectContext: NSManagedObjectContext, timeStamp: NSDate) {
    let entity = _Sensor.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
  
    sensorStarted = timeStamp
    uuid = NSUUID().UUIDString
    
  }
  
  class func currentSensor(managedObjectContext: NSManagedObjectContext) -> Sensor? {
    
    let entity = _Sensor.entity(managedObjectContext)
    var fetchRequest = NSFetchRequest(entityName: entity.name!)
    var predicate = NSPredicate(format: "sensorStarted != nil && sensorStopped = nil")
    fetchRequest.predicate = predicate
    
    if let results = managedObjectContext.executeFetchRequest(fetchRequest, error:nil) {
      for ao in results {
        if let sensor = ao as? Sensor {
          return sensor
        }
      }
    }
    return nil
  }
  
  class func isSensorActive(managedObjectContext: NSManagedObjectContext) -> Bool {
    
    let entity = _Sensor.entity(managedObjectContext)
    var fetchRequest = NSFetchRequest(entityName: entity.name!)
    var predicate = NSPredicate(format: "sensorStarted != nil && sensorStopped = nil")
    fetchRequest.predicate = predicate
    
    if let results = managedObjectContext.executeFetchRequest(fetchRequest, error:nil) {
      for ao in results {
        if let sensor = ao as? Sensor {
          return true
        }
      }
    }
    return false
  }

  override var description: String {
    return "UUID: \(uuid)\nsensor started: \(sensorStarted)\nsensor Stopped: \(sensorStopped)\nBattery Sensor: \(lastBatteryLevel)\n"
  }


}
