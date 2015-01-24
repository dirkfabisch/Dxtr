import CoreData

@objc(TransmitterData)
class TransmitterData: _TransmitterData {

  init (managedObjectContext: NSManagedObjectContext) {

    let entity = _TransmitterData.entity(managedObjectContext)
    super.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    
    // create a unique id
    uuid = "\(NSUUID())"
    
    // create the creation time stamp
    timeStamp = NSDate()
  }
  
  
}
