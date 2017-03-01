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
    
    var article = Article()
    var productList = [Product]()
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var classBackView: UIView!
    @IBOutlet weak var classTittle: UILabel!
    @IBOutlet weak var modifyDate: UILabel!
    @IBOutlet weak var titteLable: UILabel!
    @IBOutlet weak var keywordView: UIView!
    @IBOutlet weak var contentLable: UILabel!
    
    @IBOutlet weak var otherArticleView: UIView!
    @IBOutlet weak var otherProductView: UIView!
    
    @IBOutlet weak var readingCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
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
                getProductDetail(productId: article.producrt!)
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            return productList.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    
    
    
}
