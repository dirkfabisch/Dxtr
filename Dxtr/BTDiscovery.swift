//
//  BTDiscovery.swift
//
//
//  Created by Dirk Fabisch on 18/1/14.
//  Copyright (c) 2014 base68.com, All rights reserved.
//

import Foundation
import CoreBluetooth

class BTDiscovery: NSObject, CBCentralManagerDelegate {
  
  private var centralManager: CBCentralManager?
  private var peripheralBLE: CBPeripheral?
  
  private var connected: Bool = false {
    didSet {
      if (!oldValue && connected) || (oldValue && !connected) {
        notifyConnectionChanged(connected)
      }
    }
  }

  private var bleService: BTService? {
    didSet {
      if let service = self.bleService {
        logger.verbose("startDiscoveringServices")
        service.startDiscoveringServices()
      }
    }
  }
  
  class var sharedInstance: BTDiscovery {
    struct Singleton {
      static let instance: BTDiscovery = BTDiscovery()
    }
    return Singleton.instance
  }
  
  override init() {
    super.init()
    let centralQueue = dispatch_queue_create("com.base68", DISPATCH_QUEUE_SERIAL)
    self.centralManager = CBCentralManager(delegate: self, queue: centralQueue, options:[CBCentralManagerOptionRestoreIdentifierKey: "bleCentralManager"])
    //    self.centralManager = CBCentralManager(delegate: self, queue: centralQueue, options:[CBCentralManagerOptionRestoreIdentifierKey: "bleCentralManager"])
  }
  
  // MARK: - Private
  
  func startScanning() {
    if let central = centralManager {
      let connectedPeripherals = central.retrieveConnectedPeripheralsWithServices([BLEServiceUUID])
      if connectedPeripherals.count > 0 {
        clearDevices()
        let existingPeripheral = connectedPeripherals[0] as? CBPeripheral
        self.centralManager?.cancelPeripheralConnection(existingPeripheral)
        startScanning()
      } else {
        notifyScanning(true)
        central.scanForPeripheralsWithServices([BLEServiceUUID], options: nil)
      }
    }
  }
  
  func clearDevices() {
    self.bleService = nil
    self.peripheralBLE = nil
  }
  
  func notifyScanning(isScanning: Bool) {
    let connectionDetails = ["isScanning": isScanning]
    NSNotificationCenter.defaultCenter().postNotificationName(BLEDiscoveryScanningNotification,
      object: self, userInfo: connectionDetails)
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
    
    self.connected = true
    
    // Create new service class
    if (peripheral == self.peripheralBLE) {
      logger.verbose("// Create new service class")
      self.bleService = BTService(initWithPeripheral: peripheral)
    }
    
    // Stop scanning for new devices
    notifyScanning(false)
    central.stopScan()
  }
  
  func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
    
    logger.verbose("++didDisconnectPeripheral")
    if (peripheral == nil) {
      logger.error("No Peripheral included")
      return;
    }
    
    self.connected = false
    
    // See if it was our peripheral that disconnected
    if (peripheral == self.peripheralBLE) {
      self.bleService = nil;
      self.peripheralBLE = nil;
    }
    
    // Start scanning for new devices
    startScanning()
  }
  
  func centralManager(central: CBCentralManager!, willRestoreState dict: [NSObject : AnyObject]!) {
    
  }
  
  func centralManagerDidUpdateState(central: CBCentralManager!) {

    switch (central.state) {
    case CBCentralManagerState.PoweredOff:
      logger.verbose("Bluetooth is powered off")
      clearDevices()
      break;
    case CBCentralManagerState.Unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      logger.error("App not authorized to use BLE")
      break
    case CBCentralManagerState.Unknown:
      logger.error("State of central manager is unknown")
      // Wait for another event
      break
    case CBCentralManagerState.PoweredOn:
      logger.verbose("Bluetooth is powered on")
      startScanning()
    case CBCentralManagerState.Resetting:
      logger.verbose("Bluetooth connection was reset")
      clearDevices()
      break;
    case CBCentralManagerState.Unsupported:
      logger.error("Device does not support BLE")
      break
    default:
      break
    }

  }
  
  func notifyConnectionChanged(connected: Bool) {
    NSNotificationCenter.defaultCenter().postNotificationName(BLEConnectionChangedNotification, object: self, userInfo: ["isConnected": connected])
  }

}
