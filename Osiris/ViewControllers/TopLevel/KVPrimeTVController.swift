/**
 MasterViewController.swift
 Osiris

 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
*/

import UIKit

class KVPrimeTVController: UITableViewController {

  var detailViewController: KVDetailViewController? = nil

  var AllDataController = KVOsirisDataController()
  var personDataController = KVPersonDataController()
  var vendorDataController = KVVendorDataController()

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
  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int
  {
    return(people.count)
  }
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let person = people[indexPath.row]
    cell.textLabel!.text = person.incepDate?.description
    return cell
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
  }
}

