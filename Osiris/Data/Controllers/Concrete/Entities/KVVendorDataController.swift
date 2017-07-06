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
  override func createEntityInContext(_ context: NSManagedObjectContext, type: String) -> T
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: self.entityClassName!, in: context)
    let e = NSManagedObject(entity: entityDescription!, insertInto: context) as! T
    //    self.saveContext()
    return e
  }
  func createVendorInContext(_ context: NSManagedObjectContext) -> T
  {
    let vendorDesc = NSEntityDescription.entity(forEntityName: (self.entityClassName)!, in: self.PSK.viewContext)
    
    let graphicsDesc = NSEntityDescription.entity(forEntityName: (EntityTypes.Graphics), in: self.PSK.viewContext)
    let locDesc = NSEntityDescription.entity(forEntityName: (EntityTypes.Location), in: self.PSK.viewContext)
    let pxDesc = NSEntityDescription.entity(forEntityName: (EntityTypes.Physics), in: self.PSK.viewContext)

    let tmpVendor = KVPerson(entity: vendorDesc!, insertInto: context) as! T
    tmpVendor.incepDate = NSDate()
    
    let gfx = KVGraphics(entity: graphicsDesc!, insertInto: context)
    let physx = KVPhysics(entity: pxDesc!, insertInto: context)
    let loc = KVLocation(entity: locDesc!, insertInto: context)
    gfx.owner = tmpVendor
    physx.owner = tmpVendor
    loc.owner = tmpVendor
    
    tmpVendor.graphics = gfx
    tmpVendor.physics = physx
    tmpVendor.location = loc
    //
//    self.setupPerson(person)
    return tmpVendor
  }
  func makeVendor()
  {
    
  }

}
