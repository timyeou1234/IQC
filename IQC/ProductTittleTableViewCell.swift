//
//  ProductTittleTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class ProductTittleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var strokeImageView: UIImageView!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var tittleBackView: UIView!
    @IBOutlet weak var tittleNameLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawDash(){
//        self.tittleBackView.addDashedLine(startPoint: CGPoint(x: tittleBackView.frame.width, y: 0), endPoint: CGPoint(x: tittleBackView.frame.width, y: frame.height))
//        self.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 251/255, green: 251/255, blue: 251/255, alpha: 1)
    }
    
}
