//
//  ProductCollectionViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:食在安心產品及品牌格

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var productNameLable: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.addShadow()
        productImageView.clipBackground(cornerRadious: 5, color: UIColor.clear)
        productNameLable.layer.drawsAsynchronously = true
        productNameLable.layer.shadowOpacity = 0
    }

}
