//
//  SchoenHier.swift
//  locator
//
//  Created by Michael Knoch on 17/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class SchoenHier {
    
    let id:String
    let createDate: String
    var geoPosition:(lat :Double, long :Double)
    
    init(id: String, createDate:String, long: Double, lat: Double ) {
        self.id = id
        self.createDate = createDate
        self.geoPosition = (lat: lat, long: long)
    }
    
    func getGeoPosition() -> (lat :Double, long :Double) {
        return self.geoPosition
    }
    
}