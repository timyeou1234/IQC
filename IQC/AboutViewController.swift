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

class AboutViewController: UIViewController {

    var content = ""
    var loadingView = UIView()
    var gotoRoot:GotoRootDelegate?
    
    @IBAction func dismissAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var contentLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.addShadow()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
        loadingView.startLoading()
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
            let attrStr = try! NSAttributedString(
                data: self.content.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.contentLable.attributedText = attrStr
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
