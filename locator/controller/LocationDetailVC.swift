//
//  LocationDetailVC.swift
//  locator
//
//  Created by Michael Knoch on 20/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        LocationService.locationById("90dd0bb7f23c628dddf94ba236ed5e25") { (location) -> Void in
            print(location.id)
            print(location.imagePath)
         
           
    
            let url  = NSURL(string: "https://locator-app.com" + "/api/v1/locations/90dd0bb7f23c628dddf94ba236ed5e25/supertrip.jpeg?size=max&key=AIzaSyCveLtBw4QozQIkMstvefLSTd3_opSvHS4"),
            data = NSData(contentsOfURL: url!)
            print(url)
            self.imageView.image = UIImage(data: data!)
            self.locationTitle.text = location.title
        }
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
