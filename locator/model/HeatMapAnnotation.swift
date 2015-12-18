//
//  HeatMapAnnotation.swift
//  locator
//
//  Created by Michael Knoch on 18/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import MapKit

class HeatMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}