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

class KVPrimeTVController: UITableViewController  {
  /**
   */
  var detailViewController: KVDetailViewController? = nil
  /**
   */
  var currentPerson: KVPerson?
  {
    didSet {
      // Update the view.
    }
  }
  var AllDataController = KVOsirisDataController()
  var allItemsDataController = KVItemDataController()
  var mapViewTableCell = KVMapTableViewCell()
  var locationManager : CLLocationManager? = CLLocationManager()
  
  var pdc = KVPersonDataController()
  var vdc = KVVendorDataController()
  var sdc = KVSessionDataController()
  
  var people : Array <KVPerson> {
    get {
      detailViewController?.personsArr = pdc.getAllEntities()
      return pdc.getAllEntities()
    }
  }
  var vendors : Array <KVVendor> {
    get {
      return vdc.getAllEntities()
    }
  }
  var sessions : Array <KVSession> {
    get {
      return sdc.getAllEntities()
    }
  }
  // TODO: Run Setup if people.isEmpty
  override func viewDidLoad()
  {
    self.setupDataControllers()
    if (self.AllDataController.getAllEntities().isEmpty) {
      print("Nope")
    }
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    pdc.delegate = self
    
    navigationItem.leftBarButtonItem = editButtonItem
    self.setupCLManager()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton
    if let split = splitViewController {
      let controllers = split.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? KVDetailViewController
    }
  }
  override func viewWillAppear(_ animated: Bool)
  {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    //    setupDetailViewController()
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
    pdc.delegate?.willAddPerson(self)
  }
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let person = people[indexPath.row] //as! NSDate
        let dvc = (segue.destination as! UINavigationController).topViewController as! KVDetailViewController
        dvc.detailItem = person
        dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        dvc.navigationItem.leftItemsSupplementBackButton = true
        //          controller.personsArr = pdc.getAllEntities()
      }
    }
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
    if (section == 0) {
      rowCount = people.count
    }
    if (section == 1) {
      rowCount = vendors.count
    }
    if (section == 2) {
      rowCount = sessions.count
    }
    return(rowCount)
    
  }
  // MARK: - Update Cells
  // FIXME: - These are NOT custom in the XIB and Are Barely custom Here:
  /**
   
  */
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
        self.pdc.deleteEntityInContext(self.pdc.PSK.viewContext, entity: (people[indexPath.row]))
      //        tableView.deleteRows(at: [indexPath], with: .fade)
      case 1:
        self.vdc.deleteEntityInContext(self.vdc.PSK.viewContext, entity: (vendors[indexPath.row]))
      //        tableView.deleteRows(at: [indexPath], with: .fade);
      case 2:
        self.sdc.deleteEntityInContext(self.sdc.PSK.viewContext, entity: (sessions[indexPath.row]))
      //        tableView.deleteRows(at: [indexPath], with: .fade)
      default:
        break
      }
      tableView.deleteRows(at: [indexPath], with: .fade)
      self.pdc.saveCurrentContext(pdc.MOC!)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    if pdc.getAllEntities().count == 0
    {
      self.insertNewObject(self)
      tableView.reloadData()
    }
  }
  //
}
