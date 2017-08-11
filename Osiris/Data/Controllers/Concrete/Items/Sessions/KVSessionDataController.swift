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
    let _ = self.createSessionInContext(self.MOC)
  }
  func createSessionInContext(_ context: NSManagedObjectContext) -> T
  {
    let sDesc = NSEntityDescription.entity(forEntityName: EntityTypes.Session, in: context)
    let s = KVSession(entity: sDesc!, insertInto: context)as! T
    return s
  }
}

