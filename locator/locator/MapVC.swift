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
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var nearLocations = [String: Location]()
    var currentVisibleWidthInKilometers:Double = 3

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        mapView.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations.last
        print(location?.coordinate.latitude, location?.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
        let lat = location?.coordinate.latitude
        let long = location?.coordinate.longitude

        LocationService.getNearby(lat!, long: long!, maxDistance: 1, limit: 5) { (locations) -> Void in
            
            for location in locations {
                self.showMarker(location.getGeoPosition().lat, long: location.getGeoPosition().long, location: location)
            }
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getNearLocations()
        
        let lat1 = mapView.region.center.latitude - mapView.region.span.latitudeDelta * 0.5
        let long1 = mapView.region.center.longitude
        
        let lat2 = mapView.region.center.latitude + mapView.region.span.latitudeDelta * 0.5
        let long2 = mapView.region.center.longitude
        
        
        let location1 = CLLocation(latitude: lat1, longitude: long1)
        let location2 = CLLocation(latitude: lat2, longitude: long2)
        
        currentVisibleWidthInKilometers = location1.distanceFromLocation(location2) / 1000
        print(currentVisibleWidthInKilometers)
    }

    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    
    }
    
    
   
    func showMarker(lat:Double, long:Double, location:Location!) {
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        anotation.title = location.title
        mapView.addAnnotation(anotation)
    }
    
    func getNearLocations() {
        LocationService.getNearby(mapView.region.center.latitude, long: mapView.region.center.longitude, maxDistance: currentVisibleWidthInKilometers, limit: 15) { (locations) -> Void in
            
            for location in locations {
                
                if (self.nearLocations[location.id] == nil) {
                    self.nearLocations[location.id] = location
                    self.showMarker(location.getGeoPosition().lat, long: location.getGeoPosition().long, location:location)
                }
                
            }
        }
        
    }
    
    func mapUpdate() {
        print("update")
    }
    
}
