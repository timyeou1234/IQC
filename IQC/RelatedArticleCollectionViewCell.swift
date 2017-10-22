//
//  RelatedArticleCollectionViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/3.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:關聯文章儲存格

import UIKit

class RelatedArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playButtonImage: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var typeBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
