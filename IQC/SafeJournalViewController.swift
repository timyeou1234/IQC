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
    
    var isUpdating = false
    var articleList = [Article]()
    var lifeList = [Article]()
    var newsList = [Article]()
    var ownList = [Article]()
    var loadingView = LoadingView()
    var currentType = ""
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var buttonScrollView: UIScrollView!
    @IBOutlet weak var interviewButton: UIButton!
    @IBOutlet weak var lifeButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var ownButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    
    @IBOutlet weak var articleTableView: UITableView!
    
    @IBAction func interViewAction(_ sender: Any) {
        currentType = "食安專訪"
        buttonScrollView.contentOffset = CGPoint(x: 0, y: 0)
        articleTableView.reloadData()
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: 0, y: self.underlineView.frame.minY, width: self.interviewButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    @IBAction func lifeAction(_ sender: Any) {
        currentType = "食安生活"
        articleTableView.reloadData()
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: self.lifeButton.frame.minX, y: self.underlineView.frame.minY, width: self.lifeButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    @IBAction func newsAction(_ sender: Any) {
        currentType = "食安新知"
        articleTableView.reloadData()
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underlineView.frame = CGRect(x: self.newsButton.frame.minX, y: self.underlineView.frame.minY, width: self.newsButton.bounds.width, height: self.underlineView.bounds.height)
        })
    }
    
    @IBAction func ownAction(_ sender: Any) {
        currentType = "自己食安自己救"
        buttonScrollView.contentOffset = CGPoint(x: buttonScrollView.contentSize.width - self.view.bounds.width, y: 0)
        articleTableView.reloadData()
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
        
        refreshControl = UIRefreshControl()
        articleTableView.addSubview(refreshControl)
        
        articleTableView.rowHeight = self.view.bounds.height / 2
        articleTableView.estimatedRowHeight = self.view.bounds.height / 2
        
        getArticlList(type: "all")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        loadingView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArticlList(type:String){
        loadingView.isHidden = false
        articleList = [Article]()
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/blog/list/all", headers: headers).responseJSON(completionHandler: {
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
                    if let main_img = article.1["main_img"].string{
                        articleData.main_img = main_img
                    }
                    if let video = article.1["video"].string{
                        articleData.video = video
                    }
                    if let type = article.1["type"].string{
                        articleData.type = type
                        switch type{
                        case "食安專訪":
                            self.articleList.append(articleData)
                        case "食安生活":
                            self.lifeList.append(articleData)
                        case "食安新知":
                            self.newsList.append(articleData)
                        case "自己食安自己救":
                            self.ownList.append(articleData)
                        default:
                            break
                        }
                    }
                }
                self.interViewAction(self)
                self.articleTableView.isHidden = false
                self.articleTableView.reloadData()
                self.loadingView.isHidden = true
            }
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let destinationController = segue.destination as! DetailArticleViewController
            destinationController.articleId = sender as! String
        }else if segue.identifier == "openMenu"{
            let destinationController = segue.destination as! MenuViewController
            destinationController.transitioningDelegate = self
            destinationController.menuActionDelegate = self
        }
    }
    
    
}

extension SafeJournalViewController: UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, MenuActionDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isUpdating {
                update(type: currentType)
            }else{
                refreshControl.endRefreshing()
            }
        }
    }
    
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
        var article = Article()
        switch currentType{
        case "食安專訪":
            article = articleList[indexPath.row]
        case "食安生活":
            article = lifeList[indexPath.row]
        case "食安新知":
            article = newsList[indexPath.row]
        case "自己食安自己救":
            article = ownList[indexPath.row]
        default:
            break
        }
        performSegue(withIdentifier: "showDetail", sender: article.id!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentType{
        case "食安專訪":
            return articleList.count
        case "食安生活":
            return lifeList.count
        case "食安新知":
            return newsList.count
        case "自己食安自己救":
            return ownList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotTopicListTableViewCell
        cell.selectionStyle = .none
        
        var article = Article()
        switch currentType{
        case "食安專訪":
            article = articleList[indexPath.row]
        case "食安生活":
            article = lifeList[indexPath.row]
        case "食安新知":
            article = newsList[indexPath.row]
        case "自己食安自己救":
            article = ownList[indexPath.row]
        default:
            break
        }
        cell.backImageView.sd_setImage(with: URL(string: article.img!))
        cell.tittleLable.text = article.title
        let contentText = article.content!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.descriptionLable.text = contentText
        cell.topicClass.text = article.type
        cell.topicBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
        cell.playButtonImage.isHidden = article.video == nil
        
        return cell
    }
    
    func update(type:String){
        isUpdating = true
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/blog/list/\(type)", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if let list = json["list"].array{
                    var count = 0
                    switch type{
                    case "食安專訪":
                        count = self.articleList.count
                    case "食安生活":
                        count = self.lifeList.count
                    case "食安新知":
                        count = self.newsList.count
                    case "自己食安自己救":
                        count = self.ownList.count
                    default:
                        break
                    }
                    if list.count == count{
                        self.isUpdating = false
                        return
                    }
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
                    if let main_img = article.1["main_img"].string{
                        articleData.main_img = main_img
                    }
                    if let video = article.1["video"].string{
                        articleData.video = video
                    }
                    if let type = article.1["type"].string{
                        articleData.type = type
                        switch type{
                        case "食安專訪":
                            self.articleList.append(articleData)
                        case "食安生活":
                            self.lifeList.append(articleData)
                        case "食安新知":
                            self.newsList.append(articleData)
                        case "自己食安自己救":
                            self.ownList.append(articleData)
                        default:
                            break
                        }
                    }
                }
                self.refreshControl.endRefreshing()
                self.articleTableView.reloadData()
                self.isUpdating = false
            }
        })
        
    }

    
}
