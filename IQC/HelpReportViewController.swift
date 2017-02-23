//
//  HelpReportViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Photos

class HelpReportViewController: UIViewController {
    
    var photoArray = [UIImage]()
    var codeArray:[Int] = []
    var codeImageArray:[UIImageView] = []
    var codeLableArray:[UILabel] = []
    var selectedIndex = [Int]()
    
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
    
    @IBOutlet weak var reportBackgroudView: UIView!
    
    @IBAction func addImageAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "拍照", style: .default, handler: {
            success in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let albumAction = UIAlertAction(title: "從照片選擇", style: .default, handler: {
            success in
            self.performSegue(withIdentifier: "openLibary", sender: nil)
            
        })
        
        if photoArray.count < 2{
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(albumAction)
            self.present(actionSheet, animated: true, completion: nil)
        }else{
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(albumAction)
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func reportAction(_ sender: Any) {
        
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        if self.view.bounds.width > 375{
            pointsStackView.spacing = 13
        }else if self.view.bounds.width < 375{
            pointsStackView.spacing = 9
        }else{
            pointsStackView.spacing = 10
        }
        setPhoto()
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
            self.photoContentView.addSubview(photoImageView)
            photoContentView.isHidden = false
        }else if photoArray.count == 2 {
            let photoImageView1 = UIImageView()
            photoImageView1.image = photoArray[0]
            photoImageView1.frame = CGRect(x: 0, y: 0, width: (self.photoContentView.bounds.width / 2) - 1, height: self.photoContentView.bounds.height)
            photoImageView1.contentMode = .scaleAspectFill
            self.photoContentView.addSubview(photoImageView1)
            
            let photoImageView2 = UIImageView()
            photoImageView2.image = photoArray[1]
            photoImageView2.frame = CGRect(x: (self.photoContentView.bounds.width / 2) + 1, y: 0, width: (self.photoContentView.bounds.width / 2) - 1, height: self.photoContentView.bounds.height)
            photoImageView2.contentMode = .scaleAspectFill
            self.photoContentView.addSubview(photoImageView2)
            
            photoContentView.isHidden = false
            
        }else{
            photoContentView.isHidden = true
        }
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

extension HelpReportViewController: PhotoPassingDelegate{
    
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
}
