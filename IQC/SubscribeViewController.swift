//
//  SubscribeViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/16.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubscribeViewController: UIViewController {
    
    let gradient = CAGradientLayer()
    var keyboardHeight:CGFloat = 0
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textFieldViewHeight: NSLayoutConstraint!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    @IBAction func sendAction(_ sender: Any) {
        var gender = "男"
        if femaleButton.isSelected{
            gender = "女"
        }
        
        if nameTextField.text != "" && emailTextField.text != "" && moreView.isHidden == false && companyTextField.text != "" && titleTextField.text != ""{
            if isValidEmail(testStr: emailTextField.text!){
                postRequest(name: nameTextField.text!, gender: gender, mail: emailTextField.text!, company: companyTextField.text!, job: titleTextField.text!, subscribe: "1")
            }else{
                let alert = UIAlertController(title: "請輸入正確信箱", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }else if nameTextField.text != "" && emailTextField.text != "" && moreView.isHidden{
            if isValidEmail(testStr: emailTextField.text!){
                postRequest(name: nameTextField.text!, gender: gender, mail: emailTextField.text!, company: "", job: "", subscribe: "0")
            }else{
                let alert = UIAlertController(title: "請輸入正確信箱", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = UIAlertController(title: "請輸入完整資訊", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func maleAction(_ sender: Any) {
        maleButton.layer.borderColor = "".colorWithHexString("00BACA").cgColor
        femaleButton.layer.borderColor = UIColor.gray.cgColor
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }
    
    @IBAction func femaleAction(_ sender: Any) {
        femaleButton.layer.borderColor = "".colorWithHexString("00BACA").cgColor
        maleButton.layer.borderColor = UIColor.gray.cgColor
        maleButton.isSelected = false
        femaleButton.isSelected = true
    }
    
    @IBAction func moreAction(_ sender: Any) {
        if moreView.isHidden == true{
            moreView.isHidden = false
            downArrowImageView.image = #imageLiteral(resourceName: "btn_up_01")
        }else{
            moreView.isHidden = true
            downArrowImageView.image = #imageLiteral(resourceName: "btn_down_01")
        }
        if textFieldViewHeight.constant > 0{
            textFieldViewHeight.constant = 0
        }else{
            textFieldViewHeight.constant = 50
        }
    }
    
    @IBAction func dissmissAction(_ sender: Any) {
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.isFromMenu = nil
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        shadowView.addShadow()
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.masksToBounds = false
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        titleTextField.delegate = self
        companyTextField.delegate = self
        
        maleButton.layer.borderColor = UIColor.gray.cgColor
        maleButton.layer.borderWidth = 1
        maleButton.layer.masksToBounds = true
        femaleButton.layer.borderColor = UIColor.gray.cgColor
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.masksToBounds = true
        
        maleButton.setImage(nil, for: .normal)
        maleButton.setImage(#imageLiteral(resourceName: "icon_shape_03"), for: .selected)
        femaleButton.setImage(nil, for: .normal)
        femaleButton.setImage(#imageLiteral(resourceName: "icon_shape_03"), for: .selected)
        
        maleButton.setTitleColor(UIColor.gray, for: .normal)
        maleButton.setTitleColor("".colorWithHexString("00BACA"), for: .selected)
        femaleButton.setTitleColor(UIColor.gray, for: .normal)
        femaleButton.setTitleColor("".colorWithHexString("00BACA"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
        if companyTextField.isEditing || titleTextField.isEditing {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0, animations: { success in
                    self.view.frame = CGRect(x: 0, y: -self.keyboardHeight, width: self.view.bounds.width, height: self.view.bounds.height)
                })
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        監聽鍵盤事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        maleAction(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //設定漸層效果
        if gradient.frame != self.buttonView.bounds{
            gradient.frame = self.buttonView.bounds
            gradient.colors = ["".colorWithHexString("#2CCAA8").cgColor, "".colorWithHexString("#18B7CD").cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.locations = [0, 1]
            self.buttonView.layer.addSublayer(gradient)
            gradient.zPosition = 0
        }
        subButton.layer.borderColor = UIColor.lightGray.cgColor
        subButton.layer.borderWidth = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postRequest(name:String, gender:String, mail:String, company:String, job:String, subscribe:String){
        
        let headers:HTTPHeaders = ["Content-Type": "application/json" ,"charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        let param:Parameters = [ "content":[[ "name": name, "gender": gender, "mail": mail, "company": company, "job":job, "subscribe":subscribe
            ]
            ]]
        
        _ = Alamofire.request(URL(string: "https://iqctest.com/api/data/subscribe")!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: {
            response in
            debugPrint(response)
            let alert = UIAlertController(title: "感謝您的訂閱", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: {
                success in
                self.dissmissAction(self)
            })
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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

extension SubscribeViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0, animations: { success in
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        })
    }
    
}
