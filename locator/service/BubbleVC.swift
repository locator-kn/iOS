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
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    let backgroundImage = UIImage(named: "Background-rot.png")
    
    var bubble = BubbleView(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
    //let backgroundImageView = UIImageView(image: UIImage(named: "Background-rot.png"))

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .ScaleAspectFit
        view.addSubview(backgroundImageView)
        view.addSubview(bubble)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    

}
