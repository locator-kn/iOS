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
        
        addGestureRecognizer()
        
        
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
    
    func addGestureRecognizer() {
        let schoenHierGesture = UITapGestureRecognizer(target:self, action:Selector("schoenHierTapped:"))
        schoenHierImageView.addGestureRecognizer(schoenHierGesture)
        let userProfileGesture = UITapGestureRecognizer(target:self, action:Selector("userProfileTapped:"))
        userProfilImageView.addGestureRecognizer(userProfileGesture)
        let firstBubbleGesture = UITapGestureRecognizer(target:self, action:Selector("firstBubbleTapped:"))
        firstBubbleImageView.addGestureRecognizer(firstBubbleGesture)
        let secondBubbleGesture = UITapGestureRecognizer(target:self, action:Selector("secondBubbleTapped:"))
        secondBubbleImageView.addGestureRecognizer(secondBubbleGesture)
        let thirdBubbleGesture = UITapGestureRecognizer(target:self, action:Selector("thirdBubbleTapped:"))
        thirdBubbleImageView.addGestureRecognizer(thirdBubbleGesture)
        let fourthBubbleGesture = UITapGestureRecognizer(target:self, action:Selector("fourthBubbleTapped:"))
        fourthBubbleImageView.addGestureRecognizer(fourthBubbleGesture)
        let fifthBubbleGesture = UITapGestureRecognizer(target:self, action:Selector("fifthBubbleTapped:"))
        fifthBubbleImageView.addGestureRecognizer(fifthBubbleGesture)
        let sixthBubbleGesture = UITapGestureRecognizer(target:self, action:Selector("sixthBubbleTapped:"))
        sixthBubbleImageView.addGestureRecognizer(sixthBubbleGesture)
    }
    
    func schoenHierTapped(imageView: UIImageView) {
        
    }
    
    func userProfileTapped(imageView: UIImageView) {
        
    }
    
    func firstBubbleTapped(imageView: UIImageView) {
        
    }
    
    func secondBubbleTapped(imageView: UIImageView) {
        
    }
    
    func thirdBubbleTapped(imageView: UIImageView) {
        
    }
    
    func fourthBubbleTapped(imageView: UIImageView) {
        print("4")
    }
    
    func fifthBubbleTapped(imageView: UIImageView) {
        
    }
    
    func sixthBubbleTapped(imageView: UIImageView) {
        print("6")
    }
    
}
