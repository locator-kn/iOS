//
//  PictureImpression.swift
//  locator
//
//  Created by Michael Knoch on 31/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class ImageImpression: AbstractImpression {
    func getData() -> String {
        return String(data: data, encoding: NSUTF8StringEncoding)!
    }
}