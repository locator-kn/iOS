//
//  MessageCollectionViewCell.swift
//  locator
//
//  Created by Timo Weiß on 24.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

let kMessageCellFont: UIFont = UIFont.systemFontOfSize(15)

class MessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = kMessageCellFont
    }
    
}