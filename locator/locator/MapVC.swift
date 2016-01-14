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
    
    var locationMarkers = [GMSMarker]()
    var schoenHierMarkers = [GMSMarker]()
    
    var pickedLocationDetail:Location!
    
    let heatmapIcon = UIImage(named: "show_heatmap") as UIImage?
    let locationsIcon = UIImage(named: "show_locations") as UIImage?
    let optionsIcon = UIImage(named: "show_options") as UIImage?
    
    let heatmapActiveIcon = UIImage(named: "show_heatmap_active") as UIImage?
    let locationsActiveIcon = UIImage(named: "show_locations_active") as UIImage?
    let optionsActiveIcon = UIImage(named: "show_options_active") as UIImage?
    
    var toggleOptionsActive:Bool = false
    
    /* constraint outlets for options animation */
    @IBOutlet weak var locationBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var heatMapBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var heatMapButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    var previousRegion: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        
        /* hide optionmenu on load */
        self.locationBottomSpace.constant = 11
        self.heatMapBottomSpace.constant = 11
        self.heatMapButton.alpha = 0
        self.locationButton.alpha = 0

        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.delegate = self
        
        googleMap.delegate = self
        googleMap.myLocationEnabled = true
        
        super.viewDidLoad()
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
    
    func showLocationMarker(lat:Double, long:Double, location:Location!) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.icon = UIImage(named: "location")
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        marker.zIndex = 10
        marker.title = location.title
        marker.userData = location
        marker.map = googleMap
        
        locationMarkers.append(marker)
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
        
        schoenHierMarkers.append(marker)
    }
    
    /* delegate on map camerachange */
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        
        print("didChangeCameraPosition")
        getNearLocations(position.target, maxDistance: 0.5)
        getNearSchoenHiers(position.target, maxDistance: 0.5)
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        print(marker.userData)
        pickedLocationDetail = marker.userData as! Location
        performSegueWithIdentifier("locationDetail", sender: self)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if (segue.identifier == "locationDetail") {
            let controller = segue.destinationViewController as! LocationDetailVC
            controller.location = pickedLocationDetail
        }
    }
    
    @IBAction func toggleMapOptions(sender: AnyObject) {
        
        if toggleOptionsActive {
            self.locationBottomSpace.constant = 11
            self.heatMapBottomSpace.constant = 11
    
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
                self.heatMapButton.alpha = 0
                self.locationButton.alpha = 0
            }
            toggleOptionsActive = false
            
            
        } else {
            self.locationBottomSpace.constant = 67
            self.heatMapBottomSpace.constant = 127
            
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
                self.heatMapButton.alpha = 1
                self.locationButton.alpha = 1
            }
            toggleOptionsActive = true
        }
    }

    @IBAction func toggleLocations(sender: AnyObject) {
        if iterateAndToggleMapReference(locationMarkers) {
            self.locationButton.setImage(self.locationsActiveIcon, forState: .Normal)
        } else {
            self.locationButton.setImage(self.locationsIcon, forState: .Normal)
        }
    }
    
    @IBAction func toggleHeatMap(sender: AnyObject) {
        if iterateAndToggleMapReference(schoenHierMarkers) {
            self.heatMapButton.setImage(self.heatmapActiveIcon, forState: .Normal)
        } else {
            self.heatMapButton.setImage(self.heatmapIcon, forState: .Normal)
        }
    }
    
    /* returns true if markers are visible */
    func iterateAndToggleMapReference(markers: [GMSMarker]) -> Bool {
        var targetMap:GMSMapView? = nil
        if (markers[0].map == nil) {
            targetMap = googleMap
        }
        for marker in markers {
            marker.map = targetMap
        }
        return targetMap != nil
    }
    
}
