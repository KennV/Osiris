/**
 MasterViewController.swift
 Osiris
 
 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
 */
/**
Cleaned out this TopLevel Documentation and put it into the .rad file
 This class is still hella big. So I made an extension and I am moving all of the non TVC functions go over there
*/

import UIKit
import CoreData
import CoreLocation
import MapKit
import HealthKit
import HealthKitUI

/**
  Need vendor's accesor to be the selected cell here in TableView and an array in the MKNotation Array
 
Stop and Fix it NAOW
Deleting persons may cause error
Expected to never do that 
75% replicable delete people out of order 
Hell person[0] must be owner and logic will say that you can't delete this

So if it is the first. can delete is false.
 
*/

class KVPrimeTVController: UITableViewController  {
  /**
   */
  var detailViewController: KVDetailViewController? = nil
  /**
   */
  var currentPerson: KVPerson?
  {
    didSet {
      detailViewController?.detailPerson = (currentPerson)
      detailViewController?.configureView()
    }
  }
  var AllDataController = KVOsirisDataController()
  var allItemsDataController = KVItemDataController()
  var mapViewTableCell = KVMapTableViewCell()
  var locationManager : CLLocationManager? = CLLocationManager()
  
  var personDataController = KVPersonDataController()
  var vendorDataController = KVVendorDataController()
  var sessionDataController = KVSessionDataController()
  
  var people : Array <KVPerson> {
    get {
      let miPeople = personDataController.getAllEntities()
      detailViewController?.personsArr = miPeople
      detailViewController?.configureView()
      return miPeople
    }
//    set {
//      detailViewController?.personsArr  = people
//    } //Im Kinda unsure of this, as I _never_
  }
  var vendors : Array <KVVendor> {
    get {
      return vendorDataController.getAllEntities()
    }
  }
  var sessions : Array <KVSession> {
    get {
      return sessionDataController.getAllEntities()
    }
  }
  // TODO: Run Setup if people.isEmpty
  override func viewDidLoad()
  {
    setupCLManager()
    findLocation()
    setupDataControllers()

    super.viewDidLoad()
    view.backgroundColor = UIColor.darkGray
    personDataController.delegate = self
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton
    if let split = splitViewController
    {
      let controllers = split.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? KVDetailViewController
      detailViewController?.delegate = self
      detailViewController?.personsArr = people
    }
  }
  override func viewWillAppear(_ animated: Bool)
  {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    //    setupDetailViewController()
    detailViewController?.personsArr = people
    super.viewWillAppear(animated)
  }
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  /**
   ## insert a new object of Type ##
   
   - Parameter sender: An *Any*
   */
  func insertNewObject(_ sender: Any)
  {
    personDataController.delegate?.willAddPerson(self)
  }
  // MARK: - Table View
  /**
  Set for Owner, Vendors, and Sessions
  */
  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 3
  }
  /**
  */
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int
  {
    var rowCount = 0
    if (section == 0)
    {
      rowCount = people.count
    }
    if (section == 1)
    {
      rowCount = vendors.count
    }
    if (section == 2)
    {
      rowCount = sessions.count
    }
    return(rowCount)
  }
  // MARK: - Update Cells
  // FIXME: - These are NOT custom in the XIB and Are Barely custom Here:
  // FIXME: Override cell sizes
  // FIXME: headers and footers
  /**
   
  */
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return (40)
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    //While Height 0 Override down thurr
    let headerVue = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.size.width, height: 0)))
    let sectionLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: view.frame.size.width, height: 21)))
    sectionLabel.backgroundColor = UIColor.clear
    sectionLabel.textColor = UIColor.cyan
    sectionLabel.font = UIFont.boldSystemFont(ofSize: 17)
    
    let sectionButton = UIButton(frame: CGRect(x: 80, y: 10, width: 88, height: 21))
//    sectionButton.backgroundColor = UIColor.clear
//    sectionButton.titleLabel!.textColor = UIColor.black
    
    switch section
    {
    case 0:
      sectionLabel.text = NSLocalizedString("Person:", comment: "")
      sectionButton.setTitle(" ++ ", for: .normal)
      
      sectionButton.addTarget(self, action: #selector(willAddPerson(_:)), for: .touchDown)
    case 1:
      sectionLabel.text = NSLocalizedString("Vendors:", comment: "")
      sectionButton.setTitle(" ++ ", for: .normal)
      sectionButton.addTarget(self, action: #selector(willAddVendor(_:)), for: .touchDown)
      
    case 2:
      sectionLabel.text = NSLocalizedString("Sessions:", comment: "")
      sectionButton.setTitle(" ++ ", for: .normal)
    //
    default:
      return nil
    }
    headerVue.addSubview(sectionButton) //
    headerVue.addSubview(sectionLabel)
    
    return headerVue
    
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 96
    case 1:
      return 48
    case 2:
      return 48
    default:
      break
    }
    return 48
  
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    if (indexPath.section == 0)
    {
      let c = tableView.dequeueReusableCell(withIdentifier: "OwnerCell", for: indexPath) as! KVMapTableViewCell
      //          let person = people[indexPath.row]
      //          c.textLabel!.text = person.incepDate?.description
      return c
    }
    if (indexPath.section == 1)
    {
      let f = tableView.dequeueReusableCell(withIdentifier: "VendorCell", for: indexPath) //as! KVBasicCustomCell
      let item = vendors[(indexPath as NSIndexPath).row]
      //      f.nameLabel!.text = item.qName
      return f
    }
    if (indexPath.section == 2)
    {
      let d = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) //as! KVBasicCustomCell
      let item = sessions[(indexPath as NSIndexPath).row]
      //      d.nameLabel!.text = item.qName
      return d
    }
    /*
      return cell c,d,e,f or return an empty one
    */
    return (UITableViewCell())//cell!
  }
  /**
  #HELLA BIG NOTE #
   OK now it can't do that crah thin and it corrects the 'setup-mode' in both portrait and lanscape. 
  THEN IT SHALL ALWAYS BE TRUE THAT THERE IS A PERSON IN INDEX[0] AND THAT IS THE OWNER FROM THE SETUP
   */
  
  override func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool
  {
    switch indexPath.section {
    case 0:
     if people.count <= 1 // or selectedPerson.type != owner
     {
      return false;
      }
    default:
      return true
    }
    return true
  }
  // MARK: - Deleter
  /**
   Assure that there is a save: here OR save in the Osiris Class' delete()
  */
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete {
      switch indexPath.section {
      case 0:
        personDataController.deleteEntityInContext(personDataController.PSK.viewContext, entity: (people[indexPath.row]))
      //        tableView.deleteRows(at: [indexPath], with: .fade)
      case 1:
        vendorDataController.deleteEntityInContext(vendorDataController.PSK.viewContext, entity: (vendors[indexPath.row]))
      //        tableView.deleteRows(at: [indexPath], with: .fade);
      case 2:
        sessionDataController.deleteEntityInContext(sessionDataController.PSK.viewContext, entity: (sessions[indexPath.row]))
      //        tableView.deleteRows(at: [indexPath], with: .fade)
      default:
        break
      }
      tableView.deleteRows(at: [indexPath], with: .fade)
      personDataController.saveCurrentContext(personDataController.MOC!)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    if personDataController.getAllEntities().count == 0
    {
      insertNewObject(self)
      tableView.reloadData()
    }
  }
  /**
  Activate Segue from Cell-Tapped

  - Parameters:
  - tableView: mi Table Vue
  - indexPath: Section and Index of selection
  */
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    if (indexPath.section == 0 )
    {
      performSegue(withIdentifier: "showDetail", sender: nil)
    }
  }
}
