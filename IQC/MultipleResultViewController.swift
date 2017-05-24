//
//  MultipleResultViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class MultipleResultViewController: UIViewController {
    
    var productList = [Product]()
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let destinationController = segue.destination as! IQCProductDetailViewController
            let product = sender as! Product
            destinationController.productId = product.id!
        }else if segue.identifier == "showGovDetail"{
            let destinationController = segue.destination as! GovProductDetailViewController
            let product = sender as! Product
            destinationController.productId = product.id!
        }
        
    }

}

extension MultipleResultViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (productCollectionView.bounds.width/2)-15, height: productCollectionView.bounds.width/2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getProductDetail(product: productList[indexPath.item])
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
    
}

extension MultipleResultViewController{
    
    func getProductDetail(product:Product){
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/product/detail/\(product.id!)", headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                for jsonData in json["list"]{
                    if let _ = jsonData.1["gov"].string{
                        self.performSegue(withIdentifier: "showGovDetail", sender: product)
                    }else{
                        self.performSegue(withIdentifier: "showDetail", sender: product)
                    }
                }
            }
        })
        
    }
}
