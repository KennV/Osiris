/**
 MasterViewController.swift
 Osiris

 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
*/
/**
20170708@12:30
OK in its basic form I will need 3 sections in some table view
I already have a Peron/People/Owner and Vendor. So i Added
Sessions, and its parent controller.
Also sort of undocumented, I have it at about 50% test coverage. which
I really enjoy.

I am not sure what I will get in the DVC if I have no object. That is one reason to have a setup function. ~ ~ I will need just some basic logic to make a person if the array is empty when I delete the person - so the array cannot be empty. Next I have to see if Person<T> has types - - Nope that is in root so I will be testing if the item at people[0] is "Owner" or "Friend"
ACTUALLY if I tink about it for a moment, I can hide this window and _only_ present the detail if the arrays are empty. Then in the detail I can set the state/isVisible on everything except a setupButton. This will pound through getting the data and setting owner. So Back to the _PDC Class
*/
import UIKit
import CoreLocation

class KVPrimeTVController: UITableViewController {

  var detailViewController: KVDetailViewController? = nil

  var AllDataController = KVOsirisDataController()
  var personDataController = KVPersonDataController()
  var vendorDataController = KVVendorDataController()
  var allItemsDataController = KVItemDataController()
  var sessionDataController = KVSessionDataController()
  
  var people : Array <KVPerson> {
    get {
      return personDataController.getAllEntities()
    }
    set { }
  }
  var vendors : Array <KVVendor> {
    get {
      return vendorDataController.getAllEntities()
    }
    set { }
  }
  
  var sessions : Array <KVSession> {
    get {
      return sessionDataController.getAllEntities()
    }
    set { }
  }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    navigationItem.leftBarButtonItem = editButtonItem

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
    super.viewWillAppear(animated)
  }
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func insertNewObject(_ sender: Any)
  {
    //    PDC.createPersonInContext(PDC.MOC!)
    self.personDataController.makePerson()
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "showDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
            let person = people[indexPath.row] //as! NSDate
            let controller = (segue.destination as! UINavigationController).topViewController as! KVDetailViewController
            controller.detailItem = person
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
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
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    
    if (indexPath.section == 0)
    {
      let c = tableView.dequeueReusableCell(withIdentifier: "OwnerCell", for: indexPath)
          let person = people[indexPath.row]
          c.textLabel!.text = person.incepDate?.description
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
      let d = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) //as! KVBasicCustomCell
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
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete {
      self.personDataController.deleteEntityInContext(self.personDataController.PSK.viewContext, entity: (people[indexPath.row]))
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    if personDataController.getAllEntities().count == 0
    {
              self.personDataController.makePerson()
              tableView.reloadData()
    }
  }
}

