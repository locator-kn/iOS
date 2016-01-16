//
//  File.swift
//  locator
//
//  Created by Michael Knoch on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit

class Location {
    
    let id:String
    let geoPosition:(lat :Double, long :Double)

    var title:String
    var city:String!
    var imagePath:String!
    var thumb:UIImage!
    var description:String!
    //favored by me
    var favored:Bool!
    var favorites:Int!
    var stream:[AbstractImpression]!
    
    init(id: String, title: String, long: Double, lat: Double) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)
    }
    
    init(id: String, title: String, long: Double, lat: Double, thumb:UIImage) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)
        self.thumb = thumb
    }
    
    init(id: String, title: String, description:String, long: Double, lat: Double, city:String, imagePath: String, favored: Bool, favorites:Int) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)
        self.imagePath = imagePath
        self.city = city
        self.description = description
        self.favored = favored
        self.favorites = favorites
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getGeoPosition() -> (lat :Double, long :Double) {
        return self.geoPosition
    }
    
    func getData() {
        LocationService.locationById(self.id).then { (location) -> Void in
            self.title = location.title
            self.imagePath = location.imagePath
            self.city = location.city
        }
    }
    
    
}