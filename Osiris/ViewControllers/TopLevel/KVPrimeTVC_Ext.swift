/**
 KVPrimeTVC_Ext.swift
 Osiris
 
 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
 
 */

import UIKit
import CoreData
import CoreLocation
import MapKit
import HealthKit
import HealthKitUI

extension KVPrimeTVController: PersonConDelegate, CLLocationManagerDelegate
{
  // MARK: - Set Application State
  /**
   */
  func setupDataControllers()
  {
    if self.pdc.MOC != self.AllDataController.PSK.viewContext {
      self.pdc.MOC = self.AllDataController.PSK.viewContext
    }
    if self.sdc.MOC != self.AllDataController.PSK.viewContext {
      self.sdc.MOC = self.AllDataController.PSK.viewContext
    }
    if self.vdc.MOC != self.AllDataController.PSK.viewContext {
      self.vdc.MOC = self.AllDataController.PSK.viewContext
    }
  }
  /**
   */
  func setupDummyLoad()
  {
    if (vendors.isEmpty) {
      self.vdc.makeVendor()
    }
    if (sessions.isEmpty) {
      self.sdc.makeSession()
    }
  }
  /**
   */
  func setupCLManager ()
  {
    self.locationManager?.delegate = self
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
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let person = people[indexPath.row] //as! NSDate
        let dvc = (segue.destination as! UINavigationController).topViewController as! KVDetailViewController
        dvc.detailItem = person
        dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        dvc.navigationItem.leftItemsSupplementBackButton = true
        //          controller.personsArr = pdc.getAllEntities()
      }
    }
  }
  // MARK: - Protocol Conformance
  /**
  */
  func didChangePerson(_ entity: KVPerson)
  {
    pdc.saveCurrentContext(pdc.MOC!)
    tableView.reloadData()
  }
  /**
  */
  func willAddPerson(_ deli: Any?)
  {
    //    self.insertNewObject(self)
    pdc.makePerson()
    pdc.saveCurrentContext(pdc.MOC!)
    /**
     setup the person
     */
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    detailViewController?.detailItem = (people[0])
  }
  /**
  */
  func didChangeGraphicsOn(_ entity: KVGraphics)
  {
    if currentPerson?.graphics != entity {
      currentPerson?.graphics = entity
    }
    //    configureView()
    // pass it to the other deli
    //    delegate?.didChangePerson(currentPerson!)
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
  //

  
  // MARK: - Conformance is Complinace!
  //
  // Protocol Usage
  /**
  */
  @IBAction func addPerson(_ sender: AnyObject)
  {
    //    pdc.delegate?.willAddPerson(self)
  }
  /**
  */
  @IBAction func addMessage()
  {
    /**
     OK I had to clean this up in Both places
     */
    //    delegate?.willMakeMessageFromPerson(currentPerson!) //It needs to reload table data
  }
  /**
  */
  @IBAction func AddPlace()
  {
    //    delegate?.willMakeNewPlaceHere(delegate)
    //    configureView()
  }
  /**
  */
  @IBAction func addEvent()
  {
    //    delegate?.willAddNewEvent(self)
  }
}


