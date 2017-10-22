//
//  IngrediantTableViewCell.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/28.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:成分格

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
        //        dashLineBottomView.isHidden = false
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func drawDash(){
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.contentView.layoutIfNeeded()
            
            self.detailContextLable.layoutIfNeeded()
            self.dashLineBottomView.layoutIfNeeded()
            
            self.dashLineBottomView.addDashedLine(startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: self.contentView.frame.width, y: 1))
            
            
            if self.tittleBackView.bounds.height > 40{
                self.cellHeightChange?.cellHeightChange(tableView: self.tableView!, whichCell: self.indexPath!, height: self.bounds.height, howMuch: self.tittleBackView.bounds.height - 35)
            }
        }
        
        
        
    }
    
    func endDrawDash(){
        if tittleBackView.bounds.height > 40{
            cellHeightChange?.cellHeightChange(tableView: tableView!, whichCell: indexPath!, height: self.bounds.height, howMuch: tittleBackView.bounds.height - 40)
        }
    }
    
}
