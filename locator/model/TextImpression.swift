//
//  TextImpression.swift
//  locator
//
//  Created by Michael Knoch on 07/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation

class TextImpression:AbstractImpression {
    override func getData() -> AnyObject {
        return String(data: data, encoding: NSUTF8StringEncoding)!
    }
}