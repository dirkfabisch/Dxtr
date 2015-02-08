import CoreData
import QueryKit

@objc(FailedUpload)
class FailedUpload: _FailedUpload {

  convenience init (managedObjectContext: NSManagedObjectContext, managedObject: NSManagedObject, type: NightscoutUploader.UploadType) {
    let entity = _FailedUpload.entity(managedObjectContext)
    self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    self.managedObjectID = managedObject.objectID.URIRepresentation()
    self.type = type.rawValue
    self.failedAttempts = 1
    self.nextAttempt = NSDate().dateByAddingTimeInterval(120) // 2 minutes from now
  }
  
  func incrementFailed() {
    if let failed = self.failedAttempts {
      let newFailed = failed.integerValue + 1
      self.failedAttempts = NSNumber(integer: newFailed)
      let nextCheck: NSTimeInterval = newFailed == 1 ? 120 : 300
      self.nextAttempt = NSDate().dateByAddingTimeInterval(nextCheck)
    } else {
      self.failedAttempts = 1
      self.nextAttempt = NSDate().dateByAddingTimeInterval(120)
    }
  }
  
  func isMaxFailed() -> Bool {
    if let failed = self.failedAttempts {
      return failed.integerValue >= 3
    }
    return true
  }

}

