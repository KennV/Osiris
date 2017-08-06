/**
  KVVendorDetailViewController.swift
  Osiris

  Created by Kenn Villegas on 7/18/17.
  Copyright © 2017 dubian. All rights reserved.
*/

import UIKit
import MapKit

class KVVendorDetailViewController: KVDetailViewController
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

  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
