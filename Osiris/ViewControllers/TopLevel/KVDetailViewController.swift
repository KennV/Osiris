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
OKAY I need a inference to the PeopleCon
 
*/

import UIKit
import MapKit

class KVDetailViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var setupButton: UIButton!
//  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var sessionsLabel: UILabel!
  @IBOutlet weak var sessionsButton: UIButton!
  @IBOutlet weak var vendorsLabel: UILabel!
  @IBOutlet weak var vendorsButton: UIButton!
  @IBOutlet weak var personsButton: UIButton!
  @IBOutlet weak var personsLabel: UILabel!
  // FIXME: WTF to Get this as T?
//  weak var personsArr: NSArray!
  
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail = detailItem {
//        if let label = detailDescriptionLabel {
//            label.text = detail.incepDate!.description
//        }
    }
  }
  override func viewDidLoad() {
    self.setupModeForDVC()
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  /**
  The Person
  */
  var detailItem: KVPerson? {
    didSet {
        // Update the view.
        configureView()
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    let identifier = segue.identifier!
    switch identifier {
    case "ShowPerson":
      break
    case "ShowSession":
      break
    case "ShowVendor":
      break
    case "ShowSetup":
      break
    default:
      break
    }
//    if segue.identifier == "ShowLicense" {
//      //I would need to make is and set it to conform to a protocol on the PVC
//    }
  }
  // MARK: - Powa
  /** 
  Setup the inital State of the Buttons
  */
  func setupInitialState()
  {
    /**
    OK Since this does not work then I will need to set for UIState.normal
    */
    sessionsLabel.alpha = 0
    sessionsButton.isEnabled = false
    sessionsButton.alpha = 0
  }
  /** 
  if the PDC…isEmpty do the buttons for ONLY setup
  */
  func setupModeForDVC()
  {
//    do it either way BUT it does not work *dammit*
//    if (pdc.getAllEntities().isEmpty) {
      self.mapView.alpha = 0.0
      self.sessionsButton.isHidden = false
      self.sessionsButton.isHidden = true
      self.sessionsButton.isEnabled = false
      self.sessionsLabel.isHidden = true
      self.personsLabel.isHidden = true
      self.personsButton.isHidden = true
      self.personsButton.isEnabled = false
      self.vendorsLabel.isHidden = true
      self.vendorsButton.isEnabled = false
      self.vendorsButton.isHidden = true
      self.configureView()
//    }
  }

}
