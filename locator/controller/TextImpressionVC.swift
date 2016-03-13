//
//  TextImpressionVC.swift
//  locator
//
//  Created by Michael Knoch on 06/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class TextImpressionVC: UIViewController, UITextFieldDelegate {
    
    var locationId:String!
    var vc: LocationDetailVC!
    @IBOutlet weak var textField: UITextField!
    var loader: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        self.view.backgroundColor = COLORS.yellow
        self.textField.becomeFirstResponder()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        if textField.text?.characters.count > 3 {
            
            self.loader = LoadingView(frame: self.view.frame)
            self.loader.backgroundColor = COLORS.yellow
            self.view.addSubview(loader)
            self.view.endEditing(true)
            
            ImpressionService.addTextImpression(self.locationId, data: textField.text!).then {
                result -> Void in
                print("post textimpression success")
                self.vc.loadData()
            }.always {
                self.loader.dismiss()
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        } else {
            AlertService.simpleAlert(self, message: "Dein text muss länger sein")
        }
        
        return true
    }

}
