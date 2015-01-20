//
//  BTService.swift
//  Arduino_Servo
//
//  Created by Dirk Fabisch on 18/1/14.
//  Copyright (c) 2014 base68.com, All rights reserved.
//

import Foundation
import CoreBluetooth


class BTService: NSObject, CBPeripheralDelegate {
  var peripheral: CBPeripheral?
  var recieverCharacteristic: CBCharacteristic?
  
  init(initWithPeripheral peripheral: CBPeripheral) {
    super.init()
    
    self.peripheral = peripheral
    self.peripheral?.delegate = self
  }
  
  deinit {
    self.reset()
  }
  
  func startDiscoveringServices() {
    peripheral?.discoverServices([BLEServiceUUID])
  }
  
  func reset() {
    if peripheral != nil {
      peripheral = nil
    }
    
    // Deallocating therefore send notification
    self.sendBTServiceNotificationWithIsBluetoothConnected(false)
  }
  
  // Mark: - CBPeripheralDelegate
  
  func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
    //    let uuidsForBTService: [CBUUID] = [PositionCharUUID]
    
    if (peripheral != self.peripheral) {
      logger.error("Wrong Peripheral")
      return
    }
    
    if (error != nil) {
      return
    }
    
    logger.verbose("-- didDiscoverServices")
    
    let myPeripheral = peripheral
    let uuid = myPeripheral.identifier.UUIDString;
    
    if ((peripheral.services == nil) || (peripheral.services.count == 0)) {
      logger.error("No Services")
      return
    }
    
    for service in peripheral.services {
      if service.UUID == BLEServiceUUID {
        logger.verbose("matching BLE service")
        //        peripheral.discoverCharacteristics(uuidsForBTService, forService: service as CBService)
        peripheral.discoverCharacteristics(nil, forService: service as CBService)
      }
    }
  }
  
  func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
    if (peripheral != self.peripheral) {
      logger.error("Wrong Peripheral")
      return
    }
    
    if (error != nil) {
      logger.error("\(error.description)")
      return
    }
    logger.verbose(">> didDiscoversCharacteristics")
    for characteristic in service.characteristics {
      if characteristic.UUID == BLECharacteristicsUUID {
        recieverCharacteristic = (characteristic as CBCharacteristic)
        peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)

        logger.verbose("matching characteristics")
        
        // Send notification that Bluetooth is connected and all required characteristics are discovered
        sendBTServiceNotificationWithIsBluetoothConnected(true)
      }
    }
  }
  
  func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
    if (characteristic != recieverCharacteristic) {
      logger.error("Wrong Characteristcs")
      return
    }

    if (error != nil) {
      logger.error("\(error.description)")
      return
    }
    
    logger.verbose(">> didUpdateValueForCharacteristic")
    logger.verbose("\(characteristic.description)")
    logger.verbose("\(characteristic.value.description)")
    logger.verbose("Value Length: \(characteristic.value.length)")
    
  }
  
  func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
    let connectionDetails = ["isConnected": isBluetoothConnected]
    NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
  }
  
}