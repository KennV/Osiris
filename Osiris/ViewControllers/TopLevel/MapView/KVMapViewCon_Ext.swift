/**
	DetailViewController.swift
	Osiris
 
	Created by Kenn Villegas on 6/13/17.
	Copyright © 2017 dubian. All rights reserved.

OK for what it is worth, the functions and functionality if the base class is good and SOLID, but if I am to extend it well that goes into an extension

Planned changes include CoreLocation Functionality, does it need one or can it 

*/

import UIKit
import MapKit

extension KVMapViewController: CLLocationManagerDelegate
{
  func renderPerson(_ p : KVPerson) {
    if (mapView != nil) {
      print("GROOVY")
      //01 the Mapview is already deli
      mapView?.mapType = .hybridFlyover
      let loc = CLLocation(latitude: (p.location?.latitude?.doubleValue)!, longitude:(p.location?.longitude?.doubleValue)!)
      let defR = MKCoordinateRegionMakeWithDistance(loc.coordinate, 500, 500)
      mapView?.setRegion(defR, animated: true)
      let camera = MKMapCamera()
      camera.centerCoordinate = (mapView?.centerCoordinate)!
      camera.pitch = 70
      camera.altitude = 400
      camera.heading = 0
      mapView?.camera = camera
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    /**
     Lastly this is the funniest of b/points here
     I shall be examining the currentPerson, Vendor, and Session
     */
    let identifier = segue.identifier!
    switch identifier {
    case "ShowPerson":
      let personEditor = segue.destination as! KVPersonDetailViewController
      personEditor.editablePerson = detailPerson
      break
    case "ShowVendor":
      let vendorEditor = segue.destination as! KVVendorDetailViewController
      if (vendorEditor.editableVendor == nil) {
        _ = delegate?.didAddVendor(delegate)
      }
      /**
       Extended from previous Commit;
       This protocol gets a lot done.
       */
      break
    case "ShowSession":
      /**
       Ok to make a session I need to have a vendor to publish it and a person to bind it to
       */
      break
    case "ShowSetup":
      _ = delegate?.didAddPersonFor(self)
      self.reloadInputViews()
      break
    default:
      break
    }
  }

  @IBAction func startSetupAction(_ sender: UIButton) {
    //self.reloadInputViews()
  }

  func setupGUIState() {
    
    if personsArr != nil
    {
      if personsArr.isEmpty
      {
        mapView?.alpha = 0.0
        sessionsButton?.isHidden = true
        sessionsButton?.isEnabled = false
        
        personsButton?.isHidden = true
        personsButton?.isEnabled = false
        
        vendorsButton?.isHidden = true
        vendorsButton?.isEnabled = false
      } else {
        mapView?.alpha = 01.0
        
        setupButton?.isHidden = true
        setupButton?.isEnabled = false
        
        sessionsButton?.isHidden = false
        sessionsButton?.isEnabled = true
        
        personsButton?.isHidden = false
        personsButton?.isEnabled = true
        
        vendorsButton?.isHidden = false
        vendorsButton?.isEnabled = true
      }
    }
  }

  func setupMapState() {
    /** Actually set in VDidLoad
    mapView?.delegate = self
    */
    if let _kmv = self.mapView {
      _kmv.mapType = .hybridFlyover
      _kmv.showsScale = true
      _kmv.showsUserLocation = true
      _kmv.showsPointsOfInterest = true
      _kmv.showsCompass = false
      }
  }

}
