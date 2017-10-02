/**
*/

import UIKit
import MapKit

extension KVMapViewController: CLLocationManagerDelegate
{
//  @objc func getCurrentLocation(){
//  }
  func setupMapView() {
//    OKilly Do this is now a crasher
    mapView?.delegate = self
    // .Hybrid - Has Scale; .Standard Has all Custom camera No Scale Bar
    mapView?.mapType = .hybridFlyover
    
    
    
    let loc = CLLocation(latitude: (detailPerson?.location?.latitude?.doubleValue)!, longitude:(detailPerson?.location?.longitude?.doubleValue)!)
    let defR = MKCoordinateRegionMakeWithDistance(loc.coordinate, 5000, 5000)
    mapView?.setRegion(defR, animated: true)
    
    
    let camera = MKMapCamera()
    camera.centerCoordinate = (mapView?.centerCoordinate)!
    camera.pitch = 70
    camera.altitude = 400
    camera.heading = 0
    print("\(String(describing: mapView?.centerCoordinate.latitude))")
    //
    //    mapView.camera = camera
    //    let defLoc = CLLocation(latitude: (39.329842664338024), longitude: (-76.607890399244241))
    //    let defR = MKCoordinateRegionMakeWithDistance(loc.coordinate, 5000, 5000)
    //    mapView.setRegion(defR, animated: true)
    /**
     terminating because it runs slow as fuck in sim and I do not have batteries to do it in HW
     */
  }

}
