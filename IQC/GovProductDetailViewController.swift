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
import FBSDKShareKit

class GovProductDetailViewController: UIViewController, UIWebViewDelegate {
    
    var observing = false
    var product = GovProduct()
    var productId = ""
    var productList = [Product]()
    var productCellHeight = [IndexPath:CGFloat]()
    var openCell = [IndexPath:Bool]()
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var productTableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var relateProductCollectionView: UICollectionView!
    @IBOutlet weak var webviewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var facebookCommentWebView: UIWebView!
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
    
    @IBAction func shareAction(_ sender: Any) {
        let myWebsite = NSURL(string: "https://iqctest.com/product/\(productId)")
        
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
    
    @IBAction func productAction(_ sender: Any) {
        if productTableViewHeightConstant.constant == 0{
            productTableView.layoutIfNeeded()
            productTableViewHeightConstant.constant = productTableView.contentSize.height
        }else{
            productTableViewHeightConstant.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookCommentWebView.delegate = self
        self.navigationItem.backBarButtonItem?.title = ""
        sliderContainView.addShadow()
        
        productSliderCollectionView.dataSource = self
        productSliderCollectionView.delegate = self
        
        relateProductCollectionView.dataSource = self
        relateProductCollectionView.delegate = self
        
        productSliderCollectionView.register(UINib(nibName: "ProductSliderCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        relateProductCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 50
        
        detailTableView.register(UINib(nibName: "GovDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        productTableView.delegate = self
        productTableView.dataSource = self
        
        productTableView.rowHeight = UITableViewAutomaticDimension
        productTableView.estimatedRowHeight = 40
        
        productTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        productTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
        productTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        productTableView.register(UINib(nibName: "IQCProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        productTableView.register(UINib(nibName: "ProductSubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell4")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProductDetail()
        sliderIndexBackView.clipBackground(cornerRadious: sliderIndexBackView.bounds.height/2, color: UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1))
        let facebookUrl = "<!DOCTYPE html><html> <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head><body> <div id=\"fb-root\"></div><script>(function(d, s, id){var js, fjs=d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js=d.createElement(s); js.id=id; js.src=\"//connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v2.8&appId=700015816832989\"; fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script> <div class=\"fb-comments\" data-href=\"https://iqctest.com/product/\(productId)\" data-numposts=\"5\"></div></body></html>"
        
        facebookCommentWebView.loadHTMLString(facebookUrl, baseURL: URL(string: "https://www.facebook.com/iqc.com.tw"))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        webviewHeightConstant.constant = webView.frame.size.height
        if (!observing) {
            startObservingHeight()
        }
    }
    
    func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            if facebookCommentWebView.scrollView.contentSize.height < 1000{
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: window.origin.y + window.height - keyboardSize.height)
                self.scrollView.contentOffset.y = self.scrollView.contentSize.height
            }
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if facebookCommentWebView.scrollView.contentSize.height < 1000{
                let viewHeight = self.view.frame.height
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: viewHeight + keyboardSize.height)
            }
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
    deinit{
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        facebookCommentWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        facebookCommentWebView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            webviewHeightConstant.constant = facebookCommentWebView.scrollView.contentSize.height
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
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
        if collectionView == relateProductCollectionView{
            return CGSize(width: relateProductCollectionView.bounds.height - 40, height: relateProductCollectionView.bounds.height)
        }
        return CGSize(width: self.view.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == relateProductCollectionView{
            return 4.0
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == relateProductCollectionView{
            return 4.0
        }
        
        return 10
    }
    
    //MARK: Collection View Item Count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == relateProductCollectionView{
            return productList.count
        }
        
        if product.slider == nil{
            sliderIndexLable.text = "1/1"
            return 1
        }else{
            sliderIndexLable.text = "1/\((product.slider?.count)!)"
            return (product.slider?.count)!
        }
    }
    
    //    delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == relateProductCollectionView{
            getProductDetailGo(id: productList[indexPath.item].id!)
        }
        
    }
    
    //MARK: Cell For Row CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == relateProductCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productNameLable.font = cell.productNameLable.font.withSize(15)
            cell.productNameLable.text = productList[indexPath.item].title
            cell.productImageView.sd_setImage(with: URL(string: productList[indexPath.item].img!))
            
            cell.productImageView.addShadow()
            
            return cell
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == productTableView{
            //計算每一種不同的report共有多少欄數
            var countForReport = [Int]()
            if tableView == productTableView{
                for report in product.latestreport!{
                    if report.type == "檢驗合格區"{
                        var count = 2
                        if report.reportDetail != nil{
                            count += 1
                        }
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            //計算欄數總和與所在區塊
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
            
            //            換算不同區塊的index
            var index = indexPath.row
            if section > 0{
                for sectionCount in 0...section - 1{
                    index -= countForReport[sectionCount]
                }
            }
            
            if let cellHeight = productCellHeight[indexPath]{
                return cellHeight
            }else{
                if index != 1{
                    return 40
                }
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            var count = 0
            if product.latestreport == nil{
                return 0
            }
            for report in product.latestreport!{
                if report.type! == "檢驗合格區"{
                    count += 2
                    if report.item != nil{
                        count += (report.item?.count)!
                    }
                    if report.reportDetail != nil{
                        count += 1
                    }
                }
            }
            return count
            
        }
        return 4
        
    }
    
    //MARK:TableView Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == productTableView{
            
            //計算每一種不同的report共有多少欄數
            var countForReport = [Int]()
            if tableView == productTableView{
                for report in product.latestreport!{
                    if report.type == "檢驗合格區"{
                        var count = 2
                        if report.reportDetail != nil{
                            count += 1
                        }
                        if report.item == nil{
                            
                        }else{
                            count += (report.item?.count)!
                        }
                        countForReport.append(count)
                    }
                }
            }
            
            //計算欄數總和與所在區塊
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
            
            //            換算不同區塊的index
            var index = indexPath.row
            if section > 0{
                for sectionCount in 0...section - 1{
                    index -= countForReport[sectionCount]
                }
            }
            
            //作出報告的陣列
            var currentReport = [Report]()
            for report in product.latestreport!{
                if report.type == "檢驗合格區"{
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
                if currentReport[section].reportDetail != nil{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! ProductDetailTestTableViewCell
                    let detail = currentReport[section].reportDetail
                    cell.fileId = (detail?.id)!
                    cell.fileUrl = (detail?.file)!
                    cell.productId = self.productId
                    cell.testSource.text = detail?.source
                    cell.testDateLable.text = detail?.reportdate
                    cell.testUnitLable.text = detail?.title
                    return cell
                }
            }else if index == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! ProductSubjectTableViewCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! IQCProductDetailTableViewCell
                if productCellHeight[indexPath] != nil{
                    if productCellHeight[indexPath]! != 40{
                        cell.contentLable.isHidden = false
                        cell.tittleView.backgroundColor = UIColor(colorLiteralRed: 238/255, green: 249/255, blue: 251/255, alpha: 1)
                    }else{
                        cell.contentLable.isHidden = true
                        cell.tittleView.backgroundColor = UIColor.white
                    }
                }else{
                    cell.contentLable.isHidden = true
                    cell.tittleView.backgroundColor = UIColor.white
                }
                cell.contentLable.text = (currentReport[section].item?[(index - 3)].content)
                cell.tableView = tableView
                cell.indexPath = indexPath
                cell.cellHeightChange = self
                cell.tittleLable.text = currentReport[section].item?[index - 3].itemid
                cell.content = currentReport[section].item?[index - 3].content
                
                
                
                cell.ProductDetailTestTableView.reloadData()
                return cell
            }
            
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GovDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.tittleLable.text = "抽驗廠商"
            if product.factory == ""{
                cell.tittleNameLable.text = " "
            }else{
                cell.tittleNameLable.text = product.factory
            }
        case 1:
            cell.tittleLable.text = "抽檢地點"
            if product.address == ""{
                cell.tittleNameLable.text = " "
            }else{
                cell.tittleNameLable.text = product.address
            }
        case 2:
            cell.tittleLable.text = "供應廠商"
            if product.supplier == ""{
                cell.tittleNameLable.text = " "
            }else{
                cell.tittleNameLable.text = product.supplier
            }
        case 3:
            cell.tittleLable.text = "供應廠商地址"
            if product.supplieraddr == ""{
                cell.tittleNameLable.text = " "
            }else{
                cell.tittleNameLable.text = product.supplieraddr
            }
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
        
        if tableView == productTableView{
            if howMuch > 0{
                openCell[whichCell] = true
            }else{
                openCell[whichCell] = false
            }
            productTableViewHeightConstant.constant += howMuch
            productCellHeight[whichCell] = height
        }else{
            
            productIngrediantHeightConstraint.constant = detailTableView.contentSize.height
            dashLineView.addDashedLine(startPoint: CGPoint(x: self.view.bounds.width/3, y: 0), endPoint: CGPoint(x: self.view.bounds.width/3, y: detailTableView.bounds.height))
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
                
                let product = GovProduct()
                let jsonData = json["list"][0]
                
                //MARK:新加入的報告
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
                        if let report = jsonLatest.1["report"].array{
                            let jsonReportDetail = report[0]
                            let reportDetail = ReportDetail()
                            if let id = jsonReportDetail["id"].string{
                                reportDetail.id = id
                            }
                            if let title = jsonReportDetail["title"].string{
                                reportDetail.title = title
                            }
                            if let source = jsonReportDetail["source"].string{
                                reportDetail.source = source
                            }
                            if let reportdate = jsonReportDetail["reportdate"].string{
                                reportDetail.reportdate = reportdate
                            }
                            if let file = jsonReportDetail["file"].string{
                                reportDetail.file = file
                            }
                            latestReport.reportDetail = reportDetail
                        }
                        if jsonLatest.1["item"] != nil{
                            var reportClassList = [ReportClass]()
                            for jsonReportClass in jsonLatest.1["item"]{
                                
                                let repoerDetailList = [ReportDetail]()
                                let reportClass = ReportClass()
                                if let itemid = jsonReportClass.1["itemid"].string{
                                    reportClass.itemid = itemid
                                }else{
                                    reportClass.itemid = ""
                                }
                                if let content = jsonReportClass.1["content"].string{
                                    reportClass.content = content
                                }
                                reportClass.reportid = repoerDetailList
                                reportClassList.append(reportClass)
                            }
                            latestReport.item = reportClassList
                        }
                        reportList.append(latestReport)
                    }
                    product.latestreport = reportList
                }
                
                
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
                }else{
                    product.supplieraddr = "  "
                }
                
                if let factory = jsonData["factory"].string{
                    product.factory = factory
                }else{
                    product.factory = "  "
                }
                
                if let address = jsonData["address"].string{
                    product.address = address
                }else{
                    product.factory = "  "
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
                }else{
                    product.supplier = "  "
                }
                if jsonData["slider"].array != nil{
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
                }
                self.product = product
                DispatchQueue.main.async {
                    self.refreshView()
                }
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
                    
                    self.productList.append(product)
                    self.relateProductCollectionView.reloadData()
                }
                
            })
        }
    }
    
    
    
    func refreshView(){
        tittleLable.text = product.title
        let yearMonthComponet = product.modify?.components(separatedBy: "-")
        let dateComponent = yearMonthComponet?[2].components(separatedBy: " ")
        dateLable.text = "\((yearMonthComponet?[0])!)年\((yearMonthComponet?[1])!)月\((dateComponent?[0])!)日 最後修改時間"
        govLable.text = "稽查單位 - \(product.gov!)"
        if product.similar != nil{
            getProductDetail(productId: product.similar!)
        }
        detailTableView.reloadData()
        productSliderCollectionView.reloadData()
        detailTableView.reloadData()
        detailTableView.layoutIfNeeded()
        
        detailTableView.layoutIfNeeded()
        productIngrediantHeightConstraint.constant = detailTableView.contentSize.height
        productTableView.layoutIfNeeded()
        productTableViewHeightConstant.constant = 0
        productTableView.reloadData()
        openProduct()
    }
    
    func openProduct(){
        let when = DispatchTime.now() + 1
        self.productAction(self)
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.productAction(self)
            self.productAction(self)
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
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IQCProductDetail") as! IQCProductDetailViewController
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        vc.productId = id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        })
    }
    
}
