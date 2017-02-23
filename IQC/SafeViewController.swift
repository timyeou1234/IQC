//
//  SafeViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/23.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SafeViewController: UIViewController {
    
    var productTypeList = [ProductType]()
    var productList = [Product]()
    var brandList = [Brand]()
    var selectedTittle = 0
    var selectedSubTittel = -1
    
    
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var buttonBackView: UIView!
    
    @IBOutlet weak var brandBackView: UIView!
    @IBOutlet weak var tittleCollectionView: UICollectionView!
    @IBOutlet weak var subTittleCollectionView: UICollectionView!
    @IBOutlet weak var subTittleBackViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var brandCollectionView: UICollectionView!
    
    @IBAction func productAction(_ sender: Any) {
        brandBackView.isHidden = true
        productButton.isSelected = true
        brandButton.isSelected = false
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: 0, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
    }
    
    @IBAction func brandAction(_ sender: Any) {
        brandBackView.isHidden = false
        productButton.isSelected = false
        brandButton.isSelected = true
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: self.view.frame.midX, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBackView.addShadow()
        
        tittleCollectionView.delegate = self
        tittleCollectionView.dataSource = self
        
        subTittleCollectionView.delegate = self
        subTittleCollectionView.dataSource = self
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        
        productButton.setTitleColor(UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1), for: .selected)
        productButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        brandButton.setTitleColor(UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1), for: .selected)
        brandButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        tittleCollectionView.register(UINib(nibName: "SafeTittleClassCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CellFirst")
        subTittleCollectionView.register(UINib(nibName: "SafeTittleClassCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CellFirst")
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        brandCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productAction(self)
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/website/menu", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                for productType in json["list"]{
                    
                    let productData = ProductType()
                    if let title = productType.1["title"].string{
                        productData.title = title
                    }
                    if let id = productType.1["id"].string{
                        productData.id = id
                    }
                    
                    var subProductList = [ProductSubMenu]()
                    
                    for subProductType in productType.1["submenu"]{
                        
                        let subProductTypeData = ProductSubMenu()
                        if let id = subProductType.1["id"].string{
                            subProductTypeData.id = id
                        }
                        if let title = subProductType.1["title"].string{
                            subProductTypeData.title = title
                        }
                        if let modify = subProductType.1["modify"].string{
                            subProductTypeData.modify = modify
                        }
                        subProductList.append(subProductTypeData)
                    }
                    productData.submenu = subProductList
                    
                    self.productTypeList.append(productData)
                    
                }
                
            }
            if self.productTypeList.count > 0{
                self.searchProduct(self.productTypeList[0].id!, subId: "")
            }
            self.tittleCollectionView.reloadData()
            self.subTittleCollectionView.reloadData()
        })
        
        Alamofire.request("https://iqctest.com/api/brand/list/all", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                for brand in json["list"]{
                    let brandData = Brand()
                    if let id = brand.1["id"].string{
                        brandData.id = id
                    }
                    if let intro = brand.1["intro"].string{
                        brandData.intro = intro
                    }
                    if let content = brand.1["content"].string{
                        brandData.content = content
                    }
                    if let categoryid = brand.1["categoryid"].string{
                        brandData.categoryid = categoryid
                    }
                    if let des = brand.1["des"].string{
                        brandData.des = des
                    }
                    if let img = brand.1["img"].string{
                        brandData.img = img
                    }
                    if let logo = brand.1["logo"].string{
                        brandData.logo = logo
                    }
                    if let service = brand.1["service"].string{
                        brandData.service = service
                    }
                    if let number = brand.1["number"].string{
                        brandData.number = number
                    }
                    if let website = brand.1["website"].string{
                        brandData.website = website
                    }
                    if let name = brand.1["name"].string{
                        brandData.name = name
                    }
                    if let supplier = brand.1["supplier"].string{
                        brandData.supplier = supplier
                    }
                    self.brandList.append(brandData)
                }
                self.brandCollectionView.reloadData()
            }
            
            
            
        })
        
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

