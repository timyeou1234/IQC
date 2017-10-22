//
//  LoadingView.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/10.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:Loading 圖示
import UIKit

var isLoadingCircle = true
class LoadingView: UIView {
    
    var count = 0
    var isLoading = true
    
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
    
    deinit{
        self.layer.removeAllAnimations()
    }
    
    func setup(){
        isLoadingCircle = true
        Bundle.main.loadNibNamed("LoaadingView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.imageView.addSubview(blurEffectView)
        self.imageView.sendSubview(toBack: blurEffectView)
        imageView.layer.zPosition = 0
        
        
    }
    
    func startRotate(){
        setup()
        isLoading = true
        rotate()
    }
    
    func stopRotate(){
        isLoading = false
        spaningView.layer.removeAllAnimations()
    }
    
    func rotate(){
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
            self.spaningView.transform = self.spaningView.transform.rotated(by: CGFloat(M_PI/2))
        }, completion: {
            success in
            if self.isLoading{
                self.rotate()
            }
        })
    }
    
    func remove(){
        isLoadingCircle = false
        isLoading = false
        self.spaningView.layer.removeAllAnimations()
        self.layoutIfNeeded()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
