//
//  BubbleView.swift
//  locator
//
//  Created by Michael Knoch on 01/03/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit
import PromiseKit

class BubbleView: UIImageView {

    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        self.alpha = 0
        self.transform = CGAffineTransformMakeScale(0.2, 0.2)
    }

    func show() {
        let delay = Double(arc4random_uniform(8)) * 0.1 + 0.3
        UIView.animateWithDuration(delay * 0.3,
            delay: delay,
            options: .CurveEaseOut,
            animations: {
                self.alpha = 1
                self.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
    }
    
    func hide() -> Promise<Bool> {
        
        return Promise {
            fulfill, reject in
            let delay = Double(arc4random_uniform(8)) * 0.1 + 0.3
            UIView.animateWithDuration(delay * 0.3,
                delay: delay,
                options: .CurveEaseOut,
                animations: {
                    self.alpha = 0
                    self.transform = CGAffineTransformMakeScale(2, 2)
                },
                completion: {
                    void in
                    self.transform = CGAffineTransformMakeScale(0.2, 0.2)
                    fulfill(true)
                })
        }
    }

}
