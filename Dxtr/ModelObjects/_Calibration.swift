// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Calibration.swift instead.

import CoreData
import QueryKit

@objc
class _Calibration: NSManagedObject {

    class func queryset(context:NSManagedObjectContext) -> QuerySet<Calibration> {
        return QuerySet<Calibration>(context, entityName)
    }

    struct Attributes {

        var adjustedRawValue:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("adjustedRawValue")
        }
        var bg:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("bg")
        }
        var distanceFromEstimate:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("distanceFromEstimate")
        }
        var estimateBgAtTimeOfCalibration:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("estimateBgAtTimeOfCalibration")
        }
        var estimateRawAtTimeOfCalibration:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("estimateRawAtTimeOfCalibration")
        }
        var intercept:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("intercept")
        }
        var possibleBad:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("possibleBad")
        }
        var rawTimeStamp:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("rawTimeStamp")
        }
        var rawValue:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("rawValue")
        }
        var sensorAgeAtTimeOfEstimation:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("sensorAgeAtTimeOfEstimation")
        }
        var sensorConfidence:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("sensorConfidence")
        }
        var slope:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("slope")
        }
        var slopeConfidence:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("slopeConfidence")
        }
        var timeStamp:Attribute<NSNumber?> {
            return Attribute<NSNumber?>("timeStamp")
        }
        var uuid:Attribute<String?> {
            return Attribute<String?>("uuid")
        }

        var bgReadings:Attribute<BGReading?> {
            return Attribute<BGReading?>("bgReadings")
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
        return "Calibration"
    }

    class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext)
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
    var rawTimeStamp: NSNumber?

    // func validateRawTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rawValue: NSNumber?

    // func validateRawValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var sensorAgeAtTimeOfEstimation: NSNumber?

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
    var timeStamp: NSNumber?

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

