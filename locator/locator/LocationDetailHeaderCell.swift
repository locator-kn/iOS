//
//  LocationDetailHeaderCell.swift
//  locator
//
//  Created by Michael Knoch on 25/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class LocationDetailHeaderCell: UITableViewCell {
    @IBOutlet weak var category_1: UIImageView!
    @IBOutlet weak var category_2: UIImageView!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var favorCount: UILabel!
    @IBOutlet weak var favorIcon: UIButton!
    @IBOutlet weak var impressionsCount: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
