/**
  KVPersonDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.
*/

import CoreLocation
import CoreData
import UIKit

class KVPersonDataController<T : KVPerson > : KVEntityDataController<T>
{
  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Person
    self.MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  convenience init(_ ctx: NSManagedObjectContext)
  {
    self.init()
    self.entityClassName = EntityTypes.Person
    self.MOC = ctx
  }
}
