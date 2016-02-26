//
//  ImageImpression.swift
//  locator
//
//  Created by Michael Knoch on 24/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class ImageImpressionCell: UITableViewCell {

    @IBOutlet weak var imageBox: UIImageView!
    @IBOutlet weak var userThumb: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}