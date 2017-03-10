//
//  FirstViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/6.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var keyboardHeight:CGFloat = 0
    let gradient = CAGradientLayer()
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var inputCount = 0
    var codeArray:[Int] = []
    var codeImageArray:[UIImageView] = []
    var codeLableArray:[UILabel] = []
    var loadingView = UIView()
    
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    @IBOutlet weak var pointsStackView: UIStackView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var underLineView: UIView!
    
    @IBOutlet weak var cameraBackgroundView: UIView!
    @IBOutlet weak var blurViewTop: UIView!
    @IBOutlet weak var blurViewBottom: UIView!
    @IBOutlet weak var blurViewLeft: UIView!
    @IBOutlet weak var blurViewRight: UIView!
    
    @IBOutlet weak var hintLable: UILabel!
    
    @IBOutlet weak var keyboardBackView: UIView!
    
    @IBOutlet weak var codeImage1: UIImageView!
    @IBOutlet weak var codeImage2: UIImageView!
    @IBOutlet weak var codeImage3: UIImageView!
    @IBOutlet weak var codeImage4: UIImageView!
    @IBOutlet weak var codeImage5: UIImageView!
    @IBOutlet weak var codeImage6: UIImageView!
    @IBOutlet weak var codeImage7: UIImageView!
    @IBOutlet weak var codeImage8: UIImageView!
    @IBOutlet weak var codeImage9: UIImageView!
    @IBOutlet weak var codeImage10: UIImageView!
    @IBOutlet weak var codeImage11: UIImageView!
    @IBOutlet weak var codeImage12: UIImageView!
    @IBOutlet weak var codeImage13: UIImageView!
    
    @IBOutlet weak var codeLable1: UILabel!
    @IBOutlet weak var codeLable2: UILabel!
    @IBOutlet weak var codeLable3: UILabel!
    @IBOutlet weak var codeLable4: UILabel!
    @IBOutlet weak var codeLable5: UILabel!
    @IBOutlet weak var codeLable6: UILabel!
    @IBOutlet weak var codeLable7: UILabel!
    @IBOutlet weak var codeLable8: UILabel!
    @IBOutlet weak var codeLable9: UILabel!
    @IBOutlet weak var codeLable10: UILabel!
    @IBOutlet weak var codeLable11: UILabel!
    @IBOutlet weak var codeLable12: UILabel!
    @IBOutlet weak var codeLable13: UILabel!
    
    @IBOutlet weak var inputTextfield: UITextField!
    
    @IBOutlet weak var searchBackgroundView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBackgroungViewConstraint: NSLayoutConstraint!
    
    @IBAction func endEditAction(_ sender: Any) {
        if inputTextfield.isEditing{
            inputTextfield.endEditing(true)
            self.searchBackgroungViewConstraint.constant = 0
        }else{
            inputTextfield.becomeFirstResponder()
        }
    }
    
    @IBAction func camraAction(_ sender: Any) {
        inputTextfield.endEditing(true)
        cameraButton.isSelected = true
        keyboardButton.isSelected = false
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: 0, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
        
        // Start video capture.
        captureSession?.startRunning()
        searchBackgroundView.isHidden = true
        keyboardBackView.isHidden = true
    }
    
    @IBAction func keyboardAction(_ sender: Any) {
        inputTextfield.becomeFirstResponder()
        cameraButton.isSelected = false
        keyboardButton.isSelected = true
        UIView.animate(withDuration: 0.1, animations:
            {
                self.underLineView.frame = CGRect(x: self.view.frame.midX, y: self.underLineView.frame.minY, width: self.underLineView.bounds.width, height: self.underLineView.bounds.height)
        })
        
        captureSession?.stopRunning()
        searchBackgroundView.isHidden = false
        keyboardBackView.isHidden = false
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if codeArray.count == 8 || codeArray.count == 13{
            loadingView.isHidden = false
            var code = ""
            for codeDigit in codeArray{
                code += String(codeDigit)
            }
            sendRequest(code)
        }else{
            let alert = UIAlertController(title: "請輸入完整序號", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定漸層效果
        gradient.frame = self.searchBackgroundView.bounds
        gradient.colors = ["".colorWithHexString("#2CCAA8").cgColor, "".colorWithHexString("#18B7CD").cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0, 1]
        self.searchButton.layer.addSublayer(gradient)
        gradient.zPosition = 0
        
        //設定按鈕圖示
        cameraButton.setImage(#imageLiteral(resourceName: "icon_cam_01_prs"), for: .selected)
        cameraButton.setImage(#imageLiteral(resourceName: "icon_cam_01_nor"), for: .normal)
        keyboardButton.setImage(#imageLiteral(resourceName: "icon_keyboard_01_prs"), for: .selected)
        keyboardButton.setImage(#imageLiteral(resourceName: "icon_keyboard_01_nor"), for: .normal)
        
        //        設定Input
        inputTextfield.delegate = self
        //        監聽鍵盤事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        //        設定掃描
        setupCameraView()
        //        設定鍵盤輸入
        setupKeyboardView()
        
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
        loadingView.startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if self.view.bounds.width > 375{
            pointsStackView.spacing = 13
        }else if self.view.bounds.width < 375{
            pointsStackView.spacing = 9
        }else{
            pointsStackView.spacing = 10
        }
        
        loadingView.isHidden = true
        camraAction(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            //            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            //            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                loadingView.isHidden = false
                captureSession?.stopRunning()
                sendRequest(metadataObj.stringValue)
            }
        }
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
        DispatchQueue.main.async {
            self.moveSearchbutton()
        }
    }
    
    func moveSearchbutton(){
        if self.tabBarController != nil{
            self.searchBackgroungViewConstraint.constant = -(self.keyboardHeight) + (self.tabBarController?.tabBar.bounds.height)!
        }
    }
    
    func setupKeyboardView(){
        codeImageArray = [codeImage1, codeImage2, codeImage3, codeImage4, codeImage5, codeImage6, codeImage7, codeImage8, codeImage9, codeImage10, codeImage11, codeImage12, codeImage13]
        codeLableArray = [codeLable1, codeLable2, codeLable3, codeLable4, codeLable5, codeLable6, codeLable7, codeLable8, codeLable9, codeLable10, codeLable11, codeLable12, codeLable13]
        for lable in codeLableArray{
            lable.text = ""
        }
        
    }
    
    func setupCameraView(){
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = cameraBackgroundView.bounds
            cameraBackgroundView.layer.addSublayer(videoPreviewLayer!)
            //            videoPreviewLayer?.zPosition = 0
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            
            let blurEffectViewTop = UIVisualEffectView(effect: blurEffect)
            blurEffectViewTop.frame = blurViewTop.bounds
            blurEffectViewTop.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurViewTop.addSubview(blurEffectViewTop)
            
            let blurEffectViewBottom = UIVisualEffectView(effect: blurEffect)
            blurEffectViewBottom.frame = blurViewBottom.bounds
            blurEffectViewBottom.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurViewBottom.addSubview(blurEffectViewBottom)
            blurViewBottom.bringSubview(toFront: hintLable)
            hintLable.layer.zPosition = 0
            
            let blurEffectViewLeft = UIVisualEffectView(effect: blurEffect)
            blurEffectViewLeft.frame = blurViewLeft.bounds
            blurEffectViewLeft.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurViewLeft.addSubview(blurEffectViewLeft)
            
            let blurEffectViewRight = UIVisualEffectView(effect: blurEffect)
            blurEffectViewRight.frame = blurViewRight.bounds
            blurEffectViewRight.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurViewRight.addSubview(blurEffectViewRight)
            
            //            cameraBackgroundView.bringSubview(toFront: blurViewTop)
            //            cameraBackgroundView.bringSubview(toFront: blurViewLeft)
            //            cameraBackgroundView.bringSubview(toFront: blurViewBottom)
            //            cameraBackgroundView.bringSubview(toFront: blurViewRight)
            
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        }catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Start video capture.
        captureSession?.startRunning()
    }
    
    
    func sendRequest(_ code:String){
        self.view.endEditing(true)
        let headers:HTTPHeaders = ["Content-Type": "application/json","charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq"]
        
        
        Alamofire.request("https://iqctest.com/api/search/product/\(code)", headers: headers).responseJSON(completionHandler: {
            response in
            print(response)
            
            if let JSONData = response.result.value{
                let json = JSON(JSONData)
                var productList = [Product]()
                if json["count"].intValue == 0{
                    self.performSegue(withIdentifier: "NoResult", sender: self)
                }else if json["count"].intValue == 1{
                    for jsonData in json["list"]{
                        let product = Product()
                        if let id = jsonData.1["id"].string{
                            product.id = id
                        }
                        self.getProductDetail(product: product)
                    }
                }else if json["count"].int != nil{
                    for jsonData in json["list"]{
                        let product = Product()
                        if let id = jsonData.1["id"].string{
                            product.id = id
                        }
                        if let img = jsonData.1["img"].string{
                            product.img = img
                        }
                        if let modify = jsonData.1["modify"].string{
                            product.modify = modify
                        }
                        if let title = jsonData.1["title"].string{
                            product.title = title
                        }
                        productList.append(product)
                    }
                    self.performSegue(withIdentifier: "showMultipleDetail", sender: productList)
                }
            }
        })
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showMultipleDetail":
            let destinationController = segue.destination as! MultipleResultViewController
            destinationController.productList = sender as! [Product]
        case "showGovDetail":
            let destinationController = segue.destination as! GovProductDetailViewController
            destinationController.productId = (sender as! Product).id!
        case "showDetail":
            let destinationController = segue.destination as! IQCProductDetailViewController
            destinationController.productId = (sender as! Product).id!
        default:
            break
        }
    }
}

extension CameraViewController:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.characters.count)! >= codeImageArray.count && string == ""{
            
            codeArray.removeLast()
            codeImageArray[codeArray.count].isHidden = false
            codeLableArray[codeArray.count].text = string
            return true
        }
        
        if (textField.text?.characters.count)! >= codeImageArray.count {
            textField.text = "000000000000"
            return true
        }
        
        if codeArray.count == 0{
            codeArray.append(Int(string)!)
            codeImageArray[0].isHidden = true
            codeLableArray[0].text = string
            return true
        }
        
        if string != ""{
            codeArray.append(Int(string)!)
            codeImageArray[codeArray.count - 1].isHidden = true
            codeLableArray[codeArray.count - 1].text = string
        }else{
            codeArray.removeLast()
            codeImageArray[codeArray.count].isHidden = false
            codeLableArray[codeArray.count].text = string
        }
        
        return true
    }
    
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

