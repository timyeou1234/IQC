//
//  ProductDetailTestTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class ProductDetailTestTableViewCell: UITableViewCell {

    var fileUrl = ""
    
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var testSource: UILabel!
    @IBOutlet weak var testUnitLable: UILabel!
    @IBOutlet weak var testDateLable: UILabel!
    
    @IBAction func watchReportAction(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: fileUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: fileUrl)!)
            // Fallback on earlier versions
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonBackView.layer.borderColor = UIColor(colorLiteralRed: 2/255, green: 182/255, blue: 197/255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
