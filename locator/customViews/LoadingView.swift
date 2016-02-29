//
//  LoadingView.swift
//  locator
//
//  Created by Michael Knoch on 29/02/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    override func drawRect(rect: CGRect) {
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("locator_preloader", withExtension: "gif")!)
        let advTimeGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: advTimeGif)
        imageView.frame = CGRect(x: CGRectGetMidX(rect) - (50.0 / 2.0), y: CGRectGetMidY(rect) - (50.0 / 2.0), width: 50.0, height: 50.0)
        self.addSubview(imageView)
    }
    
    func dismiss() {
        UIView.animateWithDuration(1, animations: {
            self.transform = CGAffineTransformMakeScale(60, 60)
        })
        
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0
        })
    }
}
