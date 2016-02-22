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

class ImageImpressionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var locationId:String!
    let imagePicker = UIImagePickerController()
    
    var image:UIImage?
    var videoData:NSData?
    var video:Bool = true
    
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
    
    override func viewDidAppear(animated: Bool) {
        if image == nil && videoData == nil {
            self.takePicture()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
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

    }
    
    func addFilter(rawImage:UIImage) -> UIImage {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(CIImage(image: rawImage), forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        return UIImage(CIImage: filter.outputImage!)
    }
    
    func takePicture() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitImage(sender: AnyObject) {
        
        if !video {
            ImpressionService.addImageImpression(self.locationId, data: image!).then{
                result -> Void in
                print("image upload success")
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            print(videoData!.length)
            ImpressionService.addVideoImpression(self.locationId, data: videoData!).then{
                result -> Void in
                print("video upload success")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }

}
