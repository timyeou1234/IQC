//
//  MallCollectionViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class MallCollectionViewCell: UICollectionViewCell {

    var mallUrl = ""
    @IBOutlet weak var mallImagView: UIImageView!
    @IBAction func gotoMall(_ sender: Any) {
        if URL(string: mallUrl) != nil{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: mallUrl)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: mallUrl)!)
                // Fallback on earlier versions
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
