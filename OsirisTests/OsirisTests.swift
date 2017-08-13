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
  var PSK : NSPersistentContainer? = nil
  var testMOC : NSManagedObjectContext? = nil
  var SUT = KVPrimeTVController()

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
    testMOC = container.viewContext
    return container
  }
  override func setUp()
  {
    super.setUp()
    PSK = setupPSK()
    SUT.AllDataController.PSK = PSK!
    SUT.AllDataController.MOC = PSK!.viewContext
    SUT.personDataController.PSK = SUT.AllDataController.PSK
    SUT.personDataController.MOC = SUT.AllDataController.MOC
    SUT.vendorDataController.PSK = SUT.AllDataController.PSK
    SUT.vendorDataController.MOC = SUT.AllDataController.MOC
    SUT.sessionDataController.PSK = SUT.AllDataController.PSK
    SUT.sessionDataController.MOC = SUT.AllDataController.MOC
  }
  override func tearDown()
  {
    testMOC = nil
    PSK = nil
    super.tearDown()
  }
  func testADController()
  {
    XCTAssertNotNil(KVOsirisDataController(ctx: (PSK?.viewContext)!), "Combi")
    
//    let vue = KVPrimeTVController()
    XCTAssertNotNil(SUT.AllDataController.MOC, "No MOC")
    
    SUT.personDataController.MOC = SUT.AllDataController.MOC
    _ = SUT.AllDataController.createEntityInContext((PSK?.viewContext)!, type: EntityTypes.RootEntity)
    
    SUT.personDataController.makePerson()
    
    XCTAssertNotNil(SUT.AllDataController.makeRandomNumber(2))
    XCTAssertNotNil(SUT.AllDataController.makeRandomNumberCurve(2, 6))
    XCTAssertNotNil(SUT.AllDataController.makeRandomPhoneNumber())
    XCTAssertNotNil(SUT.AllDataController.makeRandomHexQuad())
  }
  func testEntityController()
  {
    let testEDC = KVEntityDataController<KVEntity>()
    testEDC.PSK = PSK!
    let entityTestItem = testEDC.createEntityInContext(testEDC.PSK.viewContext, type: EntityTypes.Entity)
    
    XCTAssertNotNil((testEDC), "Failed to Create Entity Controller")
    XCTAssertNotNil(testEDC.MOC, "Failed to Create MOC")
    XCTAssertNotNil(entityTestItem, "Failed to Create entity")
  }
  func testPDController()
  {
//    let vue = KVPrimeTVController()
    XCTAssertNotNil(SUT.AllDataController.MOC, "No MOC")
    XCTAssertNotNil(SUT.people, "No ppl arr")
    SUT.personDataController.makePerson()
    // Currently only testing the one ivar from graphics, location and physics
    let joe = SUT.people[0]
    XCTAssertEqual("New", joe.graphics?.caption)
    XCTAssertEqual("NewAddress", joe.location?.address)
    XCTAssertEqual(100, joe.physics?.massKG)

    XCTAssertEqual(joe, joe.graphics?.owner)
    XCTAssertEqual(joe, joe.location?.owner)
    XCTAssertEqual(joe, joe.physics?.owner)
  }
  func testVendorCon()
  {
    SUT.vendorDataController.PSK = PSK!
    SUT.vendorDataController.MOC = PSK?.viewContext
    XCTAssertNotNil(SUT.vendors, "Nil vndr arr")
    XCTAssertEqual(0, SUT.vendorDataController.getAllEntities().count)
//    let tj = testVendorDataController.createEntityInContext((testVendorDataController.MOC)!, type: EntityTypes.Vendor)
    let tj = SUT.vendorDataController.createVendorInContext(SUT.vendorDataController.MOC!)
    XCTAssertNotNil(tj)
    
    let testVendor = SUT.vendorDataController.getAllEntities()[0]
    XCTAssertNotNil(testVendor)
    XCTAssertEqual(1, SUT.vendorDataController.getAllEntities().count)
    //
    SUT.vendorDataController.deleteEntityInContext((SUT.vendorDataController.MOC)!, entity: testVendor)
    XCTAssertEqual(0, SUT.vendorDataController.getAllEntities().count)
    SUT.vendorDataController.makeVendor()
    XCTAssertEqual(1, SUT.vendorDataController.getAllEntities().count)
  }
  func testSessionCon()
  {
    XCTAssertNotNil(SUT.sessions, "Nil Sessions")
    XCTAssertEqual(0, SUT.sessionDataController.getAllEntities().count, "Should be zero on  a fresh test")
    SUT.sessionDataController.makeSession()
    XCTAssertNotEqual(0, SUT.sessionDataController.getAllEntities().count, "Should be zero on  a fresh test")
    let jiveSess = SUT.sessionDataController.getAllEntities().first
    XCTAssertNotNil(jiveSess, "should be a session")
  }
  func testV13()
  {
//    let TVC = KVPrimeTVController()
//    TVC.AllDataController.PSK = SUT_PSK!
//    XCTAssertNotNil(TVC.AllDataController.MOC, "No MOC")
    
  }
  func testPOne()
  {
    for _ in 0 ... 1000 {
      SUT.personDataController.makePerson()
    }
    XCTAssertNotNil(SUT.AllDataController.MOC, "No MOC")
    let  p:KVPerson = SUT.personDataController.createPersonInContext(PSK!.viewContext)
    XCTAssertNotNil(p, "nobody")
    SUT.personDataController.resetPersonDefaults(p)
    XCTAssertEqual(maleNames[1], p.firstName, "Entity name should be the Default Michael")
    //
    SUT.personDataController.setupRandomPerson(p)
  }
  
}
