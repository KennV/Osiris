/**
	KVPersonTableViewCell.swift
	Ares005 ->AENG

	Created by Kenn Villegas on 10/14/15.
	Copyright © 2015 K3nV. All rights reserved.
*/


import UIKit

class KVBasicCustomCell: UITableViewCell
{
  // MARK: Properties
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  //need a slider _OR_ a label
  //@IBOutlet var slider: UISlider!
  //@IBOutlet weak var tinyLabel: UILabel!
  @IBOutlet var ratingControl: KVRatingView!
  /**
  I bet that this could be a collection view
  */
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    // Initialization code
  }
  override func setSelected(_ selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
