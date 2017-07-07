//
//  HotTopicDetailViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/1.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire

class HotTopicDetailViewController: UIViewController {
    
    var articleId = ""
    var articleList = [Article]()
    var loadingView = LoadingView()
    var topTitle:String?
    var topSubtitle:String?
    var topDesc:String?
    
    @IBOutlet weak var hotTopicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        hotTopicTableView.delegate = self
        hotTopicTableView.dataSource = self
        
        hotTopicTableView.register(UINib(nibName: "HotTopicListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        hotTopicTableView.register(UINib(nibName: "HotTopicTopTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell0")
        
        
        hotTopicTableView.rowHeight = UITableViewAutomaticDimension
        hotTopicTableView.estimatedRowHeight = self.view.bounds.height / 2
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        loadingView.isHidden = false
        
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        articleList = [Article]()
        hotTopicTableView.reloadData()
        for id in articleId.components(separatedBy: ","){
            
            Alamofire.request("https://iqctest.com/api/article/detail/\(id)", headers: headers).responseJSON(completionHandler: {
                response in
                print(response)
            
                if let JSONData = response.result.value{
                    let json = JSON(JSONData)
                    print(json)
                    if json["list"].array == nil{
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
                        self.articleList.append(articleData)
                        self.hotTopicTableView.reloadData()
                        self.loadingView.isHidden = true
                    }
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let destinationController = segue.destination as! DetailArticleViewController
            destinationController.articleId = sender as! String
        }
    }
    
    
}

extension HotTopicDetailViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: articleList[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell0", for: indexPath) as! HotTopicTopTableViewCell
            cell.titleLable.text = topTitle
            cell.subTitleLable.text = topSubtitle
            cell.contentLable.text = topDesc
            return cell
        }
        let cell = hotTopicTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotTopicListTableViewCell
        cell.selectionStyle = .none
        
        let article = articleList[indexPath.row - 1]
        if article.main_img != nil{
            cell.backImageView.sd_setImage(with: URL(string: article.main_img!))
        }
        cell.tittleLable.text = article.title
        let contentText = article.content!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.descriptionLable.text = contentText
        cell.topicClass.text = article.type
        cell.topicBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
        cell.playButtonImage.isHidden = article.video == nil
        
        return cell
    }
    
}
