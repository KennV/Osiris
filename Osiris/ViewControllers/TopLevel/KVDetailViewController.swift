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
//  Coding Ain’t Done ‘Til All the Tests Run
//  ‘Nuff said.


/**
these could probably go into the vendor and session controller's protocol
*Additionally* I may need a services controller 
Or the effect could be a cascaded protocol
these are at or around line 180 in the PrimeViewController

AAMOFF!
the q&d version kinda has the right effect, I simply cant rely on this or the next class being a s/c of .this Luckily as I am only using three methods which add an instance if (id) - So that this and any other vue just has to implement it;
Well this is interesting do I have _p, arr<_p>, _v, _s?

Lastly I *did* get confused about what I can and should send as a delegate. And how trim I can make it srsly that is where I should start first -=- That was a great idea.

*/
  func didAddPersonFor(_ delegate :Any? ) -> Bool
  func didAddVendor(_ deli: Any?, svc: KVService, session :KVSession) -> Bool
//  func didAddNewSession(_ deli: Any?, p: KVPerson, v: KVVendor) -> Bool
  func didAddNewSession(_ deli: Any?) -> Bool
}

class KVDetailViewController: UIViewController
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
//    _ = delegate?.didMakePersonFor(self)
//    self.reloadInputViews()
//    
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
      /**
       In order to perform the show session I will need to at the very least have an informal protocol to make a blank vendor
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
  
}
