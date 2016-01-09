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

class MapVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var nearLocations = [String: Location]()
    var nearSchoenHiers = [String: SchoenHier]()
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    var previousRegion: CLLocationCoordinate2D!
    
    override func viewDidLoad() {

        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.delegate = self
        
        googleMap.delegate = self
        googleMap.myLocationEnabled = true
        
        super.viewDidLoad()
    }
    
    /* delegate on map camerachange */
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        
        print("didChangeCameraPosition")
        getNearLocations(position.target, maxDistance: 0.5)
        getNearSchoenHiers(position.target, maxDistance: 0.5)
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        print(marker.userData)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("LocationDetailVC") as! LocationDetailVC
        nextViewController.location = self.nearLocations[String(marker.userData)]
        
        
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    /* delegate on gpsAuthorizationStatus change */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status:CLAuthorizationStatus) {
    
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    /* delegate on user position update */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

    func showLocationMarker(lat:Double, long:Double, location:Location!) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.icon = UIImage(named: "location")
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        marker.zIndex = 10
        marker.title = location.title
        marker.userData = location.id
        marker.map = googleMap
    }
    
    func showHeatMapMarker(lat:Double, long:Double, schoenHier:SchoenHier!) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.icon = UIImage(named: "heatmap")
        marker.opacity = 0.3
        marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        marker.flat = true
        marker.zIndex = 5
        marker.map = googleMap
    }
    
    func getNearLocations(target: CLLocationCoordinate2D, maxDistance: Float) {
        LocationService.getNearby(target.latitude, long: target.longitude, maxDistance: maxDistance, limit: 15).then { locations -> Void in
            
            for location in locations {
                
                if (self.nearLocations[location.id] == nil) {
                    self.nearLocations[location.id] = location
                    self.showLocationMarker(location.getGeoPosition().lat, long: location.getGeoPosition().long, location:location)
                }
            }
        }
    }
    
    func getNearSchoenHiers(target: CLLocationCoordinate2D, maxDistance:Float) {
        LocationService.getSchoenHiers(target.latitude, long: target.longitude, maxDistance: maxDistance, limit: 100).then { schoenHiers -> Void in
            
            for schoenHier in schoenHiers {
            
                if (self.nearSchoenHiers[schoenHier.id] == nil) {
                    self.nearSchoenHiers[schoenHier.id] = schoenHier
                    self.showHeatMapMarker(schoenHier.getGeoPosition().lat, long: schoenHier.getGeoPosition().long, schoenHier: schoenHier)
                }
            }
        }
    }
    @IBAction func locate(sender: AnyObject) {
        self.googleMap.animateToCameraPosition(GMSCameraPosition(target: self.googleMap.myLocation.coordinate, zoom: 17, bearing: 0, viewingAngle: 0))
    }
    
    @IBAction func schoenHier(sender: AnyObject) {
        LocationService.schonHier(googleMap.myLocation.coordinate.latitude, long: googleMap.myLocation.coordinate.longitude).then {
            schoenHier -> Void in
            print("Success")
            self.getNearSchoenHiers(self.googleMap.myLocation.coordinate, maxDistance: 0.2)
            self.nearSchoenHiers[schoenHier.id] = schoenHier
            self.showHeatMapMarker(schoenHier.getGeoPosition().lat, long: schoenHier.getGeoPosition().long, schoenHier: schoenHier)
            self.locate(self)
        }
    }
    

}
