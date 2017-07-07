//
//  IngrediantTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/28.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class IngrediantTableViewCell: UITableViewCell {
    
    var tableView:UITableView?
    var indexPath:IndexPath?
    var cellHeightChange:CellHeightChangeDelegate?
    
    @IBOutlet weak var tittleBackView: UIView!
    @IBOutlet weak var tittleItemLable: UILabel!
    @IBOutlet weak var detailContextLable: UILabel!
    @IBOutlet weak var dashLineRView: UIView!
    @IBOutlet weak var dashLineBottomView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func drawDash(){
        dashLineBottomView.isHidden = false
        dashLineBottomView.addDashedLine(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: dashLineBottomView.frame.width, y: 0))
        if tittleBackView.bounds.height > 40{
            cellHeightChange?.cellHeightChange(tableView: tableView!, whichCell: indexPath!, height: self.bounds.height, howMuch: tittleBackView.bounds.height - 40)
        }
        
    }
    
    func endDrawDash(){
        dashLineBottomView.isHidden = true
        if tittleBackView.bounds.height > 40{
            cellHeightChange?.cellHeightChange(tableView: tableView!, whichCell: indexPath!, height: self.bounds.height, howMuch: tittleBackView.bounds.height - 40)
        }
    }
    
}
