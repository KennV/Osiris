/**
  KVOsirisDataController.swift
  Osiris

  Created by Kenn Villegas on 6/19/17.
  Copyright © 2017 dubian. All rights reserved.
*/

/**
More on basic architecture.
The bulk of this code has been tweaked and tuned for a while. long and short is I trust it. I am inside of 11 weeks to ship this and I need it to be the kind of code that I can work with in 15 weeks. It is, at this point more like a template. So the largest part of this refactoring was breaking the functionality into groups where I use them, not where I wrote them.
*But!* As a strange benefit I do get it about the array being immutable.
 
 static let Vehicle = "KVService"
 static let Package = "KVSession"
 static let Message = "KVTransaction"
*/

struct EntityTypes {
  static let Entity = "KVEntity"
  static let Goods = "KVGoods"
  static let Graphics = "KVGraphics"
  static let Item = "KVItem"
  static let Location = "KVLocation"
  static let Person = "KVPerson"
  static let Physics = "KVPhysics"
  static let RootEntity = "KVRootEntity"
  static let Service = "KVService"
  static let Session = "KVSession"
  static let Transaction = "KVTransaction"
  static let Vendor = "KVVendor"
}

import CoreLocation
import CoreData
import UIKit
// MARK: Strings
let femaleNames: [String] = ["Jessica","Ashley","Amanda","Sarah","Jennifer","Brittany","Stephanie","Samantha","Nicole","Elizabeth","Lauren","Megan","Tiffany","Heather","Amber","Melissa","Danielle","Emily","Rachel","Kayla"]
let maleNames: [String] = ["Michael","Christopher","Matthew","Joshua","Andrew","David","Justin","Daniel","James","Robert","John","Joseph","Ryan","Nicholas","Jonathan","William","Brandon","Anthony","Kevin","Eric"]
let lastNames: [String] = ["Cero","Uno","Dos","Tres","Quatro","Cinco","Seis",   "Siete","Ocho","Nueve","Diez","Once","Doce","Triece","Catorce","Quince","Diesiseis","Dies y Siete","Diez y Ochco","Diez y Nueve"]

let hexDigits: [String] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
// For the save Tuples
enum saveState {
  case Error, RulesBroken, SaveComplete
}

class KVOsirisDataController<T : KVRootEntity > : KVAbstractDataController<T>
{
  
