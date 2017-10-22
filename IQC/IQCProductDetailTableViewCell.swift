//
//  IQCProductDetailTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/5/7.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:巢狀儲存格

import UIKit

class IQCProductDetailTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //新加入之說明
    var content:String?
    var productId:String?
    var tableView:UITableView?
    var indexPath:IndexPath?
    var reportDetail = [ReportDetail]()
    var cellHeightChange:CellHeightChangeDelegate?
    var isOpen = false
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var tittleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tittleView: UIView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var ProductDetailTestTableView: UITableView!
    @IBOutlet weak var contentLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ProductDetailTestTableView.dataSource = self
        ProductDetailTestTableView.delegate = self
//        ProductDetailTestTableView.rowHeight = UITableViewAutomaticDimension
//        ProductDetailTestTableView.estimatedRowHeight = 132
        ProductDetailTestTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func cellChangeHeight(_ sender: Any) {
        changeButton.isEnabled = false
        contentLable.sizeToFit()
        let height = 132 * CGFloat(reportDetail.count) + contentLable.frame.height + 59
        
        if self.bounds.height > 42{
            isOpen = false
            tittleView.backgroundColor = UIColor.white
            contentLable.isHidden = true
            self.cellHeightChange?.cellHeightChange(tableView:self.tableView! ,whichCell: self.indexPath!, height: 40 , howMuch: -height)
            
        }else{
            isOpen = true
            tittleView.backgroundColor = UIColor(colorLiteralRed: 238/255, green: 249/255, blue: 251/255, alpha: 1)
            contentLable.isHidden = false
            self.cellHeightChange?.cellHeightChange(tableView:self.tableView! ,whichCell: self.indexPath!, height: 40 + height, howMuch: height)
        }
    }
    
    func requiredHeight(labelText:String) -> CGFloat {
        
        let font = UIFont(name: "Helvetica", size: 16.0)
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentLable.bounds.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = labelText
        label.sizeToFit()
        return label.frame.height
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = 132 * CGFloat(reportDetail.count)
        return reportDetail.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 132
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductDetailTestTableViewCell
        var detail = ReportDetail()
        
        detail = reportDetail[indexPath.row]
        
        if detail.file != nil{
            cell.fileUrl = detail.file!
            cell.fileId = detail.id!
            if productId != nil{
                cell.productId = productId!
            }
        }
        cell.testDateLable.text = detail.reportdate
        cell.testSource.text = detail.source
        cell.testUnitLable.text = detail.title
        cell.selectionStyle = .none
        
        return cell
    }
    
}
