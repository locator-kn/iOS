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
    var videoData:NSData?
    var video:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if videoData == nil {
            self.openPicker()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        if let possibleVideo = info[UIImagePickerControllerMediaURL] as? NSURL! {
            let tempImage = possibleVideo
            print(tempImage)
            videoData = NSData(contentsOfURL: tempImage)
        }
        self.submitVideo()
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func openPicker() {
        presentViewController(imagePicker, animated: false, completion: nil)
    }
    
    func submitVideo() {
        ImpressionService.addVideoImpression(self.locationId, data: videoData!).then{
            result -> Void in
            print("video upload success")
        }.always {
            print("always called")
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
    }
    
}
