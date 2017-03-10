//
//  TagCollectionViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tagLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func drawBorder(){
        backView.clipBackground(cornerRadious: (backView.bounds.width - tagLable.bounds.width) / 2, color: .clear)
        backView.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1).cgColor
        backView.layer.borderWidth = 1
        backView.layer.masksToBounds = true
    }

}
