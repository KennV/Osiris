/**
 KVPersonDetailViewController.swift
 Osiris

 Created by Kenn Villegas on 7/18/17.
 Copyright © 2017 dubian. All rights reserved.


*/

import UIKit
import MapKit
//Added UITextFieldDelegate; for
class KVPersonDetailViewController: KVMapViewController, UITextFieldDelegate
{
  /**
  Yeah fixed these _BUT_ for some reason these were not at all wired to the GUI
 ¿is this true?
  */
  @IBOutlet weak var toolBarButton = UIBarButtonItem()
  @IBOutlet weak var personsMapView = MKMapView()
  @IBOutlet weak var personsNameTextField = UITextField()
  @IBOutlet weak var midInitialTextField = UITextField()
  @IBOutlet weak var personsAddressTextField = UITextField()
  @IBOutlet weak var personsTypeTextField = UITextField()
  @IBOutlet weak var currentFilterLabel = UILabel()
  @IBOutlet weak var currentFilterTextField = UITextField()
  
//  TODO: - Fix the sizes in the GUI
//  there is a trace for this in the debugger
//Address button?
  var editablePerson: KVPerson? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureTextView()
    configureView()
  }
  
  override func didReceiveMemoryWarning() {
    // Dispose of any resources that can be recreated.
    super.didReceiveMemoryWarning()
  }
  
  func configureTextView() {
    personsNameTextField?.delegate = self
    personsTypeTextField?.delegate = self
    personsAddressTextField?.delegate = self
    midInitialTextField?.delegate = self
    currentFilterTextField?.delegate = self
    personsNameTextField?.becomeFirstResponder()
    /*
    OKAY this is more like I was talking about in the MapViewExt
    */
  }

  override func configureView() {
    renderPersonText(editablePerson!)
    configureMapView(editablePerson!)
  }
/**
*/  
  func configureMapView(_ person : KVPerson) {
    /**
     Now a *Funny* thing here is that I can add a locManager here or have one provided for me right now I do not need it.
     *BUT* because I have three maps (at least) then I could extend a lot of the map's behavior with a protocol.
     */
    if let loc = person.location {
      mapView?.centerCoordinate.latitude = (loc.latitude?.doubleValue)!
      mapView?.centerCoordinate.longitude = (loc.longitude?.doubleValue)!
      
    }
  }
  
  func renderPersonText(_ person : KVPerson) {
    /**
     by taking this out of the configureTextView() I can use
    */
    if let pTF = personsNameTextField {
      //        let tName = p.firstName!
      if !(pTF.delegate === self) {
        print("Delegate inactive???")
      }
      pTF.text = person.firstName!
    }
    if let mTF = midInitialTextField {
      mTF.text = ("¿-?") //p.middleName!
    }
    if let tTF = personsTypeTextField {
      tTF.text = person.type
    }
    if let aTF = personsAddressTextField {
      aTF.text = person.location?.address
    }
    
  }

}
