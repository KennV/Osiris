/**
 KVSessionDetailViewController.swift
 Osiris
 
 Created by Kenn Villegas on 7/18/17.
 Copyright © 2017 dubian. All rights reserved.
 */

import UIKit

class KVSessionDetailViewController: KVMapViewController
{
  /**
   This thing also has 2 of the button views
   
   */
  //  @IBOutlet weak var
  @IBOutlet weak var smallLabel01: UILabel!
  @IBOutlet weak var smallButton01: UIButton!
  
  @IBOutlet weak var textField02: UITextField!
  @IBOutlet weak var textFieldLabel02: UILabel!
  
  @IBOutlet weak var serviceStatusLabel03: UILabel!
  @IBOutlet weak var largeTextView05: UITextView!
  
  @IBOutlet weak var typesSelectorLeft06: UIButton!
  @IBOutlet weak var typesSelectorRight06: UIButton!
  
  @IBOutlet weak var view07: UIView!
  var editableSession: KVSession? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func configureView() {
    configureTextView()
  }
  
  func configureTextView() {
    
  }
  
}