  override init()
  {
    super.init()
    self.entityClassName = "KVRootEntity"
    self.MOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }
  convenience init(ctx: NSManagedObjectContext)
  {
    self.init()
    self.entityClassName = EntityTypes.RootEntity
    self.MOC = ctx
  }
  // MARK: - Entities
  // MARK TODO: ADD unitID
  /**
  ## Should be set to Default
   
  - Returns: \<T\> in ctx
  */
  override func createEntityInContext(_ context: NSManagedObjectContext, type: String) -> T {
    ///Also interesting this could just init a bare NSManaged Obj. I'll take teh errors I got b/c the app works better if this fails when I hit it
    return NSEntityDescription.insertNewObject(forEntityName: type, into: context) as! T
  }
  /**
  Mark the specified entity for deletion
  */
  func deleteEntityInContext(_ context: NSManagedObjectContext, entity: T)
  {
    //                    NSLog("Powa:: %@ !",object .objectID);
    //          I bp here if it breaks
    context.delete(entity)
  }
  func saveCurrentContext(_ ctx: NSManagedObjectContext)
  {
    if ctx.hasChanges {
      do {
        try ctx.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  /**
  Save changes to the specified entity
   
  - returns: (saveState, saveMessage)
  */
  func saveEntity(entity: T) -> (state: saveState, message: String?)
  {
    var ss: saveState
    var saveMessage: String?
    // Check the business rules
    saveMessage = checkRulesForEntity(entity: entity)
    if saveMessage == nil
    {
      let result = saveEntities()
      ss = saveState.SaveComplete
      saveMessage = result.message
    }
    else
    {
      ss = saveState.RulesBroken
    }
    return (state: ss, message: saveMessage)
  }
  /** ## Saves changes to all entities
   
  - returns:  (saveState, saveMessage) */
  func saveEntities() -> (state: saveState, message: String?)
  {
    var ss: saveState
    var saveMessage: String?
    //let context = persistentContainer.viewContext
//    let moc : NSManagedObjectContext = self.PSK.viewContext
    
    if MOC!.hasChanges {
      ss = saveState.Error
      saveMessage = error?.description
    }
    else
    {
      ss = saveState.SaveComplete
      saveMessage = "Good"
    }
//  if let moc : NSManagedObjectContext = self.PSK.viewContext
//    {
//      if moc.hasChanges {…}
//    }
//    else
//    {
//      ss = saveState.Error
//      saveMessage = "Database error"
//    }
    return (ss, saveMessage)
  }
  /// optional businessRules
  func checkRulesForEntity(entity: T) -> String?
  {
    return nil
  }
  // MARK: -
  // MARK: Data Accessors
  /**
  # Workhorse01
   
  - returns:
  */
  func getAllEntities() -> Array<T>
  {
    let todosFetch : NSFetchRequest = NSFetchRequest<T>(entityName: entityClassName!)
    let sortDescriptor = NSSortDescriptor(key: "incepDate", ascending: false)
    
    todosFetch.fetchBatchSize = 20
    todosFetch.sortDescriptors = [sortDescriptor]
    
    do {
      // let r = try PSK.viewContext.fetch(todosFetch)
      let r = try PSK.viewContext.fetch(todosFetch)
      return r
    } catch { fatalError("bitched\(error)") }
  }
  /**
  # Workhorse02
   
  - returns: Typed Array
  */
  func getEntities(sortedBy sortDescriptor:NSSortDescriptor?, matchingPredicate predicate:NSPredicate?) -> Array <T>
  {
    let todosFetch : NSFetchRequest = NSFetchRequest<T>(entityName: entityClassName!)
    todosFetch.fetchBatchSize = 20
    //
    if predicate != nil {
      todosFetch.predicate = predicate
    }
    if sortDescriptor != nil {
      todosFetch.sortDescriptors = [] as Array<NSSortDescriptor>
    }
    do { let r = try PSK.viewContext.fetch(todosFetch)
      return r } catch { fatalError("bitched\(error)")
    }
  }
  /**
  ## Get entities of the default type matching the predicate
   
  - returns: Typed Array
  */
  func getEntitiesMatchingPredicate(predicate: NSPredicate) -> Array<T>
  {
    return getEntities(sortedBy: nil, matchingPredicate: predicate)
  }
  /**
  Get entities of the default type sorted by descriptor and matching the predicate
   
  - returns: Typed Array
  */
  func getEntitiesSortedBy(sortDescriptor: NSSortDescriptor, matchingPredicate predicate:NSPredicate) -> Array<T>?
  {
    return getEntities(sortedBy: sortDescriptor, matchingPredicate: predicate)
  }
  // MARK: Utilities
  /// ### flat random number gen
  func makeRandomNumber(_ range: UInt32) ->Int
  {
    return Int(arc4random_uniform(range))
  }
  /**
  ## DnD Style Random Number Generator.
   
  - parameter rolls: Numer of rolls of range
  - parameter range: range of the random number
   
  - returns: a bell shaped random curve
  */
  func makeRandomNumberCurve(_ rolls: Int,_ range: UInt32) ->Int
  {
    var dwell = 0
    for _ in 1...rolls {
      dwell += makeRandomNumber(range)
    }
    return dwell
  }
  func makeRandomHexQuad() -> String
  {
    var hex = String()
    for _ in 1...4 {
      let x = hexDigits[makeRandomNumber(16)]
      hex.append(x)
    }
    return hex
  }
  /*
  Geocoder
  */
  func getAddressOfLocation(_ loc: KVLocation)
  {
    //    let location = CLLocation(latitude: 0.0, longitude: 0.0)
    let location = CLLocation(latitude: (loc.latitude?.doubleValue)!, longitude: (loc.longitude?.doubleValue)!)
    let geocoder = CLGeocoder()
    
    print("-> Finding user address...")
    
    geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
      var placemark:CLPlacemark!
      
      if error == nil && (placemarks?.count)! > 0 {
        placemark = (placemarks?[0])! as CLPlacemark
        // These lines count
        
        // these were SF Swift 2.1
        var locAddressString:String = ""
        var addressString:String = ""
        
        // united states
        if placemark.isoCountryCode == "US"
        {
          if placemark.country != nil {
            addressString = placemark.country!
          }
          //county?
          if placemark.subAdministrativeArea != nil {
            addressString = addressString + placemark.subAdministrativeArea! + ", "
          } // Baltimore City -- County?
          if placemark.postalCode != nil {
            loc.postalCode = placemark.postalCode!
            addressString = addressString + placemark.postalCode! + " "
          } // ZIP
          if placemark.locality != nil {
            loc.city = placemark.locality!
            addressString = addressString + placemark.locality!
          } //City
          if placemark.subThoroughfare != nil {
            addressString = addressString + placemark.subThoroughfare!
            locAddressString = (placemark.subThoroughfare! + " ")
          } // house
          if placemark.thoroughfare != nil {
            addressString = addressString + placemark.thoroughfare!
            locAddressString.append(placemark.thoroughfare!)
          } // ave/street
          loc.address = locAddressString
        }
        else {
          if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
          }
          if placemark.thoroughfare != nil {
            addressString = addressString + placemark.thoroughfare! + ", "
          }
          if placemark.postalCode != nil {
            addressString = addressString + placemark.postalCode! + " "
          }
          if placemark.locality != nil {
            addressString = addressString + placemark.locality! + ", "
          }
          if placemark.administrativeArea != nil {
            addressString = addressString + placemark.administrativeArea! + " "
          }
          if placemark.country != nil {
            addressString = addressString + placemark.country!
          }
        }
        print(addressString)
      }
    })
    
  }
  func makeRandomPhoneNumber() -> String
  {
    let areaCodes : [String : NSNumber] = ["Philadelphia1" : 217 , "Philadelphia2" : 267 , "Bronx1" : 718 , "Bronx2" : 347 , "Bronx3" : 929 , "Connecticut1" : 203 , "Connecticut2" : 860 , "Connecticut3" : 475 , "Portland1" : 503 , "Portland2" : 541 , "Portland3" : 971 , "Portland4" : 458 , "Manhattan1" : 212 , "Manhattan2" : 646 , "Manhattan3" : 332 , "Baltimore1" : 410 , "Baltimore2" : 443 , "Austin1" : 512 , "Austin2" : 737 , "Phoenix1" : 602 , "Phoenix2" : 480 , "Phoenix3" : 520 , "Phoenix4" : 928 , "Phoenix5" : 623 , "Chicago1" : 312 , "Chicago2" : 847 , "Chicago3" : 773 , "Chicago4" : 630 , "Chicago5" : 815 ]
    // there was a 2 line situation but I Have a Randomizer
    let zone = Array(areaCodes.values)[self.makeRandomNumber(UInt32(areaCodes.count))]
    
    var pnum = ("(" + zone.stringValue + ") " ) //Trailing Space
    
    pnum.append(hexDigits[self.makeRandomNumber(4) + 4]) //first digit
    for _ in 1...2 // tirst Triplet
    {
      pnum.append(hexDigits[self.makeRandomNumber(8) + 1])
    }
    pnum.append("-")
    for _ in 1...4
    {
      pnum.append(hexDigits[self.makeRandomNumber(9)])
    }
    return (pnum) 
  }
}
