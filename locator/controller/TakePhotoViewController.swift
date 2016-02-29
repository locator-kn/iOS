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
    
    var imagePicker: UIImagePickerController!
    
    var uiimage: UIImage!
    
    var gps:GpsService!

    override func viewDidLoad() {
        super.viewDidLoad()
        gps = GpsService(deniedHandler: gpsDeniedHandler)

        // Do any additional setup after loading the view.
    }
    
    func gpsDeniedHandler(accessGranted: Bool) {
        if !accessGranted {
            let alert = UIAlertController(title: "GPS aktivieren", message: "Du musst dein GPS aktivieren um eine Location zu erstellen.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gerne", style: UIAlertActionStyle.Default, handler: openAppSettings))
            self.presentViewController(alert, animated: true, completion: takePhoto)
        } else {
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
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
//            imagePicker.sourceType = .Camera
//        } else {
//            imagePicker.sourceType = .PhotoLibrary
//        }
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: false, completion: nil)
        //self.initial = true
        
        
       // presentViewController(imagePicker, animated: false, completion: nil)

        
    }
    
    
    func fusumaDismissedWithImage(image: UIImage) {
        print("fusumaDismissedWithImage")
    }
    
    func fusumaImageSelected(image: UIImage) {
        self.uiimage = image
        //self.imageView.image = self.image
        self.view.alpha = 1
        self.performSegueWithIdentifier("showPasstSo", sender: true)
    }
    
    func fusumaCameraRollUnauthorized() {
        AlertService.simpleAlert(self, message: "Wir benötigen Rechte um deine Kamera zu nutzen")
    }
    
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(false, completion: nil)
        uiimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.performSegueWithIdentifier("showPasstSo", sender: true)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }*/

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPasstSo" {
            let controller = segue.destinationViewController as! PasstSoViewController
            controller.uiimage = self.uiimage
            let location = gps.getMaybeCurrentLocation()
            print("setting gps coords", location.keys.first, location.values.first)
            controller.lat = location.keys.first
            controller.long = location.values.first
            gps.unsubscribeGps()

        }
    }
    

}
