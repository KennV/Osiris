/**
  KVPersonDataController.swift
  Osiris

  Created by Kenn Villegas on 6/20/17.
  Copyright © 2017 dubian. All rights reserved.
*/


import CoreLocation
import CoreData
import UIKit

protocol PersonConDelegate {
  func didChangePerson(_ t: KVPerson)
  func willAddPerson(_ deli: Any?)
  //  func willMakeMessageFromPerson(_ person: KVPerson?)
  //  func willMakeNewPlaceHere(deli: Any?) -> ()
  //  func willAddNewEvent( _ deli: Any?)
}

extension KVPerson {

}
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
    entityClassName = EntityTypes.Person
    MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  
  /** 
  ## Make a People ##

  - Parameter context: MOC
  - Returns: T: \<T\>
  */
  func createPersonInContext(_ context: NSManagedObjectContext) -> T
  {
    let pDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Person), in: PSK.viewContext)
    let gDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Graphics), in: PSK.viewContext)
    let lDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Location), in: PSK.viewContext)
    let pxDescription = NSEntityDescription.entity(forEntityName: (EntityTypes.Physics), in: PSK.viewContext)
    
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
    setupEntity(person)
    return person
  }
  /**
  
  */
  func makePerson()
  {
    let newPerson = createPersonInContext(PSK.viewContext)
    setupEntity(newPerson)
//    resetPersonDefaults(newPerson)
    setupRandomPerson(newPerson)
	// Now what can I assert in unit tests
  }
  
  //MARK TODO: Add Health specific Datas
  func resetPersonDefaults(_ person: T)
  {
    setupEntity(person)
    person.firstName = maleNames[1]
    person.middleName = femaleNames[1]
    person.lastName = lastNames[1]
    person.emailID = person.firstName! + (".") + person.lastName! + "pony.edu"
    person.phoneNumber = "(555)abc-defg"
    person.textID  = person.firstName! + ("_") + person.lastName!
  }

  func resetPersonToEditMeState(_ person: T)
  {
    let edString = "Edit-Me"
    setupEntity(person)
    person.firstName = edString
    person.middleName = edString
    person.lastName = edString
    person.qName = edString
    person.emailID = edString + ("_") + edString
    person.phoneNumber = "(555)" + edString
    person.textID  = person.firstName! + ("-") + person.lastName!
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
  
}
