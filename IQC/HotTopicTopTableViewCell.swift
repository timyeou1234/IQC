//
//  HotTopicTopTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/7/5.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class HotTopicTopTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var classifyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        classifyView.layer.borderWidth = 1
        classifyView.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        backView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
