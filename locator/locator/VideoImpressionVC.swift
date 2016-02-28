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

class VideoImpressionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var locationId:String!
    let imagePicker = UIImagePickerController()
    
    var image:UIImage?
    var videoData:NSData?
    var video:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        // camera configuration
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        if video {
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        }
        }
        
    }
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if image == nil && videoData == nil {
            self.takePicture()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
    image = possibleImage
    } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
    image = possibleImage
    } else if let possibleVideo = info[UIImagePickerControllerMediaURL] as? NSURL! {
    let tempImage = possibleVideo
    print(tempImage)
    videoData = NSData(contentsOfURL: tempImage)
    }
    imageView.image = image
    dismissViewControllerAnimated(true, completion: nil)
    
    self.submitImage(self)
    
    }*/
    
    func takePicture() {
        presentViewController(imagePicker, animated: false, completion: nil)
    }
    
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    @IBAction func submitImage(sender: AnyObject) {
        
        if !video {
            ImpressionService.addImageImpression(self.locationId, data: image!).then{
                result -> Void in
                print("image upload success")
                }.always {
                    self.dismissViewControllerAnimated(true, completion: nil);
            }
        } else {
            print(videoData!.length)
            ImpressionService.addVideoImpression(self.locationId, data: videoData!).then{
                result -> Void in
                print("video upload success")
                }.always {
                    print("always called")
                    self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
        
    }
    
}
