//
//  ProductDetailGovTitleTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/7/31.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:政府產品報告頁

import UIKit
import Alamofire
import SwiftyJSON

class ProductDetailGovTitleTableViewCell: UITableViewCell {
    
    var fileUrl = ""
    var fileId = ""
    var productId = ""
    
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var testDateLable: UILabel!
    
    @IBAction func watchReportAction(_ sender: Any) {
        if URL(string: fileUrl) == nil{
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: fileUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: fileUrl)!)
            // Fallback on earlier versions
        }
        postRequest(productid: productId, reportId: fileId)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonBackView.layer.cornerRadius = 5
        buttonBackView.layer.drawsAsynchronously = true
        buttonBackView.layer.borderWidth = 1
        buttonBackView.layer.borderColor = UIColor(colorLiteralRed: 2/255, green: 182/255, blue: 197/255, alpha: 1).cgColor
        buttonBackView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func postRequest(productid:String, reportId:String){
        let headers:HTTPHeaders = ["Content-Type": "application/json" ,"charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        let param:Parameters = [ "content":[[ "productid": productid, "reportid": reportId
            ]
            ]]
        _ = Alamofire.request(URL(string: "https://iqctest.com/api/data/report")!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: {
            response in
            debugPrint(response)
        })
    }
    
}
