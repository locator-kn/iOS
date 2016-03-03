//
//  RegisterVC5.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import Alamofire

class RegisterVC5: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilImageView: UIImageView!
    var profilImageChanged = false
    @IBOutlet weak var yesImageView: UIImageView!
    
    let imageFromSource = UIImagePickerController()
    
    var name: String?
    var residence: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = true
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profilImageView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:Selector("yesButtonTapped:"))
        yesImageView.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilImageView.layer.cornerRadius = profilImageView.frame.size.width / 2
        profilImageView.clipsToBounds = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func showDashboard(sender: UIButton) {
        performSegueWithIdentifier("showPreLogin", sender: self)
    }
    
    func yesButtonTapped(sender: UIImageView) {
        if profilImageChanged == true {
            Alamofire.upload(
                .POST,
                API.PROFIL_IMAGE_UPLOAD,
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.profilImageView.image!, 0.5)!, name: "file", fileName: "userProfilImage.jpg", mimeType: "image/jpeg")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success( _, _, _):
                        self.performSegueWithIdentifier("showPreLogin", sender: self)
                    case .Failure(let encodingError):
                        self.alertFalseImageUpload()
                        print(encodingError)
                    }
                }
            )
        } else {
            alertNoImageSelected()
        }
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
    
    func alertFalseImageUpload() {
        let alert = UIAlertController(title: "Ups", message: "Dein Profilbild konnte nicht geladen werden!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertNoImageSelected() {
        let alert = UIAlertController(title: "Ups", message: "Du musst ein Profilbild auswählen!", preferredStyle: UIAlertControllerStyle.Alert)
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
        let tmp: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profilImageChanged = true
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
