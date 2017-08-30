/**
 KVPrimeTVC_Ext.swift
 Osiris
 
 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
 
SINGLE RESPONSIBILITY

for testing purposes I need to be able to 
Make an owner
Make a vendor 
• makea section header for it
Make a Service/Session With an Owner and a Vendor
for it to work I might use some Factory +session:(_ s vendor:v owner:o)

*/

import UIKit
import CoreData
import CoreLocation
import MapKit
import HealthKit
import HealthKitUI

extension KVPrimeTVController: CLLocationManagerDelegate, PersonConDelegate, VendorConDelegate, DetailVueDelegate
{


  // MARK: - Set Application State
  /**
   */
  func setupDataControllers()
  {
    if personDataController.MOC != AllDataController.PSK.viewContext {
      personDataController.MOC = AllDataController.PSK.viewContext
    }
    if sessionDataController.MOC != AllDataController.PSK.viewContext {
      sessionDataController.MOC = AllDataController.PSK.viewContext
    }
    if vendorDataController.MOC != AllDataController.PSK.viewContext {
      vendorDataController.MOC = AllDataController.PSK.viewContext
    }
  }
  /**
  setupDummyLoad()
  */

  /**
   */
  func setupCLManager ()
  {
    locationManager?.delegate = self
    setupCLAuthState()
    locationManager?.distanceFilter = kCLDistanceFilterNone
    // According to BestPractices I was OK but now I am modern
    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    
    locationManager?.startUpdatingLocation()
    findLocation()
  }
  /**
   */
  func setupCLAuthState()
  {
    if (CLLocationManager.authorizationStatus() == .notDetermined)
    {
      locationManager?.requestAlwaysAuthorization() // then set energy states
    }
    
  }
  // TODO: Update the RSRC string/URL in here
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus)
  {
    switch status {
    case .authorizedAlways:
      break
    case .notDetermined:
      manager.requestAlwaysAuthorization()
    case .authorizedWhenInUse, .restricted, .denied:
      
      let alertVC = UIAlertController(
        title: "Background Location Services are Not Enabled",
        message: "In order to better determine usage and data patterns, please open this app's settings and set location access to 'Always'.",
        preferredStyle: .alert)
      //      let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
      alertVC.addAction(UIAlertAction (title: "Cancel", style: .cancel, handler: nil))
      
      let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
        UIApplication.shared.open((URL(string:UIApplicationOpenSettingsURLString)!), options: [ : ], completionHandler: (nil))
      }
      alertVC.addAction(openAction)
      
      present(
        alertVC,
        animated: true,
        completion: nil)
    }
    
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
  {
    print("No-Loc")
  }
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation])
  {
    foundLocation()
  }
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    ///MANUALLY BOUND TO THIS VIEWS NAV CONTROLLER
    if segue.identifier == "showDetail"
    {
      if let indexPath = tableView.indexPathForSelectedRow
      {
        let person = people[indexPath.row] //as! NSDate
        let dvc = (segue.destination as! UINavigationController).topViewController as! KVDetailViewController
        dvc.personsArr = people
        dvc.detailPerson = person
        dvc.delegate = self
        dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        dvc.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
//   MARK : - Protocol Conformance
  // MARK: - Conformance is Complinace!
  /**
  I have this one layer too deep.
   */
  func didChangeVendor(_ t: KVVendor)
  {
    
  }
  func willAddVendor(_ deli: Any?)
  {
    mkNewVendor()
    tableView.reloadData()
  }
  func willAddPerson(_ deli: Any?)
  {
    /**
     lets make an actual p
     Then edit it
     */
    let _p = (personDataController.createPersonInContext(personDataController.MOC!))
    personDataController.resetPersonToEditMeState(_p)
    /**
     then save it
     */
    _ = personDataController.saveEntity(entity: _p)
    /**
     POP THE TABLE
     */
    //currentPerson = people[0]
    // _Do I Need to fix it in the render cell?_
    currentPerson = _p
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    //YES This Line is STILL Important
    personDataController.saveCurrentContext(personDataController.MOC!)
    /**
     Optionally return it
     */
    
  }

  func didChangePerson(_ t: KVPerson)
  {
    personDataController.saveCurrentContext(personDataController.MOC!)
    tableView.reloadData()
  }
  /**
  Because it is not an IBAction it may be called from anywhere, so it is in a protocol and because that is the way we did it in cocoa I ref the delegate, and I return a Bool
  */
  func didMakePersonFor(_ delegate: Any?) -> Bool
  {
    print("\(delegate.debugDescription) from \(self.debugDescription) ")
    self.willAddPerson(delegate)
    return true
  }

  /**
  */
  func didAddVendor(_ deli: Any?, svc: KVService, session :KVSession) -> Bool
  {
    var allTasksCompleteIfTrue = false
    
    return(allTasksCompleteIfTrue)
  }
  func mkNewVendor()
  {
    let _v = (vendorDataController.createVendorInContext(vendorDataController.MOC!))
    _ = vendorDataController.saveEntity(entity: _v)
    // is this an edit vendor / new vendor
    // OR IS IT loaded from json? added and custom soem other way?
    vendorDataController.saveCurrentContext(vendorDataController.MOC!)
  }
  /**
   */
  func mkSession() -> KVSession
  {
    let _s = (sessionDataController.createSessionInContext(sessionDataController.MOC!))
    // for current or selected vendor
    // when should it change for person and or owner
    // is _that_ result saved or computed?
    _ = sessionDataController.saveEntity(entity: _s)
    sessionDataController.saveCurrentContext(sessionDataController.MOC!)
    return(_s)
  }
  /**
  */
  func didCreateNewSession(_ deli: Any?, p: KVPerson, v: KVVendor) -> Bool
  {
    var allTasksCompleteIfTrue = false
    
    return(allTasksCompleteIfTrue)
  }
  func didChangeGraphicsOn(_ entity: KVGraphics)
  {
    if currentPerson?.graphics != entity
    {
      currentPerson?.graphics = entity
    }
    //    configureView()
    // pass it to the other deli
    //    delegate?.didChangePerson(currentPerson!)
  }
  /**
  Find out where we are and then stop
  */
  func findLocation()
  {
    let defLat : Double = 37.33115792
    let defLon : Double = -122.03076853
    ///These locations are from gdb output,
    // They should be revised to reflect "home"
    print(locationManager?.location?.coordinate.latitude ?? defLat)
    print(locationManager?.location?.coordinate.longitude ?? defLon)
  }
  /**
  Yippe
  */
  func foundLocation()
  {
    locationManager?.stopUpdatingLocation()
  }
  // moved the coder to the AresDataController
  /**
  */
  func forwardGeocoding(address: String)
  {
    CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
      if error != nil
      {
        print(error!) //force unwrapped
        return
      }
      if (placemarks?.count)! > 0
      {
        let placemark = placemarks?[0]
        let location = placemark?.location
        let coordinate = location?.coordinate
        print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
        if (placemark?.areasOfInterest?.count)! > 0
        {
          let areaOfInterest = placemark!.areasOfInterest![0]
          print(areaOfInterest)
        }
        else
        {
          print("No area of interest found.")
        }
      }
    })
    //I seriously Better Know What I am doing Next time I see this code: (count 0)
  } // OK it is not what I want (YET)
//  func addSession()
//  {
    /**
     OK I had to clean this up in Both places
     */
    //    delegate?.willMakeMessageFromPerson(currentPerson!) //It needs to reload table data
//  }
  /**
  */
//  func AddPlace()
//  {
    //    delegate?.willMakeNewPlaceHere(delegate)
    //    configureView()
//  }
  /**
  */
//  func addEvent()
//  {
    //    delegate?.willAddNewEvent(self)
//  }
}


