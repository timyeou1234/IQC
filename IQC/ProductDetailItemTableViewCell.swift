//
//  ProductDetailItemTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class ProductDetailItemTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var productId:String?
    var tableView:UITableView?
    var indexPath:IndexPath?
    var reportDetail = [ReportDetail]()
    var cellHeightChange:CellHeightChangeDelegate?
    
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var ProductDetailTestTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ProductDetailTestTableView.dataSource = self
        ProductDetailTestTableView.delegate = self
        ProductDetailTestTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func cellChangeHeight(_ sender: Any) {
        if self.bounds.height > 40{
            cellHeightChange?.cellHeightChange(tableView:tableView! ,whichCell: indexPath!, height: 40 , howMuch: CGFloat(-(132 * reportDetail.count)))
        }else{
            cellHeightChange?.cellHeightChange(tableView:tableView! ,whichCell: indexPath!, height: CGFloat(40 + (132 * reportDetail.count)), howMuch: CGFloat((132 * reportDetail.count)))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportDetail.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductDetailTestTableViewCell
        
        let detail = reportDetail[indexPath.row]
        
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
        
        return cell
    }
    
}
