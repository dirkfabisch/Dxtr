//
//  NightscoutUploader.swift
//  Dxtr
//
//  Created by Rick on 2/3/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift
import QueryKit

class NightscoutUploader: NSObject {
  
  var timer: NSTimer?
  
  class var sharedInstance: NightscoutUploader {
      struct Singleton {
          static let instance: NightscoutUploader = NightscoutUploader()
      }
      return Singleton.instance
  }
  
  override init() {
    super.init()
    self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("processFailed:"), userInfo: nil, repeats: true)
  }
  
  func uploadReading(reading: BGReading) {
    if NightscoutUploader.canUpload() {
      let data = readingAsDictionary(reading)
      Alamofire.request(Router.Readings(data))
        .responseJSON { (request, response, JSON, error) in
          if error == nil {
            println(response)
            println(JSON)
            reading.synced = NSNumber(bool: true)
            DxtrModel.sharedInstance.saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName(NightscoutUploadSuccessNotification, object: self, userInfo: ["entity": reading, "payload": data])
          } else {
            logger.error("Error uploading reading: \(error)")
            FailedUpload(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!, managedObject: reading, type: UploadType.Reading)
            DxtrModel.sharedInstance.saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName(NightscoutUploadErrorNotification, object: self, userInfo: ["error": error!])
          }
        }
    }
  }
  
  func uploadCalibrationRecord(calibrationRecord: Calibration) {
    if NightscoutUploader.canUpload() {
      let data = calibrationRecordAsDictionary(calibrationRecord)
      Alamofire.request(Router.CalibrationRecords(data))
        .responseJSON { (request, response, JSON, error) in
          if error == nil {
            println(response)
            println(JSON)
            NSNotificationCenter.defaultCenter().postNotificationName(NightscoutUploadSuccessNotification, object: self, userInfo: ["entity": calibrationRecord, "payload": data])
          } else {
            logger.error("Error uploading calibration record: \(error)")
            FailedUpload(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!, managedObject: calibrationRecord, type: UploadType.CalibrationRecord)
            DxtrModel.sharedInstance.saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName(NightscoutUploadErrorNotification, object: self, userInfo: ["error": error!])
          }
        }
    }
  }
  
  func uploadMeterRecord(meterRecord: Calibration) {
    if NightscoutUploader.canUpload() {
      let data = meterRecordAsDictionary(meterRecord)
      Alamofire.request(Router.MeterRecords(data))
        .responseJSON { (request, response, JSON, error) in
          if error == nil {
            println(response)
            println(JSON)
            NSNotificationCenter.defaultCenter().postNotificationName(NightscoutUploadSuccessNotification, object: self, userInfo: ["entity": meterRecord, "payload": data])
          } else {
            logger.error("Error uploading meter record: \(error)")
            FailedUpload(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!, managedObject: meterRecord, type: UploadType.MeterRecord)
            DxtrModel.sharedInstance.saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName(NightscoutUploadErrorNotification, object: self, userInfo: ["error": error!])
          }
        }
    }
  }
  
  // TODO: Pass device status
  func uploadDeviceStatus() {
    if NightscoutUploader.canUpload() {
      Alamofire.request(Router.DeviceStatus(deviceStatusAsDictionary()))
        .responseJSON { (request, response, JSON, error) in
          if error == nil {
            
          } else {
            logger.error("Error uploading device status: \(error)")
            // Don't think we want to re-attempt a failed device status upload
          }
      }
    }
  }
  
  class func canUpload() -> Bool {
    return NightscoutUploader.isUploadEnabled() &&
      NightscoutUploader.isNightscoutURLValid() &&
      NightscoutUploader.isNightscoutAPISecretValid()
  }
  
  // MARK: Private
  
  @objc private func processFailed(timer: NSTimer) {
    var queryset = FailedUpload.queryset(DxtrModel.sharedInstance.managedObjectContext!)
    queryset = queryset.filter(FailedUpload.attributes.nextAttempt <= NSDate())
    queryset = queryset.orderBy(FailedUpload.attributes.nextAttempt.ascending())
    for failedUpload in queryset {
      logger.debug("Processing failed upload")
      processFailedUpload(failedUpload)
    }
  }
  
  private func processFailedUpload(failedUpload: FailedUpload) {
    if NightscoutUploader.canUpload() {
      if let managedObjectID = DxtrModel.sharedInstance.managedObjectContext!.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(failedUpload.managedObjectID as! NSURL) {
        logger.debug("Processing failed upload with ID: \(managedObjectID)")
        var error: NSError?
        var managedObject = DxtrModel.sharedInstance.managedObjectContext!.existingObjectWithID(managedObjectID, error: &error)
        if let actualError = error {
          logger.error("Error fetching managed object: \(actualError)")
        } else {
          if let actualManagedObject = managedObject {
            var router: Router?
            if let uploadType = UploadType(rawValue: failedUpload.type) {
              switch uploadType {
              case .Reading:
                router = Router.Readings(readingAsDictionary(actualManagedObject as! BGReading))
              case .CalibrationRecord:
                router = Router.CalibrationRecords(calibrationRecordAsDictionary(actualManagedObject as! Calibration))
              case .MeterRecord:
                router = Router.MeterRecords(meterRecordAsDictionary(actualManagedObject as! Calibration))
              }
            }
            if let actualRouter = router {
              Alamofire.request(actualRouter)
                .responseJSON { (request, response, JSON, error) in
                  if error == nil {
                    logger.debug("Uploaded failed upload")
                    // TODO: Do we need to set 'synced' property of 'actualManagedObject'?
                    DxtrModel.sharedInstance.managedObjectContext!.deleteObject(failedUpload)
                    DxtrModel.sharedInstance.saveContext()
                  } else {
                    logger.error("Error uploading failed upload: \(error)")
                    failedUpload.incrementFailed()
                    if failedUpload.isMaxFailed() {
                      DxtrModel.sharedInstance.managedObjectContext?.deleteObject(failedUpload)
                    } else {
                      logger.debug("Will try failed upload again")
                    }
                    DxtrModel.sharedInstance.saveContext()
                  }
              }
            }
          } else {
            logger.warning("Couldn't find managed object with ID: \(managedObjectID)")
          }
        }
      }
    }
  }
  
  private class func isUploadEnabled() -> Bool {
    return SettingsManager.sharedInstance.isNightscoutUploadEnabled()
  }
  
  private class func isNightscoutURLValid() -> Bool {
    if let urlString = SettingsManager.sharedInstance.getNightscoutURL() {
      if let url = NSURL(string: urlString) {
        return true
      }
    }
    return false
  }
  
  private class func isNightscoutAPISecretValid() -> Bool {
    if let apiSecret = SettingsManager.sharedInstance.getNightscoutAPISecret() {
      return count(apiSecret) >= NIGHTSCOUT_API_SECRET_MIN_LENGTH
    }
    return false
  }
  
  private func readingAsDictionary(reading: BGReading) -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["device"] = "dexcom"
    if let timeStamp = reading.timeStamp {
      dictionary["date"] = timeStamp
    }
    if let calculatedValue = reading.calculatedValue {
      dictionary["sgv"] = calculatedValue.integerValue
    }
    dictionary["direction"] = reading.slopeName()
    if let ageAdjustedRawValue = reading.ageAdjustedRawValue {
      dictionary["filtered"] = ageAdjustedRawValue // change to filtered when we start storing it
      dictionary["unfiltered"] = ageAdjustedRawValue
    }
    dictionary["type"] = "sgv"
    dictionary["rssi"] = 100
    return dictionary
  }
  
  private func calibrationRecordAsDictionary(calibrationRecord: Calibration) -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["device"] = "dexcom"
    dictionary["type"] = "cal"
    if let timeStamp = calibrationRecord.timeStamp {
      dictionary["date"] = timeStamp
    }
    if let slope = calibrationRecord.slope {
      dictionary["slope"] = slope
    }
    if let intercept = calibrationRecord.intercept {
      dictionary["intercept"] = intercept
    }
    dictionary["scale"] = 1000
    return dictionary
  }
  
  private func meterRecordAsDictionary(meterRecord: Calibration) -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["device"] = "dexcom"
    dictionary["type"] = "mbg"
    if let timeStamp = meterRecord.timeStamp {
      dictionary["date"] = timeStamp
//      let timeStampDate = NSDate(timeIntervalSince1970: (timeStamp.doubleValue * 1000))
//      dictionary["dateString"] = dateFormatter().stringFromDate(timeStampDate)
    }
    if let bg = meterRecord.bg {
      dictionary["mbg"] = bg
    }
    return dictionary
  }
  
  private func deviceStatusAsDictionary() -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["uploaderBattery"] = 100
    return dictionary
  }
  
  private func dateFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
    return formatter
  }
  
  enum Router: URLRequestConvertible {
    
    case Readings([String: AnyObject])
    case CalibrationRecords([String: AnyObject])
    case MeterRecords([String: AnyObject])
    case DeviceStatus([String: AnyObject])
    
    var method: Alamofire.Method {
      switch self {
      case .Readings, .CalibrationRecords, .MeterRecords, .DeviceStatus:
        return .POST
      }
    }
    
    var path: String {
      switch self {
      case .Readings, .CalibrationRecords, .MeterRecords:
        return "entries"
      case .DeviceStatus:
        return "devicestatus"
      }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
      let URL = NSURL(string: SettingsManager.sharedInstance.getNightscoutURL()!)!
      let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
      mutableURLRequest.HTTPMethod = method.rawValue

      if let secret = SettingsManager.sharedInstance.getNightscoutAPISecret()?.sha1()?.lowercaseString {
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["api-secret": secret]
      } else {
        logger.error("Expected API secret")
      }
      
      switch self {
      case .Readings(let parameters):
        return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
      case .CalibrationRecords(let parameters):
        return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
      case .MeterRecords(let parameters):
        return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
      case .DeviceStatus(let parameters):
        return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
      }
    }
  }
  
  enum UploadType: String {
    case Reading = "Reading"
    case CalibrationRecord = "CalibrationRecord"
    case MeterRecord = "MeterRecord"
  }
}