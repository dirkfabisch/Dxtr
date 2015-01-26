// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Sensor.swift instead.

import CoreData

enum SensorAttributes: String {
    case lastBatteryLevel = "lastBatteryLevel"
    case sensorStarted = "sensorStarted"
    case sensorStopped = "sensorStopped"
    case uuid = "uuid"
}

enum SensorRelationships: String {
    case bgReadings = "bgReadings"
    case calibrations = "calibrations"
}

@objc
class _Sensor: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Sensor"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Sensor.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var lastBatteryLevel: NSNumber?

    // func validateLastBatteryLevel(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensorStarted: NSNumber?

    // func validateSensorStarted(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensorStopped: NSNumber?

    // func validateSensorStopped(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var bgReadings: NSSet

    @NSManaged
    var calibrations: NSSet

}

extension _Sensor {

    func addBgReadings(objects: NSSet) {
        let mutable = self.bgReadings.mutableCopy() as NSMutableSet
        mutable.unionSet(objects)
        self.bgReadings = mutable.copy() as NSSet
    }

    func removeBgReadings(objects: NSSet) {
        let mutable = self.bgReadings.mutableCopy() as NSMutableSet
        mutable.minusSet(objects)
        self.bgReadings = mutable.copy() as NSSet
    }

    func addBgReadingsObject(value: BGReading!) {
        let mutable = self.bgReadings.mutableCopy() as NSMutableSet
        mutable.addObject(value)
        self.bgReadings = mutable.copy() as NSSet
    }

    func removeBgReadingsObject(value: BGReading!) {
        let mutable = self.bgReadings.mutableCopy() as NSMutableSet
        mutable.removeObject(value)
        self.bgReadings = mutable.copy() as NSSet
    }

}

extension _Sensor {

    func addCalibrations(objects: NSSet) {
        let mutable = self.calibrations.mutableCopy() as NSMutableSet
        mutable.unionSet(objects)
        self.calibrations = mutable.copy() as NSSet
    }

    func removeCalibrations(objects: NSSet) {
        let mutable = self.calibrations.mutableCopy() as NSMutableSet
        mutable.minusSet(objects)
        self.calibrations = mutable.copy() as NSSet
    }

    func addCalibrationsObject(value: Calibration!) {
        let mutable = self.calibrations.mutableCopy() as NSMutableSet
        mutable.addObject(value)
        self.calibrations = mutable.copy() as NSSet
    }

    func removeCalibrationsObject(value: Calibration!) {
        let mutable = self.calibrations.mutableCopy() as NSMutableSet
        mutable.removeObject(value)
        self.calibrations = mutable.copy() as NSSet
    }

}
