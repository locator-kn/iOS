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
    @IBOutlet weak var userProfilImageView: UIImageView!
    // First Bubble
    @IBOutlet weak var firstBubbleImageView: UIImageView!
    // Second Bubble
    @IBOutlet weak var secondBubbleImageView: UIImageView!
    // Third Bubble
    @IBOutlet weak var thirdBubbleImageView: UIImageView!
    // Fourth Bubble
    @IBOutlet weak var fourthBubbleImageView: UIImageView!
    // Fifth Bubble
    @IBOutlet weak var fifthBubbleImageView: UIImageView!
    // Sixth Bubble
    @IBOutlet weak var sixthBubbleImageView: UIImageView!
    
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
        layoutUserProfilImageView()
        layoutBubble(firstBubbleImageView)
        layoutBubble(secondBubbleImageView)
        layoutBubble(thirdBubbleImageView)
        layoutBubble(fourthBubbleImageView)
        layoutBubble(fifthBubbleImageView)
        layoutBubble(sixthBubbleImageView)
    }
    
    func layoutUserProfilImageView() {
        userProfilImageView.layer.cornerRadius = userProfilImageView.frame.width / 2
        userProfilImageView.clipsToBounds = true
    }
    
    func layoutBubble(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = colorRed.first.CGColor
        imageView.layer.borderWidth = 4
    }
    
}
