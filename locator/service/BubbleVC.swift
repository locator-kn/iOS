//
//  BubbleVC.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class BubbleVC: UIViewController {
    
    var bubble = BubbleView(frame: CGRect(x: 10, y: 100, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bubble)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
