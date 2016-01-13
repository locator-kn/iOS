//
//  ImageImpressionVC.swift
//  locator
//
//  Created by Michael Knoch on 08/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class ImageImpressionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var image:UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // camera configuration
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
    }
    
    override func viewDidAppear(animated: Bool) {
        if image == nil {
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
        } else {
            return
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

}
