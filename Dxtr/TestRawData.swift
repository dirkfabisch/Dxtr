//
//  TestRawData.swift
//  Dxtr
//
//  Created by Dirk on 23/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//
/**
*  Create a set of raw_data_for
*/


import Foundation
import CoreData

class TestRawData {
  
  // default battery level
  let sensorBatteryLevel : Int = 217
  
  func random(range: Range<Int>) -> Int {
    return range.startIndex + Int(arc4random_uniform(range.endIndex - range.startIndex + 1))
  }
  
  // create random values
  func createTestRawData(moc: NSManagedObjectContext) {
    
    // add raw data from the "past" by going back in time 495 minutes
    let startTime = NSDate().dateByAddingTimeInterval(PAST_TIME)

    for var num = 0; num < NUMBER_OF_READINGS; num++ {
      var td = TransmitterData(managedObjectContext: moc, timeStamp: (startTime.dateByAddingTimeInterval(Double(num * 300))))
      td.rawData = NSNumber(double: Double(random(170000...180000)))
      td.sensorBatteryLevel = NSNumber(int: Int32(sensorBatteryLevel))
      DxtrModel.sharedInstance.saveContext()
    }
  }

  // create on random test data value
  func createOneTestRawData(moc: NSManagedObjectContext) {
      var td = TransmitterData(managedObjectContext: moc)
      td.rawData = NSNumber(double: Double(random(170000...180000)))
      td.sensorBatteryLevel = NSNumber(int: Int32(sensorBatteryLevel))
      td.sendTDNewValueNotificcation()
      DxtrModel.sharedInstance.saveContext()
  }
  
}