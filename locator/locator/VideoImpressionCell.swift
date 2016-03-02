//
//  VideoImpressionCell.swift
//  locator
//
//  Created by Michael Knoch on 26/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoImpressionCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userThumb: UIImageView!
    
    var player: AVPlayer?
    var playerController: AVPlayerViewController?
    var vc: LocationDetailVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickThumb(sender: UIButton) {
    
        func playVideo() {
            
            let myBaseUrl = "https://locator-app.com/api/v2/locations/impression/video/56b907022f08ffcd26f8c13a/impression.mov"
            if let url = NSURL(string: myBaseUrl) {
                
                self.player = AVPlayer(URL: url)
                self.playerController = AVPlayerViewController()
                self.playerController!.player = self.player
                
                self.vc.presentViewController(self.playerController!, animated: true) {
                    () -> Void in
                    self.playerController!.player?.play()
                }
            }
            
        }
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
