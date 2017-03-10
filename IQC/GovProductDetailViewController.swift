//
//  GovProductDetailViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/2.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class GovProductDetailViewController: UIViewController {
    
    var product = GovProduct()
    var productId = ""
    
    @IBOutlet weak var sliderContainView: UIView!
    @IBOutlet weak var govLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productSliderCollectionView: UICollectionView!
    @IBOutlet weak var sliderIndexLable: UILabel!
    @IBOutlet weak var sliderIndexBackView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var dashLineView: UIView!
    
    
    @IBOutlet weak var productIngrediantHeightConstraint: NSLayoutConstraint!
    
    @IBAction func webAction(_ sender: Any) {
        if product.website == nil{
            return
        }
        if URL(string: product.website!) != nil{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: product.website!)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: product.website!)!)
                // Fallback on earlier versions
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
        sliderContainView.addShadow()
        
        productSliderCollectionView.dataSource = self
        productSliderCollectionView.delegate = self
        
        productSliderCollectionView.register(UINib(nibName: "ProductSliderCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 40
        
        detailTableView.register(UINib(nibName: "GovDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProductDetail()
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

extension GovProductDetailViewController:UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = productSliderCollectionView.visibleCells[0]
        let index = productSliderCollectionView.indexPath(for: cell)?.item
        sliderIndexLable.text = "\(index! + 1)/\(collectionView(productSliderCollectionView, numberOfItemsInSection: 0))"
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //MARK: Collection View Item Count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if product.slider == nil{
            sliderIndexLable.text = "1/1"
            return 1
        }else{
            sliderIndexLable.text = "1/\((product.slider?.count)!)"
            return (product.slider?.count)!
        }
    }
    
    //MARK: Cell For Row CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductSliderCollectionViewCell
        if product.title == nil{
            return cell
        }
        if product.slider == nil{
            cell.sliderImage.sd_setImage(with: URL(string: product.img!))
        }else{
            cell.sliderImage.sd_setImage(with: URL(string: (product.slider?[indexPath.item])!))
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GovDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.tittleLable.text = "抽驗廠商"
            cell.tittleNameLable.text = product.factory
        case 1:
            cell.tittleLable.text = "抽檢地點"
            cell.tittleNameLable.text = product.address
        case 2:
            cell.tittleLable.text = "供應廠商"
            cell.tittleNameLable.text = product.supplier
        case 3:
            cell.tittleLable.text = "供應廠商地址"
            cell.tittleNameLable.text = product.supplieraddr
        default:
            break
        }
        if product.title != nil{
            cell.indexPath = indexPath
            cell.tableView = detailTableView
            cell.cellHeightChange = self
            cell.drawDash()
        }
        return cell
    }
    
    
}

extension GovProductDetailViewController:CellHeightChangeDelegate{
    
    func cellHeightChange(tableView:UITableView ,whichCell:IndexPath, height:CGFloat, howMuch: CGFloat) {
        
        productIngrediantHeightConstraint.constant += howMuch
        dashLineView.addDashedLine(startPoint: CGPoint(x: self.view.bounds.width/3, y: 0), endPoint: CGPoint(x: self.view.bounds.width/3, y: detailTableView.bounds.height))
        
    }
    
    func getProductDetail(){
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/product/detail/\(productId)", headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                
                let product = GovProduct()
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
                
                if let supplieraddr = jsonData["supplieraddr"].string{
                    product.supplieraddr = supplieraddr
                }
                
                if let factory = jsonData["factory"].string{
                    product.factory = factory
                }
                
                if let address = jsonData["address"].string{
                    product.address = address
                }
                
                if let similar = jsonData["similar"].string{
                    product.similar = similar
                }
                
                if let modify = jsonData["modify"].string{
                    product.modify = modify
                }
                
                if let website = jsonData["website"].string{
                    product.website = website
                }
                
                if let gov = jsonData["gov"].string{
                    product.gov = gov
                }
                
                if let supplier = jsonData["supplier"].string{
                    product.supplier = supplier
                }
                
                for img in jsonData["slider"]{
                    if product.slider == nil{
                        if let imgData = img.1["img"].string{
                            product.slider = [imgData]
                        }
                    }else{
                        if let imgData = img.1["img"].string{
                            product.slider?.append(imgData)
                        }
                    }
                }
                self.product = product
                self.refreshView()
            }
        })
        
    }
    
    
    func refreshView(){
        tittleLable.text = product.title
        let yearMonthComponet = product.modify?.components(separatedBy: "-")
        let dateComponent = yearMonthComponet?[2].components(separatedBy: " ")
        dateLable.text = "\((yearMonthComponet?[0])!)年\((yearMonthComponet?[1])!)月\((dateComponent?[0])!)日 最後修改時間"
        govLable.text = "稽查單位 - \(product.gov!)"
        
        detailTableView.reloadData()
        productSliderCollectionView.reloadData()
        detailTableView.reloadData()
        
        
        
        
        
        
    }
    
}
