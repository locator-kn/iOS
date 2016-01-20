//
//  GravityObject.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import Darwin

public class GravityObject {
    
    var x = 0.0, y = 0.0
    var vx = 0.0, vy = 0.0
    var radius = 0.0, mass = 0.0
    var payload: AnyObject?
    var fixedPosition = false;
    
    init (fixedPosition: Bool) {
    self.fixedPosition = fixedPosition;
    // todo determine smart initial values for velocity vector
    self.vx = 0;
    self.vy = 0;
    self.payload = nil;
    }
    
    func fixed() -> Bool {
        return fixedPosition
    }
    
    func distanceTo(other: GravityObject) -> Double {
    let xDelta = x - other.x;
    let yDelta = y - other.y;
    let distance = sqrt(xDelta * xDelta + yDelta * yDelta);
    return distance;
    }
}