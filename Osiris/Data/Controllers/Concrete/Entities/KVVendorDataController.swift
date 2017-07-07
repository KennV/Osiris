/**
  KVVendorDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.
*/

import CoreLocation
import CoreData
import UIKit

class KVVendorDataController<T : KVVendor > : KVEntityDataController<T>
{
  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Vendor
    self.MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  func makeVendor()
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: self.entityClassName!, in: self.PSK.viewContext)
    let _ = NSManagedObject(entity: entityDescription!, insertInto: self.PSK.viewContext) as! T
  }

}
