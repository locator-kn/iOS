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

    @IBOutlet var gastro: UIButton!
    @IBOutlet var gastroLabel: UIButton!

    @IBOutlet var holiday: UIButton!
    @IBOutlet var holidayLabel: UIButton!
    
    @IBOutlet var culture: UIButton!
    @IBOutlet var cultureLabel: UIButton!
    
    @IBOutlet var secret: UIButton!
    @IBOutlet var secretLabel: UIButton!
    
    @IBOutlet weak var nature: UIButton!
    @IBOutlet weak var natureLabel: UIButton!
    
    @IBOutlet weak var nightlife: UIButton!
    @IBOutlet weak var nightlifeLabel: UIButton!
    
    @IBOutlet weak var next: UIButton!
   
    var selectedCategories:[String] = []
    
    
    @IBAction func nextAction(sender: AnyObject) {
        print("next")
    }
    
    
    @IBAction func cultureAction(sender: AnyObject) {
        culture.alpha = 1
        editSelectedCategories("culture")
        print(selectedCategories)
    }
    
    func editSelectedCategories(ident: String) -> Bool {
        if let index = selectedCategories.indexOf(ident) {
            selectedCategories.removeAtIndex(index)
            // return false if category was removed
            return false
        } else {
            selectedCategories.append(ident)
            // return true if category was selected
            return true
        }
    }
    
    func handleAlphaValueOfNext() {
        
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
        
        culture.alpha = 0.1

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
