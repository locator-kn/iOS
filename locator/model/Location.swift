//
//  File.swift
//  locator
//
//  Created by Michael Knoch on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class Location {
    
    let id:String
    let geoPosition:(lat :Double, long :Double)

    var title:String
    var city:String!
    var imagePath:String!
    
    init(id: String, title: String, long: Double, lat: Double ) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)
    }
    
    init(id: String, title: String, long: Double, lat: Double, city:String, imagePath: String) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)
        self.imagePath = imagePath
        self.city = city
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getGeoPosition() -> (lat :Double, long :Double) {
        return self.geoPosition
    }
    
    func getData() {
        LocationService.locationById(self.id) { (location) -> Void in
            self.title = location.title
            self.imagePath = location.imagePath
            self.city = location.city
        }
    }
    
    
}