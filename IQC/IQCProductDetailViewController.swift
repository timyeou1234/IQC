//
//  IQCProductDetailViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

protocol CellHeightChangeDelegate {
    func cellHeightChange(tableView:UITableView ,whichCell:IndexPath, height:CGFloat, howMuch: CGFloat)
}

class IQCProductDetailViewController: UIViewController {
    
    var brandData = Brand()
    var brandConstraint = NSLayoutConstraint()
    var productConstraint = NSLayoutConstraint()
    var contraint:NSLayoutConstraint?
    var tableViewHeightList:[CGFloat] = [0,0,0]
    var product = Product()
    var productId = ""
    var isLatest = true
    var cellHeight = [IndexPath:CGFloat]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productSliderCollectionView: UICollectionView!
    @IBOutlet weak var tittleBackView: UIView!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var modifyDateLable: UILabel!
    @IBOutlet weak var sliderIndexLable: UILabel!
    
    @IBOutlet weak var sliderIndexBackView: UIView!
    @IBOutlet weak var cerCollectionView: UICollectionView!
    @IBOutlet weak var buyCollectionView: UICollectionView!
    
    @IBOutlet weak var tittleButtonContentView: UIView!
    
    @IBOutlet weak var subTittleButtonContentView: UIView!
    @IBOutlet weak var secondSubTittleButtonContentView: UIView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var halfProductTableView: UITableView!
    @IBOutlet weak var ingrediantTableView: UITableView!
    
    @IBOutlet weak var productTableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var halfProductTableViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ingrediantTableViewHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var productIngrediantHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ingrediantToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var productIngrediantContainView: UIView!
    @IBOutlet weak var productIngrediantTableView: UITableView!
    @IBOutlet weak var productIngrediantBottomConstraint: NSLayoutConstraint!
    
//    看產品->品牌介紹
    @IBOutlet weak var brandContainView: UIView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandIdLable: UILabel!
    
    @IBOutlet weak var brandOwnedProductCollectionView: UICollectionView!
    
    @IBOutlet weak var simularProductCollectionView: UICollectionView!
    @IBAction func webAction(_ sender: Any) {
    }
    
    @IBAction func productViewAllAction(_ sender: Any) {
    }
    @IBOutlet weak var brandContainViewBottomConstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var forDashLineView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBAction func reportAction(_ sender: Any) {
        reportButton.isSelected = true
        productButton.isSelected = false
        
        brandContainView.isHidden = true
        productIngrediantContainView.isHidden = true
        
        brandContainViewBottomConstraint.isActive = false
        productIngrediantBottomConstraint.isActive = false
        
        view.removeConstraint(productConstraint)
        
        firstButton.setTitle("近期報告", for: .normal)
        firstButton.setTitle("近期報告", for: .selected)
        secondButton.setTitle("歷年報告", for: .normal)
        secondButton.setTitle("歷年報告", for: .selected)
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: 0, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
        firstSubAction(self)
    }
    
    @IBOutlet weak var productButton: UIButton!
    @IBAction func productAction(_ sender: Any) {
        reportButton.isSelected = false
        productButton.isSelected = true
        
        brandContainView.isHidden = true
        productIngrediantContainView.isHidden = false
        
        productIngrediantBottomConstraint = contraint
        
        firstButton.setTitle("成分標示", for: .normal)
        firstButton.setTitle("成分標示", for: .selected)
        secondButton.setTitle("品牌介紹", for: .normal)
        secondButton.setTitle("品牌介紹", for: .selected)
        
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: self.view.frame.midX, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
        firstSubAction(self)
    }
    
