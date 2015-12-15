//
//  MapVC.swift
//  locator
//
//  Created by Michael Knoch on 15/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    var lastLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = self.view as! GMSMapView
        mapView.camera = GMSCameraPosition.cameraWithLatitude(47.66492492654014, longitude: 9.199697971343934, zoom: 10)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations.last
        print(location?.coordinate.latitude, location?.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    


    @IBAction func buttonUp(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }

    

}
