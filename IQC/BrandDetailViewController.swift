//
//  BrandDetailViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/7.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class BrandDetailViewController: UIViewController, UIWebViewDelegate {
    
    var brandId = ""
    var brandData = Brand()
    var brandOwnedProduct = [Product]()
    var loadingView = LoadingView()
    
    // 6/26Change
    @IBOutlet weak var desWebView: UIWebView!
    @IBOutlet weak var detailDesWebView: UIWebView!
    @IBOutlet weak var desWebViewHeightt: NSLayoutConstraint!
    @IBOutlet weak var detailDesWebviewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var brandNameLable: UILabel!
    
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var phoneLable: UILabel!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var introLable: UILabel!
    @IBOutlet weak var desIntroLable: UILabel!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBAction func brandWebAction(_ sender: Any) {
        if brandData.website != nil{
            if URL(string:brandData.website!) != nil{
                UIApplication.shared.openURL(URL(string:brandData.website!)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        desWebView.delegate = self
        detailDesWebView.delegate = self
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        設定讀取中圖示
        loadingView.frame = self.view.bounds
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        loadingView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload(){
        loadingView.isHidden = false
        getBrand(id: brandId)
    }
    
    func getBrand(id:String){
        if id == ""{
            return
        }
            
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/brand/detail/\(id)", headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                if json["list"] == nil{
                    return
                }
                for brand in json["list"]{
                    
                    if let id = brand.1["id"].string{
                        self.brandData.id = id
                    }
                    if let product = brand.1["product"].string{
                        self.brandData.product = product
                        self.getProductList(id: product)
                    }
                    if let intro = brand.1["intro"].string{
                        self.brandData.intro = intro
                    }
                    if let content = brand.1["content"].string{
                        self.brandData.content = content
                    }
                    if let categoryid = brand.1["categoryid"].string{
                        self.brandData.categoryid = categoryid
                    }
                    if let des = brand.1["des"].string{
                        self.brandData.des = des
                    }
                    if let img = brand.1["img"].string{
                        self.brandData.img = img
                    }
                    if let logo = brand.1["logo"].string{
                        self.brandData.logo = logo
                    }
                    if let service = brand.1["service"].string{
                        self.brandData.service = service
                    }
                    if let number = brand.1["number"].string{
                        self.brandData.number = number
                    }
                    if let website = brand.1["website"].string{
                        self.brandData.website = website
                    }
                    if let name = brand.1["name"].string{
                        self.brandData.name = name
                    }
                    if let supplier = brand.1["supplier"].string{
                        self.brandData.supplier = supplier
                    }
                }
                DispatchQueue.main.async {
                    self.refreshBrandContent()
                }
            }
        })
    }
    
    func refreshBrandContent(){
        if brandData.img != nil{
            if URL(string: brandData.img!) != nil{
                backImageView.sd_setImage(with: URL(string: brandData.img!))
            }
        }
        
        if brandData.logo != nil{
            if URL(string: brandData.logo!) != nil{
                logoImageView.sd_setImage(with: URL(string: brandData.logo!))
            }
        }
        
        brandNameLable.text = brandData.name
        numberLable.text = brandData.number
        addressLable.text = brandData.supplier
        phoneLable.text = brandData.service
        let attrStr = try! NSAttributedString(
            data: brandData.intro!.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        introLable.attributedText = attrStr
        let attrStr2 = try! NSAttributedString(
            data: brandData.content!.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        desIntroLable.attributedText = attrStr2
        
//        6/26 Change to web view
        desWebView.loadHTMLString(brandData.intro!, baseURL: nil)
        detailDesWebView.loadHTMLString(brandData.content!, baseURL: nil)
        
        loadingView.isHidden = true
    }
    
    //        6/26 Change to web view
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        
        if webView == desWebView{
            desWebViewHeightt.constant = webView.frame.height
             webView.bounds = CGRect(x: 0, y: 0, width: webView.frame.width, height: desWebViewHeightt.constant)
        }else{
            detailDesWebviewHeight.constant = webView.frame.height
             webView.bounds = CGRect(x: 0, y: 0, width: webView.frame.width, height: detailDesWebviewHeight.constant)
        }
        
    }
    
    //    取得品牌擁有的產品與相似產品（資訊所需較少）
    func getProductList(id:String){
        self.brandOwnedProduct = [Product]()
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        for id in (id.components(separatedBy: ",")){
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
                    
                    self.brandOwnedProduct.append(product)
                    self.productCollectionView.reloadData()
                    
                }
            })
        }
        
    }
}

extension BrandDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getProductDetailGo(id: brandOwnedProduct[indexPath.item].id!)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (productCollectionView.bounds.width/2) - 15, height: productCollectionView.bounds.width/2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandOwnedProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        
        cell.productNameLable.text = brandOwnedProduct[indexPath.item].title
        cell.productImageView.sd_setImage(with: URL(string: brandOwnedProduct[indexPath.item].img!))
        
        return cell
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
