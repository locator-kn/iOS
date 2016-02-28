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
import PromiseKit

class MapVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var infoWindow: InfoWindow?
    var mapThumb:UIImage?
    var mapThumbId:String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var nearLocations = [String: Location]()
    var nearSchoenHiers = [String: SchoenHier]()
    var locationsOfInterest = [String: Location]()
    
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
    var locationsVisible:Bool = true
    var heatmapVisible:Bool = true
    
    @IBOutlet weak var overlay: UIImageView!
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigate"), style: .Plain, target: self, action: "locate")

        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.delegate = self
        
        googleMap.delegate = self
        googleMap.myLocationEnabled = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.overlay.frame
        gradient.colors = [UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.5).CGColor, UIColor.clearColor().CGColor]
        gradient.locations = [0.0, 1]
        self.overlay.layer.insertSublayer(gradient, atIndex: 0)
        
        if (locationsOfInterest.count > 0) {
            self.toggleLocations(self)
            let coordinate = CLLocationCoordinate2D(latitude: locationsOfInterest.values.first!.geoPosition.lat,
                longitude: locationsOfInterest.values.first!.geoPosition.long)
            
            if locationsOfInterest.count == 1 {
                googleMap.camera = GMSCameraPosition(target: coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            } else {
                googleMap.camera = GMSCameraPosition(target: coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
            }
            
            for (_, location) in locationsOfInterest {
                self.showLocationMarker(location.geoPosition.lat, long: location.geoPosition.long,
                    location:location, interesting:true)
            }
        }
        super.viewDidLoad()
    }
    
    func getNearLocations(target: CLLocationCoordinate2D, maxDistance: Float) {
        LocationService.getNearby(target.latitude, long: target.longitude, maxDistance: maxDistance, limit: 15).then { locations -> Void in
            
            for location in locations {
                
                if (self.nearLocations[location.id] == nil && self.locationsOfInterest[location.id] == nil) {
                    self.nearLocations[location.id] = location
                    self.showLocationMarker(location.geoPosition.lat, long: location.geoPosition.long, location:location, interesting: false)
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
    
    func showLocationMarker(lat:Double, long:Double, location:Location!, interesting:Bool) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
       
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        marker.zIndex = 10
        marker.title = location.title
        marker.userData = location
        marker.map = googleMap
        
        if interesting {
            marker.icon = UIImage(named: "location_red")
            if locationsOfInterest.count == 1 {
                self.googleMap.selectedMarker = marker
            }
        } else {
            marker.icon = UIImage(named: "location")
            locationMarkers.append(marker)
        }
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
        
        getNearSchoenHiers(position.target, maxDistance: 0.5)
        if (self.locationsVisible) {
            getNearLocations(position.target, maxDistance: 0.5)
        }
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
        
        if (locationsOfInterest.count > 0) {
            return
        }
        
        if let location = locations.first{
            googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locate() {
        self.googleMap.animateToCameraPosition(GMSCameraPosition(target: self.googleMap.myLocation.coordinate, zoom: 17, bearing: 0, viewingAngle: 0))
    }
    
    @IBAction func schoenHier(sender: AnyObject) {
        LocationService.schonHier(googleMap.myLocation.coordinate.latitude, long: googleMap.myLocation.coordinate.longitude).then {
            schoenHier -> Void in
            print("Success")
            self.getNearSchoenHiers(self.googleMap.myLocation.coordinate, maxDistance: 0.2)
            self.nearSchoenHiers[schoenHier.id] = schoenHier
            self.showHeatMapMarker(schoenHier.getGeoPosition().lat, long: schoenHier.getGeoPosition().long, schoenHier: schoenHier)
            self.locate()
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
            self.optionButton.setImage(self.optionsIcon, forState: .Normal)
            self.locationBottomSpace.constant = 11
            self.heatMapBottomSpace.constant = 11
    
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
                self.heatMapButton.alpha = 0
                self.locationButton.alpha = 0
            }
            toggleOptionsActive = false
            
        } else {
            self.optionButton.setImage(self.optionsActiveIcon, forState: .Normal)
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
        
        if self.nearLocations.count == 0 {
            getNearLocations(googleMap.camera.target, maxDistance: 0.5)
        }
        
        if iterateAndToggleMapReference(locationMarkers, flag: self.locationsVisible) {
            self.locationButton.setImage(self.locationsActiveIcon, forState: .Normal)
        } else {
            self.locationButton.setImage(self.locationsIcon, forState: .Normal)
        }
        self.locationsVisible = !self.locationsVisible
    }
    
    @IBAction func toggleHeatMap(sender: AnyObject) {
        
        if iterateAndToggleMapReference(schoenHierMarkers, flag: self.heatmapVisible) {
            self.heatMapButton.setImage(self.heatmapActiveIcon, forState: .Normal)
        } else {
            self.heatMapButton.setImage(self.heatmapIcon, forState: .Normal)
        }
        self.heatmapVisible = !self.heatmapVisible
    }
    
    /* returns true if markers are visible */
    func iterateAndToggleMapReference(markers: [GMSMarker], flag:Bool) -> Bool {
        var targetMap:GMSMapView? = nil
        
        if (markers.count > 0) {
            if (!flag) {
                targetMap = googleMap
            }
            for marker in markers {
                marker.map = targetMap
            }
            return targetMap != nil
        }
        return !flag
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        infoWindow = NSBundle.mainBundle().loadNibNamed("InfoWindow", owner: self, options: nil).first as? InfoWindow
        
        let locationData = marker.userData as? Location
        infoWindow!.title.text = locationData?.title
        infoWindow!.favorites.text = String(locationData!.favorites!)        
        infoWindow!.author.text = locationData?.user.name
        
        infoWindow!.author.sizeToFit()
        infoWindow!.favorites.sizeToFit()
     
        if (self.mapThumb != nil && self.mapThumbId == locationData?.id) {
            infoWindow!.image.image = self.mapThumb
            
            
        } else {
            let imagePromise = UtilService.dataFromCache(locationData!.imagePathNormal)
            let userPromise = UserService.getUser(locationData!.user.id!)
            
            when(imagePromise, userPromise).then {
                image, user -> Void in
                self.mapThumb = UIImage(data: image)
                locationData?.user = user
                self.mapThumbId = locationData?.id
                self.googleMap.selectedMarker = self.googleMap.selectedMarker
            }
        }
        
        print("Infowindow returned")
        
        return infoWindow
    }
    
    
}
