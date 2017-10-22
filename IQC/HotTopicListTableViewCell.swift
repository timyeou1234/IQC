//
//  HotTopicListTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:一般文章橫隔

import UIKit

class HotTopicListTableViewCell: UITableViewCell {

    @IBOutlet weak var playButtonImage: UIImageView!
    @IBOutlet weak var topicBackView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var topicClass: UILabel!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topicBackView.addShadow()
        topicBackView.layer.cornerRadius = 2
        topicBackView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
