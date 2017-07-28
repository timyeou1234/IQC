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
import Social
import FacebookShare
import FBSDKShareKit
import TagListView

var MyObservationContext = 0

class DetailArticleViewController: UIViewController, UIWebViewDelegate {
    
    var observing = false
    var navFrame:CGRect?
    var articleId = ""
    var isFirstLoad = true
    var article = Article()
    var productList = [Product]()
    var relatedeArticle = [Article]()
    var tagRow = 1
    var loadingView = LoadingView()
    var facebookActive = false
    
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var facebookWebviewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteTextLable: UILabel!
    @IBOutlet weak var facebookWebview: UIWebView!
    @IBOutlet weak var webViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var scrollContainView: UIScrollView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var classBackView: UIView!
    @IBOutlet weak var classTittle: UILabel!
    @IBOutlet weak var modifyDate: UILabel!
    @IBOutlet weak var titteLable: UILabel!
    //    @IBOutlet weak var contentLable: UILabel!
    
    
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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBAction func shareAction(_ sender: Any) {
        facebookActive = true
        let myWebsite = NSURL(string: "https://iqctest.com/article/\(articleId)")
        
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagList.delegate = self
        tagList.alignment = .right
        tagList.textFont = UIFont.systemFont(ofSize: 17)
        
        facebookWebview.delegate = self
        contentWebView.delegate = self
        AppUtility.lockOrientation(.portrait)
        classBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        readingCollectionView.dataSource = self
        readingCollectionView.delegate = self
        
        readingCollectionView.register(UINib(nibName: "RelatedArticleCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        
        self.tabBarController?.tabBar.isHidden = true
        if article.id == nil{
            getArticleDetail(id: articleId)
        }else{
            loadingView.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playended), name: .UIWindowDidBecomeHidden, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playStarted), name: .UIWindowDidBecomeVisible, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let facebookUrl = "<!DOCTYPE html><html> <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head><body> <div id=\"fb-root\"></div><script>(function(d, s, id){var js, fjs=d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js=d.createElement(s); js.id=id; js.src=\"//connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v2.8&appId=700015816832989\"; fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script> <div class=\"fb-comments\" data-href=\"https://iqctest.com/article/\(articleId)\" data-numposts=\"5\"></div></body></html>"
        if isFirstLoad{
            facebookWebview.loadHTMLString(facebookUrl, baseURL: URL(string: "https://www.facebook.com/iqc.com.tw"))
            facebookWebview.reload()
            isFirstLoad = false
        }
    }
    
    func setupView(){
        relatedeArticle = [Article]()
        productList = [Product]()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        if article.video == nil{
            playButton.isHidden = true
            youtubeWebView.isHidden = true
        }else{
            youtubeWebView.loadRequest(URLRequest(url: URL(string: article.video!)!))
            youtubeWebView.isHidden = false
        }
        if article.main_img != nil{
            self.backImageView.sd_setImage(with: URL(string: article.main_img!))
        }
        self.classTittle.text = article.type
        self.navigationItem.title = article.type
        self.titteLable.text = article.title
        let date = article.modify?.components(separatedBy: "-")
        self.modifyDate.text = "\((date?[0])!)年\((date?[1])!)月\((date?[2].components(separatedBy: " ")[0])!)日"
        contentWebView.loadHTMLString(article.content!, baseURL: nil)
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
        }else if article.reading == nil && article.producrt == nil{
            loadingView.isHidden = true
        }
        
        if article.tag != nil{
            var tagList = [String]()
            for tag in (article.tag?.components(separatedBy: ","))!{
                tagList.append(tag)
            }
            self.tagList.removeAllTags()
            self.tagList.addTags(tagList)
            
        }
        
        if article.note != nil{
            noteView.isHidden = false
            noteTextLable.text = article.note
        }else{
            noteView.isHidden = true
        }
        
        navFrame = self.navigationController?.navigationBar.frame
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        if webView == contentWebView{
            webViewHeightConstant.constant = webView.frame.size.height
        }else if webView == facebookWebview{
            facebookWebviewHeightConstant.constant = webView.scrollView.contentSize.height
            let currentURL : String = (webView.request?.url?.absoluteString)!
            if currentURL.contains("/close_popup"){
                let facebookUrl = "<!DOCTYPE html><html> <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head><body> <div id=\"fb-root\"></div><script>(function(d, s, id){var js, fjs=d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js=d.createElement(s); js.id=id; js.src=\"//connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v2.8&appId=700015816832989\"; fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script> <div class=\"fb-comments\" data-href=\"https://iqctest.com/article/\(articleId)\" data-numposts=\"5\"></div></body></html>"
                facebookWebview.loadHTMLString(facebookUrl, baseURL: URL(string: "https://www.facebook.com/iqc.com.tw"))
            }
            if (!observing) {
                startObservingHeight()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    deinit{
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        facebookWebview.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        facebookWebview.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            facebookWebviewHeightConstant.constant = facebookWebview.scrollView.contentSize.height
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }

    }
    
    func playStarted(){
        if !facebookActive && youtubeWebView.isFirstResponder{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    func playended(){
        scrollContainView.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        facebookActive = false
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
        if let destinationController = segue.destination as? SearchViewController{
            destinationController.fromTagWord = sender as! String
        }
    }
    
    
}

extension DetailArticleViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TagListViewDelegate{
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        performSegue(withIdentifier: "search", sender: title)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == readingCollectionView{
            return 20
        }else if collectionView == productCollectionView{
            return 8
        }
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == readingCollectionView{
            return 20
        }
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView{
            if productCollectionView.bounds.width/2 - 10 >= productCollectionView.bounds.height{
                return CGSize(width: productCollectionView.bounds.height - 40, height: productCollectionView.bounds.height)
            }
            return CGSize(width: (productCollectionView.bounds.width/2)-10, height: productCollectionView.bounds.height)
        }else if collectionView == readingCollectionView{
            return CGSize(width: readingCollectionView.bounds.height-20, height: readingCollectionView.bounds.height-30)
        }
        let tag = article.tag?.components(separatedBy: ",")[indexPath.item]
        return CGSize(width: (tag! as NSString).size(attributes: nil).width + 24, height: 40)
        //return CGSize(width: (getSizeFromString(string: tag!, withFont: classTittle.font).width + 15), height: 40)
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        let attributes = [NSFontAttributeName:self,]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: DBL_MAX), nil)
    }
    
    func getSizeFromString(string:String, withFont font:UIFont)->CGSize{
        
        let textSize = NSString(string: string ).size(
            
            attributes: [ NSFontAttributeName:font ])
        
        return textSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == readingCollectionView{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailArticle") as! DetailArticleViewController
            if relatedeArticle.count > indexPath.item {
                vc.articleId = relatedeArticle[indexPath.item].id!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if collectionView == productCollectionView{
            if productList.count <= indexPath.item{
                return
            }
            let product = productList[indexPath.item]
            if product.gov != nil{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GovProductDetail") as! GovProductDetailViewController
                vc.productId = product.id!
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
                vc.productId = product.id!
                self.loadingView.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
//            getProductDetailGo(id: productList[indexPath.item].id!)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            return productList.count
        }
        if collectionView == readingCollectionView{
            if relatedeArticle.count == 0{
                return 3
            }
            return relatedeArticle.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == readingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RelatedArticleCollectionViewCell
            
            if relatedeArticle.count == 0 || relatedeArticle.count - 1 < indexPath.row{
                return cell
            }
            
            let article = relatedeArticle[indexPath.row]
            if article.main_img != nil{
                if URL(string: article.main_img!) != nil{
                    cell.backImageView.sd_setImage(with: URL(string: article.main_img!))
                }}
            cell.typeLable.text = article.type
            cell.tittleLable.text = article.title
            cell.typeBackView.clipBackground(color: UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1))
            cell.playButtonImage.isHidden = article.video == nil
            cell.backImageView.clipBackground(cornerRadious: 5, color: .clear)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        
        cell.productNameLable.font = cell.productNameLable.font.withSize(15)
        cell.productNameLable.text = productList[indexPath.item].title
        cell.productImageView.sd_setImage(with: URL(string: productList[indexPath.item].img!))
        
        cell.productImageView.addShadow()
        
        return cell
    }
    
    
}

extension DetailArticleViewController{
    
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
                    if let note = article.1["note"].string{
                        articleData.note = note
                    }
                    self.article = articleData
                }
                self.setupView()
            }
        })
        
    }
    
    
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
                    
                    if let gov = jsonData["gov"].string{
                        product.gov = gov
                    }
                    
                    self.productList.append(product)
                    self.productCollectionView.reloadData()
                    self.loadingView.isHidden = true
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
    
    func getProductDetailGo(id:String){
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

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
