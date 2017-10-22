//
//  HotTopicDetailViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/1.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:熱門文章第二層

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
        
        if articleList.count != 0{
            hotTopicTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UITableViewAutomaticDimension
        }else{
            return self.view.bounds.height / 2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0{
            self.performSegue(withIdentifier: "showDetail", sender: articleList[indexPath.row - 1].id)
        }
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
            cell.selectionStyle = .none
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
