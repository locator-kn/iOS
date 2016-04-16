//
//  CameraService.swift
//  locator
//
//  Created by Michael Knoch on 16/04/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import UIKit

class CameraService {
    
    static func uploadProfileImage(ctrl: UIViewController, imageSource: UIImagePickerController) {
        
        let alert = UIAlertController(title: "Profilbild ändern", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Kamera", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            captureImage(ctrl, imageSource: imageSource)
        }))
        alert.addAction(UIAlertAction(title: "Bildergallerie", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            getFromGallery(ctrl, imageSource: imageSource)
        }))
        alert.addAction(UIAlertAction(title: "doch nicht ändern", style: UIAlertActionStyle.Cancel, handler: nil))
        ctrl.presentViewController(alert, animated: true, completion: nil)
    }
    
    static private func captureImage(ctrl: UIViewController, imageSource: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imageSource.sourceType = UIImagePickerControllerSourceType.Camera
            ctrl.presentViewController(imageSource, animated: true) {}
        }
    }
    
    static private func getFromGallery(ctrl: UIViewController, imageSource: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imageSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            ctrl.presentViewController(imageSource, animated: true) {}
        }
    }
    
}