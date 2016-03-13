//
//  Color.swift
//  locator
//
//  Created by Sergej Birklin on 09/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import UIKit

public class Color {
    
    public struct violet {
        let first = UIColor(netHex: 0x6663af)
        let second = UIColor(netHex: 0x7f7cdd)
        let third = UIColor(netHex: 0x9996e2)
    }
    
    public struct cyan {
        let first = UIColor(netHex: 0x5e91a3)
        let second = UIColor(netHex: 0x75b5cc)
        let third = UIColor(netHex: 0x91c4d6)
    }
    
    struct green {
        let first = UIColor(netHex: 0xa0a819)
        let second = UIColor(netHex: 0xc6d121)
        let third = UIColor(netHex: 0xd3db4c)
    }
    
    struct beige {
        let first = UIColor(netHex: 0xc98c11)
        let second = UIColor(netHex: 0xf9ad16)
        let third = UIColor(netHex: 0xfcbf44)
    }
    
    struct brown {
        let first = UIColor(netHex: 0xcc5b16)
        let second = UIColor(netHex: 0xff721c)
        let third = UIColor(netHex: 0xff8e49)
    }
    
    struct red {
        let first = UIColor(netHex: 0xcc513d)
        let second = UIColor(netHex: 0xff664c)
        let third = UIColor(netHex: 0xff8470)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}