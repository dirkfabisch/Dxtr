//
//  TransmitterData.swift
//  Dxtr
//
//  Created by Dirk on 19/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import CoreData

@objc(TransmitterData)
class TransmitterData: NSManagedObject, DebugPrintable, Printable {

  @NSManaged var uuid: String
  @NSManaged var rawData: Double
  @NSManaged var timeStamp: NSDate
  @NSManaged var sensorBatteryLeve: Int16
  
}

