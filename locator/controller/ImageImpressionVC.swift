//
//  ImageImpressionVC.swift
//  locator
//
//  Created by Michael Knoch on 08/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import Fusuma

class ImageImpressionVC: UIViewController, UINavigationControllerDelegate, FusumaDelegate {

    var locationId:String!
    var initial = false
    let imagePicker = UIImagePickerController()
    
    var image:UIImage?
    var video:Bool = false
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.view.alpha = 0
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if image == nil && !self.initial {
            self.openCamera()
        } else if image == nil && self.initial {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func openCamera() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
        self.initial = true
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
    }
    
    func fusumaImageSelected(image: UIImage) {
        self.image = image
        self.imageView.image = self.image
        self.view.alpha = 1
    }
    
    func fusumaCameraRollUnauthorized() {
        AlertService.simpleAlert(self, message: "Wir benötigen Rechte um deine Kamera zu nutzen")
    }

    @IBAction func noeButton(sender: AnyObject) {
        self.openCamera()
    }
    
    @IBAction func submitImage(sender: AnyObject) {
        ImpressionService.addImageImpression(self.locationId, data: image!).then{
            result -> Void in
            print("image upload success")
        }.always {
            self.dismissViewControllerAnimated(true, completion: nil);
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
