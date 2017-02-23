//
//  Extension.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/9.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

extension UIView{
    
    func startLoading(){
        let loadingView = LoadingView(frame: self.bounds)
        self.addSubview(loadingView)
    }
    
    func clipBackground(){
        self.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
    }
}

extension String{
    func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespaces).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}

extension UILabel{
    
    func addBackground(){
        self.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)
        self.textColor = UIColor.white
        self.layer.cornerRadius = self.bounds.width/4
        self.layer.masksToBounds = true
    }
    
}

