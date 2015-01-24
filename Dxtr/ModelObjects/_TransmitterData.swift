// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TransmitterData.swift instead.

import CoreData

enum TransmitterDataAttributes: String {
    case rawData = "rawData"
    case sensorBatteryLevel = "sensorBatteryLevel"
    case timeStamp = "timeStamp"
    case uuid = "uuid"
}

@objc
class _TransmitterData: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "TransmitterData"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _TransmitterData.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var rawData: NSNumber?

    // func validateRawData(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensorBatteryLevel: NSNumber?

    // func validateSensorBatteryLevel(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var timeStamp: NSDate?

    // func validateTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

