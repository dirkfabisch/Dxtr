//
//  BTDiscovery.swift
//
//
//  Created by Dirk Fabisch on 18/1/14.
//  Copyright (c) 2014 base68.com, All rights reserved.
//

import Foundation
import CoreBluetooth

let btDiscoverySharedInstance = BTDiscovery();

class BTDiscovery: NSObject, CBCentralManagerDelegate {
  
  private let centralManager: CBCentralManager?
  private var peripheralBLE: CBPeripheral?
  
  override init() {
    super.init()
    let centralQueue = dispatch_queue_create("com.base68", DISPATCH_QUEUE_SERIAL)
    centralManager = CBCentralManager(delegate: self, queue: centralQueue)
  }
  
  func startScanning() {
    if let central = centralManager {
       central.scanForPeripheralsWithServices([BLEServiceUUID], options: nil)
  ()  }
  }
  
  var bleService: BTService? {
    didSet {
      if let service = self.bleService {
        logger.verbose("starDiscoveringService")
        service.startDiscoveringServices()
      }
    }
  }
  
  // MARK: - CBCentralManagerDelegate
  
  func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
    // Be sure to retain the peripheral or it will fail during connection.
    logger.verbose("++didDiscoverPeripheral")
    // Validate peripheral information
    if ((peripheral == nil) || (peripheral.name == nil) || (peripheral.name == "")) {
      logger.error("No Peripheral included")
      return
    }
    
    // If not already connected to a peripheral, then connect to this one
    if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.Disconnected)) {
      // Retain the peripheral before trying to connect
      self.peripheralBLE = peripheral
      
      // Reset service
      self.bleService = nil
      
      // Connect to peripheral
      central.connectPeripheral(peripheral, options: nil)
    }
  }
  
  func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
   
    logger.verbose("++didConnectPeripheral")
    if (peripheral == nil) {
      logger.error("No Peripheral included")
      return;
    }
    
    // Create new service class
    if (peripheral == self.peripheralBLE) {
      logger.verbose("// Create new service class")
      self.bleService = BTService(initWithPeripheral: peripheral)
    }
    
    // Stop scanning for new devices
    sendBTDiscoveryNotificationWithIsScanning(false)
    central.stopScan()
  }
  
  func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
    
    logger.verbose("++didDisconnectPeripheral")
    if (peripheral == nil) {
      logger.error("No Peripheral included")
      return;
    }
    
    // See if it was our peripheral that disconnected
    if (peripheral == self.peripheralBLE) {
      self.bleService = nil;
      self.peripheralBLE = nil;
    }
    
    // Start scanning for new devices
    self.startScanning()
  }
  
  // MARK: - Private
  
  func clearDevices() {
    self.bleService = nil
    self.peripheralBLE = nil
  }
  
  func centralManagerDidUpdateState(central: CBCentralManager!) {
    switch (central.state) {
    case CBCentralManagerState.PoweredOff:
      self.clearDevices()
      
    case CBCentralManagerState.Unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      break
      
    case CBCentralManagerState.Unknown:
      // Wait for another event
      break
      
    case CBCentralManagerState.PoweredOn:
      logger.verbose("start scanning")
      sendBTDiscoveryNotificationWithIsScanning(true)
      self.startScanning()
      
    case CBCentralManagerState.Resetting:
      self.clearDevices()
      
    case CBCentralManagerState.Unsupported:
      break
      
    default:
      break
    }
  }
  
  func sendBTDiscoveryNotificationWithIsScanning(isScaning: Bool) {
    let connectionDetails = ["isScanning": isScaning]
    NSNotificationCenter.defaultCenter().postNotificationName(BLEDiscoveryScanningNotification,
      object: self, userInfo: connectionDetails)
  }


}
