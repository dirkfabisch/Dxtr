// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TransmitterData.swift instead.

import CoreData
import QueryKit

@objc
class _TransmitterData: NSManagedObject {

    class func queryset(context:NSManagedObjectContext) -> QuerySet<TransmitterData> {
        return QuerySet<TransmitterData>(context, entityName)
    }

    struct Attributes {

        var rawData:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("rawData")
        }
        var sensorBatteryLevel:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("sensorBatteryLevel")
        }
        var timeStamp:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("timeStamp")
        }
        var uuid:Attribute<String?> {
            return Attribute<String?>("uuid")
        }

    }

    class var attributes:Attributes {
        return Attributes()
    }

    // MARK: - Class methods

    class var entityName:String {
        return "TransmitterData"
    }

    class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext)
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
    var timeStamp: NSNumber?

    // func validateTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

