//
//  BubbleView.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit

public class BubbleView: UIView {
    
    let myimageView = UIImageView(image: UIImage(named: "baum"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public var mycenter = CGPoint(x: 0, y: 0)
    public var radius = 80.0
    
    public override func drawRect(rect: CGRect) {
        
        // ImageView
        myimageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        myimageView.clipsToBounds = true
        myimageView.layer.cornerRadius = myimageView.frame.size.width / 2
        self.addSubview(myimageView)
        
        // Shadow
        self.layer.shadowColor = UIColor.redColor().CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        // Border
        self.layer.borderColor = UIColor.greenColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = min(rect.width, rect.height) / 2
    }
    
}