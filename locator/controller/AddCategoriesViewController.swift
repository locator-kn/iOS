//
//  AddCategoriesViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import CoreLocation

class AddCategoriesViewController: UIViewController, UITextFieldDelegate {
    
    
    var lat:Double!
    var long:Double!
    
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
    var nextEnabled: Bool = false
   
    var selectedCategories:[String] = []
    
    var createdLocation:Location!
    
    var loader:LoadingView!
    
    
    @IBAction func nextAction(sender: AnyObject) {
        if nextEnabled {
            print("weiter gehts")
            //
            
            //let vc = self.storyboard!.instantiateViewControllerWithIdentifier("test") as! LoadingAnimationViewController
            //self.presentViewController(vc, animated: true, completion: nil)
            
            self.loader = LoadingView(frame: self.view.frame)
            self.loader.backgroundColor = COLORS.black
            self.view.addSubview(loader)
            
            // TODO handle nil of lat and long
            LocationService.createNewLocation(uiimage, categories: selectedCategories, locationTitle: locationTitle, lat: String(format:"%f", lat), long: String(format:"%f", long)).then{
                result -> Void in
                
                self.createdLocation = result
                self.loader.dismiss()
                //self.dismissViewControllerAnimated(true, completion: nil)

                self.performSegueWithIdentifier("showNewLocation", sender: true)
                
                print("image upload success")
            }
            
            //ImpressionService.addImageImpression("569e4a9a4c9d7b5f3b400709", data: uiimage!)
        } else {
            print("next disabled")
        }
        
        print(selectedCategories)
    }
    
    
    @IBAction func cultureAction(sender: AnyObject) {

        if editSelectedCategories("culture") {
            setAlphaForButtons(culture, button2: cultureLabel, alpha: 1)
        } else {
            setAlphaForButtons(culture, button2: cultureLabel, alpha: 0.4)
        }
    }
    
    func handleAlphaValueOfNext() {
        
    }
    
    
    @IBAction func gastroAction(sender: AnyObject) {

        if editSelectedCategories("gastro") {
            setAlphaForButtons(gastro, button2: gastroLabel, alpha: 1)
        } else {
            setAlphaForButtons(gastro, button2: gastroLabel, alpha: 0.4)
        }
    }
    
    @IBAction func holidayAction(sender: AnyObject) {

        if editSelectedCategories("holiday") {
            setAlphaForButtons(holiday, button2: holidayLabel, alpha: 1)
        } else {
            setAlphaForButtons(holiday, button2: holidayLabel, alpha: 0.4)
        }
    }
    
    @IBAction func secretAction(sender: AnyObject) {

        if editSelectedCategories("secret") {
            setAlphaForButtons(secret, button2: secretLabel, alpha: 1)
        } else {
            setAlphaForButtons(secret, button2: secretLabel, alpha: 0.4)
        }
    }
    
    
    @IBAction func natureAction(sender: AnyObject) {

        if editSelectedCategories("nature") {
            setAlphaForButtons(nature, button2: natureLabel, alpha: 1)
        } else {
            setAlphaForButtons(nature, button2: natureLabel, alpha: 0.4)
        }
    }
    
    @IBAction func nightlifeAction(sender: AnyObject) {

        if editSelectedCategories("nightlife") {
            setAlphaForButtons(nightlife, button2: nightlifeLabel, alpha: 1)
        } else {
            setAlphaForButtons(nightlife, button2: nightlifeLabel, alpha: 0.4)
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.title = "Kategorien wählen"
        
        culture.alpha = 0.4
        cultureLabel.alpha = 0.4
        
        holiday.alpha = 0.4
        holidayLabel.alpha = 0.4

        nature.alpha = 0.4
        natureLabel.alpha = 0.4
        
        secret.alpha = 0.4
        secretLabel.alpha = 0.4
        
        gastro.alpha = 0.4
        gastroLabel.alpha = 0.4
        
        nightlife.alpha = 0.4
        nightlifeLabel.alpha = 0.4
        
        next.alpha = 0.4

    }
    
    /* delegate on gpsAuthorizationStatus change */
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setAlphaForButtons(button1: UIButton, button2: UIButton, alpha: CGFloat) {
        button1.alpha = alpha
        button2.alpha = alpha
    }
    
    func editSelectedCategories(ident: String) -> Bool {

        if let index = selectedCategories.indexOf(ident) {
            selectedCategories.removeAtIndex(index)
            nextEnabled = checkForNextAvailablility()
            // return false if category was removed
            return false
        } else {
            if selectedCategories.count == 3 {
                return false
            }
            selectedCategories.append(ident)
            nextEnabled = checkForNextAvailablility()
            // return true if category was selected
            return true
        }
    }
    
    func checkForNextAvailablility() -> Bool {
        if selectedCategories.count == 0 {
            next.alpha = 0.4
            return false
        }
        next.alpha = 1
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("going to leave")
        if (segue.identifier == "showCreateLocationSuccess") {
            
            print("showCreateLocationSuccess")
        } else if segue.identifier == "showNewLocation" {
            let controller = segue.destinationViewController as? LocationDetailVC
            controller?.location = self.createdLocation
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
