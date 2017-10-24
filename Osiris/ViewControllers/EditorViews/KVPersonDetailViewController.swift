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
    if let p = editablePerson {
      if let pTF = personsNameTextField {
//        let tName = p.firstName!
        if !(pTF.delegate === self) {
          print("Delegate inactive???")
        }
        pTF.text = p.firstName!
      }
      if let mTF = midInitialTextField {
        mTF.text = ("¿-?") //p.middleName!
      }
      if let tTF = personsTypeTextField {
        tTF.text = p.type
      }
      if let aTF = personsAddressTextField {
        aTF.text = p.location?.address
      }
    }

  }
  
  func configureMapView() {
    /**
   
    */
  }
  // This is new
  override func configureView() {
    configureTextView()
  }
}
