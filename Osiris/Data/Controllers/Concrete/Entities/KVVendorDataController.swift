/**
  KVVendorDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.

*/


import CoreLocation
import CoreData
import UIKit

enum VendorTypes {
  case sessionProvider
}

protocol VendorConDelegate {
  
}
extension KVVendor {
  
}

class KVVendorDataController<T : KVVendor > : KVEntityDataController<T>
{
  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Vendor
    self.MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  
  /**
  ## Make a Vendor ##
  
  - Parameter context: MOC
  - Returns: T: \<T\>
  */
  func createVendorInContext(_ context:NSManagedObjectContext) -> T
  {
    let vDesc = NSEntityDescription.entity(forEntityName: (EntityTypes.Vendor), in: context)
    //
    //
    let v = KVVendor(entity: vDesc!, insertInto: context)as! T
    resetVendorDefaults(v)
    return v
  }
  func makeVendor()
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: self.entityClassName!, in: self.PSK.viewContext)
    let _ = NSManagedObject(entity: entityDescription!, insertInto: self.PSK.viewContext) as! T
  }
  func resetVendorDefaults(_ vendor: T)
  {
    
  }

}
