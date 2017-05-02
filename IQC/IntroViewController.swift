//
//  IntroViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/17.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    let gradient = CAGradientLayer()
    var firstOringinFrame:CGRect?

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImageHand: UIImageView!
    @IBOutlet weak var secondImageBubble: UIImageView!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    
    @IBAction func skipAction(_ sender: Any) {
        if skipButton.currentTitle == "略過"{
            performSegue(withIdentifier: "showMain", sender: nil)
        }else{
            firstImage.frame = firstOringinFrame!
            buttonFirst.isSelected = true
            buttonSecond.isSelected = false
            skipButton.setTitle("略過", for: .normal)
            nextButton.setTitle("下一則", for: .normal)
            firstImage.isHidden = false
            secondImageBubble.isHidden = true
            secondImageHand.isHidden = true
            presentFirst()
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if nextButton.currentTitle == "下一則"{
            buttonFirst.isSelected = false
            buttonSecond.isSelected = true
            skipButton.setTitle("上一則", for: .normal)
            nextButton.setTitle("完成", for: .normal)
            firstImage.isHidden = true
            secondImageBubble.isHidden = true
            secondImageHand.isHidden = false
            presentSecond()
        }else{
            performSegue(withIdentifier: "showMain", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstOringinFrame = firstImage.frame
        
        buttonFirst.setImage(#imageLiteral(resourceName: "btn_coach_nor"), for: .normal)
        buttonFirst.setImage(#imageLiteral(resourceName: "btn_coach_prs"), for: .selected)
        buttonSecond.setImage(#imageLiteral(resourceName: "btn_coach_nor"), for: .normal)
        buttonSecond.setImage(#imageLiteral(resourceName: "btn_coach_prs"), for: .selected)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        secondImageHand.isHidden = true
        secondImageBubble.isHidden = true
        buttonFirst.isSelected = true
        presentFirst()
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
    

    func presentFirst(){
        UIView.animate(withDuration: 2, animations: {
            self.firstImage.frame = CGRect(x: 0 - (self.firstImage.frame.width * 0.1), y: self.firstImage.frame.minY - (self.firstImage.frame.height * 0.1), width: self.firstImage.frame.width * 1.2, height: self.firstImage.frame.height * 1.2)
        })
    }
    
    func presentSecond(){
        UIView.animate(withDuration: 0.2, animations: {
            self.secondImageBubble.isHidden = false
        }, completion: {
            success in
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.secondImageBubble.transform = self.secondImageBubble.transform.rotated(by: CGFloat(M_PI_4))
            }, completion: {
                success in
                UIView.animate(withDuration: 1, animations: {
                    self.secondImageBubble.transform = self.secondImageBubble.transform.rotated(by:CGFloat(-M_PI_4))
                })
            })
        })
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
