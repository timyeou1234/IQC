//
//  JournalCoachViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/21.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:食安誌教學頁

import UIKit

class JournalCoachViewController: UIViewController {

    let gradient = CAGradientLayer()
    var count = 0
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var handImage: UIImageView!
    
    @IBAction func skipAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moveHand()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //設定漸層效果
        gradient.frame = self.buttonView.bounds
        gradient.colors = ["".colorWithHexString("#2CCAA8").cgColor, "".colorWithHexString("#18B7CD").cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0, 1]
        self.buttonView.layer.addSublayer(gradient)
        gradient.zPosition = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveHand(){
        UIView.animate(withDuration: 0.1, animations: {
            self.handImage.frame = CGRect(x: self.handImage.frame.minX, y: self.handImage.frame.minY, width: self.handImage.bounds.width, height: self.handImage.bounds.height)
        }, completion: {
            success in
            UIView.animate(withDuration: 2.0, animations: {
                self.handImage.frame = CGRect(x: self.handImage.frame.minX + 50, y: self.handImage.frame.minY, width: self.handImage.bounds.width, height: self.handImage.bounds.height)
            }, completion: {
                success in
                UIView.animate(withDuration: 2.0, animations: {
                    self.handImage.frame = CGRect(x: self.handImage.frame.minX - 100, y: self.handImage.frame.minY, width: self.handImage.bounds.width, height: self.handImage.bounds.height)
                }, completion: {
                    success in
                    UIView.animate(withDuration: 2.0, animations: {
                        self.handImage.frame = CGRect(x: self.handImage.frame.minX + 50, y: self.handImage.frame.minY, width: self.handImage.bounds.width, height: self.handImage.bounds.height)
                    }, completion: {
                        success in
                        if self.count == 0{
                            self.count += 1
                            self.moveHand()
                        }
                    })
                })
            })
            
        })
    }

}
