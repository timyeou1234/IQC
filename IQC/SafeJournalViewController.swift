//
//  SafeJournalViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/7.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SafeJournalViewController: UIViewController {
    
    var articleList = [Article]()
    var loadingView = UIView()
    
    @IBOutlet weak var interviewButton: UIButton!
    @IBOutlet weak var lifeButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var ownButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    
    @IBOutlet weak var articleTableView: UITableView!
    
    @IBAction func interViewAction(_ sender: Any) {
        getArticlList(type: "interview")
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: 0, y: self.underlineView.frame.minY, width: self.interviewButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    @IBAction func lifeAction(_ sender: Any) {
        getArticlList(type: "life")
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: self.lifeButton.frame.minX, y: self.underlineView.frame.minY, width: self.lifeButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    @IBAction func newsAction(_ sender: Any) {
        getArticlList(type: "news")
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: self.newsButton.frame.minX, y: self.underlineView.frame.minY, width: self.newsButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    @IBAction func ownAction(_ sender: Any) {
        getArticlList(type: "video")
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: self.ownButton.frame.minX, y: self.underlineView.frame.minY, width: self.ownButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interviewButton.setTitleColor(UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1), for: .selected)
        interviewButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        lifeButton.setTitleColor(UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1), for: .selected)
        lifeButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        newsButton.setTitleColor(UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1), for: .selected)
        newsButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        ownButton.setTitleColor(UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1), for: .selected)
        ownButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        articleTableView.register(UINib(nibName: "HotTopicListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        articleTableView.rowHeight = self.view.bounds.height / 2
        articleTableView.estimatedRowHeight = self.view.bounds.height / 2
        
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
        loadingView.startLoading()
        loadingView.isHidden = true
        
        interViewAction(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArticlList(type:String){
        loadingView.isHidden = false
        articleList = [Article]()
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/blog/list/\(type)", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if json["list"].array == nil{
                    self.articleTableView.isHidden = true
                    self.loadingView.isHidden = true
                    return
                }
                for article in json["list"]{
                    let articleData = Article()
                    if let id = article.1["id"].string{
                        articleData.id = id
                    }
                    if let modify = article.1["modify"].string{
                        articleData.modify = modify
                    }
                    if let content = article.1["content"].string{
                        articleData.content = content
                    }
                    if let img = article.1["list_img"].string{
                        articleData.img = img
                    }
                    if let article = article.1["article"].string{
                        articleData.article = article
                    }
                    if let title = article.1["title"].string{
                        articleData.title = title
                    }
                    if let type = article.1["type"].string{
                        articleData.type = type
                    }
                    if let video = article.1["video"].string{
                        articleData.video = video
                    }
                    self.articleList.append(articleData)
                }
                self.articleTableView.isHidden = false
                self.articleTableView.reloadData()
                self.loadingView.isHidden = true
            }
        })
    }
    
    func getArticleDetail(id:String){
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/article/detail/\(id)", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                let articleData = Article()
                
                if json["list"].array == nil{
                    self.loadingView.isHidden = true
                    return
                }
                
                for article in json["list"]{
                   
                    if let id = article.1["id"].string{
                        articleData.id = id
                    }
                    if let modify = article.1["modify"].string{
                        articleData.modify = modify
                    }
                    if let content = article.1["content"].string{
                        articleData.content = content
                    }
                    if let main_img = article.1["main_img"].string{
                        articleData.main_img = main_img
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
                    if let tag = article.1["tag"].string{
                        articleData.tag = tag
                    }
                    if let producrt = article.1["producrt"].string{
                        articleData.producrt = producrt
                    }
                    if let reading = article.1["reading"].string{
                        articleData.reading = reading
                    }
                    if let type = article.1["type"].string{
                        articleData.type = type
                    }
                    if let video = article.1["video"].string{
                        articleData.video = video
                    }
                }
                self.loadingView.isHidden = true
                self.performSegue(withIdentifier: "showDetail", sender: articleData)
            }
        })
        
    }
        
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetail"{
                let destinationController = segue.destination as! DetailArticleViewController
                destinationController.article = sender as! Article
            }else if segue.identifier == "openMenu"{
                let destinationController = segue.destination as! MenuViewController
                destinationController.transitioningDelegate = self
                destinationController.menuActionDelegate = self
            }
        }
        
        
    }
    
    extension SafeJournalViewController: UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, MenuActionDelegate{
        
        func openSegue(_ segueName: String, sender: AnyObject?) {
            dismiss(animated: false){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: segueName)
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }
        
        func reopenMenu() {
            
        }
        
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return PresentMenuAnimator()
        }
        
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return DismissmenuAnimator()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            getArticleDetail(id: articleList[indexPath.item].id!)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articleList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = articleTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotTopicListTableViewCell
            
            let article = articleList[indexPath.row]
            cell.backImageView.sd_setImage(with: URL(string: article.img!))
            cell.tittleLable.text = article.title
            let contentText = article.content!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            cell.descriptionLable.text = contentText
            cell.topicClass.text = article.type
            cell.topicBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
            cell.playButtonImage.isHidden = article.video == nil
            
            return cell
        }
        
}
