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

// Define logging instance
let logger = XCGLogger.defaultInstance()
