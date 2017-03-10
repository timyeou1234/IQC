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
    
    var navFrame:CGRect?
    var article = Article()
    var productList = [Product]()
    var relatedeArticle = [Article]()
    var tagRow = 1
    var loadingView = UIView()
    
    @IBOutlet weak var scrollContainView: UIScrollView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var classBackView: UIView!
    @IBOutlet weak var classTittle: UILabel!
    @IBOutlet weak var modifyDate: UILabel!
    @IBOutlet weak var titteLable: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var otherArticleView: UIView!
    @IBOutlet weak var otherProductView: UIView!
    
    @IBOutlet weak var readingCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var youtubeWebView: UIWebView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playAction(_ sender: Any) {
        if URL(string: article.video!) != nil{
            youtubeWebView.isHidden = false
            playButton.isHidden = true
            youtubeWebView.loadRequest(URLRequest(url: URL(string: article.video!)!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        readingCollectionView.dataSource = self
        readingCollectionView.delegate = self
        
        readingCollectionView.register(UINib(nibName: "RelatedArticleCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        tagCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
        loadingView.startLoading()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        if article.video == nil{
            playButton.isHidden = true
            youtubeWebView.isHidden = true
        }else{
            playButton.isHidden = false
            youtubeWebView.isHidden = true
        }
        if article.main_img != nil{
            self.backImageView.sd_setImage(with: URL(string: article.main_img!))
        }
        self.classTittle.text = article.type
        self.navigationItem.title = article.type
        self.titteLable.text = article.title
        let date = article.modify?.components(separatedBy: "-")
        self.modifyDate.text = "\((date?[0])!)年\((date?[1])!)月\((date?[2].components(separatedBy: " ")[0])!)日"
        let attrStr = try! NSAttributedString(
            data: article.content!.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        self.contentLable.attributedText = attrStr
        if article.producrt != nil{
            if article.producrt != ""{
                loadingView.isHidden = false
                getProductDetail(productId: article.producrt!)
            }
        }
        
        if article.reading != nil{
            if article.reading != ""{
                loadingView.isHidden = false
                getReading(reading: article.reading!)
            }
        }
        
        if article.tag != nil{
            var width = Int(self.view.bounds.width)
            for tag in (article.tag?.components(separatedBy: ","))!{
                if tag.characters.count > width{
                    tagRow += 1
                    width = Int(self.view.bounds.width)
                }else{
                    width -= (tag.characters.count * 17) + 20
                }
            }
            tagCollectionViewHeight.constant = CGFloat(40 * tagRow)
        }
        navFrame = self.navigationController?.navigationBar.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playended), name: .UIWindowDidBecomeHidden, object: nil)
        
    }
    
    func playended(){
        scrollContainView.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
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

extension DetailArticleViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
            return CGSize(width: (productCollectionView.bounds.width/2)-10, height: productCollectionView.bounds.height)
        }else if collectionView == readingCollectionView{
            return CGSize(width: 260, height: 240)
        }
        return CGSize(width: ((article.tag?.components(separatedBy: ",")[indexPath.item].characters.count)! * 17) + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            return productList.count
        }
        if article.tag != nil && collectionView == tagCollectionView{
            return (article.tag?.components(separatedBy: ",").count)!
        }
        if collectionView == readingCollectionView{
            return relatedeArticle.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TagCollectionViewCell
            
            cell.tagLable.text = article.tag?.components(separatedBy: ",")[indexPath.item]
            cell.drawBorder()
            
            return cell
        }else if collectionView == readingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RelatedArticleCollectionViewCell
            
            let article = relatedeArticle[indexPath.row]
            if article.main_img != nil{
                if URL(string: article.main_img!) != nil{
                    cell.backImageView.sd_setImage(with: URL(string: article.main_img!))
                }}
            cell.typeLable.text = article.type
            cell.tittleLable.text = article.title
            cell.typeBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
            cell.playButtonImage.isHidden = article.video == nil
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        
        cell.productNameLable.text = productList[indexPath.item].title
        cell.productImageView.sd_setImage(with: URL(string: productList[indexPath.item].img!))
        
        cell.productImageView.addShadow()
        
        return cell
    }
    
    
}

extension DetailArticleViewController{
    
    func getProductDetail(productId:String){
        
        
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        for id in productId.components(separatedBy: ","){
            Alamofire.request("https://iqctest.com/api/product/detail/\(id)", headers: headers).responseJSON(completionHandler: {
                response in
                if let JSONData = response.result.value{
                    let json = JSON(JSONData)
                    print(json)
                    
                    let product = Product()
                    let jsonData = json["list"][0]
                    
                    if let id = jsonData["id"].string{
                        product.id = id
                    }
                    
                    if let title = jsonData["title"].string{
                        product.title = title
                    }
                    
                    if let img = jsonData["img"].string{
                        product.img = img
                    }
                    
                    self.productList.append(product)
                    self.productCollectionView.reloadData()
                }
                
            })
        }
    }
    
    func getReading(reading:String){
        
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        for id in reading.components(separatedBy: ","){
            
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
                        self.relatedeArticle.append(articleData)
                    }
                    if reading.components(separatedBy: ",").count == self.relatedeArticle.count{
                        self.readingCollectionView.reloadData()
                        self.loadingView.isHidden = true
                    }
                }
            })
            
        }
    }
    
}
