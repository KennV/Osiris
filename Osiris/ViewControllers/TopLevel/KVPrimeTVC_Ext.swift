/**
 KVPrimeTVC_Ext.swift
 Osiris
 
 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
 
SINGLE RESPONSIBILITY
(~_•)
for testing purposes I need to be able to 
Make an owner
Make a vendor 
• make a section header for it
• Make a Service/Session With an Owner and a Vendor

Added multiple selection for the TV. Let me see how to make that work
(*I should look that up I know there is API for it, send it to the DVC and then have that go over to the edit views *)
Yup I will have to manually toggle the state, Also I added a button to the custom personView. that NPE crash is rare but tagged
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

    //MANUALLY BOUND TO THIS VIEWS NAV CONTROLLER
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
        if !(vendors.isEmpty) {
          dvc.currentVendor = vendors.first
        }
        if !(sessions.isEmpty) {
          dvc.currentSession = sessions.first
        }
      }
    }
  }
  // MARK: - Table View Protocol Conformance
  /**
  (*Not the setupƒn *)
   // FIXED - These are NOT custom in the XIB and Are Barely custom Here:
  With the initial issue of the GUI in the XIB I have to have custom Heights, these are in this groovy litle delegate that probably doesn't need to be on the main
  
   */
  // Sizes of headers and footers
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return (40)
  }
  // Labels and buttons in headers and footers
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    //While Height 0 Override down thurr
    let headerVue = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.size.width, height: 0)))
    let sectionLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: view.frame.size.width, height: 21)))
    sectionLabel.backgroundColor = UIColor.clear
    sectionLabel.textColor = UIColor.cyan
    sectionLabel.font = UIFont.boldSystemFont(ofSize: 17)
    
    let sectionButton = UIButton(frame: CGRect(x: 80, y: 10, width: 88, height: 21))
    //    sectionButton.backgroundColor = UIColor.clear
    //    sectionButton.titleLabel!.textColor = UIColor.black
    
    switch section
    {
    case 0:
      sectionLabel.text = NSLocalizedString("Person:", comment: "")
      sectionButton.setTitle(" ++ ", for: .normal)
      sectionButton.addTarget(self, action: #selector(willAddPerson(_:)), for: .touchDown)
    case 1:
      sectionLabel.text = NSLocalizedString("Vendors:", comment: "")
      sectionButton.setTitle(" ++ ", for: .normal)
      sectionButton.addTarget(self, action: #selector(willAddVendor(_:)), for: .touchDown)
      
    case 2:
      sectionLabel.text = NSLocalizedString("Sessions:", comment: "")
      sectionButton.setTitle(" ++ ", for: .normal)
      sectionButton.addTarget(self, action: #selector(willAddSession(_:)), for: .touchDown)
    //
    default:
      return nil
    }
    headerVue.addSubview(sectionButton) //
    headerVue.addSubview(sectionLabel)
    
    return headerVue
    
  }
  // Height for the different sections
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    switch indexPath.section {
    case 0:
      return 128
    case 1:
      return 48
    case 2:
      return 48
    default:
      break
    }
    return 48
  }  
  // TODO: - Multi Table View Selection
  /**
  Currently a little buggy but not very
  OK I CAN see the DVC so I can see if it has a current Vendor, and if not to 
   
  But I will still need an ivar to hold the index of the vendor or the session that was selectd
  AND 
   AND
   AND I need to be able to use the last person or the last session that was created (from the DVC/Deli) if I do not have one when that view comes up
  */
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
  {
    let cell = tableView.cellForRow(at: indexPath)
    switch indexPath.section {
    case 0:
      print(" ")
    case 1:
      if (maxCount <= 1) {
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark)
        { maxCount -= 1
          cell!.accessoryType = UITableViewCellAccessoryType.none;
        } else {
          cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
          maxCount += 1
        }
      }
    case 2:
      if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
        cell!.accessoryType = UITableViewCellAccessoryType.none;
      }else{
        cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
      }
    default:
      break
    }
//    return 0
  }
  
  // MARK: - Conformance is Complinace!
  /**
  Simplify
  Because it is not an IBAction it may be called from anywhere, so it is in a protocol and because that is the way we did it in cocoa I ref the delegate, and I return a Bool
   So this seems to be the best current order to call them in.
   
  */
  func mkNewPerson() -> KVPerson
  {
    /**
     lets make an actual p
     Then edit it
     */
    let tmpPerson = (personDataController.createPersonInContext(personDataController.MOC!))
    personDataController.resetPersonToEditMeState(tmpPerson)
    return (tmpPerson)
  }
  func willAddPerson(_ deli: Any?)
  {
    let _p = mkNewPerson()
    /**
     then save it
     */
    _ = personDataController.saveEntity(entity: _p)
    /**
     POP THE TABLE
     
     //currentPerson = people[0]
     // _Do I Need to fix it in the render cell?_
     */
    currentPerson = _p
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    didChangePerson(_p)
    //YES This Line is STILL Important
    //personDataController.saveCurrentContext(personDataController.MOC!)
   
  }
  func didAddPersonFor(_ delegate: Any?) -> Bool
  {
    print("\(delegate.debugDescription) from \(self.debugDescription) ")
    self.willAddPerson(delegate)
    return true
  }
  func didChangePerson(_ t: KVPerson)
  {
    personDataController.saveCurrentContext(personDataController.MOC!)
     tableView.reloadData()
  }
  /**
  
  */
  func mkNewVendor() -> KVVendor
  {
    let _v = (vendorDataController.createVendorInContext(vendorDataController.MOC!))
    _ = vendorDataController.saveEntity(entity: _v)
    return(_v)
  }
  func willAddVendor(_ deli: Any?)
  {
    var v = mkNewVendor()
    didChangeVendor(v)
    
  }
  /*
  ¿¿¿ Hmmm look at service existing like is is some kind of data bearing class and all ??? I might be a classCluster or somethign else that I can extend to give me types of sessions and transactions
  */
  func didAddVendor(_ deli: Any?, svc: KVService, session :KVSession) -> Bool
  {
    let allTasksCompleteIfTrue = true
    let v = mkNewVendor()
    didChangeVendor(v)
    return(allTasksCompleteIfTrue)
  }
  func didChangeVendor(_ t: KVVendor)
  {
    vendorDataController.saveCurrentContext(vendorDataController.MOC!)
    tableView.reloadData()
  }
  /**
  */
  func mkSession() -> KVSession
  {
    let _s = (sessionDataController.createSessionInContext(sessionDataController.MOC!))
    _ = sessionDataController.saveEntity(entity: _s)
    return(_s)
  }
  func willAddSession(_ sender: Any?) {
    let xs = mkSession()
    _ = sessionDataController.saveEntity(entity: xs)
    self.didChangeSession(xs)
  }

  func didAddNewSession(_ deli: Any?) -> Bool
  {
    let allTasksCompleteIfTrue = false
    
    return(allTasksCompleteIfTrue)
  }
  func didChangeSession(_ s: KVSession)
  {
    sessionDataController.saveCurrentContext(sessionDataController.MOC!)
    tableView.reloadData()
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
}
