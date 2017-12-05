//
//  ProductDetailItemTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/27.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:巢狀儲存格

import UIKit

class ProductDetailItemTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //新加入之說明
    var content:String?
    var productId:String?
    var tableView:UITableView?
    var indexPath:IndexPath?
    var reportDetail = [ReportDetail]()
    var cellHeightChange:CellHeightChangeDelegate?
    var tableViewHeight:CGFloat = 0
    var contentHeight:CGFloat = 0
    var isOpen = false
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var tittleView: UIView!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var ProductDetailTestTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ProductDetailTestTableView.dataSource = self
        ProductDetailTestTableView.delegate = self
        ProductDetailTestTableView.rowHeight = UITableViewAutomaticDimension
        ProductDetailTestTableView.estimatedRowHeight = 132
        ProductDetailTestTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        ProductDetailTestTableView.register(UINib(nibName: "ProductContentTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
    }
    
    @IBAction func cellChangeHeight(_ sender: Any) {
        let height = self.ProductDetailTestTableView.contentSize.height
        
        if self.bounds.height > 42{
            self.cellHeightChange?.cellHeightChange(tableView:self.tableView! ,whichCell: self.indexPath!, height: 40 , howMuch: -height)
        }else{
            self.cellHeightChange?.cellHeightChange(tableView:self.tableView! ,whichCell: self.indexPath!, height: 40 + height, howMuch: height)
        }
        
    }
    
    func cellHeightChangexc(){
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if content != nil && reportDetail.count == 0{
            return 1
        }else if content != nil{
            return reportDetail.count + 1
        }
        return reportDetail.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if content != nil && indexPath.row == 0{
            return UITableViewAutomaticDimension
        }
        return 132
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if content != nil && indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ProductContentTableViewCell
            cell.contentLable.text = self.content
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductDetailTestTableViewCell
        var detail = ReportDetail()
        if content != nil{
            detail = reportDetail[indexPath.row - 1]
        }else{
            detail = reportDetail[indexPath.row]
        }
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
