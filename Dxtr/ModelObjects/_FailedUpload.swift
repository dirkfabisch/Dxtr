// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FailedUpload.swift instead.

import CoreData
import QueryKit

@objc
class _FailedUpload: NSManagedObject {

    class func queryset(context:NSManagedObjectContext) -> QuerySet<FailedUpload> {
        return QuerySet<FailedUpload>(context, entityName)
    }

    struct Attributes {

        var failedAttempts:Attribute<NSNumber> {
            return Attribute<NSNumber>("failedAttempts")
        }
        var managedObjectID:Attribute<AnyObject> {
            return Attribute<AnyObject>("managedObjectID")
        }
        var nextAttempt:Attribute<NSDate> {
            return Attribute<NSDate>("nextAttempt")
        }
        var type:Attribute<String> {
            return Attribute<String>("type")
        }

    }

    class var attributes:Attributes {
        return Attributes()
    }

    // MARK: - Class methods

    class var entityName:String {
        return "FailedUpload"
    }

    class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _FailedUpload.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var failedAttempts: NSNumber?

    // func validateFailedAttempts(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var managedObjectID: AnyObject

    // func validateManagedObjectID(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var nextAttempt: NSDate

    // func validateNextAttempt(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var type: String

    // func validateType(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

