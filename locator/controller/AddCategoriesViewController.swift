//
//  AddCategoriesViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class AddCategoriesViewController: UIViewController, UITextFieldDelegate {
    
    var uiimage:UIImage!
    
    var locationTitle:String!

    @IBOutlet var gastro: UIView!
    @IBOutlet var gastroLabel: UIView!

    @IBOutlet var holiday: UIView!
    @IBOutlet var holidayLabel: UIView!
    
    @IBOutlet var culture: UIView!
    @IBOutlet var cultureLabel: UIView!
    
    @IBOutlet var secret: UIView!
    @IBOutlet var secretLabel: UIView!
    
    @IBOutlet weak var nature: UIButton!
    @IBOutlet weak var natureLabel: UIButton!
    
    @IBOutlet weak var nightlife: UIButton!
    @IBOutlet weak var nightlifeLabel: UIButton!
    
    
    
    @IBAction func cultureAction(sender: AnyObject) {
        print("culture")
    }
    
    
    @IBAction func gastroAction(sender: AnyObject) {
        print("gastro")
    }
    
    @IBAction func holidayAction(sender: AnyObject) {
        print("holiday")
    }
    
    @IBAction func secretAction(sender: AnyObject) {
        print("secret")
    }
    
    
    @IBAction func natureAction(sender: AnyObject) {
        print("nature")
    }
    
    @IBAction func nightlifeAction(sender: AnyObject) {
        print("nightlife")
    }
    
    override func viewDidLoad() {
        
        //print("AddCategoriesViewController:", locationTitle)
        super.viewDidLoad()

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
