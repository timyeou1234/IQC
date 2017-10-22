//
//  ProductType.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:產品分類資料模型

import UIKit

class ProductType: NSObject {
    
    var title:String?
    var type:String?
    var id:String?
    var submenu:[ProductSubMenu]?
    
}

class ProductSubMenu:NSObject{
    
    var category:String?
    var sort:String?
    var id:String?
    var modify:String?
    var title:String?
    var del:String?
    var type:String?
    
}
