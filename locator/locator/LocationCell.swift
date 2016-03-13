//
//  LocationCell.swift
//  locator
//
//  Created by Michael Knoch on 18/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

   
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
