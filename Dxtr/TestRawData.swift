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
  let sensorBatteryLevel : Int32 = 217
  
  func random(range: Range<Int32>) -> Int32 {
    return range.startIndex + Int32(arc4random_uniform(range.endIndex - range.startIndex + 1))
  }
  
  // create random values
  func createTestRawData(moc: NSManagedObjectContext) {
    
    // add raw data from the "past" by going back in time 495 minutes
    let startTime = NSDate().dateByAddingTimeInterval(-29700)

    for var num = 0.0; num < 100; num++ {
      var td = TransmitterData(managedObjectContext: moc, timeStamp: (startTime.dateByAddingTimeInterval(num * 300)))
      td.rawData = NSNumber(int: random(170000...180000))
      td.sensorBatteryLevel = NSNumber(int: sensorBatteryLevel)
      DxtrModel.sharedInstance.saveContext()
    }
  }

  // create on random test data value
  func createOneTestRawData(moc: NSManagedObjectContext) {
      var td = TransmitterData(managedObjectContext: moc)
      td.rawData = NSNumber(int: random(170000...180000))
      td.sensorBatteryLevel = NSNumber(int: sensorBatteryLevel)
      td.sendTDNewValueNotificcation()
      DxtrModel.sharedInstance.saveContext()
  }
  
}