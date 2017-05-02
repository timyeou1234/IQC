//
//  AboutViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/16.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AboutViewController: UIViewController, UIWebViewDelegate {

    var content = ""
    var loadingView = LoadingView()
    var gotoRoot:GotoRootDelegate?
    
    @IBAction func dismissAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var webviewHightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentWebView.delegate = self
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
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
