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
  @IBOutlet weak var toolBarButton: UIBarButtonItem!
  @IBOutlet weak var personsMapView: MKMapView!
  @IBOutlet weak var personsNameTextField: UITextField!
  @IBOutlet weak var midInitialTextField: UITextField!
  @IBOutlet weak var personsAddressTextField: UITextField!
  @IBOutlet weak var personsTypeTextField: UITextField!
  @IBOutlet weak var currentFilterLabel: UILabel!
  @IBOutlet weak var currentFilterTextField: UITextField!
  
  
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning()
    {
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