    @IBOutlet weak var firstButton: UIButton!
    @IBAction func firstSubAction(_ sender: Any) {
        
        firstButton.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1).cgColor
        secondButton.layer.borderColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).cgColor
        firstButton.isSelected = true
        secondButton.isSelected = false
        
        if firstButton.title(for: .normal) == "成分標示"{
            productConstraint = NSLayoutConstraint(item: productIngrediantContainView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
            brandContainView.isHidden = true
            productIngrediantContainView.isHidden = false
            view.removeConstraint(brandConstraint)
            view.addConstraint(productConstraint)
            return
        }
        
        if reportButton.isSelected{
            isLatest = true
        }else{
            isLatest = false
        }
        tableViewHeightList = [0,0,0]
        productTableView.reloadData()
        halfProductTableView.reloadData()
        ingrediantTableView.reloadData()
        productTableViewHeightConstant.constant = 0
        halfProductTableViewHightConstraint.constant = 0
        ingrediantTableViewHightConstraint.constant = 0
    }
    
    @IBOutlet weak var secondButton: UIButton!
    @IBAction func secondSubAction(_ sender: Any) {
        secondButton.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1).cgColor
        firstButton.layer.borderColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).cgColor
        firstButton.isSelected = false
        secondButton.isSelected = true
        if secondButton.title(for: .normal) == "品牌介紹"{
            brandContainView.isHidden = false
            productIngrediantContainView.isHidden = true
            brandConstraint = NSLayoutConstraint(item: brandContainView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
            view.addConstraint(brandConstraint)
            view.removeConstraint(productConstraint)
            return
        }
        
        if reportButton.isSelected{
            isLatest = false
        }else{
            isLatest = true
        }
        tableViewHeightList = [0,0,0]
        productTableView.reloadData()
        halfProductTableView.reloadData()
        ingrediantTableView.reloadData()
        productTableViewHeightConstant.constant = 0
        halfProductTableViewHightConstraint.constant = 0
        ingrediantTableViewHightConstraint.constant = 0
    }
    
    @IBAction func productOpenAction(_ sender: Any) {
        if productTableViewHeightConstant.constant == 0{
            productTableViewHeightConstant.constant = tableViewHeightList[0]
        }else{
            productTableViewHeightConstant.constant = 0
        }
    }
    @IBAction func halfProductOpenAction(_ sender: Any) {
        if halfProductTableViewHightConstraint.constant == 0{
            halfProductTableViewHightConstraint.constant = tableViewHeightList[1]
        }else{
            halfProductTableViewHightConstraint.constant = 0
        }
    }
    @IBAction func ingrediantOpenAction(_ sender: Any) {
        if ingrediantTableViewHightConstraint.constant == 0{
            ingrediantTableViewHightConstraint.constant = tableViewHeightList[2]
        }else{
            ingrediantTableViewHightConstraint.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tittleBackView.addShadow()
        
        firstButton.layer.borderWidth = 1
        firstButton.layer.masksToBounds = true
        secondButton.layer.borderWidth = 1
        secondButton.layer.masksToBounds = true
        
        sliderIndexBackView.clipBackground(color: UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1))
        
        reportButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        productButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        reportButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        productButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        firstButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        secondButton.setTitleColor((UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)), for: .selected)
        firstButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        secondButton.setTitleColor(UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        productSliderCollectionView.dataSource = self
        productSliderCollectionView.delegate = self
        cerCollectionView.dataSource = self
        cerCollectionView.delegate = self
        buyCollectionView.dataSource = self
        buyCollectionView.delegate = self
        
        productIngrediantTableView.dataSource = self
        productIngrediantTableView.delegate = self
        
        brandOwnedProductCollectionView.dataSource = self
        simularProductCollectionView.dataSource = self
        brandOwnedProductCollectionView.delegate = self
        simularProductCollectionView.delegate = self
        
        productIngrediantTableView.register(UINib(nibName: "IngrediantTableViewCell", bundle:nil), forCellReuseIdentifier: "Cell1")
        
        productSliderCollectionView.register(UINib(nibName: "ProductSliderCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell1")
        cerCollectionView.register(UINib(nibName: "CerImgCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell2")
        buyCollectionView.register(UINib(nibName: "MallCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell3")
        
        productTableView.delegate = self
        productTableView.dataSource = self
        halfProductTableView.dataSource = self
        halfProductTableView.delegate = self
        ingrediantTableView.dataSource = self
        ingrediantTableView.delegate = self
        
        productTableView.rowHeight = UITableViewAutomaticDimension
        halfProductTableView.rowHeight = UITableViewAutomaticDimension
        ingrediantTableView.rowHeight = UITableViewAutomaticDimension
        
        productIngrediantTableView.rowHeight = UITableViewAutomaticDimension
        productIngrediantTableView.estimatedRowHeight = 50
        
        productTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
        productTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        productTableView.register(UINib(nibName: "ProductDetailItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        
        halfProductTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell21")
        halfProductTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell22")
        halfProductTableView.register(UINib(nibName: "ProductDetailItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        
        ingrediantTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell31")
        ingrediantTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell32")
        ingrediantTableView.register(UINib(nibName: "ProductDetailItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        
        
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

extension IQCProductDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = productSliderCollectionView.visibleCells[0]
        let index = productSliderCollectionView.indexPath(for: cell)?.item
        sliderIndexLable.text = "\(index! + 1)/\(collectionView(productSliderCollectionView, numberOfItemsInSection: 0))"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productSliderCollectionView{
            return CGSize(width: self.view.bounds.width, height: collectionView.bounds.height)
        }else if collectionView == cerCollectionView{
            return CGSize(width: 40, height: 40)
        }else if collectionView == buyCollectionView{
            return CGSize(width: 100, height: 40)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productSliderCollectionView{
            return 0
        }
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if product.title == nil{
            return 0
        }
        if collectionView == productSliderCollectionView{
            if product.slider == nil{
                sliderIndexLable.text = "1/1"
                return 1
            }else{
                sliderIndexLable.text = "1/\((product.slider?.count)!)"
                return (product.slider?.count)!
            }
        }else if collectionView == cerCollectionView{
            if product.cer == nil{
                return 0
            }else{
                return (product.cer?.count)!
            }
        }else if collectionView == buyCollectionView{
            if product.mall == nil{
                return 0
            }else{
                return (product.mall?.count)!
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productSliderCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! ProductSliderCollectionViewCell
            
            if product.slider == nil{
                cell.sliderImage.sd_setImage(with: URL(string: product.img!))
            }else{
                cell.sliderImage.sd_setImage(with: URL(string: (product.slider?[indexPath.item])!))
            }
            return cell
        }
        
        if collectionView == cerCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CerImgCollectionViewCell
            
            cell.cerImageView.sd_setImage(with: URL(string: (product.cer?[indexPath.item])!))
            return cell
        }
        
        if collectionView == buyCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! MallCollectionViewCell
            
            cell.mallImagView.sd_setImage(with: URL(string: (product.mall?[indexPath.item].img)!))
            cell.mallUrl = (product.mall?[indexPath.item].url!)!
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productIngrediantTableView{
            return 7
        }
        if isLatest{
            if product.latestreport == nil{
                return 0
            }
        }else{
            if product.historyreport == nil{
                return 0
            }
        }
        
        if tableView == productTableView{
            var count = 0
            if isLatest{
                for report in product.latestreport!{
                    if report.type! == "成品檢驗合格區"{
                        count += 2
                        if report.item != nil{
                            count += (report.item?.count)!
                        }
                    }
                }
                if tableViewHeightList[0] == 0{
                    tableViewHeightList[0] = CGFloat(40 * count)
                }
                return count
            }else{
                if product.historyreport == nil{
                    return 0
                }
                for report in product.historyreport!{
                    if report.type! == "成品檢驗合格區"{
                        count += 2
                        if report.item != nil{
                            count += (report.item?.count)!
                        }
                    }
                }
                if tableViewHeightList[0] == 0{
                    tableViewHeightList[0] = CGFloat(40 * count)
                }
                return count
            }
        }
        if tableView == halfProductTableView{
            var count = 0
            if isLatest{
                for report in product.latestreport!{
                    if report.type! == "半成品檢驗合格區"{
                        count += 2
                        if report.item != nil{
                            count += (report.item?.count)!
                        }
                    }
                }
                if tableViewHeightList[1] == 0{
                    tableViewHeightList[1] = CGFloat(40 * count)
                }
                return count
            }else{
                if product.historyreport == nil{
                    return 0
                }
                for report in product.historyreport!{
                    if report.type! == "半成品檢驗合格區"{
                        count += 2
                        if report.item != nil{
                            count += (report.item?.count)!
                        }
                    }
                }
                if tableViewHeightList[1] == 0{
                    tableViewHeightList[1] = CGFloat(40 * count)
                }
                return count
            }
        }
        if tableView == ingrediantTableView{
            var count = 0
            if isLatest{
                for report in product.latestreport!{
                    if report.type! == "原料檢驗合格區"{
                        count += 2
                        if report.item != nil{
                            count += (report.item?.count)!
                        }
                    }
                }
                if tableViewHeightList[2] == 0{
                    tableViewHeightList[2] = CGFloat(40 * count)
                }
                return count
            }else{
                if product.historyreport == nil{
                    return 0
                }
                for report in product.historyreport!{
                    if report.type! == "原料檢驗合格區"{
                        count += 2
                        if report.item != nil{
                            count += (report.item?.count)!
                        }
                    }
                }
                if tableViewHeightList[2] == 0{
                    tableViewHeightList[2] = CGFloat(40 * count)
                }
                return count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == productIngrediantTableView{
            return UITableViewAutomaticDimension
        }
        if cellHeight[indexPath] != nil{
            let cellHeightF = cellHeight[indexPath]
            return cellHeightF!
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        產品標示
        if tableView == productIngrediantTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! IngrediantTableViewCell
            switch indexPath.row {
            case 0:
                cell.tittleItemLable.text = "成份"
                cell.detailContextLable.text = product.ingredient
            case 1:
                cell.tittleItemLable.text = "產地"
                cell.detailContextLable.text = product.origin
            case 2:
                cell.tittleItemLable.text = "容量"
                cell.detailContextLable.text = product.capacity
            case 3:
                cell.tittleItemLable.text = "過敏原標示"
                var text = ""
                if product.allergy != nil{
                    for allergy in product.allergy!{
                        if text == ""{
                            text += "\(allergy)"
                        }else{
                            text += ",\(allergy)"
                        }
                    }
                }
                cell.detailContextLable.text = text
            case 4:
                cell.tittleItemLable.text = "素食標示"
                var text = ""
                if product.allergy != nil{
                    for veg in product.veg!{
                        if text == ""{
                            text += "\(veg)"
                        }else{
                            text += ",\(veg)"
                        }
                    }
                }
                cell.detailContextLable.text = text
            case 5:
                cell.tittleItemLable.text = "投保產品責任險字號"
                cell.detailContextLable.text = product.number
            case 6:
                cell.tittleItemLable.text = "警語"
                cell.detailContextLable.text = product.warn
            default:
                break
            }
            if product.title != nil{
                cell.indexPath = indexPath
                cell.tableView = productIngrediantTableView
                cell.cellHeightChange = self
                cell.drawDash()
            }
            return cell
        }
        if isLatest{
            var countForReport = [Int]()
            if tableView == productTableView{
                for report in product.latestreport!{
                    if report.type == "成品檢驗合格區"{
                        var count = 2
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                            
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            if tableView == halfProductTableView{
                for report in product.latestreport!{
                    if report.type == "半成品檢驗合格區"{
                        var count = 2
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                            
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            if tableView == ingrediantTableView{
                for report in product.latestreport!{
                    if report.type == "原料檢驗合格區"{
                        var count = 2
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                            
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            var total = 0
            var section = 0
            for count in countForReport{
                total += count
                if indexPath.row + 1 <= total {
                    break
                }else{
                    section += 1
                }
            }
            var index = indexPath.row
            if section > 0{
                for sectionCount in 0...section - 1{
                    index = indexPath.row - countForReport[sectionCount]
                }
            }
            
            if tableView == productTableView{
                var currentReport = [Report]()
                for report in product.latestreport!{
                    if report.type == "成品檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                if index == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ProductTittleTableViewCell
                    cell.drawDash()
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 215/255)
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ProductTittleTableViewCell
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    
                    cell.cellHeightChange = self
                    cell.indexPath = indexPath
                    cell.tableView = tableView
                    cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                    cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                    
                    cell.ProductDetailTestTableView.reloadData()
                    return cell
                }
            }
            
            if tableView == halfProductTableView{
                var currentReport = [Report]()
                for report in product.latestreport!{
                    if report.type == "半成品檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                if index == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell21", for: indexPath) as! ProductTittleTableViewCell
                    cell.drawDash()
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 215/255)
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell21", for: indexPath) as! ProductTittleTableViewCell
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    
                    cell.cellHeightChange = self
                    cell.indexPath = indexPath
                    cell.tableView = tableView
                    cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                    cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                    
                    cell.ProductDetailTestTableView.reloadData()
                    return cell
                }
            }
            
            if tableView == ingrediantTableView{
                var currentReport = [Report]()
                for report in product.latestreport!{
                    if report.type == "原料檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                if index == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell31", for: indexPath) as! ProductTittleTableViewCell
                    cell.drawDash()
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 215/255)
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell31", for: indexPath) as! ProductTittleTableViewCell
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    
                    cell.cellHeightChange = self
                    cell.indexPath = indexPath
                    cell.tableView = tableView
                    cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                    cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                    
                    cell.ProductDetailTestTableView.reloadData()
                    return cell
                }
            }
            
        }else{
            //歷年報告開始
            
            var countForReport = [Int]()
            if tableView == productTableView{
                for report in product.historyreport!{
                    if report.type == "成品檢驗合格區"{
                        var count = 2
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                            
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            if tableView == halfProductTableView{
                for report in product.historyreport!{
                    if report.type == "半成品檢驗合格區"{
                        var count = 2
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                            
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            if tableView == ingrediantTableView{
                for report in product.historyreport!{
                    if report.type == "原料檢驗合格區"{
                        var count = 2
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                            
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            var total = 0
            var section = 0
            for count in countForReport{
                total += count
                if indexPath.row + 1 <= total {
                    break
                }else{
                    section += 1
                }
            }
            var index = indexPath.row
            if section > 0{
                for sectionCount in 0...section - 1{
                    index = indexPath.row - countForReport[sectionCount]
                }
            }
            
            if tableView == productTableView{
                var currentReport = [Report]()
                for report in product.historyreport!{
                    if report.type == "成品檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                if index == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ProductTittleTableViewCell
                    cell.drawDash()
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 215/255)
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ProductTittleTableViewCell
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    
                    cell.cellHeightChange = self
                    cell.indexPath = indexPath
                    cell.tableView = tableView
                    cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                    cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                    
                    cell.ProductDetailTestTableView.reloadData()
                    return cell
                }
            }
            
            if tableView == halfProductTableView{
                var currentReport = [Report]()
                for report in product.historyreport!{
                    if report.type == "半成品檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                if index == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell21", for: indexPath) as! ProductTittleTableViewCell
                    cell.drawDash()
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 215/255)
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell21", for: indexPath) as! ProductTittleTableViewCell
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    
                    cell.cellHeightChange = self
                    cell.indexPath = indexPath
                    cell.tableView = tableView
                    cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                    cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                    
                    cell.ProductDetailTestTableView.reloadData()
                    return cell
                }
            }
            
            if tableView == ingrediantTableView{
                var currentReport = [Report]()
                for report in product.historyreport!{
                    if report.type == "原料檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                if index == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell31", for: indexPath) as! ProductTittleTableViewCell
                    cell.drawDash()
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 215/255)
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell31", for: indexPath) as! ProductTittleTableViewCell
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    
                    cell.cellHeightChange = self
                    cell.indexPath = indexPath
                    cell.tableView = tableView
                    cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                    cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                    
                    cell.ProductDetailTestTableView.reloadData()
                    return cell
                }
            }

        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        return cell
    }
    
}

extension IQCProductDetailViewController:CellHeightChangeDelegate{
    
    func cellHeightChange(tableView:UITableView ,whichCell:IndexPath, height:CGFloat, howMuch: CGFloat) {
        if tableView != productIngrediantTableView{
            cellHeight = [whichCell:height]
        }
        switch tableView {
        case productTableView:
            productTableViewHeightConstant.constant += howMuch
            tableViewHeightList[0] = productTableViewHeightConstant.constant
        case halfProductTableView:
            halfProductTableViewHightConstraint.constant += howMuch
            tableViewHeightList[1] = halfProductTableViewHightConstraint.constant
        case productIngrediantTableView:
            productIngrediantHeightConstraint.constant += howMuch
            forDashLineView.addDashedLine(startPoint: CGPoint(x: self.view.bounds.width/2, y: 0), endPoint: CGPoint(x: self.view.bounds.width/2, y: productIngrediantTableView.bounds.height))
        default:
            ingrediantTableViewHightConstraint.constant += howMuch
            tableViewHeightList[2] = ingrediantTableViewHightConstraint.constant
        }
        
        tableView.reloadRows(at: [whichCell], with: .none)
    }
    
    func getProductDetail(){
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/product/detail/\(productId)", headers: headers).responseJSON(completionHandler: {
            response in
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                print(json)
                
                let jsonData = json["list"][0]
                
                if let _ = jsonData["latestreport"].array{
                    var reportList = [Report]()
                    for jsonLatest in jsonData["latestreport"]{
                        let latestReport = Report()
                        if let title = jsonLatest.1["title"].string{
                            latestReport.tittle = title
                        }
                        if let type = jsonLatest.1["type"].string{
                            latestReport.type = type
                        }
                        if jsonLatest.1["item"] != nil{
                            var reportClassList = [ReportClass]()
                            for jsonReportClass in jsonLatest.1["item"]{
                                
                                var repoerDetailList = [ReportDetail]()
                                let reportClass = ReportClass()
                                if let itemid = jsonReportClass.1["itemid"].string{
                                    reportClass.itemid = itemid
                                }else{
                                    reportClass.itemid = ""
                                }
                                for jsonReportDetail in jsonReportClass.1["reportid"]{
                                    
                                    let reportDetail = ReportDetail()
                                    if let reportdate = jsonReportDetail.1["reportdate"].string{
                                        reportDetail.reportdate = reportdate
                                    }
                                    if let id = jsonReportDetail.1["id"].string{
                                        reportDetail.id = id
                                    }
                                    if let title = jsonReportDetail.1["title"].string{
                                        reportDetail.title = title
                                    }
                                    if let source = jsonReportDetail.1["source"].string{
                                        reportDetail.source = source
                                    }
                                    if let file = jsonReportDetail.1["file"].string{
                                        reportDetail.file = file
                                    }
                                    repoerDetailList.append(reportDetail)
                                }
                                reportClass.reportid = repoerDetailList
                                reportClassList.append(reportClass)
                            }
                            
                            latestReport.item = reportClassList
                        }
                        reportList.append(latestReport)
                    }
                    self.product.latestreport = reportList
                }
                
                if let _ = jsonData["historyreport"].array{
                    var reportList = [Report]()
                    for jsonLatest in jsonData["historyreport"]{
                        let latestReport = Report()
                        if let title = jsonLatest.1["title"].string{
                            latestReport.tittle = title
                        }
                        if let type = jsonLatest.1["type"].string{
                            latestReport.type = type
                        }
                        if jsonLatest.1["item"] != nil{
                            var reportClassList = [ReportClass]()
                            for jsonReportClass in jsonLatest.1["item"]{
                                
                                var repoerDetailList = [ReportDetail]()
                                let reportClass = ReportClass()
                                if let itemid = jsonReportClass.1["itemid"].string{
                                    reportClass.itemid = itemid
                                }
                                for jsonReportDetail in jsonReportClass.1["reportid"]{
                                    
                                    let reportDetail = ReportDetail()
                                    if let reportdate = jsonReportDetail.1["reportdate"].string{
                                        reportDetail.reportdate = reportdate
                                    }
                                    if let id = jsonReportDetail.1["id"].string{
                                        reportDetail.id = id
                                    }
                                    if let title = jsonReportDetail.1["title"].string{
                                        reportDetail.title = title
                                    }
                                    if let source = jsonReportDetail.1["source"].string{
                                        reportDetail.source = source
                                    }
                                    repoerDetailList.append(reportDetail)
                                }
                                reportClass.reportid = repoerDetailList
                                reportClassList.append(reportClass)
                            }
                            latestReport.item = reportClassList
                        }
                        reportList.append(latestReport)
                    }
                    self.product.historyreport = reportList
                }
                
                if let id = jsonData["id"].string{
                    self.product.id = id
                }
                
                if let title = jsonData["title"].string{
                    self.product.title = title
                }
                
                if let warn = jsonData["warn"].string{
                    self.product.warn = warn
                }
                
                if let img = jsonData["img"].string{
                    self.product.img = img
                }
                
                if let ingredient = jsonData["ingredient"].string{
                    self.product.ingredient = ingredient
                }
                
                if let number = jsonData["number"].string{
                    self.product.number = number
                }
                
                if let capacity = jsonData["capacity"].string{
                    self.product.capacity = capacity
                }
                
                if let similar = jsonData["similar"].string{
                    self.product.similar = similar
                }
                
                if let origin = jsonData["origin"].string{
                    self.product.origin = origin
                }
                
                if let modify = jsonData["modify"].string{
                    self.product.modify = modify
                }
                
                if let brandid = jsonData["brandid"].string{
                    self.getBrand(id: brandid)
                }
                
                for jsonCer in jsonData["cer"]{
                    if self.product.cer == nil{
                        self.product.cer = [jsonCer.1["img"].stringValue]
                    }else{
                        self.product.cer?.append(jsonCer.1["img"].stringValue)
                    }
                }
                
                for jsonVeg in jsonData["veg"]{
                    if self.product.veg == nil{
                        self.product.veg = [jsonVeg.1["title"].stringValue]
                    }else{
                        self.product.veg?.append(jsonVeg.1["title"].stringValue)
                    }
                }
                
                for jsonAllergy in jsonData["allergy"]{
                    if self.product.allergy == nil{
                        self.product.allergy = [jsonAllergy.1["title"].stringValue]
                    }else{
                        self.product.allergy?.append(jsonAllergy.1["title"].stringValue)
                    }
                }
                
                for jsonMall in jsonData["mall"]{
                    let mall = Mall()
                    if let url = jsonMall.1["url"].string{
                        mall.url = url
                    }
                    if let img = jsonMall.1["img"].string{
                        mall.img = img
                    }
                    if self.product.mall == nil{
                        self.product.mall = [mall]
                    }
                    self.product.mall?.append(mall)
                }
                
                for jsonSlider in jsonData["slider"]{
                    if let main = jsonSlider.1["main"].string{
                        if main == "0"{
                            if self.product.slider == nil{
                                self.product.slider = [jsonSlider.1["img"].stringValue]
                            }
                            self.product.slider?.append(jsonSlider.1["img"].stringValue)
                        }else{
                            if self.product.slider == nil{
                                self.product.slider = [jsonSlider.1["img"].stringValue]
                            }
                            self.product.slider?.insert(jsonSlider.1["img"].stringValue, at: 0)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.refreshView()
                }
            }
            
        })
        
    }
    
    func getBrand(id:String){
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        Alamofire.request("https://iqctest.com/api/brand/list/\(id)", headers: headers).responseJSON(completionHandler: {
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
            }
        })
    }
    
    func refreshView(){
        
        tittleLable.text = product.title
        let yearMonthComponet = product.modify?.components(separatedBy: "-")
        let dateComponent = yearMonthComponet?[2].components(separatedBy: " ")
        modifyDateLable.text = "\((yearMonthComponet?[0])!)年\((yearMonthComponet?[1])!)月\((dateComponent?[0])!)日 最後修改時間"
        productSliderCollectionView.reloadData()
        if product.cer != nil{
            cerCollectionView.reloadData()
        }
        if product.mall != nil{
            buyCollectionView.reloadData()
        }
        if product.latestreport != nil{
            productTableView.reloadData()
            halfProductTableView.reloadData()
            ingrediantTableView.reloadData()
        }
        productIngrediantTableView.reloadData()
        self.reportAction(self)
        self.firstSubAction(self)
    }
    
}
