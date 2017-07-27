/**
  KVSessionDataController.swift
  Osiris

  Created by Kenn Villegas on 7/8/17.
  Copyright © 2017 dubian. All rights reserved.

*/

import UIKit
import CoreData

class KVSessionDataController<T : KVSession> : KVItemDataController <T>
{
  override init()
  {
    super.init()
    self.entityClassName = EntityTypes.Session
    self.MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  func makeSession()
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: self.entityClassName!, in: self.PSK.viewContext)
    let _ = NSManagedObject(entity: entityDescription!, insertInto: self.PSK.viewContext) as! T
  }
}

