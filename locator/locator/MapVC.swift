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
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations.last
        print(location?.coordinate.latitude, location?.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
        let lat = location?.coordinate.latitude
        let long = location?.coordinate.longitude

        showMarker(lat!, long: long!, location: false)
        
        LocationService.getNearby(lat!, long: long!, maxDistance: 3, limit: 15) { (locations) -> Void in
            
            for location in locations {
                self.showMarker(location.getGeoPosition().lat, long: location.getGeoPosition().long, location: true)
            }
        }
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(lat!, longitude: long!, zoom: 15))
    }
    
    
    
    @IBAction func buttonUp(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    func showMarker(lat:Double, long:Double, location:Bool) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        if (location) {
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
            marker.opacity = 0.8
        }
    }
}
