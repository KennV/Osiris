/**
  OsirisTests.swift
  OsirisTests

  Created by Kenn Villegas on 6/13/17.
  Copyright © 2017 dubian. All rights reserved.
*/

import XCTest
import CoreData

@testable import Osiris

class OsirisTests: XCTestCase {
  var SUT_PSK : NSPersistentContainer? = nil
  var MOC : NSManagedObjectContext? = nil

  func setupPSK() -> NSPersistentContainer
  {
    
    let container = NSPersistentContainer(name: "Osiris")
    container.loadPersistentStores(completionHandler:
      { (NSInMemoryStoreType, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    )
    self.MOC = container.viewContext
    return container
  }
  override func setUp()
  {
    super.setUp()
    SUT_PSK = setupPSK()
  }
  override func tearDown()
  {
    MOC = nil
    SUT_PSK = nil
    super.tearDown()
  }
  func testEntityController()
  {
    let testEDC = KVEntityDataController<KVEntity>()
    testEDC.PSK = self.SUT_PSK!
    let entityTestItem = testEDC.createEntityInContext(testEDC.PSK.viewContext, type: EntityTypes.Entity)
    
    XCTAssertNotNil((testEDC), "Failed to Create Entity Controller")
    XCTAssertNotNil(testEDC.PSK.viewContext, "Failed to Create MOC")
    XCTAssertNotNil(entityTestItem, "Failed to Create entity")
  }
  func testADController()
  {
    XCTAssertNotNil(KVOsirisDataController(ctx: (SUT_PSK?.viewContext)!), "Combi")
    
    let pTVC = KVPrimeTVController()
    pTVC.AllDataController.PSK = SUT_PSK!
    
    XCTAssertNotNil(pTVC.AllDataController.MOC, "No MOC")
    pTVC.personDataController.MOC = pTVC.AllDataController.MOC

    XCTAssertEqual(0, pTVC.AllDataController.getAllEntities().count)
    _ = pTVC.AllDataController.createEntityInContext((SUT_PSK?.viewContext)!, type: EntityTypes.RootEntity)
//    XCTAssertEqual(1, pTVC.AllDataController.getAllEntities().count)
    
//    XCTAssertEqual(0, pTVC.people.count)
    pTVC.personDataController.makePerson()
//    XCTAssertEqual(1, pTVC.people.count)
    
    XCTAssertNotNil(pTVC.AllDataController.makeRandomNumber(2))
    XCTAssertNotNil(pTVC.AllDataController.makeRandomNumberCurve(2, 6))
    XCTAssertNotNil(pTVC.AllDataController.makeRandomPhoneNumber())
    XCTAssertNotNil(pTVC.AllDataController.makeRandomHexQuad())
  }
  func testPDController()
  {
    let TVC = KVPrimeTVController()
    
    TVC.AllDataController.PSK = SUT_PSK!
    XCTAssertNotNil(TVC.AllDataController.MOC, "No MOC")
    
    TVC.personDataController.MOC = TVC.AllDataController.MOC
//    XCTAssertEqual(0, TVC.people.count)
    TVC.personDataController.makePerson()
//    XCTAssertEqual(1, TVC.people.count)
    // Currently only testing the one ivar from graphics, location and physics
    let joe = TVC.people[0]
    XCTAssertEqual("New", joe.graphics?.caption)
    XCTAssertEqual("NewAddress", joe.location?.address)
    XCTAssertEqual(100, joe.physics?.massKG)
    //
    XCTAssertEqual(joe, joe.graphics?.owner)
    XCTAssertEqual(joe, joe.location?.owner)
    XCTAssertEqual(joe, joe.physics?.owner)
  }
  func testVendorCon()
  {
    let vue = KVPrimeTVController()
    let testVendorDataController = vue.vendorDataController
    testVendorDataController.PSK = SUT_PSK!
    testVendorDataController.MOC = SUT_PSK?.viewContext
    
    XCTAssertEqual(0, testVendorDataController.getAllEntities().count)
//    let tj = testVendorDataController.createEntityInContext((testVendorDataController.MOC)!, type: EntityTypes.Vendor)
    let tj = testVendorDataController.createVendorInContext(testVendorDataController.MOC!)
    XCTAssertNotNil(tj)
    
    let testVendor = testVendorDataController.getAllEntities()[0]
    XCTAssertNotNil(testVendor)
    XCTAssertEqual(1, testVendorDataController.getAllEntities().count)
    //
    testVendorDataController.deleteEntityInContext((testVendorDataController.MOC)!, entity: testVendor)
    XCTAssertEqual(0, testVendorDataController.getAllEntities().count)
    testVendorDataController.makeVendor()
    XCTAssertEqual(1, testVendorDataController.getAllEntities().count)
  }
  func testSessionCon()
  {
    let vue = KVPrimeTVController()
    let sessCon = vue.sessionDataController
    sessCon.PSK = SUT_PSK!
    sessCon.MOC = SUT_PSK!.viewContext
    XCTAssertEqual(0, sessCon.getAllEntities().count, "Should be zero on  a fresh test")
    sessCon.makeSession()
    XCTAssertNotEqual(0, sessCon.getAllEntities().count, "Should be zero on  a fresh test")
    let jiveSess = sessCon.getAllEntities().first
    XCTAssertNotNil(jiveSess, "should be a session")
  }
/**
   OK What and why am I testing.
If I look at the coverage now it is at 32% WHich on teh surface is a lot of untested code, but then again it is ALSO code that does't directly get tested. like the basic AppKit Functionality.
*/
  func testV13() {
    let TVC = KVPrimeTVController()
    TVC.AllDataController.PSK = SUT_PSK!
    XCTAssertNotNil(TVC.AllDataController.MOC, "No MOC")
    
  }
  func testPOne() {
    //Corrected this context (ctx: (SUT_PSK?.viewContext)!) to what you see below ?
    let TVC = KVPrimeTVController()
    TVC.AllDataController.PSK = SUT_PSK!
    let PDC = KVPersonDataController(ctx: (SUT_PSK!.viewContext))
    for _ in 0 ... 1000 {
      PDC.makePerson()
    }
    XCTAssertNotNil(TVC.AllDataController.MOC, "No MOC")
    let  p:KVPerson = TVC.personDataController.createPersonInContext(SUT_PSK!.viewContext)
    XCTAssertNotNil(p, "nobody")
    TVC.personDataController.resetPersonDefaults(p)
    XCTAssertEqual(maleNames[1], p.firstName, "Entity name should be the Default Michael")
    //
    TVC.personDataController.setupRandomPerson(p)
  }
  
}
