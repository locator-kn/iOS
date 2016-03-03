//
//  RegisterVC5.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class RegisterVC5: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilImageView: UIImageView!
    
    let imageFromSource = UIImagePickerController()
    
    var name: String?
    var residence: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profilImageView.userInteractionEnabled = true
        profilImageView.addGestureRecognizer(tapGestureRecognizer)
        profilImageView.layer.cornerRadius = profilImageView.frame.size.width / 2
        profilImageView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func showDashboard(sender: UIButton) {
        performSegueWithIdentifier("showPreLogin", sender: self)
    }
    
    func imageTapped(img: AnyObject)
    {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.captureImage()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.getFromGallery()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertFalseInput() {
        let alert = UIAlertController(title: "Ups", message: "Fehlerhafte Registrierung", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func captureImage() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imageFromSource, animated: true) {}
        }
    }
    
    @IBAction func getFromGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageFromSource, animated: true) {}
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let tmp: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilImageView.image = tmp
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }
    
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/
