//
//  AboutViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/16.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:關於iQC

import UIKit
import Alamofire
import SwiftyJSON

class AboutViewController: UIViewController, UIWebViewDelegate {

    var content = ""
    var loadingView = LoadingView()
    var gotoRoot:GotoRootDelegate?
    
    @IBAction func dismissAction(_ sender: Any) {
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.isFromMenu = nil
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var webviewHightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentWebView.delegate = self
        contentWebView.scrollView.isDirectionalLockEnabled = true
        shadowView.addShadow()
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.masksToBounds = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        
        Alamofire.request("https://iqctest.com/api/website/intro", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            if let _ = response.error{
                let alert = UIAlertController(title: "網路異常", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                for list in json["list"]{
                    if let content = list.1["content"].string{
                        self.content = content
                        self.refreshView()
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshView(){
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.contentWebView.loadHTMLString(self.content, baseURL: nil)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        webviewHightConstant.constant = webView.frame.height
        webView.frame = CGRect(x: 0, y: 0, width: contentWebView.frame.width, height: webviewHightConstant.constant)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
