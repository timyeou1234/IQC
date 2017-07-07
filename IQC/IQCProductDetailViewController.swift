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
import FBSDKShareKit

protocol CellHeightChangeDelegate {
    func cellHeightChange(tableView:UITableView ,whichCell:IndexPath, height:CGFloat, howMuch: CGFloat)
}

class IQCProductDetailViewController: UIViewController, UIWebViewDelegate {
    
    var isDraw = false
    var loadingView = LoadingView()
    var observing = false
    var cellHeightChange:CellHeightChangeDelegate?
    var navigationBarOriginalOffset : CGFloat?
    var brandData = Brand()
    var brandOwnedProduct = [Product]()
    var simularProduct = [Product]()
    var brandConstraint = NSLayoutConstraint()
    var productConstraint = NSLayoutConstraint()
    var contraint:NSLayoutConstraint?
    var tableViewHeightList:[CGFloat] = [0,0,0]
    var product = Product()
    var productId = ""
    var isLatest = true
    var cellHeight = [IndexPath:CGFloat]()
    var productCellHeight = [IndexPath:CGFloat]()
    var halfProductCellHeight = [IndexPath:CGFloat]()
    var ingrediantCellHeight = [IndexPath:CGFloat]()
    
    @IBOutlet weak var headerTopView: UIView!
    @IBOutlet weak var stickyViewConstraint: NSLayoutConstraint!
    //    For 留在上方的參數
    
    @IBOutlet weak var productIngrediantBottomView: UIView!
    
    @IBOutlet weak var facebookCommentWebview: UIWebView!
    @IBOutlet weak var webViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var sliderContainView: UIView!
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
    //看報告最下方
    @IBOutlet weak var ingrediantToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var productIngrediantContainView: UIView!
    @IBOutlet weak var productIngrediantTableView: UITableView!
    //看產品最下方
    @IBOutlet weak var productIngrediantBottomConstraint: NSLayoutConstraint!
    
    //    看產品->品牌介紹
    @IBOutlet weak var brandContainView: UIView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandIdLable: UILabel!
    
    @IBOutlet weak var brandOwnedProductCollectionView: UICollectionView!
    
