//
//  PasstSoViewController.swift
//  locator
//
//  Created by Timo Weiß on 29.02.16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class PasstSoViewController: UIViewController {

    var uiimage:UIImage!
    
    var lat:Double!
    var long:Double!
    
    @IBOutlet weak var uiImageView: UIImageView!
    
    @IBOutlet weak var noeButton: UIButton!
    @IBOutlet weak var jaButton: UIButton!
    
    @IBAction func noeButtonAction(sender: AnyObject) {
        print("nö")
    }

    @IBAction func jaButtonAction(sender: AnyObject) {
        print("Ja")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("lalala")
        
        uiImageView.image = uiimage

        // Do any additional setup after loading the view.
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
