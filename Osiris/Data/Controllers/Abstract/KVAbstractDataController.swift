//
//  KVAbstractDataController.swift
//  AresED-V
//
//  Created by Kenn Villegas on 11/23/15.
//  Copyright © 2015 K3nV. All rights reserved.
//

/*
 this gets called from the App Deli
 let controller = masterNavigationController.topViewController as! MasterViewController
 OR A NavKhan!!!
 controller.managedObjectContext = self.persistentContainer.viewContext
 
 Which I need to make in the vue
 */

import UIKit
import CoreData

class KVAbstractDataController<T : NSManagedObject> : NSObject
{
  // I made this optional Then set it in the init and then force-unwrap it in _.managedObjectModel
  var dbName : String = "Osiris"
  var entityClassName : String?
  var error : NSError?
  var copyDatabaseIfNotPresent : Bool = false
  var appName: String?  = "Osiris"

  lazy var PSK: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: self.appName!)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
    return container
  }()
  func saveContext () {
    let context = PSK.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  /// Baseline init() works in r\t & Test
  func createEntityInContext(_ context: NSManagedObjectContext, type: String) -> T
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: type, in: context)
    let e = NSManagedObject(entity: entityDescription!, insertInto: context) as! T
    return e
  }
  // MARK: - Fetched results controller  
  var fetchedResultsController: NSFetchedResultsController<T> {
    if _fetchedResultsController != nil {
      return _fetchedResultsController!
    }
    //let fetchRequest: NSFetchRequest<T> = KVRootEntity.fetchRequest()
    let fetchRequest = NSFetchRequest<T>(entityName: "KVRootEntity")
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "incepDate", ascending: false)
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.PSK.viewContext,
                                                               sectionNameKeyPath: nil, cacheName: "Master")
    //TODO: SET THE TV : THIS DELEGATE #GODOY
    //    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    do {
      try _fetchedResultsController!.performFetch()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    
    return _fetchedResultsController!
  }
  var _fetchedResultsController: NSFetchedResultsController<T>? = nil
}
