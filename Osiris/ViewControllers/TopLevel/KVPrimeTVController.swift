/**
 MasterViewController.swift
 Osiris

 Created by Kenn Villegas on 6/13/17.
 Copyright © 2017 dubian. All rights reserved.
*/
/**
Cleaned out this and put it into the .rad file
This class is still hella big.
 */
import UIKit
import CoreData
import CoreLocation
import MapKit
import HealthKit
import HealthKitUI

class KVPrimeTVController: UITableViewController, CLLocationManagerDelegate, PersonConDelegate {

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
  // MARK: - Set Application State
  /**
  */
  func setupDataControllers()
  {
    if self.pdc.MOC != self.AllDataController.PSK.viewContext {
      self.pdc.MOC = self.AllDataController.PSK.viewContext
    }
    if self.sdc.MOC != self.AllDataController.PSK.viewContext {
      self.sdc.MOC = self.AllDataController.PSK.viewContext
    }
    if self.vdc.MOC != self.AllDataController.PSK.viewContext {
      self.vdc.MOC = self.AllDataController.PSK.viewContext
    }
  }
  /**
  */
  func setupDummyLoad()
  {
    if (vendors.isEmpty) {
      self.vdc.makeVendor()
    }
    if (sessions.isEmpty) {
      self.sdc.makeSession()
    }
  }
  /**
  */
  func setupCLManager ()
  {
    self.locationManager?.delegate = self
    setupCLAuthState()
    locationManager?.distanceFilter = kCLDistanceFilterNone
    // According to BestPractices I was OK but now I am modern
    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation

    locationManager?.startUpdatingLocation()
    findLocation()
  }
  /**
  */
  func setupCLAuthState()
  {
    if (CLLocationManager.authorizationStatus() == .notDetermined)
    {
      locationManager?.requestAlwaysAuthorization() // then set energy states
    }
    
  }
  // TODO: Update the RSRC string/URL in here
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus)
  {
    switch status {
    case .authorizedAlways:
      break
    case .notDetermined:
      manager.requestAlwaysAuthorization()
    case .authorizedWhenInUse, .restricted, .denied:
      
      let alertVC = UIAlertController(
        title: "Background Location Services are Not Enabled",
        message: "In order to better determine usage and data patterns, please open this app's settings and set location access to 'Always'.",
        preferredStyle: .alert)
      //      let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
      alertVC.addAction(UIAlertAction (title: "Cancel", style: .cancel, handler: nil))
      
      let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
        UIApplication.shared.open((URL(string:UIApplicationOpenSettingsURLString)!), options: [ : ], completionHandler: (nil))
      }
      alertVC.addAction(openAction)
      
      present(
        alertVC,
        animated: true,
        completion: nil)
    }
    
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
  {
    print("No-Loc")
  }
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation])
  {
    foundLocation()
  }
  /**
  Find out where we are and then stop
  */
  func findLocation()
  {
    let defLat : Double = 37.33115792
    let defLon : Double = -122.03076853
    ///These locations are from gdb output,
    // They should be revised to reflect "home"
    print(locationManager?.location?.coordinate.latitude ?? defLat)
    print(locationManager?.location?.coordinate.longitude ?? defLon)
  }
  /**
  Yippe
  */
  func foundLocation()
  {
    locationManager?.stopUpdatingLocation()
  }
  // moved the coder to the AresDataController
  /**
  */
  func forwardGeocoding(address: String)
  {
    CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
      if error != nil
      {
        print(error!) //force unwrapped
        return
      }
      if (placemarks?.count)! > 0
      {
        let placemark = placemarks?[0]
        let location = placemark?.location
        let coordinate = location?.coordinate
        print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
        if (placemark?.areasOfInterest?.count)! > 0
        {
          let areaOfInterest = placemark!.areasOfInterest![0]
          print(areaOfInterest)
        }
        else
        {
          print("No area of interest found.")
        }
      }
    })
    //I seriously Better Know What I am doing Next time I see this code: (count 0)
  } // OK it is not what I want (YET)
  //
  // MARK: - Protocol Conformance
  /**
  */
  func didChangePerson(_ entity: KVPerson)
  {
    pdc.saveCurrentContext(pdc.MOC!)
    tableView.reloadData()
  }
  /**
  */
  func willAddPerson(_ deli: Any?)
  {
//    self.insertNewObject(self)
    pdc.makePerson()
    pdc.saveCurrentContext(pdc.MOC!)
    /**
    setup the person
    */
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    detailViewController?.detailItem = (people[0])
  }
  /**
  */
  func didChangeGraphicsOn(_ entity: KVGraphics)
  {
    if currentPerson?.graphics != entity {
      currentPerson?.graphics = entity
    }
//    configureView()
    // pass it to the other deli
//    delegate?.didChangePerson(currentPerson!)
  }
  // MARK: - Conformance is Complinace!
  //
  // Protocol Usage
  /**
  */
  @IBAction func addPerson(_ sender: AnyObject)
  {
//    pdc.delegate?.willAddPerson(self)
  }
  /**
  */
  @IBAction func addMessage()
  {
    /**
     OK I had to clean this up in Both places
     */
//    delegate?.willMakeMessageFromPerson(currentPerson!) //It needs to reload table data
  }
  /**
  */
  @IBAction func AddPlace()
  {
//    delegate?.willMakeNewPlaceHere(delegate)
//    configureView()
  }
  /**
  */
  @IBAction func addEvent()
  {
//    delegate?.willAddNewEvent(self)
  }
}
