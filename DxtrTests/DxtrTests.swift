//
//  DxtrTests.swift
//  DxtrTests
//
//  Created by Dirk on 11/01/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import XCTest
import CoreData

import Dxtr

class DxtrTests: XCTestCase {
  
  var moc:NSManagedObjectContext?
  var store:NSPersistentStore?
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let mom = NSManagedObjectModel.mergedModelFromBundles(nil)
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
    XCTAssertNotNil(psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil),"Should create in memory store" )
    self.store = psc.persistentStores[0] as? NSPersistentStore
    self.moc = NSManagedObjectContext()
    self.moc?.persistentStoreCoordinator = psc
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    store = nil
    moc = nil
  }
  
  /**
  Check that the setup code is working properly
  */
  func testThatEnvironmentWorks(){
    XCTAssertNotNil(moc, "no managed object context")
    XCTAssertNotNil(store, "no persistent store")
  }
  
  /**
  Try to create a working sensor in the past
  */
  func testCreateSensorWithTimeStampInThePast() {
    var ss = Sensor(managedObjectContext: moc!, timeStamp: NSDate().getTime() - 100000)
    XCTAssertNotNil(ss, "no Sensor created")
  }
  
  func testCreateSensorWithTimeStampInTheFuture() {
    var ss = Sensor(managedObjectContext: moc!, timeStamp: NSDate().getTime() + 100000)
    XCTAssertNil(ss, "Sensor created in the future")
  }
}