extension SafeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tittleCollectionView || collectionView == subTittleCollectionView{
            return CGSize(width: CGFloat(productTypeList[indexPath.item].title!.characters.count * 16 + 32), height: self.tittleCollectionView.bounds.height)
        }else if collectionView == productCollectionView || collectionView == brandCollectionView{
            return CGSize(width: (productCollectionView.bounds.width/2)-10, height: productCollectionView.bounds.width/2 + 40)
        }
        return CGSize()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    }
    
    //    delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tittleCollectionView{
            selectedTittle = indexPath.item
            selectedSubTittel = -1
            tittleCollectionView.reloadData()
            subTittleCollectionView.reloadData()
            searchProduct(productTypeList[indexPath.item].id!, subId: "")
        }else if collectionView == subTittleCollectionView{
            selectedSubTittel = indexPath.item
            subTittleCollectionView.reloadData()
            searchProduct(productTypeList[selectedTittle].id!, subId: (productTypeList[selectedTittle].submenu?[selectedSubTittel].id!)!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tittleCollectionView {
            return productTypeList.count
        }else if collectionView == subTittleCollectionView{
            if productTypeList.count == 0{
                return 0
            }
            if productTypeList[selectedTittle].submenu?.count == 0{
                self.subTittleBackViewHeightContraint.constant = 0
                return 0
            }else{
                self.subTittleBackViewHeightContraint.constant = 60
                return (productTypeList[selectedTittle].submenu?.count)!
            }
        }else if collectionView == productCollectionView{
            return productList.count
        }else if collectionView == brandCollectionView{
            return brandList.count
        }
        return 0
    }
    
    //    datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productImageView.sd_setImage(with: URL(string: brandList[indexPath.item].logo!))
            cell.productNameLable.text = brandList[indexPath.item].name
            cell.productImageView.addShadow()
            
            return cell
        }
        if collectionView == productCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productNameLable.text = productList[indexPath.item].title
            cell.productImageView.sd_setImage(with: URL(string: productList[indexPath.item].img!))
            
            cell.productImageView.addShadow()
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFirst", for: indexPath) as! SafeTittleClassCollectionViewCell
        if collectionView == tittleCollectionView{
            if selectedTittle == indexPath.item{
                
                cell.backView.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1).cgColor
                cell.tittleLable.textColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1)
                
            }else{
                
                cell.backView.layer.borderColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).cgColor
                cell.tittleLable.textColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1)
                
            }
            cell.backView.layer.borderWidth = 1
            cell.backView.layer.masksToBounds = true
            cell.tittleLable.text = productTypeList[indexPath.item].title
            
            
        }else if collectionView == subTittleCollectionView{
            cell.tittleLable.textColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1)
            cell.tittleLable.text = productTypeList[selectedTittle].submenu?[indexPath.item].title
            if selectedSubTittel == indexPath.item{
                cell.backView.backgroundColor = UIColor(colorLiteralRed: 238/255, green: 249/255, blue: 251/255, alpha: 1)
            }else{
                cell.backView.backgroundColor = UIColor.clear
            }
        }
        
        
        return cell
    }
    
    
}

extension SafeViewController{
    
    func searchProduct(_ tittleId:String, subId:String){
        
        productList = [Product]()
        
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        var subIdString = "all"
        if subId != "" {
            subIdString = String(subId)
        }
        
        Alamofire.request("https://iqctest.com/api/safety/list/\(tittleId)/\(subIdString)", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                
                if json["count"].intValue == 0{
                    self.productCollectionView.reloadData()
                    return
                }
                
                for product in json["list"]{
                    let productData = Product()
                    if let id = product.1["id"].string{
                        productData.id = id
                    }
                    if let img = product.1["img"].string{
                        productData.img = img
                    }
                    if let modify = product.1["modify"].string{
                        productData.modify = modify
                    }
                    if let title = product.1["title"].string{
                        productData.title = title
                    }
                    self.productList.append(productData)
                }
                self.productCollectionView.reloadData()
            }
        })
        
        
        
    }
    
}
