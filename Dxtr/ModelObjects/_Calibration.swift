// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Calibration.swift instead.

import CoreData

enum CalibrationAttributes: String {
    case adjustedRawValue = "adjustedRawValue"
    case bg = "bg"
    case distanceFromEstimate = "distanceFromEstimate"
    case estimateBgAtTimeOfCalibration = "estimateBgAtTimeOfCalibration"
    case estimateRawAtTimeOfCalibration = "estimateRawAtTimeOfCalibration"
    case intercept = "intercept"
    case possibleBad = "possibleBad"
    case rawTimeStamp = "rawTimeStamp"
    case rawValue = "rawValue"
    case sensorAgeAtTimeOfEstimation = "sensorAgeAtTimeOfEstimation"
    case sensorConfidence = "sensorConfidence"
    case slope = "slope"
    case slopeConfidence = "slopeConfidence"
    case timeStamp = "timeStamp"
    case uuid = "uuid"
}

enum CalibrationRelationships: String {
    case bgReadings = "bgReadings"
    case sensor = "sensor"
}

@objc
class _Calibration: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Calibration"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Calibration.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var adjustedRawValue: NSNumber?

    // func validateAdjustedRawValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var bg: NSNumber?

    // func validateBg(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var distanceFromEstimate: NSNumber?

    // func validateDistanceFromEstimate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var estimateBgAtTimeOfCalibration: NSNumber?

    // func validateEstimateBgAtTimeOfCalibration(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var estimateRawAtTimeOfCalibration: NSNumber?

    // func validateEstimateRawAtTimeOfCalibration(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var intercept: NSNumber?

    // func validateIntercept(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var possibleBad: NSNumber?

    // func validatePossibleBad(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rawTimeStamp: NSDate?

    // func validateRawTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rawValue: NSNumber?

    // func validateRawValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensorAgeAtTimeOfEstimation: NSDate?

    // func validateSensorAgeAtTimeOfEstimation(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensorConfidence: NSNumber?

    // func validateSensorConfidence(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var slope: NSNumber?

    // func validateSlope(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var slopeConfidence: NSNumber?

    // func validateSlopeConfidence(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var timeStamp: NSDate?

    // func validateTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var bgReadings: BGReading?

    // func validateBgReadings(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensor: Sensor?

    // func validateSensor(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

