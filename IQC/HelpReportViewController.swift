//
//  HelpReportViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON

class HelpReportViewController: UIViewController {
    
    var loadingView = UIView()
    var keyboardHeight:CGFloat = 0
    var photoArray = [UIImage]()
    var codeArray:[Int] = []
    var codeImageArray:[UIImageView] = []
    var codeLableArray:[UILabel] = []
    var selectedIndex = [Int]()
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var photoContentView: UIView!
    
    @IBOutlet weak var pointsStackView: UIStackView!
    
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
    
    @IBOutlet weak var completeImage: UIImageView!
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var inputTextfield: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBAction func changePassWordAction(_ sender: Any) {
        inputTextfield.becomeFirstResponder()
    }
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportBackgroudView: UIView!
    
    @IBAction func addImageAction(_ sender: Any) {
        
        let action = YNActionSheet()
        action.delegate = self
        if photoArray.count < 2{
            action.addCancelButtonWithTitle(Title: "取消")
            action.addButtonWithTitle(Title: "拍照")
            action.addButtonWithTitle(Title: "從照片選擇")
        }else{
            action.addCancelButtonWithTitle(Title: "取消")
            action.addButtonWithTitle(Title: "從照片選擇")
        }
        self.present(action, animated: false, completion: nil)
        
    }
    
    
    @IBAction func reportAction(_ sender: Any) {
        
        self.view.endEditing(true)
        if codeArray.count == 8 || codeArray.count == 13{
            if productNameTextField.text != "" && photoArray.count != 0{
                self.loadingView.isHidden = false
                postRequest()
                return
            }
        }
        
        let alert = UIAlertController(title: "請輸入完整資訊", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productNameTextField.delegate = self
        changePasswordButton.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 197/255, alpha: 1.0).cgColor
        changePasswordButton.layer.borderWidth = 1
        changePasswordButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
        //        設定鍵盤輸入
        setupKeyboardView()
        //        設定Input
        inputTextfield.delegate = self
        //        監聽鍵盤事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        
        //        設定讀取中圖示
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
        loadingView.startLoading()
        
        
        gradient.frame = reportBackgroudView.bounds
        gradient.colors = ["".colorWithHexString("#2CCAA8").cgColor, "".colorWithHexString("#18B7CD").cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0, 1]
        
        self.reportBackgroudView.layer.addSublayer(gradient)
        gradient.zPosition = 0
        gradient.isHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if self.view.bounds.width > 375{
            pointsStackView.spacing = 13
        }else if self.view.bounds.width < 375{
            pointsStackView.spacing = 9
        }else{
            pointsStackView.spacing = 10
        }
        completeImage.isHidden = true
        completeView.isHidden = true
        setPhoto()
        loadingView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0, animations: { success in
                self.view.frame = CGRect(x: 0, y: -self.keyboardHeight, width: self.view.bounds.width, height: self.view.bounds.height)
            })
            
        }
    }
    
    func setupKeyboardView(){
        codeImageArray = [codeImage1, codeImage2, codeImage3, codeImage4, codeImage5, codeImage6, codeImage7, codeImage8, codeImage9, codeImage10, codeImage11, codeImage12, codeImage13]
        codeLableArray = [codeLable1, codeLable2, codeLable3, codeLable4, codeLable5, codeLable6, codeLable7, codeLable8, codeLable9, codeLable10, codeLable11, codeLable12, codeLable13]
        for lable in codeLableArray{
            lable.text = ""
        }
        
    }
    
    func setPhoto(){
        photoArray = [UIImage]()
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count - 1 > 0 {
            
            // Perform the image request
            for i in selectedIndex{
                
                imgManager.requestImage(for: fetchResult.object(at: fetchResult.count - 1 - i) as PHAsset, targetSize: self.view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: {
                    (image, _) in
                    // Add the returned image to your array
                    self.photoArray.append(image!)
                })
            }
        }
        
        for imageView in self.photoContentView.subviews{
            imageView.removeFromSuperview()
        }
        
        if photoArray.count == 1{
            let photoImageView = UIImageView()
            photoImageView.image = photoArray[0]
            photoImageView.frame = CGRect(x: 0, y: 0, width: self.photoContentView.bounds.width, height: self.photoContentView.bounds.height)
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            self.photoContentView.addSubview(photoImageView)
            photoContentView.isHidden = false
        }else if photoArray.count == 2 {
            let photoImageView1 = UIImageView()
            photoImageView1.image = photoArray[0]
            photoImageView1.frame = CGRect(x: 0, y: 0, width: (self.photoContentView.bounds.width / 2) - 1, height: self.photoContentView.bounds.height)
            photoImageView1.contentMode = .scaleAspectFill
            photoImageView1.clipsToBounds = true
            self.photoContentView.addSubview(photoImageView1)
            
            let photoImageView2 = UIImageView()
            photoImageView2.clipsToBounds = true
            photoImageView2.image = photoArray[1]
            photoImageView2.frame = CGRect(x: (self.photoContentView.bounds.width / 2) + 1, y: 0, width: (self.photoContentView.bounds.width / 2) - 1, height: self.photoContentView.bounds.height)
            photoImageView2.contentMode = .scaleAspectFill
            self.photoContentView.addSubview(photoImageView2)
            
            photoContentView.isHidden = false
            
        }else{
            photoContentView.isHidden = true
        }
        checkIfCanSend()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openLibary"{
            let destinationController = segue.destination as! PhotoLibraryViewController
            destinationController.selectedImageIndex = selectedIndex
            destinationController.photoDelegate = self
        }
        
    }
    
    
}

