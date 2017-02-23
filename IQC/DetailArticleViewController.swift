//
//  DetailArticleViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class DetailArticleViewController: UIViewController {
    
    var articleId = 0

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var classBackView: UIView!
    @IBOutlet weak var classTittle: UILabel!
    @IBOutlet weak var modifyDate: UILabel!
    @IBOutlet weak var titteLable: UILabel!
    @IBOutlet weak var keywordView: UIView!
    @IBOutlet weak var contentLable: UILabel!
    
    @IBOutlet weak var otherArticleView: UIView!
    @IBOutlet weak var otherProductView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        
        
        Alamofire.request("https://iqctest.com/api/article/detail/\(articleId)", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                for article in json["list"]{
                    let articleData = Article()
                    if let modify = article.1["modify"].string{
                        articleData.modify = modify
                    }
                    if let content = article.1["content"].string{
                        articleData.content = content
                    }
                    if let img = article.1["img"].string{
                        articleData.img = img
                    }
                    if let article = article.1["article"].string{
                        articleData.article = article
                    }
                    if let title = article.1["title"].string{
                        articleData.title = title
                    }
                    if let des = article.1["des"].string{
                        articleData.des = des
                    }
                    
                }
            
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
