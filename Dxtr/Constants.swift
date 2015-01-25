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
let START_TIME_OF_SENSOR = NSDate().dateByAddingTimeInterval(Double(PAST_TIME+(-7200)))

// calculation constant
let MMOLL_TO_MGDL = 18.0182
let MGDL_TO_MMOLL = 1 / MMOLL_TO_MGDL