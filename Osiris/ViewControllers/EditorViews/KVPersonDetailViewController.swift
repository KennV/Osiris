/**
 KVPersonDetailViewController.swift
 Osiris
 
 Created by Kenn Villegas on 7/18/17.
 Copyright © 2017 dubian. All rights reserved.
 */

import UIKit
import MapKit

class KVPersonDetailViewController: KVDetailViewController
{
  /**
  Yeah fixed these _BUT_ for some reason these were not at all wired to the GUI
  */
  @IBOutlet weak var toolBarButton = UIBarButtonItem()
  @IBOutlet weak var personsMapView = MKMapView()
  @IBOutlet weak var personsNameTextField = UITextField()
  @IBOutlet weak var midInitialTextField = UITextField()
  @IBOutlet weak var personsAddressTextField = UITextField()
  @IBOutlet weak var personsTypeTextField = UITextField()
  @IBOutlet weak var currentFilterLabel = UILabel()
  @IBOutlet weak var currentFilterTextField = UITextField()
  
  var editablePerson: KVPerson? {
    didSet {
      configureView()
    }
  }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureView()
  }
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func configureTextView()
  {
    if let p = editablePerson {
      if let pTF = personsNameTextField
      {
//        let tName = p.firstName!
        pTF.text = p.firstName!
      }
      if let mTF = midInitialTextField
      {
        mTF.text = ("¿-?") //p.middleName!
      }
      if let tTF = personsTypeTextField
      {
        tTF.text = p.type
      }
      if let aTF = personsAddressTextField
      {
        aTF.text = p.location?.address
      }
    }
    
  }
  func configureMapView() {
    
  }
  // This is new
  override func configureView() {
    configureTextView()
  }
}
