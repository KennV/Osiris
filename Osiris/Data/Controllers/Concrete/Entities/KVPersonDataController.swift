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
  func createPersonInContext(_ context: NSManagedObjectContext) -> T
  {
    let pDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Person), in: self.PSK.viewContext)
    let gDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Graphics), in: self.PSK.viewContext)
    let lDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Location), in: self.PSK.viewContext)
    let pxDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Physics), in: self.PSK.viewContext)
    
    let person = KVPerson(entity: pDescription!, insertInto: context) as! T
    person.incepDate = NSDate()
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
    self.setupEntity(person)
    return person
  }
  /**
  
  */
  func makePerson()
  {
    let newPerson = self.createPersonInContext(self.PSK.viewContext)
    setupEntity(newPerson)
//    resetPersonDefaults(newPerson)
    setupRandomPerson(newPerson)
	// Now what can I assert in unit tests
  }
  func resetPersonDefaults(_ t: T)
  {
    t.firstName = maleNames[1]
    t.middleName = femaleNames[1]
    t.lastName = lastNames[1]
    t.emailID = t.firstName! + (".") + t.lastName! + "pony.edu"
    t.phoneNumber = "(555)abc-defg"
    t.textID  = t.firstName! + ("_") + t.lastName!
  }
  func setupRandomPerson(_ t: T)
  {
    setupRandomPersonName(t)
    makeUniqueHexQuad(t)
    t.phoneNumber = makeRandomPhoneNumber()
//    var arr = [String]()
//    for p in self.getAllEntities() {
//      arr.append(p.unitID!)
//    }
//    jiveDose(set: (NSSet(array: arr)), t: t)
  }
  func setupRandomPersonName(_ t: T)
  {
    if (makeRandomNumber(100)) > 50 {
      t.firstName = femaleNames[makeRandomNumber(20)]
    } else {
      t.firstName = maleNames[makeRandomNumber(20)]
    }
    if (makeRandomNumber(100)) > 80 {
      if (makeRandomNumber(100) < 25) {
        t.middleName = femaleNames[makeRandomNumber(20)]
      } else {
        t.middleName = maleNames[makeRandomNumber(20)]
      }
    } else {
      t.middleName = ""
    }
    
  }
  func jiveDose(set: NSSet,t: T) {
    let hq = makeRandomHexQuad()
    while (!(set.contains(hq))) {
//      t.unitID = hq 
    }
    
    
  }
}
