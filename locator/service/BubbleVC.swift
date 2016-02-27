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
    
    let width = UIScreen.mainScreen().bounds.width
    let height = UIScreen.mainScreen().bounds.height
    
    let backgroundImage = UIImage(named: "Background-rot.png")
    let schoenHierImage = UIImage(named: "schoen_hier.png")
    
    let long = 9.169753789901733
    let lat = 47.66868204997508
    let maxDistance: Float = 2.0
    let limit = 20
    
    var bubbles = [Bubble]()
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
        
        bubbles.append(schoenHierBubble!)
        bubbles.append(userProfileBubble!)
        
        BubbleService.getBubbles(lat, long: long, maxDistance: maxDistance, limit: limit).then { bubbles -> Void in
            let messageArray = bubbles[0]
            let locationArray = bubbles[1]
            
            let messages = messageArray as! [Message]
            let locations = locationArray as! [Location]
            
            for var i = 0; i < 3; ++i { // maximum amount of bubbles
                let bubble = self.makeMessageBubble(messages[i], priority: i)
                bubble.data = messages[i]
                self.bubbles.append(bubble)
            }
            
            for var i = 0; i < 3; ++i { // maximum amount of bubbles
                let bubble = self.makeLocationBubble(locations[i], priority: i)
                bubble.data = locations[i]
                self.bubbles.append(bubble)
            }
            
            self.positionBubblesInDifferentQuadrants()
            self.simulateGravity()
        }
            .then {
                self.reloadInputViews()
        }
    }
    
    func initSchoenHierBubble() {
        let radius = getRadiusByPriority((schoenHierBubble?.priority)!)
        let frame = setFrameToRealPosition(CGRect(x: (0.5 * width), y: 0.38 * height, width: CGFloat(2 * radius), height: CGFloat(2 * radius)))
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
        
        let minimum = min((Double((bubble.view?.frame.width)!)), Double((bubble.view?.frame.height)!))
        gravityObject.radius = minimum / Double(pointToPixelScale) // #####!!!!!!!!!!!!!!!!!!!!!!!!!#####)
        gravityObject.mass = gravityObject.radius * 2
        gravityObject.x = Double(((bubble.view?.frame.origin.x)!)) * Double(pointToPixelScale) // #####!!!!!!!!!!!!!!!!!!!!!!!!!#####)
        gravityObject.y = Double((bubble.view?.frame.origin.y)!) * Double(pointToPixelScale) // #####!!!!!!!!!!!!!!!!!!!!!!!!!#####)
        return gravityObject
    }
    
    func simulateGravity() {
        var gravityObjects = [GravityObject]()
        for bubble in bubbles {
            let gravityObject = toGravityObject(bubble)
            gravityObjects.append(gravityObject)
        }
        
        let userProfileGravityObject = toGravityObject(userProfileBubble!)
        userProfileGravityObject.mass = -100
        gravityObjects.append(userProfileGravityObject)
        
        let schoenHierGravityObject = toGravityObject(schoenHierBubble!)
        schoenHierGravityObject.mass = 400
        gravityObjects.append(schoenHierGravityObject)
        
        let simulator = GravitySimulator(worldGravity: 10.0, width: Double(width), height: Double(height))
        simulator.simulateGravity(gravityObjects, times: 200)
        
        for gravityObject in gravityObjects {
            let bubble = gravityObject.payload as! Bubble
            if (!bubble.positionFixed) {
                let posX = gravityObject.x / Double(pointToPixelScale)
                let posY = gravityObject.y / Double(pointToPixelScale)
                print("Position of bubble: X: \(posX) Y: \(posY)")
                bubble.view?.center = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
                self.view.addSubview(bubble.view!)
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
        let realX = frame.origin.x  - (frame.width / 2)
        
        return CGRect(x: realX, y: frame.origin.y, width: frame.width, height: frame.height)
    }
    
    func positionBubblesInDifferentQuadrants() {
        let startQuadrant = 1
        var nextQuadrant = positionBubbles(0, startQuadrant: startQuadrant)
        nextQuadrant = positionBubbles(1, startQuadrant: nextQuadrant)
        nextQuadrant = positionBubbles(2, startQuadrant: nextQuadrant)
    }
    
    func positionBubbles(priority: Int, startQuadrant: Int) -> Int {
        
        var quadrant = startQuadrant
        for i in bubbles {
            if (i.priority == priority) {
                let bubbleCenter = getInitialBubbleCenter(quadrant)
                i.view?.frame.origin = bubbleCenter
                print("Origin of Bubble \(bubbleCenter)")
                quadrant = ((quadrant) % 4) + 1
            }
        }
        return quadrant
    }
    
    func getInitialBubbleCenter(quadrant: Int) -> CGPoint {
        let distanceFromBorder: CGFloat = 0.2 * pointToPixelScale           // #######!!!!!!!!!!!!!!!!!!!!!!
        var distanceFromLeftInPercent: CGFloat = 0.0
        var distanceFromTopInPercent: CGFloat = 0.0
        
        if (quadrant == 1) {
            distanceFromLeftInPercent = 1.0 - distanceFromBorder
            distanceFromTopInPercent = distanceFromBorder
        } else if (quadrant == 2) {
            distanceFromLeftInPercent = distanceFromBorder
            distanceFromTopInPercent = distanceFromBorder
        } else if (quadrant == 3) {
            distanceFromLeftInPercent = distanceFromBorder
            distanceFromTopInPercent = 0.9 - distanceFromBorder
        } else {
            distanceFromLeftInPercent = 1.0 - distanceFromBorder
            distanceFromTopInPercent = 0.9 - distanceFromBorder
        }
        
        let x = (distanceFromLeftInPercent * width) * pointToPixelScale     // #######!!!!!!!!!!!!!!!!!!!!!!
        let y = (distanceFromTopInPercent * height) * pointToPixelScale     // #######!!!!!!!!!!!!!!!!!!!!!!
        
        return CGPoint(x: x, y: y)
    }
    
    func makeMessageBubble(message: Message, priority: Int) -> Bubble {
        
        let view = BubbleView()
        view.radius = Double(getRadiusByPriority(priority))
        print("Radius of Message Bubble: \(view.radius)")
        view.layer.borderColor = UIColor.yellowColor().CGColor
        view.layer.borderWidth = getStrokeWidthByPriority(priority)
        
        let bubble = Bubble()
        bubble.data = message
        bubble.priority = priority
        bubble.view = view
        return bubble
        
    }
    
    func makeLocationBubble(location: Location, priority: Int) -> Bubble {
        
        let view = BubbleView()
        view.radius = Double(getRadiusByPriority(priority))
        print("Radius of Location Bubble: \(view.radius)")
        view.layer.borderColor = UIColor.redColor().CGColor
        view.layer.borderWidth = getStrokeWidthByPriority(priority)
        
        let bubble = Bubble()
        bubble.data = location
        bubble.priority = priority
        bubble.view = view
        return bubble
        
    }
    
    func getStrokeWidthByPriority(priority: Int) -> CGFloat {
        return CGFloat(width * 0.013)
    }
}

public let pointToPixelScale = UIScreen.mainScreen().scale
