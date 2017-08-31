/**
 MasterViewController.swift
 Osiris
 
 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
*/

import UIKit
import CoreData
import CoreLocation
import MapKit
import HealthKit
import HealthKitUI

/**
  Need vendor's accesor to be the selected cell here in TableView and an array in the MKNotation Array

 *****
# Please Add multiple selection BUT single action on the TView
*****

*/

class KVPrimeTVController: UITableViewController  {
 
  var detailViewController: KVDetailViewController? = nil
  
  var AllDataController = KVOsirisDataController()
  var allItemsDataController = KVItemDataController()
  var mapViewTableCell = KVMapTableViewCell()
  var locationManager : CLLocationManager? = CLLocationManager()
  
  var personDataController = KVPersonDataController()
  var vendorDataController = KVVendorDataController()
  var sessionDataController = KVSessionDataController()

  var currentPerson: KVPerson?
  {
    didSet {
      detailViewController?.detailPerson = (currentPerson)
      detailViewController?.configureView()
    }
  }
  var people : Array <KVPerson> {
    get {
      let miPeople = personDataController.getAllEntities()
      detailViewController?.personsArr = miPeople
      detailViewController?.configureView()
      return miPeople
    }
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
  
  var maxCount: Int = 0
  
  override func viewDidLoad()
  {
    setupCLManager()
    findLocation()
    setupDataControllers()

    super.viewDidLoad()
    view.backgroundColor = UIColor.darkGray
    personDataController.delegate = self
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(willAddPerson(_:)))
    navigationItem.rightBarButtonItem = addButton
    if let split = splitViewController
    {
      let controllers = split.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? KVDetailViewController
      detailViewController?.delegate = self
      detailViewController?.personsArr = people
    }
    tableView.allowsMultipleSelection = true
  }
  override func viewWillAppear(_ animated: Bool)
  {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    //Is this an error is it a possible nil early enough in the lifecycle
    detailViewController?.personsArr = people
    super.viewWillAppear(animated)
  }
  /**
   ## insert a new object of Type ##
   
   - Parameter sender: An *Any*
   */
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
  override func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool
  {
    /*
     Stop and Fix it NAOW
     Deleting persons may cause error
     Expected to never do that
     75% replicable delete people out of order
     Hell person[0] must be owner and logic will say that you can't delete this
     
     So if it is the first. can delete is false.
    */
    ///Disable the delete on section 0
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
//      If through some future mischief or stupidity the arry becomes empty then by deletion /GUI it will insert a new person
      willAddPerson(self)
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
