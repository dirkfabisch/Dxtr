// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BGReading.swift instead.

import CoreData

enum BGReadingAttributes: String {
    case a = "a"
    case ageAdjustedRawValue = "ageAdjustedRawValue"
    case b = "b"
    case c = "c"
    case calculatedValue = "calculatedValue"
    case calculatedValueSlope = "calculatedValueSlope"
    case calibrationFlag = "calibrationFlag"
    case ra = "ra"
    case rawData = "rawData"
    case rb = "rb"
    case rc = "rc"
    case synced = "synced"
    case timeSinceSensorStarted = "timeSinceSensorStarted"
    case timeStamp = "timeStamp"
    case uuid = "uuid"
}

enum BGReadingRelationships: String {
    case calibration = "calibration"
    case sensor = "sensor"
}

@objc
class _BGReading: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "BGReading"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
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

