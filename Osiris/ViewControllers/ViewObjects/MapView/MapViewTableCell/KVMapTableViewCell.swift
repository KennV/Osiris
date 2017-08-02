/**
  KVMapTableViewCell.swift
  Osiris

  Created by Kenn Villegas on 7/26/17.
  Copyright © 2017 dubian. All rights reserved.

From the Controller that consumes this view::
OK the first view works but has no map
 
•: thus I need to init a map
*/

import UIKit
import MapKit

class KVMapTableViewCell: UITableViewCell {

  @IBOutlet weak var cellMapView: MKMapView!
  @IBOutlet weak var buttonOne: UIButton!
  @IBOutlet weak var buttonTwo: UIButton!
  @IBOutlet weak var buttonThree: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
