//
//  BubbleVC.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class BubbleVC: UIViewController {
    
//    let long = 9.169753789901733
//    let lat = 47.66868204997508
//    let maxDistance: Float = 2.0
//    let limit = 20
    let colorRed = Color.red()
    
    // Schoenhier
    @IBOutlet weak var schoenHierImageView: UIImageView!
    // UserProfil
    // First Bubble
    @IBOutlet weak var firstBubbleImageView: UIImageView!
    // Second Bubble
    @IBOutlet weak var secondBubbleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        BubbleService.getBubbles(lat, long: long, maxDistance: maxDistance, limit: limit).then { bubbles -> Void in
//            
//            }
//            .then {
//                self.reloadInputViews()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutBubbles(firstBubbleImageView)
        layoutBubbles(secondBubbleImageView)
    }
    
    func layoutBubbles(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = colorRed.first.CGColor
        imageView.layer.borderWidth = 4
    }
    
}
