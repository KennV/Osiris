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
 
OK Can I operate the corner buttons w/o a stack view, Or Do I _rilly_ do it on stack01..04?

OK if I am in SetupMode the buttons and map need to be invisible
 AND if i am in Landscape then I need to swallow the side view for wide / non compact layouts.
OKAY I need a interface to the PeopleCon
And It needs to be setup in the appDeli 
OR I just set it in the TVC VWillAppear…
*/

import UIKit
import MapKit

protocol DetailVueDelegate
{
//  func phaseTest(_ delegate :Any? )
  func didMakePersonFor(_ delegate :Any? ) -> Bool
  /**
  these could probably go into the vendor and session controller's protocol
  *Additionally* I may need a services controller 
  Or the effect could be a cascaded protocol
  these are at or around line 180 in the PrimeViewController
  */
  
  func didAddVendor(_ deli: Any?, svc: KVService, session :KVSession) -> Bool
  func didCreateNewSession(_ deli: Any?, p: KVPerson, v: KVVendor) -> Bool
}

class KVDetailViewController: UIViewController
{
  @IBOutlet weak var mapView = MKMapView()
  @IBOutlet weak var setupButton = UIButton()
  @IBOutlet weak var detailDescriptionLabel = UILabel()
  @IBOutlet weak var sessionsLabel = UILabel()
  @IBOutlet weak var sessionsButton = UIButton()
  @IBOutlet weak var vendorsLabel = UILabel()
  @IBOutlet weak var vendorsButton = UIButton()
  @IBOutlet weak var personsButton = UIButton()
  @IBOutlet weak var personsLabel = UILabel()
  //  var hasBeenSetUpIfTrue: Bool! = true.
  var delegate: DetailVueDelegate?
  var personsArr: Array <KVPerson>!
  var detailPerson: KVPerson? {
    didSet {
      // Update the view.
      configureView()
    }
  }
  func configureView()
  {
    setupGUIState()
    //setupMapState
    if let _p = detailPerson
    {
      title = _p.incepDate!.description
    }
  }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
  }
  override func viewWillAppear(_ animated: Bool)
  {
    if (personsArr.isEmpty == false)
    {
      if (detailPerson == nil)
      {
        detailPerson = personsArr.first
      }
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
  }
  /**
  The Person
  */
  @IBAction func startSetupAction(_ sender: UIButton)
  {
//    _ = delegate?.didMakePersonFor(self)
//    self.reloadInputViews()
//    
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    let identifier = segue.identifier!
    switch identifier {
    case "ShowPerson":
      let personEditor = segue.destination as! KVPersonDetailViewController
      personEditor.editablePerson = detailPerson
      break
    case "ShowSession":
      /**
      Ok to make a session I need to have a vendor to publish it and a person to bind it to
      */
      break
    case "ShowVendor":
      /**
      In order to perform the show session I will need to at the very least have an informal protocol to make a blank vendor
      */
      break
    case "ShowSetup":
      _ = delegate?.didMakePersonFor(self)
      self.reloadInputViews()
      break
    default:
      break
    }
//    if segue.identifier == "ShowLicense" {
//      //I would need to make is and set it to conform to a protocol on the PVC
//    }
  }
  /** 
  Setup the inital State of the Buttons
  _if the PDC…isEmpty do the buttons for ONLY setup_
  */
  func setupGUIState()
  {
    if personsArr != nil
    {
      if personsArr.isEmpty
      {
        mapView?.alpha = 0.0
        sessionsButton?.isHidden = true
        sessionsButton?.isEnabled = false
        sessionsLabel?.isHidden = true
        
        personsLabel?.isHidden = true
        personsButton?.isHidden = true
        personsButton?.isEnabled = false
        
        vendorsLabel?.isHidden = true
        vendorsButton?.isHidden = true
        vendorsButton?.isEnabled = false
      } else {
        mapView?.alpha = 01.0
        
        setupButton?.isHidden = true
        setupButton?.isEnabled = false
      
        sessionsButton?.isHidden = false
        sessionsLabel?.isHidden = false
        sessionsButton?.isEnabled = true
        
        personsLabel?.isHidden = false
        personsButton?.isHidden = false
        personsButton?.isEnabled = true
        
        vendorsLabel?.isHidden = false
        vendorsButton?.isHidden = false
        vendorsButton?.isEnabled = true
      }
    }
  }
  
}
