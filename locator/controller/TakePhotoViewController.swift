//
//  TakePhotoViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import Fusuma

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
   let imageFromSource = UIImagePickerController()
    @IBOutlet weak var imageViewController: UIImageView!
    
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var loading: UIImageView!
    var image: UIImage!
    var gps:GpsService!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("locator_preloader", withExtension: "gif")!)
        self.loading.image = UIImage.gifWithData(imageData!)
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = true
        self.title = "neue Location"
        self.view.backgroundColor = COLORS.black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"), style: .Plain, target: self, action: "close")
        gps = GpsService(successHandler: gpsSuccessHandler ,deniedHandler: gpsDeniedHandler)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gpsSuccessHandler(accessGranted: Bool) {
        self.takePhoto()
    }
    
    func gpsDeniedHandler(accessGranted: Bool) {
        if !accessGranted {
            let alert = UIAlertController(title: "GPS aktivieren", message: "Du musst dein GPS aktivieren um eine Location zu erstellen.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gerne", style: UIAlertActionStyle.Default, handler: AlertService.openAppSettings))
            self.presentViewController(alert, animated: true, completion: takePhoto)
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imageFromSource, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nameYourLocation" {
            let controller = segue.destinationViewController as! NameYourLocationViewController
            controller.uiimage = self.image
            let location = gps.getMaybeCurrentLocation()
            print("setting gps coords", location.keys.first, location.values.first)
            controller.lat = location.keys.first
            controller.long = location.values.first
            gps.unsubscribeGps()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.image = editedImage
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("nameYourLocation", sender: true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
