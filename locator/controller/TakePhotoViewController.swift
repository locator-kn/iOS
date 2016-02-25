//
//  TakePhotoViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var imageView: UIImageView!
    
    var uiimage: UIImage!

    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        print("takePhoto called")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController called")
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        uiimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        print(uiimage)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.performSegueWithIdentifier("nameYourLocation", sender: true)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("asdjhkajsdhashdkjas")
        if (segue.identifier == "nameYourLocation") {
            let controller = segue.destinationViewController as! NameYourLocationViewController
            controller.uiimage = self.uiimage
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
