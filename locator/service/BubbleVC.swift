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
    
    var bubble = BubbleView(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
    var bubbles: [Bubble]?
    var schoenHierBubble: Bubble?
    var userProfileBubble: Bubble?

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .ScaleAspectFit
        view.addSubview(backgroundImageView)
        view.addSubview(bubble)
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
                let poxY = gravityObject.y
                print("Position of bubble: X: \(posX) Y: \(poxY)")
                //    layout.setBubbleCenter(bubble.view, posX, posY); "Java"
            }
        }
    }
}
