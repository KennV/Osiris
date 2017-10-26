/**
  KVVendorDetailViewController.swift
  Osiris

  Created by Kenn Villegas on 7/18/17.
  Copyright © 2017 dubian. All rights reserved.
*/

import UIKit
import MapKit

class KVVendorDetailViewController: KVMapViewController
{
  
  @IBOutlet weak var vendorMapView: MKMapView!
  @IBOutlet weak var servicesButtonLabel: UILabel!
  @IBOutlet weak var servicesButton: UIButton!
  @IBOutlet weak var placesLabel: UILabel!
  @IBOutlet weak var placesTextField: UITextField!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var timeTextField: UITextField!
  @IBOutlet weak var costTextField: UITextField!
  @IBOutlet weak var costLabel: UILabel!
  @IBOutlet weak var toolbarButton01: UIBarButtonItem!
  
  var editableVendor: KVVendor? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /**
  Jeepers this class is empty But it loads
  Can't test for properties (like with person) if this doesn't have a vendor
  */
  
  func configureTextView() {
    
  }
  
  override func configureView() {
    configureTextView()
    configureMapView()
  }

  func configureMapView() {
    
  }
  
  func renderTextView(_ vendor: KVVendor) {
    
  }

  func renderMapViewForAllVendors(_ array: Array<KVVendor>) {
    
  }
  
  func renderMapViewForCurrentVendor(_ vendor: KVVendor) {
    
  }
}
