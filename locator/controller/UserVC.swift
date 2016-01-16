//
//  UserVC.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    var user:User = User(id: "56786fe35227864133663978")
    var userLocations: [Location]?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        print("userid", self.user.id)
        super.viewDidLoad()
        
        // fetch user information
        UserService.getUser(user.id!)
            .then {
                result -> Void in
                print("request user success", self.user.id)
                self.user = result
                self.updateView()
            }
            .error {
                error -> Void in
                print(error)
        }
        
        //fetch user locations
        LocationService.getLocationsByUser(user.id!)
            .then {
                result -> Void in
            }
            .error {
                error -> Void in
                print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateView() {
        self.profileImage.image = self.user.profilImage
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        
        self.userName.text = self.user.name
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tabBarVC") {
            let ctrl = segue.destinationViewController as! UserTabVC
            ctrl.locations = self.userLocations
        }
    }

}
