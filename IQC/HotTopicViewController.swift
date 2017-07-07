//
//  HotTopicViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class HotTopicViewController: UIViewController {
    
    var isUpdating = false
    var refreshControl: UIRefreshControl!
    var articleList = [Article]()
    var loadingView = LoadingView()
    
    @IBOutlet weak var hotTopicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotTopicTableView.delegate = self
        hotTopicTableView.dataSource = self
        
        hotTopicTableView.register(UINib(nibName: "HotTopicListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        refreshControl = UIRefreshControl()
        hotTopicTableView.addSubview(refreshControl)
        
        hotTopicTableView.rowHeight = self.view.bounds.height / 2
        hotTopicTableView.estimatedRowHeight = self.view.bounds.height / 2
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        
        if articleList.count == 0{
            loadingView.isHidden = false
            hotTopicTableView.isHidden = true
            let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
            
            Alamofire.request("https://iqctest.com/api/topic/list", headers: headers).responseJSON(completionHandler: {
                response in
                print(response)
                
                if let JSONData = response.result.value{
                    let json = JSON(JSONData)
                    print(json)
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
                        if let content = article.1["content"].string{
                            articleData.content = content
                        }
                        self.articleList.append(articleData)
                    }
                    self.hotTopicTableView.reloadData()
                    self.hotTopicTableView.isHidden = false
                    self.loadingView.isHidden = true
                }
            })
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        loadingView.remove()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail"{
            let destinationController = segue.destination as! HotTopicDetailViewController
            let article = sender as! Article
            destinationController.topTitle = article.title
            destinationController.topSubtitle = article.des
            destinationController.topDesc = article.content
            if article.article != nil{
                destinationController.articleId = article.article!
            }
        }else if segue.identifier == "openMenu"{
            let destinationController = segue.destination as! MenuViewController
            destinationController.transitioningDelegate = self
            destinationController.menuActionDelegate = self
        }
    }
    
    
}

extension HotTopicViewController:UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, MenuActionDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isUpdating {
                update()
            }
            refreshControl.endRefreshing()
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
        if articleList.count > indexPath.row{
            self.performSegue(withIdentifier: "showDetail", sender: articleList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hotTopicTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotTopicListTableViewCell
        cell.selectionStyle = .none
        
        let article = articleList[indexPath.row]
        cell.backImageView.sd_setImage(with: URL(string: article.img!))
        cell.tittleLable.text = article.title
        cell.descriptionLable.text = article.des
        cell.topicClass.text = "熱門專題"
        cell.topicBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
        
        return cell
    }
    
    func update(){
        isUpdating = true
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/topic/list", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if let list = json["list"].array{
                    if list.count == self.articleList.count{
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
                    self.articleList.append(articleData)
                }
                self.hotTopicTableView.reloadData()
                self.isUpdating = false
            }
        })

    }
    
}


