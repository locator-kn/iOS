//
//  RegisterVC5.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Locator. All rights reserved.
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
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
        profilImageView.addGestureRecognizer(tapGestureRecognizer1)
        navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilImageView = UtilService.roundImageView(profilImageView)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func showDashboard(sender: UIButton) {
        performSegueWithIdentifier("showPreLogin", sender: self)
    }
    
    func yesButtonTapped() {
        
        if profilImageChanged == true {
            
            UserService.uploadProfileImg(self.profilImageView.image!)
                .then {
                    result -> Void in
                    self.performSegueWithIdentifier("showPreLogin", sender: self)
                }
                .error {
                    err -> Void in
                    self.alertFalseImageUpload()
            }
            
        } else {
            alertNoImageSelected()
        }
    }
    
    func imageTapped(img: AnyObject) {
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
        AlertService.simpleAlert(self, message: "Dein Profilbild konnte nicht geladen werden!")
    }
    
    func alertNoImageSelected() {
        AlertService.simpleAlert(self, message: "Du musst ein Profilbild auswählen!")
    }
    
    func captureImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imageFromSource, animated: true) {}
        }
    }
    
    func getFromGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageFromSource, animated: true) {}
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let tmp: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilImageChanged = true
        profilImageView.image = tmp
        
        if let img = self.profilImageView.image {
            NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(img), forKey: "userimg")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        yesButtonTapped()
        
    }
    
}
