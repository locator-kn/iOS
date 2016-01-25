//
//  BubbleVC.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class BubbleVC: UIViewController {
    
    // screen width and height:
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    let backgroundImage = UIImage(named: "Background-rot.png")
    let schoenHierImage = UIImage(named: "schoen_hier.png")
    
    var bubbles: [Bubble]?
    var schoenHierBubble: Bubble?
    var userProfileBubble: Bubble?

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .ScaleAspectFit
        view.addSubview(backgroundImageView)
        
        schoenHierBubble = Bubble()
        schoenHierBubble!.priority = -1
        schoenHierBubble!.positionFixed = true
        initSchoenHierBubble()
        view.addSubview((schoenHierBubble?.view)!)
        //schoenHierBubble!.view = (BubbleView)layout.findViewById(R.id.schoenHierBubble);
        
        userProfileBubble = Bubble()
        userProfileBubble!.priority = -1
        userProfileBubble!.positionFixed = true
        initUserProfileBubble()
        view.addSubview((userProfileBubble?.view)!)
        //userProfileBubble!.view = (BubbleView)layout.findViewById(R.id.userProfileBubble);
    }
    
    func initSchoenHierBubble() {
        let radius = getRadiusByPriority((schoenHierBubble?.priority)!)
        let frame = setFrameToRealPosition(CGRect(x: 0.5 * width, y: 0.38 * height, width: CGFloat(2 * radius), height: CGFloat(2 * radius)))
        schoenHierBubble?.view = BubbleView(frame: frame)
        schoenHierBubble?.view?.radius = Double(radius)
        schoenHierBubble?.view?.myimageView.image = schoenHierImage
    }
    
    func initUserProfileBubble() {
        let radius = getRadiusByPriority(2)
        let frame = setFrameToRealPosition(CGRect(x: 0.5 * width, y: 0.89 * height, width: CGFloat(2 * radius), height: CGFloat(2 * radius)))
        userProfileBubble?.view = BubbleView(frame: frame)
        userProfileBubble?.view?.radius = Double(radius)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class Bubble {
        var view: BubbleView?
        var data: AnyObject?
        var priority: Int?
        var positionFixed = false
    }
    
    func toGravityObject(bubble: Bubble) -> GravityObject {
        let gravityObject = GravityObject(fixedPosition: bubble.positionFixed)
        gravityObject.payload = bubble
        gravityObject.radius = Double((bubble.view?.frame.width)!) / 2.0
        gravityObject.mass = gravityObject.radius * 2
        gravityObject.x = Double((bubble.view?.center.x)!)
        gravityObject.y = Double((bubble.view?.center.y)!)
        return gravityObject
    }
    
    func simulateGravity() {
        var gravityObjects = [GravityObject]()
        for bubble in bubbles! {
            let gravityObject = toGravityObject(bubble)
            gravityObjects.append(gravityObject)
        }
        
        let userProfileGravityObject = toGravityObject(userProfileBubble!)
        userProfileGravityObject.mass = -100
        gravityObjects.append(userProfileGravityObject)
        
        let schoenHierGravityObject = toGravityObject(schoenHierBubble!)
        schoenHierGravityObject.mass = -100
        gravityObjects.append(schoenHierGravityObject)
        
        let simulator = GravitySimulator(worldGravity: 10.0, width: Double(width), height: Double(height))
        simulator.simulateGravity(gravityObjects, times: 200)
        
        for gravityObject in gravityObjects {
            let bubble = gravityObject.payload as! Bubble
            if (!bubble.positionFixed) {
                let posX = gravityObject.x
                let posY = gravityObject.y
                print("Position of bubble: X: \(posX) Y: \(posY)")
                bubble.view?.center = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
                //    layout.setBubbleCenter(bubble.view, posX, posY); "Java"
            }
        }
    }
    
    func getRadiusByPriority(priority: Int) -> Int {
        var widthFactor = 0.0
        if (priority == -1) {
            widthFactor = 0.2
        } else if (priority == 0) {
            widthFactor = 0.13
        } else if (priority == 1) {
            widthFactor = 0.10
        } else if (priority == 2) {
            widthFactor = 0.07
        }
        return Int(widthFactor * Double(width))
    }
    
    func setFrameToRealPosition(frame: CGRect) -> CGRect {
        let realX = frame.origin.x - (frame.width / 2)
        
        return CGRect(x: realX, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}