extension HelpReportViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != inputTextfield{
            return true
        }
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0, animations: { success in
            self.checkIfCanSend()
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            //Error saving image
            return
        }
        //Image saved successfully
        self.selectedIndex.insert(0, at: 0)
        if self.selectedIndex.count == 2{
            self.selectedIndex[1] = self.selectedIndex[1] + 1
        }
        setPhoto()
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HelpReportViewController: PhotoPassingDelegate, YNActionSheetDelegate{
    
    func buttonClick(index: Int) {
        print(index)
        if index == 0{
            if photoArray.count == 2{
                self.performSegue(withIdentifier: "openLibary", sender: nil)
                return
            }else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }else{
            self.performSegue(withIdentifier: "openLibary", sender: nil)
        }
    }
    
    func postRequest(){
        var isComplete = [Bool]()
        for _ in 0...photoArray.count - 1{
            isComplete.append(false)
        }
        let headers:HTTPHeaders = ["Content-Type": "application/json" ,"charset": "utf-8", "X-API-KEY": "1Em7jr4bEaIk92tv7bw5udeniSSqY69L", "authorization": "Basic MzE1RUQ0RjJFQTc2QTEyN0Q5Mzg1QzE0NDZCMTI6c0BqfiRWMTM4VDljMHhnMz1EJXNRMjJJfHEzMXcq", "content-type": "multipart/form-data; boundary=---011000010111000001101001",]
        
        
        
        for photo in photoArray{
            let url = try! URLRequest(url: URL(string: "https://iqctest.com/api/data/payback")!, method: .post, headers: headers)
            
            var code = ""
            for codeDigit in codeArray{
                code += String(codeDigit)
            }
            Alamofire.upload(multipartFormData: {
                (multipartFormData) in
                multipartFormData.append("{ \"content\":[ { \"title\":\"\(self.productNameTextField.text!)\", \"barcode\": \"\(code)\" }]}".data(using: .utf8)!, withName: "info")
                multipartFormData.append(UIImageJPEGRepresentation(photo, 0.2)!, withName: "file", fileName: "content\(self.photoArray.index(of: photo)).jpg", mimeType: "image/jpeg")
            }, with: url, encodingCompletion: {
                (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
                DispatchQueue.main.async {
                    isComplete[self.photoArray.index(of: photo)!] = true
                    if isComplete.count == 1{
                        self.isComplete()
                    }else{
                        if isComplete[0] == true && isComplete[1] == true{
                            self.isComplete()
                        }
                    }
                }
            })
            
            
        }
        
    }
    
    func openCamera(selectedIndex: [Int]) {
        self.selectedIndex = selectedIndex
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func getSelectedIndex(selectedIndex: [Int]) {
        self.selectedIndex = selectedIndex
        setPhoto()
    }
    
    func checkIfCanSend(){
        if productNameTextField.text != "" && inputTextfield.text != "" && photoArray.count > 0{
            reportButton.backgroundColor = UIColor.clear
        }else{
            reportButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func isComplete(){
        reportBackgroudView.isHidden = true
        self.loadingView.isHidden = true
        completeImage.isHidden = false
        self.reportButton.isHidden = true
        self.completeView.isHidden = false
        let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
