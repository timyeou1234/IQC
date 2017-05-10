//
//  ScannerCoachViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/20.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class ScannerCoachViewController: UIViewController {
    
    let gradient = CAGradientLayer()
    var timer:Timer!
    var phoneOriginFrame = CGRect()
    var upClimb = true
    var loopIndex = 0
    var currentIndex = 5
    var count = 0
    var isAnimateing = false
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var bottleImageView: UIImageView!
    
    @IBOutlet weak var phoneBottleAlign: NSLayoutConstraint!
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var desLable: UILabel!
    
    @IBAction func skipAction(_ sender: Any) {
        if skipButton.currentTitle == "上一則"{
            timer.invalidate()
            skipButton.setTitle("略過", for: .normal)
            nextButton.setTitle("下一則", for: .normal)
            presentFirst()
        }else{
            self.performSegue(withIdentifier: "showMain", sender: nil)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if nextButton.currentTitle == "下一則"{
            skipButton.setTitle("上一則", for: .normal)
            nextButton.setTitle("完成", for: .normal)
            presentSecond()
        }else{
            timer.invalidate()
            self.performSegue(withIdentifier: "showMain", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonFirst.setImage(#imageLiteral(resourceName: "btn_coach_nor"), for: .normal)
        buttonFirst.setImage(#imageLiteral(resourceName: "btn_coach_prs"), for: .selected)
        buttonSecond.setImage(#imageLiteral(resourceName: "btn_coach_nor"), for: .normal)
        buttonSecond.setImage(#imageLiteral(resourceName: "btn_coach_prs"), for: .selected)
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        barcodeImageView.isHidden = true
        handImageView.isHidden = true
        
        presentFirst()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentFirst(){
        if count == 2{
            count = 0
            return
        }
        
        buttonFirst.isSelected = true
        buttonSecond.isSelected = false
        desLable.text = "對準任何商品條碼掃描\r立刻GET到食品檢驗報告"
        backgroundImage.image = #imageLiteral(resourceName: "bg_coach_01@3x.png")
        bottleImageView.isHidden = false
        phoneImageView.isHidden = false
        barcodeImageView.isHidden = true
        handImageView.isHidden = true
        
        UIView.animate(withDuration: 2, delay: 1, options: [], animations: {
            self.phoneBottleAlign.constant = 50
//            self.view.layoutIfNeeded()
        }, completion: {
            success in
            UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
                self.phoneBottleAlign.constant = -50
                self.view.layoutIfNeeded()
            }, completion: {
                success in
                UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
                    self.phoneBottleAlign.constant = 50
                    self.view.layoutIfNeeded()
                }, completion: {
                    success in
                    UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
                        self.phoneBottleAlign.constant = -50
                        self.view.layoutIfNeeded()
                    }, completion: {
                        success in
                        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
                            self.phoneBottleAlign.constant = 0
                            self.view.layoutIfNeeded()
                        }, completion: {
                            success in
                        })
                    })
                })
            })
        })
        
    }
    
    func changeImage(){
        var imageName = ""
        switch currentIndex {
        case 5:
            imageName = "icon_barcode_0\(currentIndex)@3x.png"
            currentIndex = 1
        case 1,2,3:
            imageName = "icon_barcode_0\(currentIndex)@3x.png"
            currentIndex += 1
        case 4:
            imageName = "icon_barcode_0\(currentIndex)@3x.png"
            currentIndex = 6
        case 6:
            imageName = "icon_barcode_03@3x.png"
            currentIndex = 7
        case 7:
            imageName = "icon_barcode_02@3x.png"
            currentIndex = 8
        case 8:
            imageName = "icon_barcode_01@3x.png"
            currentIndex = 9
        case 9:
            imageName = "icon_barcode_05@3x.png"
            currentIndex = 5
            if loopIndex == 0{
                loopIndex = 1
            }else{
                timer.invalidate()
            }
        default:
            break
        }
        DispatchQueue.main.async {
            self.barcodeImageView.image = UIImage(named: imageName)
        }
        
    }
    
    func presentSecond(){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        phoneImageView.layer.removeAllAnimations()
        backgroundImage.image = #imageLiteral(resourceName: "bg_coach_02@3x.png")
        barcodeImageView.image = #imageLiteral(resourceName: "icon_barcode_05@3x.png")
        currentIndex = 5
        desLable.text = "條碼掃不出來？\r沒關係！輸入數字也可以查詢"
        buttonFirst.isSelected = false
        buttonSecond.isSelected = true
        bottleImageView.isHidden = true
        phoneImageView.isHidden = true
        barcodeImageView.isHidden = false
        handImageView.isHidden = false
        count = 0
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
