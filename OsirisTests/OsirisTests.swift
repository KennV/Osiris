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
  
  func setupPSK() -> NSPersistentContainer  {
    //    let st = "NSInMemoryStoreType" // storeType
    let container = NSPersistentContainer(name: "Osiris")
    container.loadPersistentStores(completionHandler: { (NSInMemoryStoreType, error) in
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
    })
    //    container.NSS
    return container
  }
  var MOC : NSManagedObjectContext? = nil
  func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext
  {
    
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    do {
      try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
      print("Adding in-memory persistent store coordinator failed")
    }
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    return managedObjectContext
  }
  override func setUp() {
    super.setUp()
    MOC = setUpInMemoryManagedObjectContext()
  }
  override func tearDown() {
    MOC = nil
    //    SUT_PSK = nil
    super.tearDown()
  }
  func entityControllerTest() {
    let testEDC = KVEntityDataController<KVEntity>()
    testEDC.PSK = self.SUT_PSK!
    let entityTestItem = testEDC.createEntityInContext(testEDC.PSK.viewContext, type: "Entity")
    
    XCTAssertNotNil((testEDC), "Failed to Create Entity Controller")
    XCTAssertNotNil(testEDC.PSK.viewContext, "Failed to Create MOC")
    XCTAssertNotNil(entityTestItem, "Failed to Create entity")
  }
  func baseTVCTest() {
    let tableViewController = KVPrimeTVController()
    XCTAssertEqual(0, tableViewController.objects.count)
    tableViewController.insertNewObject(self)
    XCTAssertEqual(1, tableViewController.objects.count)
    tableViewController.AllDataController = KVOsirisDataController(self.MOC!)
    XCTAssertNotNil(tableViewController.AllDataController.MOC, "Skurry ")
  }
  
}
