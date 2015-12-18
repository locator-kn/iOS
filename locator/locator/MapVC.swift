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

class MapVC: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var nearLocations = [String: Location]()
    var nearSchoenHiers = [String: SchoenHier]()
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var previousRegion: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        mapView.delegate = self
        
        searchField.delegate = self
        
        searchField.attributedPlaceholder = NSAttributedString(string: "Suche")
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
        let annotation = LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), title: location.title)
        mapView.addAnnotation(annotation)
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
    
    func textFieldShouldReturn(searchField: UITextField) -> Bool {
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchField.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse != nil{
                self.mapView.setRegion(localSearchResponse!.boundingRegion, animated: true)
            } else {
                print(error)
            }
        }
        return true
    }
    
    // MARK: - MapView Delegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is LocationAnnotation) {
            var mapView = mapView.dequeueReusableAnnotationViewWithIdentifier("view")
            if mapView == nil {
                mapView = MKAnnotationView(annotation: annotation, reuseIdentifier: "view")
                mapView!.image = UIImage(named:"location")
                mapView!.canShowCallout = true
            } else {
                //we are re-using a view, update its annotation reference...
                mapView!.annotation = annotation
            }
            return mapView
        } else {
            return nil
        }
        
    }
    

}
