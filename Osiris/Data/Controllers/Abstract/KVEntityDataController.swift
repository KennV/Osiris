/**
  KVEntityDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.

  Entities are Named World Objects. People Places and Things if you will;
  These are seperate from Items which are Goods and Services
  this is still one Level Abstracted from Person and Vendor

*/

import CoreLocation
import CoreData
import UIKit

class KVEntityDataController<T : KVEntity > : KVOsirisDataController<T>
{
  func setupEntity(_ KVEntity: T)
  {
    KVEntity.unitID = NSUUID().uuidString
    setupGraphics(g: KVEntity.graphics!)
    setupLocation(l: KVEntity.location!)
    setupPhysics(p: KVEntity.physics!)
    _ = saveEntity(entity: KVEntity)
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
}
