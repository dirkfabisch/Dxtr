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

  // raw data structure
  struct rawData {
    var interval : Int
    var raw : Double
  }
  
  // array with all the raw data from the reale readingsw for testing reasons
  let rawArray : [rawData] = [
    rawData(interval: 00, raw: 157984),
    rawData(interval: 05, raw: 159712),
    rawData(interval: 10, raw: 163488),
    rawData(interval: 15, raw: 164320),
    rawData(interval: 20, raw: 168096),
    rawData(interval: 25, raw: 168800),
    rawData(interval: 30, raw: 167680),
    rawData(interval: 35, raw: 169888),
    rawData(interval: 50, raw: 169888),
    rawData(interval: 55, raw: 168128),
    rawData(interval: 00, raw: 166848),
    rawData(interval: 05, raw: 165184),
    rawData(interval: 10, raw: 164064),
    rawData(interval: 15, raw: 162464),
    rawData(interval: 20, raw: 161248),
    rawData(interval: 30, raw: 162016),
    rawData(interval: 35, raw: 165728),
    rawData(interval: 40, raw: 172608),
    rawData(interval: 45, raw: 176960),
    rawData(interval: 50, raw: 175680),
    rawData(interval: 55, raw: 177024),
    rawData(interval: 00, raw: 175968),
    rawData(interval: 05, raw: 175584),
    rawData(interval: 10, raw: 172640),
    rawData(interval: 15, raw: 171712),
    rawData(interval: 20, raw: 171072),
    rawData(interval: 25, raw: 169440),
    rawData(interval: 30, raw: 170624),
    rawData(interval: 35, raw: 170432),
    rawData(interval: 40, raw: 170976),
    rawData(interval: 45, raw: 171008),
    rawData(interval: 50, raw: 175840),
    rawData(interval: 55, raw: 176512),
    rawData(interval: 00, raw: 180256),
    rawData(interval: 05, raw: 181632),
    rawData(interval: 05, raw: 181472),
    rawData(interval: 10, raw: 182144),
    rawData(interval: 15, raw: 181760),
    rawData(interval: 20, raw: 183872),
    rawData(interval: 25, raw: 186400),
    rawData(interval: 30, raw: 185184),
    rawData(interval: 35, raw: 184000),
    rawData(interval: 40, raw: 180864),
    rawData(interval: 45, raw: 177984),
    rawData(interval: 50, raw: 175104),
    rawData(interval: 55, raw: 171488),
    rawData(interval: 00, raw: 166496),
    rawData(interval: 05, raw: 162080),
    rawData(interval: 10, raw: 158176),
    rawData(interval: 15, raw: 154688),
    rawData(interval: 20, raw: 151136),
    rawData(interval: 25, raw: 147904),
    rawData(interval: 30, raw: 143840),
    rawData(interval: 35, raw: 138912),
    rawData(interval: 40, raw: 135296),
    rawData(interval: 45, raw: 133088),
    rawData(interval: 55, raw: 124832),
    rawData(interval: 00, raw: 123840),
    rawData(interval: 05, raw: 122096),
    rawData(interval: 10, raw: 121440),
    rawData(interval: 15, raw: 121888),
    rawData(interval: 20, raw: 122432),
    rawData(interval: 25, raw: 123328),
    rawData(interval: 30, raw: 123728),
    rawData(interval: 35, raw: 123600),
    rawData(interval: 40, raw: 123616),
    rawData(interval: 45, raw: 124864),
    rawData(interval: 50, raw: 126752),
    rawData(interval: 00, raw: 136512),
    rawData(interval: 05, raw: 139360),
    rawData(interval: 10, raw: 138528),
    rawData(interval: 15, raw: 138848),
    rawData(interval: 20, raw: 139008),
    rawData(interval: 25, raw: 141312),
    rawData(interval: 30, raw: 146752),
    rawData(interval: 35, raw: 150560),
    rawData(interval: 10, raw: 150720),
    rawData(interval: 15, raw: 153856),
    rawData(interval: 20, raw: 156608),
    rawData(interval: 30, raw: 173088),
    rawData(interval: 55, raw: 193376),
    rawData(interval: 05, raw: 192416),
    rawData(interval: 10, raw: 186560),
    rawData(interval: 15, raw: 181728),
    rawData(interval: 30, raw: 153824),
    rawData(interval: 35, raw: 153664),
    rawData(interval: 40, raw: 147840),
    rawData(interval: 45, raw: 145024),
    rawData(interval: 50, raw: 146720),
    rawData(interval: 55, raw: 145760),
    rawData(interval: 00, raw: 151264),
    rawData(interval: 05, raw: 159264),
    rawData(interval: 10, raw: 166944),
    rawData(interval: 15, raw: 170880),
    rawData(interval: 20, raw: 175040),
    rawData(interval: 25, raw: 181440),
    rawData(interval: 30, raw: 185504),
    rawData(interval: 35, raw: 188000),
    rawData(interval: 40, raw: 189280),
    rawData(interval: 45, raw: 191648),
    rawData(interval: 50, raw: 196448),
    rawData(interval: 55, raw: 199392),
    rawData(interval: 00, raw: 204800),
    rawData(interval: 05, raw: 207584),
    rawData(interval: 10, raw: 208576),
    rawData(interval: 15, raw: 210464),
    rawData(interval: 20, raw: 219136),
    rawData(interval: 25, raw: 223552),
    rawData(interval: 30, raw: 225952),
    rawData(interval: 35, raw: 232032),
    rawData(interval: 40, raw: 235456),
    rawData(interval: 45, raw: 240160),
    rawData(interval: 50, raw: 249888),
    rawData(interval: 55, raw: 259328),
    rawData(interval: 00, raw: 261920),
    rawData(interval: 05, raw: 261344),
    rawData(interval: 10, raw: 268224),
    rawData(interval: 25, raw: 260928),
    rawData(interval: 40, raw: 257856),
    rawData(interval: 45, raw: 253664),
    rawData(interval: 50, raw: 249856),
    rawData(interval: 55, raw: 247488),
    rawData(interval: 00, raw: 246400),
    rawData(interval: 05, raw: 228288),
    rawData(interval: 10, raw: 232544),
    rawData(interval: 15, raw: 231840),
    rawData(interval: 20, raw: 230688),
    rawData(interval: 15, raw: 193792),
    rawData(interval: 20, raw: 191296),
    rawData(interval: 25, raw: 188000),
    rawData(interval: 30, raw: 186304),
    rawData(interval: 35, raw: 182176),
    rawData(interval: 05, raw: 170496),
    rawData(interval: 10, raw: 170944),
    rawData(interval: 15, raw: 169184),
    rawData(interval: 30, raw: 188192),
    rawData(interval: 35, raw: 191232),
    rawData(interval: 40, raw: 190848),
    rawData(interval: 45, raw: 195136),
    rawData(interval: 50, raw: 199360),
    rawData(interval: 55, raw: 200480),
    rawData(interval: 00, raw: 200512),
    rawData(interval: 05, raw: 200704),
    rawData(interval: 10, raw: 201120),
    rawData(interval: 15, raw: 200256),
    rawData(interval: 20, raw: 201248),
    rawData(interval: 25, raw: 203328),
    rawData(interval: 40, raw: 209024),
    rawData(interval: 50, raw: 210240),
    rawData(interval: 55, raw: 209984),
    rawData(interval: 00, raw: 210816),
    rawData(interval: 05, raw: 213504),
    rawData(interval: 10, raw: 213504),
    rawData(interval: 15, raw: 213728),
    rawData(interval: 20, raw: 215264),
    rawData(interval: 25, raw: 216768),
    rawData(interval: 50, raw: 241504),
    rawData(interval: 55, raw: 238720),
    rawData(interval: 00, raw: 234720),
    rawData(interval: 05, raw: 230208),
    rawData(interval: 10, raw: 227808),
    rawData(interval: 15, raw: 227520),
    rawData(interval: 20, raw: 224768),
    rawData(interval: 25, raw: 219328),
    rawData(interval: 30, raw: 215648),
    rawData(interval: 35, raw: 206912),
    rawData(interval: 40, raw: 211136),
    rawData(interval: 45, raw: 213344),
    rawData(interval: 50, raw: 211872),
    rawData(interval: 40, raw: 232640),
    rawData(interval: 55, raw: 237760),
    rawData(interval: 00, raw: 229216),
    rawData(interval: 05, raw: 232864),
    rawData(interval: 10, raw: 233440),
    rawData(interval: 15, raw: 229440),
    rawData(interval: 30, raw: 221760),
    rawData(interval: 45, raw: 215840),
    rawData(interval: 50, raw: 209312),
    rawData(interval: 55, raw: 208480),
    rawData(interval: 00, raw: 207072),
    rawData(interval: 05, raw: 195808),
    rawData(interval: 10, raw: 188480),
    rawData(interval: 15, raw: 177024),
    rawData(interval: 20, raw: 167552),
    rawData(interval: 25, raw: 159840),
    rawData(interval: 30, raw: 152928),
    rawData(interval: 35, raw: 144544),
    rawData(interval: 45, raw: 136416),
    rawData(interval: 05, raw: 134720),
    rawData(interval: 25, raw: 137600),
    rawData(interval: 30, raw: 136704),
    rawData(interval: 35, raw: 131392),
    rawData(interval: 40, raw: 132640),
    rawData(interval: 50, raw: 124592),
    rawData(interval: 55, raw: 135936),
    rawData(interval: 10, raw: 138560),
    rawData(interval: 15, raw: 137312),
    rawData(interval: 20, raw: 140352),
    rawData(interval: 25, raw: 144800),
    rawData(interval: 30, raw: 147808),
    rawData(interval: 35, raw: 152608),
    rawData(interval: 40, raw: 157984),
    rawData(interval: 45, raw: 163456),
    rawData(interval: 50, raw: 167232),
    rawData(interval: 00, raw: 170432),
    rawData(interval: 05, raw: 168352),
    rawData(interval: 10, raw: 169280),
    rawData(interval: 15, raw: 170432),
    rawData(interval: 20, raw: 170624),
    rawData(interval: 25, raw: 168672),
    rawData(interval: 30, raw: 169216),
    rawData(interval: 35, raw: 165024),
    rawData(interval: 40, raw: 163648),
    rawData(interval: 45, raw: 164128),
    rawData(interval: 50, raw: 162912),
    rawData(interval: 00, raw: 162624),
    rawData(interval: 05, raw: 164832),
    rawData(interval: 10, raw: 163488),
    rawData(interval: 20, raw: 168064),
    rawData(interval: 25, raw: 169440),
    rawData(interval: 30, raw: 173504),
    rawData(interval: 35, raw: 183552),
    rawData(interval: 40, raw: 189824),
    rawData(interval: 45, raw: 192224),
    rawData(interval: 50, raw: 191104),
    rawData(interval: 55, raw: 187808),
    rawData(interval: 10, raw: 177792),
    rawData(interval: 10, raw: 174432),
    rawData(interval: 15, raw: 173344),
    rawData(interval: 20, raw: 171680),
    rawData(interval: 25, raw: 172256),
    rawData(interval: 35, raw: 168096),
    rawData(interval: 40, raw: 168128),
    rawData(interval: 45, raw: 166976)
  ]
  

  
