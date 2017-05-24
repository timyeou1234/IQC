//
//  NoResultViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/10.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class NoResultViewController: UIViewController {
    
    var code = ""
    var fromSearch = false
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var outcomeLable: UILabel!
    @IBOutlet weak var detailLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fromSearch{
            outcomeLable.text = "查無資訊"
            reportButton.isHidden = true
            reportView.isHidden = true
            detailLable.isHidden = true
        }else{
            outcomeLable.text = "此商品查無資訊"
            reportView.isHidden = false
            reportView.isHidden = false
            detailLable.isHidden = false
        }
        if gradient.frame != self.reportView.bounds{
            //設定漸層效果
            gradient.frame = self.reportView.bounds
            gradient.colors = ["".colorWithHexString("#2CCAA8").cgColor, "".colorWithHexString("#18B7CD").cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.locations = [0, 1]
            self.reportView.layer.addSublayer(gradient)
            gradient.zPosition = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationController = segue.destination as? HelpReportViewController{
            if code != ""{
                destinationController.code = code
            }
        }
    }
    
    
}
