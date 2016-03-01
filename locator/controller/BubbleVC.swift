//
//  BubbleVC.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class BubbleVC: UIViewController {
    
    //let long = 9.169753789901733
    //let lat = 47.66868204997508
    let maxDistance: Float = 2.0
    let limit = 6
    let colorRed = Color.red()
    
    var locations = [Location]()
    var detailLocation: Location?
    
    var gps:GpsService!
    
    // Schoenhier
    @IBOutlet weak var schoenHierImageView: UIImageView!
    // UserProfil
    @IBOutlet weak var userProfilImageView: BubbleView!
    // First Bubble
    @IBOutlet weak var firstBubbleImageView: BubbleView!
    // Second Bubble
    @IBOutlet weak var secondBubbleImageView: BubbleView!
    // Third Bubble
    @IBOutlet weak var thirdBubbleImageView: BubbleView!
    // Fourth Bubble
    @IBOutlet weak var fourthBubbleImageView: BubbleView!
    // Fifth Bubble
    @IBOutlet weak var fifthBubbleImageView: BubbleView!
    // Sixth Bubble
    @IBOutlet weak var sixthBubbleImageView: BubbleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map_icon_white"), style: .Plain, target: self, action: "showMap")
        
        addGestureRecognizer()
        
        gps = GpsService(deniedHandler: gpsDeniedHandler)
        let location = gps.getMaybeCurrentLocation()
        let lat = location.keys.first
        let long = location.values.first
        BubbleService.getBubbles(lat!, long: long!, maxDistance: maxDistance, limit: limit).then { bubbles -> Void in
            
            for (index, element) in bubbles.enumerate() {
                self.locations.append(element)
                self.loadLocationImage(index, urlPath: element.imagePathNormal)
            }
            
            }
            .then {
                result -> Void in
                self.reloadInputViews()
                
                self.firstBubbleImageView.show()
                self.secondBubbleImageView.show()
                self.thirdBubbleImageView.show()
                self.fourthBubbleImageView.show()
                self.fifthBubbleImageView.show()
                self.sixthBubbleImageView.show()
                
                
        }
    }
    
    func gpsDeniedHandler(accessGranted: Bool) {
        print("TODO handle access:", accessGranted)
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
        let schoenHierGesture_hold = UILongPressGestureRecognizer(target:self, action:Selector("schonHierLongPress:"))
        schoenHierImageView.addGestureRecognizer(schoenHierGesture)
        schoenHierImageView.addGestureRecognizer(schoenHierGesture_hold)
        
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
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Left
        view.addGestureRecognizer(rightSwipe)
    }
    
    func schoenHierTapped(imageView: UIImageView) {
        performSegueWithIdentifier("map", sender: self)
    }
    
    func schonHierLongPress(imageView: UIImageView) {
        performSegueWithIdentifier("createLocation", sender: self)
    }
    
    func userProfileTapped(imageView: UIImageView) {
        performSegueWithIdentifier("showOwnProfil", sender: self)
    }
    
    func firstBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[0]
        showDetailView()
    }
    
    func secondBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[1]
        showDetailView()
    }
    
    func thirdBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[2]
        showDetailView()
    }
    
    func fourthBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[3]
        showDetailView()
    }
    
    func fifthBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[4]
        showDetailView()
    }
    
    func sixthBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[5]
        showDetailView()
    }
    
    func loadLocationImage(bubble: Int, urlPath: String) {
        UtilService.dataFromCache(urlPath).then { image -> Void in
            switch bubble{
            case 0:
                self.firstBubbleImageView.image = UIImage(data: image)
            case 1:
                self.secondBubbleImageView.image = UIImage(data: image)
            case 2:
                self.thirdBubbleImageView.image = UIImage(data: image)
            case 3:
                self.fourthBubbleImageView.image = UIImage(data: image)
            case 4:
                self.fifthBubbleImageView.image = UIImage(data: image)
            case 5:
                self.sixthBubbleImageView.image = UIImage(data: image)
            default:
                break
            }
        }
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe left")
            self.showMap()
        }
    }
    
    func showMap() {
        self.performSegueWithIdentifier("map", sender: self)
    }
    
    func showDetailView() {
        performSegueWithIdentifier("showDetailLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailLocation") {
            
            if let destinationVC: LocationDetailVC = segue.destinationViewController as? LocationDetailVC {
                destinationVC.location = detailLocation
            }
        } else if (segue.identifier == "showOwnProfil") {
            if let _: UserVC = segue.destinationViewController as? UserVC {
                
            }
        } else if let destinationVC: MapVC = segue.destinationViewController as? MapVC {
            destinationVC.initialSchoenHier = true
        }
    }
    
}
