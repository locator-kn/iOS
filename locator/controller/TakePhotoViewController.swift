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
    
    var uiimage: UIImage!
    var fromTheFront:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        takePhoto()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        fromTheFront = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if !fromTheFront {
            takePhoto()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePhoto() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: false, completion: nil)

        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(false, completion: nil)
        uiimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.performSegueWithIdentifier("nameYourLocation", sender: true)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "nameYourLocation") {
            let controller = segue.destinationViewController as! NameYourLocationViewController
            controller.uiimage = self.uiimage
        }
    }
    

}
