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
ACTUALLY if I think about it for a moment, I can hide this window and _only_ present the detail if the arrays are empty. Then in the detail I can set the state/isVisible on everything except a setupButton. This will pound through getting the data and setting owner. So Back to the _PDC Class
OK I have set the DetailView as top in the App Delegate. All I need to do is hide the UI and only have an setup button See. the Split view Tag in appDeli
Well I *Do* need to add a protocol here for the setup to init an owner and all that this entails, _BUT_ I do not need one per se for the regular<T> inits/save/load.
 */
import UIKit
import CoreData
import CoreLocation
import MapKit
import HealthKit
import HealthKitUI

class KVPrimeTVController: UITableViewController, CLLocationManagerDelegate, MapKhanDelegate {

  var detailViewController: KVDetailViewController? = nil
  var currentPerson: KVPerson?
  {
    didSet {
      // Update the view.
      //        configureView()
    }
  }
  var AllDataController = KVOsirisDataController()
  var personDataController = KVPersonDataController()
  var vendorDataController = KVVendorDataController()
  var allItemsDataController = KVItemDataController()
  var sessionDataController = KVSessionDataController()
  var locationManager : CLLocationManager? = CLLocationManager()
  // kNew
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
    self.setupCLManager()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? KVDetailViewController
      detailViewController?.delegate = self
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
    self.personDataController.makePerson()
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    self.detailViewController?.detailItem = (people[0])
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
      self.insertNewObject(self)
      tableView.reloadData()
    }
  }
  //
  
  func setupCLManager ()
  {
    self.locationManager?.delegate = self
    setupCLAuthState()
    locationManager?.distanceFilter = kCLDistanceFilterNone
    // According to BestPractices I was OK but now I am modern
    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    //looking into a no-init bug
    //    locationManager?.activityType = .otherNavigation
    locationManager?.startUpdatingLocation()
    findLocation()
  }
  func setupCLAuthState()
  {
    if (CLLocationManager.authorizationStatus() == .notDetermined) {
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
  func findLocation()
  {
    let defLat : Double = 37.33115792
    let defLon : Double = -122.03076853
    ///These locations are from gdb output,
    // They should be revised to reflect "home"
    print(locationManager?.location?.coordinate.latitude ?? defLat)
    print(locationManager?.location?.coordinate.longitude ?? defLon)
  }
  func foundLocation()
  {
    locationManager?.stopUpdatingLocation()
  }
  // moved the coder to the AresDataController
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
//MARK: - Conformance is Complinace!
  //
  // MARK: Protocol Conformance
  //
  func didChangePerson(_ entity: KVPerson)
  {
    personDataController.saveCurrentContext(personDataController.MOC!)
    tableView.reloadData()
  }
  func willAddPerson(_ deli: Any?)
  {
    self.insertNewObject(self)
  }
  func didChangeGraphicsOn(_ entity: KVGraphics)
  {
    if currentPerson?.graphics != entity {
      currentPerson?.graphics = entity
    }
//    configureView()
    // pass it to the other deli
//    delegate?.didChangePerson(currentPerson!)
  }
  // Protocol Usage
  @IBAction func addPerson(_ sender: AnyObject)
  {
//    delegate?.willAddPerson(delegate)
//    currentPerson = pdc.getAllEntities()[0]
//    configureView()
  }
  @IBAction func addMessage()
  {
    /**
     OK I had to clean this up in Both places
     */
//    delegate?.willMakeMessageFromPerson(currentPerson!) //It needs to reload table data
  }
  @IBAction func AddPlace()
  {
//    delegate?.willMakeNewPlaceHere(delegate)
//    configureView()
  }
  @IBAction func addEvent()
  {
//    delegate?.willAddNewEvent(self)
  }
}

