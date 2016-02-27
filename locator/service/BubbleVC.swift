//
//  BubbleVC.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class BubbleVC: UIViewController {
    
    let long = 9.169753789901733
    let lat = 47.66868204997508
    let maxDistance: Float = 2.0
    let limit = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BubbleService.getBubbles(lat, long: long, maxDistance: maxDistance, limit: limit).then { bubbles -> Void in
            
        }
            .then {
                self.reloadInputViews()
        }
    }
}
