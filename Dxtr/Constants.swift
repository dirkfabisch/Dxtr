//
//  Constants.swift
//  Dxtr
//
//  Created by Dirk on 12/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import CoreBluetooth
import XCGLogger

/* Services & Characteristics UUIDs */
let BLESPeripheralUUID = CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb")
let BLECharacteristicsUUID = CBUUID(string: "0000ffe1-0000-1000-8000-00805f9b34fb")
let BLEServiceUUID = CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb")
//let BLEServiceUUID = CBUUID(string: "FFE0")

// Notifications
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"
let BLEDiscoveryScanningNotification = "kBLEDiscoveryScanningNotification"
// Notification Send if new Value comes from the transmitter
let TDNewValueNotificcation = "kTDNewValueNotificcation"

// Define logging instance
let logger = XCGLogger.defaultInstance()

// logging instance for file logging
let fileLog = XCGLogger()

// all values for a simulated run on simulator
let NUMBER_OF_READINGS = 100
let PAST_TIME:Double = -29700 // 495 Minutes == 100 Readings
let START_TIME_OF_SENSOR : NSTimeInterval = round(NSDate().dateByAddingTimeInterval(Double(PAST_TIME+(-7200))).getTime())

// calculation constant
let MMOLL_TO_MGDL = 18.0182
let MGDL_TO_MMOLL = 1 / MMOLL_TO_MGDL

//TODO: Have these as adjustable settings!!

let READINGS_BESTOFFSET = Double(60000 * 0) // Assume readings are about x minutes off from actual!

let NIGHTSCOUT_UPLOAD_ENABLED_PREFERENCE = "nightscout_upload_enabled"
let NIGHTSCOUT_URL_PREFERENCE = "nightscout_url"
let NIGHTSCOUT_API_SECRET_PREFERENCE = "nightscout_api_secret"
let NIGHTSCOUT_API_SECRET_MIN_LENGTH = 12

// extension  for handling time in the same way than android 
// avoids confusion in calculation with time and values
extension NSDate {
  func getTime() -> NSTimeInterval {
    return round(self.timeIntervalSince1970 * 1000)
  }
  
  func getDateWithZeroSeconds() -> NSDate {
    let time = floor(self.timeIntervalSince1970 / 60.0) * 60.0;
    return NSDate(timeIntervalSince1970: time)
  }
  
}

// extension for gettimg a real date from the double values in time stamps
extension Double {
  func getDate() -> NSDate {
    var ts = self
    return NSDate(timeIntervalSince1970: round(ts/1000))
  }
}
