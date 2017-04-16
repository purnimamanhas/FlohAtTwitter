//
//  TweetsTableViewCell.swift
//  FlohAtTwitter
//
//  Created by Purnima on 15/04/17.
//  Copyright © 2017 Purnima. All rights reserved.

import UIKit

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet var avatar: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var tweetMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatar.layer.cornerRadius = self.avatar.frame.width/2.0
        self.avatar.layer.borderWidth = 2.0
        self.avatar.layer.borderColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 0.2).cgColor
        self.avatar.clipsToBounds = true
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
