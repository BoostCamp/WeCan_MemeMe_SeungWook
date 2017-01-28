//
//  TableViewCell.swift
//  MeMe
//
//  Created by Seungwook Jeong on 2017. 1. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.imageView?.frame = CGRect(x: 5, y: 5, width: 200, height: 200)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.textLabel?.frame = CGRect(x: 230, y: 100, width: 1000, height: 10)
        self.textLabel?.textAlignment = NSTextAlignment.natural
    }

}