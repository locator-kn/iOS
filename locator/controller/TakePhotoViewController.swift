//
//  TakePhotoViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import Fusuma

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate, FusumaDelegate {
    
    var warschonda:Bool = false
    
    @IBAction func jaButtonAction(sender: AnyObject) {
        self.performSegueWithIdentifier("nameYourLocation", sender: true)
    }
    @IBAction func noeButtonAction(sender: AnyObject) {
        
        if uiimage == nil {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.takePhoto()
        }
        
        //self.performSegueWithIdentifier("showImagePickerAgain", sender: true)
    }
    @IBOutlet weak var imageViewController: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    
    var uiimage: UIImage!
    
    var gps:GpsService!
    
    var fusuma:FusumaViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        gps = GpsService(deniedHandler: gpsDeniedHandler)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if uiimage == nil && warschonda {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func gpsDeniedHandler(accessGranted: Bool) {
        if !accessGranted {
            let alert = UIAlertController(title: "GPS aktivieren", message: "Du musst dein GPS aktivieren um eine Location zu erstellen.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gerne", style: UIAlertActionStyle.Default, handler: openAppSettings))
            self.presentViewController(alert, animated: true, completion: takePhoto)
        } else {
            print("open foto")
            takePhoto()
        }
    }
    
    func openAppSettings(a: UIAlertAction) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePhoto() {
        fusuma = FusumaViewController()
        fusuma.delegate = self
        self.warschonda = true
        self.presentViewController(fusuma, animated: false, completion: nil)
    }
    
    
    func fusumaDismissedWithImage(image: UIImage) {
        print("fusumaDismissedWithImage")
    }
    
    func fusumaImageSelected(image: UIImage) {
        self.uiimage = image
        self.imageViewController.image = image
        self.view.alpha = 1
        
    }
    
    func fusumaCameraRollUnauthorized() {
        AlertService.simpleAlert(self, message: "Wir benötigen Rechte um deine Kamera zu nutzen")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nameYourLocation" {
            let controller = segue.destinationViewController as! NameYourLocationViewController
            controller.uiimage = self.uiimage
            let location = gps.getMaybeCurrentLocation()
            print("setting gps coords", location.keys.first, location.values.first)
            controller.lat = location.keys.first
            controller.long = location.values.first
            gps.unsubscribeGps()
            
            self.uiimage = nil

        }
    }
    

}
