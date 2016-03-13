//
//  LoadingAnimationViewController.swift
//  locator
//
//  Created by Timo Weiß on 27.02.16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class LoadingAnimationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("locator_preloader", withExtension: "gif")!)
        let advTimeGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: advTimeGif)
        imageView.frame = CGRect(x: CGRectGetMidX(self.view.frame) - (50.0 / 2.0), y: CGRectGetMidY(self.view.frame) - (50.0 / 2.0), width: 50.0, height: 50.0)

        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
