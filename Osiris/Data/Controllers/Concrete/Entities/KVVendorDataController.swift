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
  convenience init(_ ctx: NSManagedObjectContext)
  {
    self.init()
    self.entityClassName = EntityTypes.Vendor
    self.MOC = ctx
  }
}
