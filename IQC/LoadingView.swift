//
//  LoadingView.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/10.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet private var contentView:UIView?
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var spaningView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    func setup(){
        Bundle.main.loadNibNamed("LoaadingView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        self.sendSubview(toBack: blurEffectView)
        self.bringSubview(toFront: imageView)
        imageView.layer.zPosition = 0
        
        rotate()
        
    }
    
    func rotate(){
        UIView.animate(withDuration: 3, delay: 0, options: .curveLinear, animations: {
            self.spaningView.transform = self.spaningView.transform.rotated(by: CGFloat(M_PI/2))
        }, completion: {
            success in
            self.rotate()
        })
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
