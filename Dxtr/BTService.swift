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
  
    if (!Sensor.isSensorActive(DxtrModel.sharedInstance.managedObjectContext!)) {
      // we have no active sensor -> do nothing
      return
    }
    
    if (characteristic != recieverCharacteristic) {
      logger.error("Wrong Characteristcs")
      return
    }

    if (error != nil) {
      logger.error("\(error.description)")
      return
    }
    
    logger.verbose(">> didUpdateValueForCharacteristic")
    // Check if we got a whole data tuple
    // Sometimes HM-10 Sends batterie status and sensor data seperatly
    if (characteristic.value.length < 6) {
      logger.warning("Only battery status recieved")
      return
    }
    
    if let datastring = NSString(data:characteristic.value, encoding: NSUTF8StringEncoding) {
      // data array should look like this if complete
      // [0] sensor raw data
      // [1] battery level of the sensor
      // [2] battery level of the wixel HW
      // data array should look like this if only raw data
      // [0] sensor raw data
      // [1] battery level of the wixel HW
      
      // split the datastring
      var data_components = datastring.componentsSeparatedByString(" ")
      
      fileLog.debug("\(data_components)")

      // check if we have a reading with battery reading
      // their are 3 elements in the data array
      if data_components.count > 2 {
        // Create the database object
        var transmitterData = TransmitterData(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!)
        transmitterData.rawData = NSNumber(double: (data_components[0] as NSString).doubleValue)
        transmitterData.sensorBatteryLevel = NSNumber(int:(data_components[1] as NSString).intValue)
        transmitterData.sendTDNewValueNotificcation()
      } else {
        if ((data_components[0] as Int) < 1000) {
          logger.warning("we recieved only a batterie reading")
          return
        } else {
          // Create the database object
          var transmitterData = TransmitterData(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!)
          transmitterData.rawData = NSNumber(double:(data_components[0] as NSString).doubleValue)
          transmitterData.sendTDNewValueNotificcation()
        }
      }
      
      // save data
      DxtrModel.sharedInstance.saveContext()
    } else {
      logger.error("Could not convert data from sensor")
      return
    }
    
    
  }
  
  func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
    let connectionDetails = ["isConnected": isBluetoothConnected]
    NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
  }
  
}