    @IBOutlet weak var simularProductCollectionView: UICollectionView!
    
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
        if URL(string:brandData.website!) != nil{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:brandData.website!)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:brandData.website!)!)
                // Fallback on earlier versions
            }
        }
    }
    
    @IBAction func productViewAllAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SafeViewController") as! SafeViewController
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        vc.gotoBrandId = brandData.id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //    看產品品牌專區最下方
    @IBOutlet weak var brandContainViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var forDashLineView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    
    @IBAction func reportAction(_ sender: Any) {
        reportButton.isSelected = true
        productButton.isSelected = false
        
        brandContainView.isHidden = true
        productIngrediantContainView.isHidden = true
        
        if brandContainViewBottomConstraint != nil{
            brandContainViewBottomConstraint.isActive = false
            productIngrediantBottomConstraint.isActive = false
        }
        view.removeConstraint(productConstraint)
        view.removeConstraint(brandConstraint)
        
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
        productTableViewHeightConstant.constant = 0
        halfProductTableViewHightConstraint.constant = 0
        ingrediantTableViewHightConstraint.constant = 0
        firstButton.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1).cgColor
        secondButton.layer.borderColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).cgColor
        firstButton.isSelected = true
        secondButton.isSelected = false
        
        if firstButton.title(for: .normal) == "成分標示"{
            productConstraint = NSLayoutConstraint(item: productIngrediantContainView, attribute: .bottom, relatedBy: .equal, toItem: facebookCommentWebview, attribute: .top, multiplier: 1, constant: 0)
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
        
        if firstButton.title(for: .normal) != "成分標示"{
            productOpenAction(self)
        }
    }
    
    @IBOutlet weak var secondButton: UIButton!
    @IBAction func secondSubAction(_ sender: Any) {
        productTableViewHeightConstant.constant = 0
        halfProductTableViewHightConstraint.constant = 0
        ingrediantTableViewHightConstraint.constant = 0
        secondButton.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 192/255, alpha: 1).cgColor
        firstButton.layer.borderColor = UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).cgColor
        firstButton.isSelected = false
        secondButton.isSelected = true
        if secondButton.title(for: .normal) == "品牌介紹"{
            brandContainView.isHidden = false
            productIngrediantContainView.isHidden = true
            brandConstraint = NSLayoutConstraint(item: brandContainView, attribute: .bottom, relatedBy: .equal, toItem: facebookCommentWebview, attribute: .top, multiplier: 1, constant: 0)
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
        
        productOpenAction(self)
    }
    
    @IBAction func productOpenAction(_ sender: Any) {
        if productTableViewHeightConstant.constant == 0{
            if isLatest{
                productTableViewHeightConstant.constant = tableViewHeightList[0]}
            else{
                productTableViewHeightConstant.constant = productTableView.contentSize.height
            }
        }else{
            productTableViewHeightConstant.constant = 0
        }
    }
    @IBAction func halfProductOpenAction(_ sender: Any) {
        if halfProductTableViewHightConstraint.constant == 0{
            if isLatest{
                halfProductTableViewHightConstraint.constant = tableViewHeightList[1]
            }else{
                halfProductTableViewHightConstraint.constant = halfProductTableView.contentSize.height
            }
        }else{
            halfProductTableViewHightConstraint.constant = 0
        }
    }
    @IBAction func ingrediantOpenAction(_ sender: Any) {
        if ingrediantTableViewHightConstraint.constant == 0{
            if isLatest{
                //                ingrediantTableViewHightConstraint.constant = tableViewHeightList[2]
                ingrediantTableViewHightConstraint.constant = ingrediantTableView.contentSize.height
            }else{
                ingrediantTableViewHightConstraint.constant = ingrediantTableView.contentSize.height
            }
        }else{
            ingrediantTableViewHightConstraint.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookCommentWebview.delegate = self
        scrollView.delegate = self
        
        tittleBackView.addShadow()
        self.navigationItem.backBarButtonItem?.title = ""
        
        firstButton.layer.borderWidth = 1
        firstButton.layer.masksToBounds = true
        secondButton.layer.borderWidth = 1
        secondButton.layer.masksToBounds = true
        
        sliderIndexBackView.clipBackground(cornerRadious: sliderIndexBackView.bounds.height/2, color: UIColor(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1))
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
        
        brandOwnedProductCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        simularProductCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
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
        
        productIngrediantTableView.rowHeight = UITableViewAutomaticDimension
        productIngrediantTableView.estimatedRowHeight = 50
        productTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        productTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
        productTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        productTableView.register(UINib(nibName: "ProductDetailItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        productTableView.register(UINib(nibName: "IQCProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell4")
        
        halfProductTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        halfProductTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell21")
        halfProductTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell22")
        halfProductTableView.register(UINib(nibName: "ProductDetailItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        halfProductTableView.register(UINib(nibName: "IQCProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell4")
        
        ingrediantTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        ingrediantTableView.register(UINib(nibName: "ProductTittleTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell31")
        ingrediantTableView.register(UINib(nibName: "ProductDetailTestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell32")
        ingrediantTableView.register(UINib(nibName: "ProductDetailItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        ingrediantTableView.register(UINib(nibName: "IQCProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell4")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView.frame = self.view.frame
        loadingView.startRotate()
        self.view.addSubview(loadingView)
        self.tabBarController?.tabBar.isHidden = true
        getProductDetail()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let facebookUrl = "<!DOCTYPE html><html> <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head><body> <div id=\"fb-root\"></div><script>(function(d, s, id){var js, fjs=d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js=d.createElement(s); js.id=id; js.src=\"//connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v2.8&appId=700015816832989\"; fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script> <div class=\"fb-comments\" data-href=\"https://iqctest.com/product/\(productId)\" data-numposts=\"5\"></div></body></html>"
        
        
        facebookCommentWebview.loadHTMLString(facebookUrl, baseURL: URL(string: "https://www.facebook.com/iqc.com.tw"))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        webView.scrollView.isScrollEnabled = false
        webViewHeightConstant.constant = webView.frame.size.height
        let currentURL : String = (webView.request?.url?.absoluteString)!
        if currentURL.contains("/close_popup"){
            let facebookUrl = "<!DOCTYPE html><html> <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head><body> <div id=\"fb-root\"></div><script>(function(d, s, id){var js, fjs=d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js=d.createElement(s); js.id=id; js.src=\"//connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v2.8&appId=700015816832989\"; fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script> <div class=\"fb-comments\" data-href=\"https://iqctest.com/product/\(productId)\" data-numposts=\"5\"></div></body></html>"
            
            
            facebookCommentWebview.loadHTMLString(facebookUrl, baseURL: URL(string: "https://www.facebook.com/iqc.com.tw"))
        }
        if (!observing) {
            startObservingHeight()
        }
    }
    
    func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            if facebookCommentWebview.scrollView.contentSize.height < 1000{
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
            if facebookCommentWebview.scrollView.contentSize.height < 1000{
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
        facebookCommentWebview.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        facebookCommentWebview.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            webViewHeightConstant.constant = facebookCommentWebview.scrollView.contentSize.height
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.stopRotate()
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
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
        //        tittleButtonContentView.frame.origin.y = max(navigationBarOriginalOffset!, scrollView.contentOffset.y)
        if navigationBarOriginalOffset != nil{
            if navigationBarOriginalOffset! < scrollView.contentOffset.y{
                stickyViewConstraint.constant = scrollView.contentOffset.y
            }else{
                stickyViewConstraint.constant = navigationBarOriginalOffset!
            }}
    }
    
    
    //MARK: Collection View Size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == brandOwnedProductCollectionView || collectionView == simularProductCollectionView{
            return CGSize(width: (brandOwnedProductCollectionView.bounds.width/2)-10, height: brandOwnedProductCollectionView.bounds.width/2 + 40)
        }
        if collectionView == productSliderCollectionView{
            return CGSize(width: self.view.bounds.width, height: collectionView.bounds.height)
        }else if collectionView == cerCollectionView{
            return CGSize(width: 50, height: 50)
        }else if collectionView == buyCollectionView{
            return CGSize(width: 100, height: 60)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productSliderCollectionView{
            return 0
        }else if collectionView == buyCollectionView{
            return 10
        }
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productSliderCollectionView{
            return 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var product = Product()
        if collectionView == cerCollectionView{
            return
        }
        if collectionView == brandOwnedProductCollectionView{
            if brandOwnedProduct.count <= indexPath.item{
                return
            }
            product = brandOwnedProduct[indexPath.item]
        }
        if collectionView == simularProductCollectionView{
            if simularProduct.count <= indexPath.item{
                return
            }
            product = simularProduct[indexPath.item]
        }
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
    }
    
    //MARK: Collection View Item Count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if product.title == nil{
            return 0
        }
        if collectionView == brandOwnedProductCollectionView{
            return brandOwnedProduct.count
        }
        if collectionView == simularProductCollectionView{
            return simularProduct.count
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
    
    //MARK: Cell For Row CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //品牌擁有的產品
        if collectionView == brandOwnedProductCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productNameLable.text = brandOwnedProduct[indexPath.item].title
            cell.productImageView.sd_setImage(with: URL(string: brandOwnedProduct[indexPath.item].img!))
            
            cell.productImageView.addShadow()
            
            return cell
            
        }
        //相似的產品
        if collectionView == simularProductCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productNameLable.text = simularProduct[indexPath.item].title
            cell.productImageView.sd_setImage(with: URL(string: simularProduct[indexPath.item].img!))
            
            cell.productImageView.addShadow()
            
            return cell
        }
        
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
        
        //6/29修改
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
                        if report.item != nil{
                            count = (report.item![0].reportid?.count)!
                        }
                    }
                }
                if tableViewHeightList[0] == 0{
                    tableViewHeightList[0] = CGFloat(132 * count)
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
                        if report.item != nil{
                            count = (report.item![0].reportid?.count)!
                        }
                    }
                }
                if tableViewHeightList[1] == 0{
                    tableViewHeightList[1] = CGFloat(132 * count)
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
                            count = (report.item![0].reportid?.count)!
                        }
                    }
                }
                if tableViewHeightList[2] == 0{
                    tableViewHeightList[2] = CGFloat(132 * count)
                }
                return count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //此為成分標示表格，由字數決定高度
        if tableView == productIngrediantTableView{
            
            if product.ingredient == ""{
                
                if indexPath.row == 0{
                    return 0
                }
            }
            if product.origin == ""{
                if indexPath.row == 1{
                    return 0
                }
            }
            if product.capacity == ""{
                if indexPath.row == 2{
                    return 0
                }
            }
            if product.allergy?.count == 0{
                if indexPath.row == 3{
                    return 0
                }
            }
            if product.veg?.count == 0{
                if indexPath.row == 4{
                    return 0
                }
            }
            if product.number == ""{
                if indexPath.row == 5{
                    return 0
                }
            }
            if product.warn == ""{
                if indexPath.row == 6{
                    return 0
                }
            }
            return UITableViewAutomaticDimension
        }
        if !isLatest{
            return 132
        }
        switch tableView {
        case productTableView:
            if productCellHeight[indexPath] != nil{
                let cellHeightF = productCellHeight[indexPath]
                return cellHeightF!
            }
        case halfProductTableView:
            if halfProductCellHeight[indexPath] != nil{
                let cellHeightF = halfProductCellHeight[indexPath]
                return cellHeightF!
            }
        case ingrediantTableView:
            if ingrediantCellHeight[indexPath] != nil{
                let cellHeightF = ingrediantCellHeight[indexPath]
                return cellHeightF!
            }
        default:
            break
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
                if product.origin == nil{
                    product.origin = ""
                }
                cell.detailContextLable.text = product.origin
            case 2:
                cell.tittleItemLable.text = "容量"
                if product.capacity == nil{
                    product.capacity = ""
                }
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
                if product.veg != nil{
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
                if product.number == nil{
                    product.number = " "
                }
                cell.detailContextLable.text = product.number
            case 6:
                cell.tittleItemLable.text = "警語"
                if product.warn == nil{
                    product.warn = " "
                }
                cell.detailContextLable.text = product.warn
            default:
                break
            }
            if cell.detailContextLable.text == ""{
                cell.isHidden = true
            }else{
                cell.isHidden = false
            }
            var count = 6
            if product.ingredient == ""{
                count -= 1
            }
            if product.origin == ""{
                count -= 1
            }
            if product.capacity == ""{
                count -= 1
            }
            if product.allergy?.count == 0{
                count -= 1
            }
            if product.veg?.count == 0{
                count -= 1
            }
            if product.number == ""{
                count -= 1
            }
            if product.warn == ""{
                count -= 1
            }
            
            if product.title != nil{
                cell.indexPath = indexPath
                cell.tableView = productIngrediantTableView
                cell.cellHeightChange = self
                
                if count == indexPath.row{
                    productIngrediantBottomView.layer.zPosition = 0
                    cell.endDrawDash()
                    drawMiddleLine()
                }else{
                    if cell.detailContextLable.text != ""{
                        cell.drawDash()
                    }else{
                        cell.isHidden = true
                    }
                }
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
                    if !isDraw{
                        cell.drawDash()
                    }
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 251/255, green: 251/255, blue: 251/255, alpha: 1)
                    cell.strokeImageView.isHidden = false
                    cell.selectionStyle = .none
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ProductTittleTableViewCell
                    cell.strokeImageView.isHidden = true
                    cell.selectionStyle = .none
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    //                    新加入若有說明
                    if (currentReport[section].item?[(index - 2)].content) != nil{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! IQCProductDetailTableViewCell
                        cell.changeButton.isEnabled = true
                        cell.selectionStyle = .none
                        cell.contentLable.text = (currentReport[section].item?[(index - 2)].content)
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
                        
                        cell.contentLable.text = (currentReport[section].item?[(index - 2)].content)
                        cell.cellHeightChange = self
                        cell.indexPath = indexPath
                        cell.tableView = tableView
                        cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                        cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                        
                        cell.ProductDetailTestTableView.reloadData()
                        return cell

                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
//                    cell.changeButton.isEnabled = true
                    cell.productId = self.productId
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
                    if !isDraw{
                        cell.drawDash()
                        
                    }
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 251/255, green: 251/255, blue: 251/255, alpha: 1)
                    cell.strokeImageView.isHidden = false
                    cell.selectionStyle = .none
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell21", for: indexPath) as! ProductTittleTableViewCell
                    cell.strokeImageView.isHidden = true
                    cell.selectionStyle = .none
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    //                    新加入若有說明
                    if (currentReport[section].item?[(index - 2)].content) != nil{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! IQCProductDetailTableViewCell
                        cell.changeButton.isEnabled = true
                        cell.contentLable.text = (currentReport[section].item?[(index - 2)].content)
                        if halfProductCellHeight[indexPath] != nil{
                            if halfProductCellHeight[indexPath]! != 40{
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
                        
                        cell.contentLable.text = (currentReport[section].item?[(index - 2)].content)
                        cell.cellHeightChange = self
                        cell.indexPath = indexPath
                        cell.tableView = tableView
                        cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                        cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                        
                        cell.ProductDetailTestTableView.reloadData()
                        return cell
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    cell.changeButton.isEnabled = true
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
                    if !isDraw{
                        cell.drawDash()
                    }
                    cell.tittleBackView.backgroundColor = UIColor(colorLiteralRed: 251/255, green: 251/255, blue: 251/255, alpha: 1)
                    cell.strokeImageView.isHidden = false
                    cell.selectionStyle = .none
                    cell.tittleLable.text = "檢體名稱"
                    cell.tittleNameLable.text = currentReport[section].tittle
                    return cell
                }else if index == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell31", for: indexPath) as! ProductTittleTableViewCell
                    cell.strokeImageView.isHidden = true
                    cell.selectionStyle = .none
                    cell.tittleBackView.backgroundColor = UIColor.white
                    cell.tittleLable.text = "檢驗項目"
                    cell.tittleNameLable.text = ""
                    return cell
                }else{
                    //                    新加入若有說明
                    if (currentReport[section].item?[(index - 2)].content) != nil{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! IQCProductDetailTableViewCell
                        cell.changeButton.isEnabled = true
                        cell.contentLable.text = (currentReport[section].item?[(index - 2)].content)
                        if ingrediantCellHeight[indexPath] != nil{
                            if ingrediantCellHeight[indexPath]! != 40{
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
                        
                        cell.contentLable.text = (currentReport[section].item?[(index - 2)].content)
                        cell.cellHeightChange = self
                        cell.indexPath = indexPath
                        cell.tableView = tableView
                        cell.reportDetail = (currentReport[section].item?[(index - 2)].reportid)!
                        cell.tittleLable.text = currentReport[section].item?[(index - 2)].itemid
                        
                        cell.ProductDetailTestTableView.reloadData()
                        return cell

                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ProductDetailItemTableViewCell
                    cell.changeButton.isEnabled = true
                    //                    cell.content = (currentReport[section].item?[(index - 2)].content)
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductDetailTestTableViewCell
                
                let detail = (currentReport[section].item?[0].reportid?[index])!
                
                if detail.file != nil{
                    cell.fileUrl = detail.file!
                    cell.fileId = detail.id!
                    cell.productId = productId
                }
                cell.testDateLable.text = detail.reportdate
                cell.testSource.text = detail.source
                cell.testUnitLable.text = detail.title
                
                return cell
                
            }
            
            if tableView == halfProductTableView{
                var currentReport = [Report]()
                for report in product.historyreport!{
                    if report.type == "半成品檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductDetailTestTableViewCell
                
                let detail = (currentReport[section].item?[0].reportid?[index])!
                
                if detail.file != nil{
                    cell.fileUrl = detail.file!
                    cell.fileId = detail.id!
                    cell.productId = productId
                }
                cell.testDateLable.text = detail.reportdate
                cell.testSource.text = detail.source
                cell.testUnitLable.text = detail.title
                
                return cell
            }
            
            if tableView == ingrediantTableView{
                var currentReport = [Report]()
                for report in product.historyreport!{
                    if report.type == "原料檢驗合格區"{
                        currentReport.append(report)
                    }
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductDetailTestTableViewCell
                
                let detail = (currentReport[section].item?[0].reportid?[index])!
                
                if detail.file != nil{
                    cell.fileUrl = detail.file!
                    cell.fileId = detail.id!
                    cell.productId = productId
                }
                cell.testDateLable.text = detail.reportdate
                cell.testSource.text = detail.source
                cell.testUnitLable.text = detail.title
                
                return cell
            }
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        return cell
    }
    
}

extension IQCProductDetailViewController:CellHeightChangeDelegate{
    
    
    //    MARK: 計算展開後改變的高度
    func cellHeightChange(tableView:UITableView ,whichCell:IndexPath, height:CGFloat, howMuch: CGFloat) {
        self.isDraw = true
        switch tableView {
        case productTableView:
            productTableViewHeightConstant.constant += howMuch
            tableViewHeightList[0] = productTableViewHeightConstant.constant
            productCellHeight[whichCell] = height
        case halfProductTableView:
            halfProductTableViewHightConstraint.constant += howMuch
            tableViewHeightList[1] = halfProductTableViewHightConstraint.constant
            halfProductCellHeight[whichCell] = height
        //此為成分標示表格，僅需畫虛線
        case productIngrediantTableView:
            productIngrediantHeightConstraint.constant += howMuch
        default:
            ingrediantTableViewHightConstraint.constant += howMuch
            tableViewHeightList[2] = ingrediantTableViewHightConstraint.constant
            ingrediantCellHeight[whichCell] = height
            
        }
        if tableView != productIngrediantTableView{
            tableView.reloadData()
//            tableView.isUserInteractionEnabled = false
//            tableView.reloadRows(at: [whichCell], with: .none)
//            tableView.isUserInteractionEnabled = true
        }
        
    }
    
    func drawMiddleLine(){
        forDashLineView.addDashedLine(startPoint: CGPoint(x: self.view.bounds.width/2, y: 0), endPoint: CGPoint(x: self.view.bounds.width/2, y: productIngrediantHeightConstraint.constant))
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
                                if let content = jsonReportClass.1["content"].string{
                                    reportClass.content = content
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
                    self.getProductList(id: similar, type: "")
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
                
                if let _ = jsonData["cer"].array{
                    self.product.cer = [String]()
                    for jsonCer in jsonData["cer"]{
                        if self.product.cer == nil{
                            self.product.cer = [jsonCer.1["img"].stringValue]
                        }else{
                            self.product.cer?.append(jsonCer.1["img"].stringValue)
                        }
                    }
                }
                if let _ = jsonData["veg"].array{
                    for jsonVeg in jsonData["veg"]{
                        if self.product.veg == nil{
                            self.product.veg = [jsonVeg.1["title"].stringValue]
                        }else{
                            self.product.veg?.append(jsonVeg.1["title"].stringValue)
                        }
                    }
                }
                
                if let _ = jsonData["allergy"].array{
                    for jsonAllergy in jsonData["allergy"]{
                        if self.product.allergy == nil{
                            self.product.allergy = [jsonAllergy.1["title"].stringValue]
                        }else{
                            self.product.allergy?.append(jsonAllergy.1["title"].stringValue)
                        }
                    }
                }
                
                if let _ = jsonData["mall"].array{
                    self.product.mall = [Mall]()
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
                        }else{
                            self.product.mall?.append(mall)
                        }
                    }
                }
                
                for jsonSlider in jsonData["slider"]{
                    if let main = jsonSlider.1["main"].string{
                        if main == "0"{
                            if self.product.slider == nil{
                                self.product.slider = [jsonSlider.1["img"].stringValue]
                            }else{
                                self.product.slider?.append(jsonSlider.1["img"].stringValue)
                            }
                        }else{
                            if self.product.slider == nil{
                                self.product.slider = [jsonSlider.1["img"].stringValue]
                            }else{
                            
                                self.product.slider?.insert(jsonSlider.1["img"].stringValue, at: 0)
                            }
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
        productIngrediantTableView.layoutIfNeeded()
        productIngrediantHeightConstraint.constant = productIngrediantTableView.contentSize.height
        self.reportAction(self)
        self.firstSubAction(self)
        self.underLineView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.underLineView.bounds.height)
        stickyViewConstraint.constant = headerTopView.frame.maxY
        navigationBarOriginalOffset = headerTopView.frame.maxY
        loadingView.isHidden = true
    }
    
    //取得所屬品牌後刷新頁面
    func refreshBrandContent(){
        backGroundImageView.sd_setImage(with: URL(string: brandData.img!))
        brandImageView.sd_setImage(with: URL(string: brandData.logo!))
        brandIdLable.text = brandData.name
        if brandData.product != nil{
            getProductList(id: brandData.product!, type: "brand")
        }
        
    }
    
    //    取得品牌擁有的產品與相似產品（資訊所需較少）
    func getProductList(id:String, type:String){
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
                    
                    if let gov = jsonData["gov"].string{
                        product.gov = gov
                    }
                    
                    if type == "brand"{
                        self.brandOwnedProduct.append(product)
                        self.brandOwnedProductCollectionView.reloadData()
                    }else{
                        self.simularProduct.append(product)
                        self.simularProductCollectionView.reloadData()
                    }
                }
            })
        }
    }
    
    //至產品內頁
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
                        //                        self.loadingView.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IQCProductDetail") as! IQCProductDetailViewController
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        vc.productId = id
                        //                        self.loadingView.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        })
        
    }
    
}
