//
//  TabSegue.swift
//  locator
//
//  Created by Michael Knoch on 18/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class TabSegue: UIStoryboardSegue {

    override func perform() {
        let tabBarController = self.sourceViewController as! UserVC
        let destinationController = self.destinationViewController as UIViewController
        
        for view in tabBarController.subView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        // Add view to placeholder view
        tabBarController.currentViewController = destinationController
        tabBarController.subView.addSubview(destinationController.view)
        

        
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.subView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.subView.addConstraints(verticalConstraint)
        
        tabBarController.subView.layoutIfNeeded()
        destinationController.didMoveToParentViewController(tabBarController)
    }
    

    
}
