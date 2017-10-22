//
//  Product.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:產品資料模型

import UIKit

class Product: NSObject {
    
    var mainId:String?
    var subId:String?
    var gov:String?
    var id:String?
    var img:String?
    var modify:String?
    var title:String?
    var brandid:String?
    var capacity:String?
    var similar:String?
    var origin:String?
    var cer:[String]?
    var mall:[Mall]?
    var slider:[String]?
    var allergy:[String]?
    var ingredient:String?
    var veg:[String]?
    var warn:String?
    var number:String?
    var latestreport:[Report]?
    var historyreport:[Report]?
    
}

class Mall: NSObject {
    var url:String?
    var img:String?
}

class Report: NSObject {
    
    var tittle:String?
    var type:String?
    var reportDetail:ReportDetail?
    var item:[ReportClass]?
    var list:[ReportDetail]?
    
}

class ReportClass: NSObject{
    
    var itemid:String?
    var content:String?
    var reportid:[ReportDetail]?
    
}

class ReportDetail: NSObject {
    
    var id:String?
    var reportdate:String?
    var title:String?
    var source:String?
    var file:String?
    
}

class GovProduct:NSObject{
    
    var title:String?
    var id:String?
    var img:String?
    var slider:[String]?
    var gov:String?
    var factory:String?
    var address:String?
    var supplier:String?
    var supplieraddr:String?
    var website:String?
    var similar:String?
    var modify:String?
    var reportTitle:String?
    var latestreport:[Report]?
    
}






