//
//  ImageImpressionVC.swift
//  locator
//
//  Created by Michael Knoch on 08/01/16.
//  Copyright © 2016 Locator. All rights reserved.
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
    var dismiss:Bool = false
    var vc: LocationDetailVC!
    var loader: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.videoMaximumDuration = 10
            imagePicker.videoQuality = .TypeMedium
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.videoData == nil && !self.dismiss {
            self.openPicker()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss = true
        dismissViewControllerAnimated(true, completion: nil)
        dismissViewControllerAnimated(false, completion: nil)
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func submitVideo() {
        
        self.loader = LoadingView(frame: self.view.frame)
        self.loader.backgroundColor = COLORS.yellow
        self.view.addSubview(loader)
        
        ImpressionService.addVideoImpression(self.locationId, data: videoData!).then{
            result -> Void in
            print("video upload success")
            self.vc.loadData()
        }.always {
            print("always called")
            self.loader.dismiss()
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
    }
    
}
