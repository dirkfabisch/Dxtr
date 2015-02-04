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

class NightscoutUploader: NSObject {
    
  class var sharedInstance: NightscoutUploader {
      struct Singleton {
          static let instance: NightscoutUploader = NightscoutUploader()
      }
      return Singleton.instance
  }
  
  func uploadReading(reading: BGReading) {
    Alamofire.request(Router.Readings(readingAsDictionary(reading)))
      .responseJSON { (request, response, JSON, error) in
        if error == nil {
          println(response)
          println(JSON)
          reading.synced = NSNumber(bool: true)
          DxtrModel.sharedInstance.saveContext()
        } else {
          logger.error("Error uploading reading: \(error)")
        }
      }
  }
  
  func uploadCalibrationRecord(calibrationRecord: Calibration) {
    Alamofire.request(Router.CalibrationRecords(calibrationRecordAsDictionary(calibrationRecord)))
      .responseJSON { (request, response, JSON, error) in
        if error == nil {
          println(response)
          println(JSON)
        } else {
          logger.error("Error uploading calibration record: \(error)")
        }
      }
  }
  
  func uploadMeterRecord(meterRecord: Calibration) {
    Alamofire.request(Router.MeterRecords(meterRecordAsDictionary(meterRecord)))
      .responseJSON { (request, response, JSON, error) in
        if error == nil {
          println(response)
          println(JSON)
        } else {
          logger.error("Error uploading meter record: \(error)")
        }
      }
  }
  
  // TODO: Pass device status
  func uploadDeviceStatus() {
    Alamofire.request(Router.DeviceStatus(deviceStatusAsDictionary()))
      .responseJSON { (request, response, JSON, error) in
        if error == nil {
          
        } else {
          logger.error("Error uploading device status: \(error)")
        }
    }
  }
  
  // MARK: Private
  
  func readingAsDictionary(reading: BGReading) -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["device"] = "dexcom"
    if let timeStamp = reading.timeStamp {
      dictionary["date"] = timeStamp
      let timeStampDate = NSDate(timeIntervalSince1970: (timeStamp.doubleValue * 1000))
      dictionary["dateString"] = dateFormatter().stringFromDate(timeStampDate)
    }
    if let calculatedValue = reading.calculatedValue {
      dictionary["sgv"] = calculatedValue
    }
    // TODO: dictionary["direction"] = reading.slopeName when it's added
    if let ageAdjustedRawValue = reading.ageAdjustedRawValue {
      dictionary["filtered"] = ageAdjustedRawValue // change to filtered when we start storing it
      dictionary["unfiltered"] = ageAdjustedRawValue
    }
    dictionary["type"] = "sgv"
    dictionary["rssi"] = 100
    return dictionary
  }
  
  func calibrationRecordAsDictionary(calibrationRecord: Calibration) -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["device"] = "dexcom"
    dictionary["type"] = "cal"
    if let timeStamp = calibrationRecord.timeStamp {
      dictionary["date"] = timeStamp
      let timeStampDate = NSDate(timeIntervalSince1970: (timeStamp.doubleValue * 1000))
      dictionary["dateString"] = dateFormatter().stringFromDate(timeStampDate)
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
  
  func meterRecordAsDictionary(meterRecord: Calibration) -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["device"] = "dexcom"
    dictionary["type"] = "mbg"
    if let timeStamp = meterRecord.timeStamp {
      dictionary["date"] = timeStamp
      let timeStampDate = NSDate(timeIntervalSince1970: (timeStamp.doubleValue * 1000))
      dictionary["dateString"] = dateFormatter().stringFromDate(timeStampDate)
    }
    if let bg = meterRecord.bg {
      dictionary["mbg"] = bg
    }
    return dictionary
  }
  
  func deviceStatusAsDictionary() -> [String: AnyObject] {
    var dictionary = [String: AnyObject]()
    dictionary["uploaderBattery"] = 100
    return dictionary
  }
  
  func dateFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
    return formatter
  }
  
  enum Router: URLRequestConvertible {
    
    static let baseURL = NIGHTSCOUT_BASE_URI
    static var apiSecret: String?
    
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
        return "/entries"
      case .DeviceStatus:
        return "/devicestatus"
      }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
      let URL = NSURL(string: Router.baseURL)!
      let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
      mutableURLRequest.HTTPMethod = method.rawValue
      
      if let secret = Router.apiSecret?.sha1() {
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
}