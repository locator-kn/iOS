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
    var nearSchoenHiers = [String: SchoenHier]()
    
    @IBOutlet weak var mapView: MKMapView!
    var previousRegion: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let latitudeTollerance:Double = 1
        let longitudeTollerance:Double = 1
        
        if ((previousRegion == nil)) {
            previousRegion = mapView.region.center
        }
        
        /* if (mapView.region.center.latitude > previousRegion.latitude + latitudeTollerance
            || mapView.region.center.longitude < previousRegion.longitude + longitudeTollerance
            || mapView.region.center.latitude > previousRegion.latitude - latitudeTollerance
            || mapView.region.center.longitude < previousRegion.longitude - longitudeTollerance) {
              
                previousRegion = mapView.region.center
                print("Update")
        } else {
            return
        } */
        
        let lat1 = mapView.region.center.latitude - mapView.region.span.latitudeDelta * 0.5
        let long1 = mapView.region.center.longitude
        
        let lat2 = mapView.region.center.latitude + mapView.region.span.latitudeDelta * 0.5
        let long2 = mapView.region.center.longitude
        
        
        let location1 = CLLocation(latitude: lat1, longitude: long1)
        let location2 = CLLocation(latitude: lat2, longitude: long2)
        
        let currentVisibleWidthInKilometers = location1.distanceFromLocation(location2) / 1000
        
        getNearLocations(currentVisibleWidthInKilometers)
        getNearSchoenHiers(currentVisibleWidthInKilometers)
    }

    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    
    }
    
    func showMarker(lat:Double, long:Double, location:Location!) {
        let anotation = MKPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        anotation.title = location.title
        mapView.addAnnotation(anotation)
    }
    
    func addHeatmap(lat:Double, long:Double, schoenHier:SchoenHier!) {
        let anotation = MKPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(anotation)
    }
    
    func getNearLocations(maxDistance: Double) {
        LocationService.getNearby(mapView.region.center.latitude, long: mapView.region.center.longitude, maxDistance: maxDistance, limit: 15) { (locations) -> Void in
            
            for location in locations {
                
                if (self.nearLocations[location.id] == nil) {
                    self.nearLocations[location.id] = location
                    self.showMarker(location.getGeoPosition().lat, long: location.getGeoPosition().long, location:location)
                }
            }
        }
    }
    
    func getNearSchoenHiers(maxDistance:Double) {
        LocationService.getSchoenHiers(mapView.region.center.latitude, long: mapView.region.center.longitude, maxDistance: maxDistance, limit: 15) { (schoenHiers) -> Void in
            
            for schoenHier in schoenHiers {
            
                if (self.nearSchoenHiers[schoenHier.id] == nil) {
                    self.nearSchoenHiers[schoenHier.id] = schoenHier
                    self.addHeatmap(schoenHier.getGeoPosition().lat, long: schoenHier.getGeoPosition().long, schoenHier: schoenHier)
                }
            }
        }
    }
    
}
