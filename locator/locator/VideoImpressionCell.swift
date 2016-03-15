//
//  VideoImpressionCell.swift
//  locator
//
//  Created by Michael Knoch on 26/02/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoImpressionCell: UITableViewCell {

    var user:User!
    var rootVC: LocationDetailVC!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userThumb: UIImageView!
    
    var videoUrl:String?
    var player: AVPlayer?
    var playerController: AVPlayerViewController?
    var vc: LocationDetailVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickThumb(sender: UIButton) {
        print("Play", videoUrl)
        if let url = NSURL(string: API.IMAGE_URL + videoUrl!) {
        self.player = AVPlayer(URL: url)
        self.playerController = AVPlayerViewController()
        self.playerController!.player = self.player
                
        self.vc.presentViewController(self.playerController!, animated: true) {
                () -> Void in
                    self.playerController!.player?.play()
            }
        }
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func redirectUser(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserVC") as! UserVC
        nextViewController.user = self.user
        self.rootVC.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
