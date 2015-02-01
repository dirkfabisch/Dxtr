// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BGReading.swift instead.

import CoreData
import QueryKit

@objc
class _BGReading: NSManagedObject {

    class func queryset(context:NSManagedObjectContext) -> QuerySet<BGReading> {
        return QuerySet<BGReading>(context, entityName)
    }

    struct Attributes {

        var a:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("a")
        }
        var ageAdjustedRawValue:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("ageAdjustedRawValue")
        }
        var b:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("b")
        }
        var c:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("c")
        }
        var calculatedValue:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("calculatedValue")
        }
        var calculatedValueSlope:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("calculatedValueSlope")
        }
        var calibrationFlag:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("calibrationFlag")
        }
        var ra:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("ra")
        }
        var rawData:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("rawData")
        }
        var rb:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("rb")
        }
        var rc:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("rc")
        }
        var synced:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("synced")
        }
        var timeSinceSensorStarted:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("timeSinceSensorStarted")
        }
        var timeStamp:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("timeStamp")
        }
        var uuid:Attribute<String?> {
            return Attribute<String?>("uuid")
        }

        var calibration:Attribute<Calibration?> {
            return Attribute<Calibration?>("calibration")
        }

        var sensor:Attribute<Sensor?> {
            return Attribute<Sensor?>("sensor")
        }

    }

    class var attributes:Attributes {
        return Attributes()
    }

    // MARK: - Class methods

    class var entityName:String {
        return "BGReading"
    }

    class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _BGReading.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var a: NSNumber?

    // func validateA(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var ageAdjustedRawValue: NSNumber?

    // func validateAgeAdjustedRawValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var b: NSNumber?

    // func validateB(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var c: NSNumber?

    // func validateC(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var calculatedValue: NSNumber?

    // func validateCalculatedValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var calculatedValueSlope: NSNumber?

    // func validateCalculatedValueSlope(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var calibrationFlag: NSNumber?

    // func validateCalibrationFlag(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var ra: NSNumber?

    // func validateRa(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rawData: NSNumber?

    // func validateRawData(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rb: NSNumber?

    // func validateRb(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rc: NSNumber?

    // func validateRc(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var synced: NSNumber?

    // func validateSynced(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var timeSinceSensorStarted: NSNumber?

    // func validateTimeSinceSensorStarted(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var timeStamp: NSNumber?

    // func validateTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var calibration: Calibration?

    // func validateCalibration(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensor: Sensor?

    // func validateSensor(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

