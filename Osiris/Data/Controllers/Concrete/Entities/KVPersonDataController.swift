/**
  KVPersonDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.
*/
protocol PersonConDelegate {
  func didChangePerson(_ entity: KVPerson)
  func willAddPerson(_ deli: Any?)
  //  func willMakeMessageFromPerson(_ person: KVPerson?)
  //  func willMakeNewPlaceHere(deli: Any?) -> ()
  //  func willAddNewEvent( _ deli: Any?)
}
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
  var delegate: PersonConDelegate?
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
  //MARK TODO: Add Health specific Datas
  func resetPersonDefaults(_ person: T)
  {
    self.setupEntity(person)
    person.firstName = maleNames[1]
    person.middleName = femaleNames[1]
    person.lastName = lastNames[1]
    person.emailID = person.firstName! + (".") + person.lastName! + "pony.edu"
    person.phoneNumber = "(555)abc-defg"
    person.textID  = person.firstName! + ("_") + person.lastName!
  }
  func setupRandomPerson(_ rndPerson: T)
  {
    setupRandomPersonName(rndPerson)
    rndPerson.phoneNumber = makeRandomPhoneNumber()
  }
  func setupRandomPersonName(_ rndNamedPerson: T)
  {
    if (makeRandomNumber(100)) > 50 {
      rndNamedPerson.firstName = femaleNames[makeRandomNumber(20)]
    } else {
      rndNamedPerson.firstName = maleNames[makeRandomNumber(20)]
    }
    if (makeRandomNumber(100)) > 80 {
      if (makeRandomNumber(100) < 25) {
        rndNamedPerson.middleName = femaleNames[makeRandomNumber(20)]
      } else {
        rndNamedPerson.middleName = maleNames[makeRandomNumber(20)]
      }
    } else {
      rndNamedPerson.middleName = ""
    }
  }
  /** ## Almost ##
   - Parameters:
     - set: _all().hexID_
     - t: \<T\>
  */
  func jiveDose(set: NSSet,t: T) {
    let hq = makeRandomHexQuad()
    while (!(set.contains(hq))) {
//      t.unitID = hq 
    }
    
    
  }
}
