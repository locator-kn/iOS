//
//  GpsService.swift
//  locator
//
//  Created by Michael Knoch on 31/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import CoreLocation

class GpsService: NSObject, CLLocationManagerDelegate {
    
    var lat:CLLocationDegrees = CLLocationDegrees(0.0)
    var long:CLLocationDegrees = CLLocationDegrees(0.0)
    var locationManager:CLLocationManager = CLLocationManager()
    var deniedHandler:((Bool) -> Void)!
    var successHandler:((Bool) -> Void)!
    var initial = false
    
    init(successHandler: (Bool) -> Void, deniedHandler: (Bool) -> Void) {
        super.init()
        self.deniedHandler = deniedHandler
        self.successHandler = successHandler
        setupLocationManager()
    }
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5.0
        self.locationManager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.deniedHandler(true)
            locationManager.startUpdatingLocation()
        } else if status == .Denied {
            self.deniedHandler(false)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lat = (locations.first?.coordinate.latitude)!
        long = (locations.first?.coordinate.longitude)!
        
        if !self.initial {
            self.initial = true
            self.successHandler(true)
        }
    }
    
    func getMaybeCurrentLocation() -> [CLLocationDegrees: CLLocationDegrees] {
        return [lat: long]
    }
    
    func unsubscribeGps() {
        locationManager.stopUpdatingLocation()
    }
    
}