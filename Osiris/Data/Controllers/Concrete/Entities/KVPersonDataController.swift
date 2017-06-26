/**
  KVPersonDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.
*/

import CoreLocation
import CoreData
import UIKit
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html
enum PersonTypes {
  case owner, friend, vendor
//  case owner(personType:String, personStatus:NSNumber)
}
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
  override func createEntityInContext(_ context: NSManagedObjectContext, type: String) -> T
  {
    let entityDescription = NSEntityDescription.entity(forEntityName: self.entityClassName!, in: context)
    let e = NSManagedObject(entity: entityDescription!, insertInto: context) as! T
    return e
  }
  func createPersonInContext(_ context: NSManagedObjectContext) -> T
  {
    let pDescription = NSEntityDescription.entity(forEntityName: (self.entityClassName)!, in: self.PSK.viewContext)
    let gDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Graphics), in: self.PSK.viewContext)
    let lDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Location), in: self.PSK.viewContext)
    let pxDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Physics), in: self.PSK.viewContext)
    
    let person = KVPerson(entity: pDescription!, insertInto: context) as! T
    let gfx = KVGraphics(entity: gDescription!, insertInto: context)
    let physx = KVPhysics(entity: pxDescription!, insertInto: context)
    let loc = KVLocation(entity: lDescription!, insertInto: context)
    
    gfx.owner = person
    physx.owner = person
    loc.owner = person
    
    person.graphics = gfx
    person.physics = physx
    person.location = loc
    //
    self.setupPerson(person)
    return person
  }
  func setupPerson(_ t: T)
  {
    self.setupGraphics(g: t.graphics!)
    self.setupLocation(l: t.location!)
    self.setupPhysics(p: t.physics!)
  }
  func setupGraphics(g :KVGraphics)
  {
    g.caption = "New"
    g.photoActual = UIImage()
    g.photoFileName = g.caption
    g.rating = 0.1
  }
  func setupLocation(l :KVLocation)
  {
    /**
    */
    l.latitude = 44
    l.longitude = 128
    l.altitude = 32
    l.heading = 1
    l.address = "NewAddress"
    l.postalCode = "10001"
    l.state = "New York"
  }
  func setupPhysics(p: KVPhysics)
  {
    p.massKG = 100
    p.xLong = 1
    p.yWide = 1
    p.zTall = 2
  }
  /**
  
  */
  
}
