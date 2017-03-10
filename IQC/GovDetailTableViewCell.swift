//
//  GovDetailTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/2.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class GovDetailTableViewCell: UITableViewCell {
    
    var tableView:UITableView?
    var indexPath:IndexPath?

    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var tittleBackView: UIView!
    @IBOutlet weak var tittleNameLable: UILabel!
    @IBOutlet weak var dashLineBottomView: UIView!
    
    var cellHeightChange:CellHeightChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawDash(){
        self.tittleBackView.addDashedLine(startPoint: CGPoint(x: tittleBackView.frame.width, y: 0), endPoint: CGPoint(x: tittleBackView.frame.width, y: frame.height))
        if tittleLable.text != "供應廠商地址"{
            dashLineBottomView.addDashedLine(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: dashLineBottomView.frame.width, y: 0))
        }else{
            cellHeightChange?.cellHeightChange(tableView: tableView!, whichCell: indexPath!, height: self.bounds.height, howMuch: self.bounds.height - 40)}
        
    }
    
}
