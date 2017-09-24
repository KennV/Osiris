/**
  DetailViewController.swift
  Osiris

  Created by Kenn Villegas on 6/13/17.
  Copyright © 2017 dubian. All rights reserved.
*/
/**
Yes, this _does_ need map/location/health imported, BUT it also needs to have a way to pop that back over to prime setup might need to go into a sub nav controller.

20170715@0000
well, yes.

OK if I am in SetupMode the buttons and map need to be invisible AND if i am in Landscape then I need to swallow the side view for wide / non compact layouts.
 
OKAY I need a interface to the PeopleCon
 
And It needs to be setup in the appDeli 
OR I just set it in the TVC VWillAppear…
 
AAMOFF!

*/

import UIKit
import MapKit

protocol DetailVueDelegate
{
//  Coding Ain’t Done ‘Til All the Tests Run
//  ‘Nuff said.
  func didAddPersonFor(_ delegate :Any? ) -> Bool
  func didAddVendor(_ deli: Any?) -> Bool
//  func didAddVendor(_ deli: Any?, svc: KVService, session :KVSession) -> Bool
//  func didAddNewSession(_ deli: Any?, p: KVPerson, v: KVVendor) -> Bool
  func didAddNewSession(_ deli: Any?) -> Bool
}

class KVDetailViewController: UIViewController, MKMapViewDelegate
{
  // Interface
  var delegate: DetailVueDelegate?
  // GUI
  @IBOutlet weak var mapView = MKMapView()
  @IBOutlet weak var setupButton = UIButton()
  @IBOutlet weak var sessionsButton = UIButton()
  @IBOutlet weak var vendorsButton = UIButton()
  @IBOutlet weak var personsButton = UIButton()
  // Data
  var personsArr: Array <KVPerson>!
  var detailPerson: KVPerson? {
    didSet {
      // Update the view.
      configureView()
    }
  }
  var currentVendor: KVVendor! = nil
  var currentSession: KVSession! = nil
  
  func configureView()
  {
    setupGUIState()
    //setupMapState
    /**
    If I crash here it is b/c this is nil I do not need the title but this should not really be nil
    */
    if let _p = detailPerson
    {
      title = _p.incepDate!.description
    }
  }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupGUIState()
    setupMapView()
    configureView()
  }
  override func viewWillAppear(_ animated: Bool)
  {
//    if !(personsArr.isEmpty)
//    {
//      if (detailPerson == nil)
//      {
//        detailPerson = personsArr.first
//      }
//    }
  }
  @IBAction func startSetupAction(_ sender: UIButton)
  {
    //self.reloadInputViews()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
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
  func setupGUIState()
  {
    
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
  func setupMapView()
  {
    mapView?.delegate = self
    // .Hybrid - Has Scale; .Standard Has all Custom camera No Scale Bar
    mapView?.mapType = .hybridFlyover

    mapView?.showsScale = true
    mapView?.showsUserLocation = true
    mapView?.showsPointsOfInterest = true
    mapView?.showsCompass = false
    if (detailPerson?.location != nil) {
      let loc = CLLocation(latitude: (detailPerson?.location?.latitude?.doubleValue)!, longitude:(detailPerson?.location?.longitude?.doubleValue)!)
//      mapView?.centerCoordinate = loc.coordinate
    let defR = MKCoordinateRegionMakeWithDistance(loc.coordinate, 5000, 5000)
      mapView?.setRegion(defR, animated: true)
    }

    let camera = MKMapCamera()
    camera.centerCoordinate = (mapView?.centerCoordinate)! //see line 175
    camera.pitch = 70
    camera.altitude = 400
    camera.heading = 0
    print("\(String(describing: mapView?.centerCoordinate.latitude))")
//
//    mapView.camera = camera
    //    let defLoc = CLLocation(latitude: (39.329842664338024), longitude: (-76.607890399244241))
    //    let defR = MKCoordinateRegionMakeWithDistance(loc.coordinate, 5000, 5000)
    //    mapView.setRegion(defR, animated: true)
   /**
     terminating because it runs slow as fuck in sim and I do not have batteries to do it in HW
    */
  }
  
}
