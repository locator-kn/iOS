//
//  MapVC.swift
//  locator
//
//  Created by Michael Knoch on 15/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = self.view as! GMSMapView
        mapView.camera = GMSCameraPosition.cameraWithLatitude(-33.8600, longitude: 151.2094, zoom: 10)
    }

  
    

}
