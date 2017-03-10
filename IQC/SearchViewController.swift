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

class SearchViewController: UIViewController {
    
    let dropDown = DropDown()
    var isLoaded = [false, false]
    var productList = [Product]()
    var articleList = [Article]()
    
    var tag = [String]()
    var usedTag = [String]()
    
    var loadingView = UIView()
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var outComeView: UIView!
    @IBOutlet weak var usedCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var classLable: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var classButton: UIButton!
    
    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var usedCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var articleButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var desLable: UILabel!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    
    @IBAction func productAction(_ sender: Any) {
        productCollectionView.isHidden = false
        articleTableView.isHidden = true
        
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: 0, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
    }
    
    @IBAction func articleAction(_ sender: Any) {
        productCollectionView.isHidden = true
        articleTableView.isHidden = false
        
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: self.view.frame.midX, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
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
//        searchBarView.addShadow()
        buttonView.addShadow()
        outComeView.isHidden = true
        
        let tapAround = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboardCustom(_:)))
        tapAround.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAround)
        
        searchTextField.delegate = self
        searchTextField.tintColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)
        
        dropDown.anchorView = classButton
        dropDown.dataSource = ["商品", "文章"]
        
        dropDown.selectionAction = {
            (index: Int, item: String) in
            self.classLable.text = item
        }
        
        articleButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        productButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        articleButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        productButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        tagCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        usedCollectionView.dataSource = self
        usedCollectionView.delegate = self
        
        usedCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        articleTableView.register(UINib(nibName: "HotTopicListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        articleTableView.rowHeight = self.view.bounds.height / 2
        articleTableView.estimatedRowHeight = self.view.bounds.height / 2
        
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
        loadingView.startLoading()
        // Do any additional setup after loading the view.
    }
    
    func dissmissKeyboardCustom(_ sender: Any){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getKeyword()
        self.navigationController?.navigationBar.isHidden = true
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
            usedCollectionViewHeight.constant = CGFloat(40 * tagRow)
            usedCollectionView.reloadData()
        }
        articleTableView.isHidden = true
        loadingView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        searchTextField.text = ""
        self.outComeView.isHidden = true
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

extension SearchViewController:UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        }else if collectionView == tagCollectionView{
            return CGSize(width: ((tag[indexPath.item].characters.count) * 17) + 20, height: 40)
        }
        return CGSize(width: ((usedTag[indexPath.item].characters.count) * 17) + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == usedCollectionView{
            searchTextField.text = usedTag[indexPath.item]
        }else if collectionView == tagCollectionView{
            searchTextField.text = tag[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            return productList.count
        }else if collectionView == tagCollectionView{
            return tag.count
        }
        return usedTag.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TagCollectionViewCell
            
            cell.tagLable.text = tag[indexPath.item]
            cell.drawBorder()
            
            return cell
        }else if collectionView == usedCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TagCollectionViewCell
            
            cell.tagLable.text = usedTag[indexPath.item]
            cell.drawBorder()
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        
        cell.productNameLable.text = productList[indexPath.item].title
        cell.productImageView.sd_setImage(with: URL(string: productList[indexPath.item].img!))
        
        cell.productImageView.addShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: articleList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotTopicListTableViewCell
        
        let article = articleList[indexPath.row]
        cell.backImageView.sd_setImage(with: URL(string: article.img!))
        cell.tittleLable.text = article.des
        cell.descriptionLable.text = article.content
        cell.topicClass.text = article.title
        cell.topicBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
        
        return cell
    }
    
    
}

extension SearchViewController{
    
    func getOutcome(keyWord:String){
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
                }
                if self.isLoaded[0] && self.isLoaded[1]{
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
                        if let tag = jsonData.1["tltle"].string{
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
                        self.tagCollectionViewHeight.constant = CGFloat(40 * tagRow)
                        self.tagCollectionView.reloadData()
                    }
                    
                }
            }
        })
        
    }
}


