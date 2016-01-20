//
//  GravitySimulator.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation

public class GravitySimulator {
    
    var width = 0.0
    var height = 0.0
    var worldGravity = 0.0
    var gravityObjects = [GravityObject]()
    
    init (worldGravity: Double, width: Double, height: Double) {
        self.worldGravity = worldGravity
        self.width = width
        self.height = height
    }
    
    public func simulateGravity(gravityObjects: [GravityObject], times: Int) {
        self.gravityObjects = gravityObjects
        for (var i = 0; i < times; i++) {
            for gravityObject in gravityObjects {
                if (!gravityObject.fixed()) {
                    moveGravityItem(gravityObject)
                }
            }
        }
    }
    
    private func moveGravityItem(gravityObject: GravityObject) {
        
        let distanceToGravityItems = 10.0
        
        for other in gravityObjects {
            if (other.fixed()) {
                continue
            }
            let radiusSum = gravityObject.radius + other.radius + distanceToGravityItems
            let distance = gravityObject.distanceTo(other)
            if (distance == 0 || distance >= radiusSum) {
                continue
            }
            let pen = distance - radiusSum
            let cos = (-gravityObject.x + other.x) / distance
            let sin = (-gravityObject.y + other.y) / distance
            
            gravityObject.vx = (gravityObject.vx * 0.5) + (cos * pen)
            gravityObject.vx = (gravityObject.vx * 0.5) + (sin * pen)
            
        }
        
        for other in gravityObjects {
            if (!other.fixed()) {
                continue
            }
            let distance = gravityObject.distanceTo(other) - distanceToGravityItems
            if (distance == 0) {
                continue
            }
            let dx = -gravityObject.x + other.x
            let dy = -gravityObject.y + other.y
            let cos = dx / distance
            let sin = dy / distance
            let forceGravity = worldGravity * (gravityObject.mass * other.mass)/(distance*distance)
            
            let vx = gravityObject.vx + cos * forceGravity
            let vy = gravityObject.vy + sin * forceGravity
            gravityObject.vx = vx
            gravityObject.vy = vy
            let pen = distance - (gravityObject.radius + other.radius)
            if (pen < 0) {
                gravityObject.vx = gravityObject.vx * 0.8 + (cos * pen)
                gravityObject.vy = gravityObject.vy * 0.8 + (sin * pen)
            }
        }
        
        gravityObject.x = bound(gravityObject.radius,
            val: gravityObject.x + gravityObject.vx, max: width - gravityObject.radius)
        gravityObject.y = bound(gravityObject.radius,
            val: gravityObject.y + gravityObject.vy, max: height - gravityObject.radius)
    }
    
    
    func bound(min: Double, val: Double, max: Double) -> Double {
        if (val < min) {
            return min
        }
        if (val > max) {
            return max
        }
        return val
    }
}