//  func random(range: Range<Int>) -> Int {
//    return range.startIndex + Int(arc4random_uniform(range.endIndex - range.startIndex + 1))
//  }
//  
  // create random values
  func createTestRawData(moc: NSManagedObjectContext) {
    
    // add raw data from the "past" by going back in time 495 minutes
    let startTime = NSDate().dateByAddingTimeInterval(PAST_TIME)

    for var num = 0; num < NUMBER_OF_READINGS; num++ {
      var td = TransmitterData(managedObjectContext: moc, timeStamp: (startTime.dateByAddingTimeInterval(Double(num * 300)).getTime()))
//      td.rawData = NSNumber(double: Double(random(170000...180000)))
      td.sensorBatteryLevel = NSNumber(int: Int32(sensorBatteryLevel))
      DxtrModel.sharedInstance.saveContext()
    }
  }

  // create on random test data value
  func createOneTestRawData(moc: NSManagedObjectContext, rd: rawData) {
      var td = TransmitterData(managedObjectContext: moc)
//      td.rawData = NSNumber(double: Double(random(170000...180000)))
      td.sensorBatteryLevel = NSNumber(int: Int32(sensorBatteryLevel))
      td.sendTDNewValueNotificcation()
      DxtrModel.sharedInstance.saveContext()
  }
  
  
}
