//
//  SearchViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire
import DropDown
import TagListView

class SearchViewController: UIViewController {
    
    var isGo = false
    var isRelative = false
    var fromTagWord = ""
    let dropDown = DropDown()
    var searchedWord = ""
    var selectedIndex = 0
    var isLoaded = [false, false]
    var productList = [Product]()
    var articleList = [Article]()
    var text = ""
    
    var tag = [String]()
    var usedTag = [String]()
    
    var loadingView = LoadingView()
    
    
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var usedTagView: TagListView!
    
    
    @IBOutlet weak var underLineLeadinConstraint: NSLayoutConstraint!
    @IBOutlet weak var relativeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var relativeView: UIView!
    @IBOutlet weak var relativeLable: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var outComeView: UIView!
    //    @IBOutlet weak var usedCollectionView: UICollectionView!
    //    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var classLable: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var classButton: UIButton!
    
    //    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    //    @IBOutlet weak var usedCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var articleButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var desLable: UILabel!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    
    @IBAction func productAction(_ sender: Any) {
        articleButton.isSelected = false
        productButton.isSelected = true
        productCollectionView.isHidden = false
        articleTableView.isHidden = true
        if isRelative{
            relativeHeightConstraint.constant = 80
        }
        
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineLeadinConstraint.constant = 0
        })
        
        text = "<font size=\"5\"  color=\"#636363\">共有\"</font><font font size=\"5\"   color=\"#00B6C4\">\(self.productList.count)</font><font size=\"5\"  color=\"#636363\">\"筆關於\"</font><font size=\"5\"  color=\"#00B6C4\">\(searchedWord)</font><font size=\"5\"  color=\"#636363\">\"的商品搜尋結果</font>"
        
        let attrStr = try! NSAttributedString(
            data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        self.desLable.attributedText = attrStr
        
    }
    
    @IBAction func articleAction(_ sender: Any) {
        articleButton.isSelected = true
        productButton.isSelected = false
        productCollectionView.isHidden = true
        articleTableView.isHidden = false
        //        relativeHeightConstraint.constant = 0
        
        text = "<font size=\"5\" color=\"#636363\">共有\"</font><font size=\"5\"   color=\"#00B6C4\">\(self.articleList.count)</font><font size=\"5\"   color=\"#636363\">\"筆關於\"</font><font size=\"5\" color=\"#00B6C4\">\(searchedWord)</font><font size=\"5\" color=\"#636363\">\"的文章搜尋結果</font>"
        
        let attrStr = try! NSAttributedString(
            data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        self.desLable.attributedText = attrStr
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineLeadinConstraint.constant = self.view.bounds.width/2
        })
    }
    
    @IBAction func classAction(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchIsDetail.searchDetailBack.isDetailBack = false
        
        tagView.delegate = self
        usedTagView.delegate = self
        tagView.alignment = .left
        tagView.textFont = UIFont.systemFont(ofSize: 17)
        usedTagView.alignment = .left
        usedTagView.textFont = UIFont.systemFont(ofSize: 17)
        
        
        relativeHeightConstraint.constant = 0
        //        searchBarView.addShadow()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        buttonView.addShadow()
        outComeView.isHidden = true
        
        let tapAround = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboardCustom(_:)))
        tapAround.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAround)
        
        searchTextField.delegate = self
        searchTextField.tintColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)
        
        dropDown.anchorView = classButton
        dropDown.dataSource = ["商品", "文章"]
        
        
        
        articleButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        productButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        articleButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        productButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        articleTableView.register(UINib(nibName: "HotTopicListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        articleTableView.rowHeight = self.view.bounds.height / 2
        articleTableView.estimatedRowHeight = self.view.bounds.height / 2
        
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        
        // Do any additional setup after loading the view.
    }
    
    func dissmissKeyboardCustom(_ sender: Any){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        isGo = false
        self.navigationController?.navigationBar.isHidden = true
        if SearchIsDetail.searchDetailBack.isDetailBack!{
            
            return
        }
        searchTextField.text = ""
        self.outComeView.isHidden = true
        tag = [String]()
        getKeyword()
        searchTextField.becomeFirstResponder()
        let userDefaults = Foundation.UserDefaults.standard
        if userDefaults.array(forKey: "usedTag") != nil{
            usedTag = userDefaults.array(forKey: "usedTag") as! [String]
            var width = Int(self.view.bounds.width)
            var tagRow = 1
            for tag in usedTag{
                if tag.characters.count > width{
                    tagRow += 1
                    width = Int(self.view.bounds.width)
                }else{
                    width -= (tag.characters.count * 17) + 20
                }
            }
            usedTagView.removeAllTags()
            usedTagView.addTags(usedTag)
        }
        articleTableView.isHidden = true
        loadingView.isHidden = true
        if fromTagWord != ""{
            searchTextField.text = fromTagWord
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if SearchIsDetail.searchDetailBack.isDetailBack!{
            SearchIsDetail.searchDetailBack.isDetailBack = false
            return
        }
        dropDown.selectionAction = {
            (index: Int, item: String) in
            self.classLable.text = item
            if index == 0{
                self.productButton.isSelected = true
                self.articleButton.isSelected = false
                self.productAction(self)
            }else{
                self.productButton.isSelected = false
                self.articleButton.isSelected = true
                self.articleAction(self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationController = segue.destination as? NoResultViewController{
            destinationController.fromSearch = true
        }
    }
    
    
}

extension SearchViewController:UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TagListViewDelegate{
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        searchTextField.text = title
        if searchTextField.text != ""{
            getOutcome(keyWord: searchTextField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            let alert = UIAlertController(title: "請輸入關鍵字", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
            return true
        }
        getOutcome(keyWord: textField.text!)
        if !usedTag.contains(textField.text!){
            usedTag.append(textField.text!)
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(usedTag, forKey: "usedTag")
        }
        self.view.endEditing(true)
        loadingView.isHidden = false
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView{
            return CGSize(width: (productCollectionView.bounds.width/2)-10, height: (productCollectionView.bounds.width/2) + 40)
        }
        return CGSize(width: ((usedTag[indexPath.item].characters.count) * 17) + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView{
            if !isGo{
                SearchIsDetail.searchDetailBack.isDetailBack = true
                isGo = true
                getProductDetail(id: productList[indexPath.item].id!)
            }
            return
        }
        
        if searchTextField.text != ""{
            getOutcome(keyWord: searchTextField.text!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        
        cell.productNameLable.text = productList[indexPath.item].title
        cell.productImageView.sd_setImage(with: URL(string: productList[indexPath.item].img!))
        
        cell.productImageView.addShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isGo{
            SearchIsDetail.searchDetailBack.isDetailBack = true
            isGo = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailArticle") as! DetailArticleViewController
            self.navigationItem.backBarButtonItem?.title = ""
            vc.articleId = articleList[indexPath.row].id!
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        cell.selectionStyle = .none
        cell.topicBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
        
        return cell
    }
    
    
}

extension SearchViewController{
    
    func getOutcome(keyWord:String){
        searchedWord = keyWord
        loadingView.isHidden = false
        articleList = [Article]()
        productList = [Product]()
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        let keyWoedUTF = keyWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(URL(string: "https://iqctest.com/api/search/product/\(keyWoedUTF!)")!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if json["list"].array == nil{
                    self.isLoaded[0] = true
                    self.productButton.setTitle("商品(0)", for: .normal)
                    self.productButton.setTitle("商品(0)", for: .selected)
                }else{
                    for jsonData in json["list"]{
                        let productData = Product()
                        if let id = jsonData.1["id"].string{
                            productData.id = id
                        }
                        if let img = jsonData.1["img"].string{
                            productData.img = img
                        }
                        if let modify = jsonData.1["modify"].string{
                            productData.modify = modify
                        }
                        if let title = jsonData.1["title"].string{
                            productData.title = title
                        }
                        self.productList.append(productData)
                    }
                    self.productButton.setTitle("商品(\(self.productList.count))", for: .normal)
                    self.productButton.setTitle("商品(\(self.productList.count))", for: .normal)
                    self.isLoaded[0] = true
                    self.productCollectionView.reloadData()
                    if let result = json["result"].string{
                        if result == "2"{
                            self.relativeHeightConstraint.constant = 80
                            let relativeText = "<font size=\"5\"  color=\"#636363\">查無\"</font><font font size=\"5\"   color=\"#00B6C4\">\(keyWord)</font><font size=\"5\"  color=\"#636363\">\"相關文章根據上述商品類型，為你推薦有檢驗報告的相似商品與文章</font>"
                            let attrStrRe = try! NSAttributedString(
                                data: relativeText.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                documentAttributes: nil)
                            self.relativeLable.attributedText = attrStrRe
                            self.isRelative = true
                        }else{
                            self.relativeHeightConstraint.constant = 0
                            self.isRelative = false
                        }
                    }
                }
                if self.isLoaded[0] && self.isLoaded[1]{
                    if self.articleList.count == 0 && self.productList.count == 0{
//                        self.performSegue(withIdentifier: "noResult", sender: nil)
                    }
                    var text = ""
                    if self.articleButton.isSelected{
                        text = "<font size=\"5\"  color=\"#636363\">共有\"</font><font font size=\"5\"   color=\"#00B6C4\">\(self.articleList.count)</font><font size=\"5\"  color=\"#636363\">\"筆關於\"</font><font size=\"5\"  color=\"#00B6C4\">\(keyWord)</font><font size=\"5\"  color=\"#636363\">\"的文章搜尋結果</font>"
                    }else{
                        text = "<font size=\"5\"  color=\"#636363\">共有\"</font><font font size=\"5\"   color=\"#00B6C4\">\(self.productList.count)</font><font size=\"5\"  color=\"#636363\">\"筆關於\"</font><font size=\"5\"  color=\"#00B6C4\">\(keyWord)</font><font size=\"5\"  color=\"#636363\">\"的商品搜尋結果</font>"
                    }
                    let attrStr = try! NSAttributedString(
                        data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                        documentAttributes: nil)
                    self.desLable.attributedText = attrStr
                    self.outComeView.isHidden = false
                    self.loadingView.isHidden = true
                }
            }
        })
        
        Alamofire.request(URL(string: "https://iqctest.com/api/search/article/\(keyWoedUTF!)")!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if json["list"].array == nil{
                    self.isLoaded[1] = true
                    self.articleButton.setTitle("文章(0)", for: .normal)
                    self.articleButton.setTitle("文章(0)", for: .selected)
                }else{
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
                        if let type = article.1["type"].string{
                            articleData.type = type
                        }
                        if let des = article.1["des"].string{
                            articleData.des = des
                        }
                        self.articleList.append(articleData)
                    }
                    self.articleButton.setTitle("文章(\(self.articleList.count))", for: .normal)
                    self.articleButton.setTitle("文章(\(self.articleList.count))", for: .selected)
                    self.isLoaded[1] = true
                    self.articleTableView.reloadData()
                }
                if self.isLoaded[0] && self.isLoaded[1]{
                    if self.articleList.count == 0 && self.productList.count == 0{
//                        self.performSegue(withIdentifier: "noResult", sender: nil)
                    }
                    var text = ""
                    if self.articleButton.isSelected{
                        self.articleTableView.isHidden = false
                        text = "<font size=\"5\"   color=\"#636363\">共有\"</font><font size=\"5\" color=\"#00B6C4\">\(self.articleList.count)</font><font size=\"5\"  color=\"#636363\">\"筆關於\"</font><font size=\"5\" color=\"#00B6C4\">\(keyWord)</font><font size=\"5\"  color=\"#636363\">\"的文章搜尋結果</font>"
                    }else{
                        text = "<font size=\"5\"   color=\"#636363\">共有\"</font><font size=\"5\"   color=\"#00B6C4\">\(self.productList.count)</font><font size=\"5\"  color=\"#636363\">\"筆關於\"</font><font size=\"5\"  color=\"#00B6C4\">\(keyWord)</font><font size=\"5\"  color=\"#636363\">\"的商品搜尋結果</font>"
                    }
                    let attrStr = try! NSAttributedString(
                        data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                        documentAttributes: nil)
                    self.desLable.attributedText = attrStr
                    self.outComeView.isHidden = false
                    self.loadingView.isHidden = true
                }
            }
        })
    }
    
    func getKeyword(){
        
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        Alamofire.request(URL(string: "https://iqctest.com/api/website/keyword")!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if json["list"].array == nil{
                    
                }else{
                    for jsonData in json["list"]{
                        if let tag = jsonData.1["title"].string{
                            self.tag.append(tag)
                        }
                    }
                    DispatchQueue.main.async {
                        var width = Int(self.view.bounds.width)
                        var tagRow = 1
                        for tag in self.tag{
                            if tag.characters.count > width{
                                tagRow += 1
                                width = Int(self.view.bounds.width)
                            }else{
                                width -= (tag.characters.count * 17) + 20
                            }
                        }
                        //                        self.tagCollectionViewHeight.constant = CGFloat(45 * tagRow)
                        //                        self.tagCollectionView.reloadData()
                        self.tagView.removeAllTags()
                        self.tagView.addTags(self.tag)
                        //                        self.tagView.sizeToFit()
                    }
                    
                }
            }
        })
        
    }
    
    func getProductDetail(id:String){
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/product/detail/\(id)", headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                for jsonData in json["list"]{
                    if let _ = jsonData.1["gov"].string{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GovProductDetail") as! GovProductDetailViewController
                        vc.productId = id
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        self.loadingView.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IQCProductDetail") as! IQCProductDetailViewController
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        vc.productId = id
                        self.loadingView.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        })
        
    }
    
}

class SearchIsDetail:NSObject{
    
    static let searchDetailBack = SearchIsDetail()
    
    var isDetailBack:Bool?
    
}


