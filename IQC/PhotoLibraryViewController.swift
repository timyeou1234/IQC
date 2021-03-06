//
//  PhotoLibraryViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/22.
//  Copyright © 2017年 Wework. All rights reserved.
//
//MARK:選擇相片頁面

protocol PhotoPassingDelegate {
    func openCamera(selectedIndex:[Int])
    func getSelectedIndex(selectedIndex:[Int])
}

import UIKit
import Photos

class PhotoLibraryViewController: UIViewController {
    
    var imageArray = [UIImage]()
    var selectedImageIndex = [Int]()
    var photoDelegate:PhotoPassingDelegate?
    var photoArray = [PHAsset]()
    
    @IBAction func cancelAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func DoneAction(_ sender: Any) {
        photoDelegate?.getSelectedIndex(selectedIndex: selectedImageIndex)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.register(UINib(nibName: "PhotoLibraryFirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell1")
        self.photoCollectionView.register(UINib(nibName: "PhotoLibraryPhotoCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        let width = UIScreen.main.bounds.width - 4
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: width/3, height: width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        photoCollectionView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoArray = [PHAsset]()
        
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in
            // self.cameraAssets.add(object)
            self.photoArray.append(object)
        })
        
        self.photoArray.reverse()
        self.photoCollectionView.reloadData()
//        let imgManager = PHImageManager.default()
//        
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
//        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
//        
//        // If the fetch result isn't empty,
//        // proceed with the image request
//        for i in 0...fetchResult.count - 1{
//            
//            // Perform the image request
//            
//            imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: self.view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: {
//                (image, _) in
//                
//                // Add the returned image to your array
//                
//                self.photoArray.append(image!)
//                let index = IndexPath(item: i, section: 0)
//                self.photoCollectionView.reloadItems(at: [index])
//            })
//        }
        
        if selectedImageIndex.count > 0{
            doneButton.isEnabled = true
            doneButton.tintColor = UIColor.blue
        }else{
            doneButton.isEnabled = false
            doneButton.tintColor = UIColor.lightGray
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if imageArray.count > 0{
            let destinationController = segue.destination as! HelpReportViewController
            
            destinationController.selectedIndex = selectedImageIndex
        }
     }
    
}

extension PhotoLibraryViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    //    delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            if selectedImageIndex.count < 2{
                photoDelegate?.openCamera(selectedIndex: selectedImageIndex)
                _ = self.navigationController?.popViewController(animated: true)
            }
            return
        }
        if selectedImageIndex.contains(indexPath.item - 1){
            selectedImageIndex.remove(at: selectedImageIndex.index(of: indexPath.item - 1)!)
            photoCollectionView.reloadItems(at: [indexPath])
            if selectedImageIndex.count == 0{
                doneButton.isEnabled = false
                doneButton.tintColor = UIColor.lightGray
            }
        }else if selectedImageIndex.count < 2{
            doneButton.isEnabled = true
            doneButton.tintColor = UIColor.blue
            selectedImageIndex.append(indexPath.item - 1)
            photoCollectionView.reloadItems(at: [indexPath])
        }else{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var photoCount = 0
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            photoCount = fetchResult.count
        }
        
        return photoArray.count + 1
    }
    
    //    datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell =
                photoCollectionView.dequeueReusableCell(
                    withReuseIdentifier: "Cell1", for: indexPath) as! PhotoLibraryFirstCollectionViewCell
            
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0.5
            
            return cell
        }
        
        let cell =
            photoCollectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell", for: indexPath) as! PhotoLibraryPhotoCollectionViewCell
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        if photoArray.count > indexPath.item{
            let asset = photoArray[indexPath.item]
            let manager = PHImageManager.default()
            if cell.tag != 0 {
                manager.cancelImageRequest(PHImageRequestID(cell.tag))
            }
            cell.tag = Int(manager.requestImage(for: asset,
                                                targetSize: CGSize(width: 120.0, height: 120.0),
                                                contentMode: .aspectFill,
                                                options: nil) { (result, _) in
                                                    cell.photoImageView.image = result
            })
        }else{
            cell.photoImageView.image = nil
        }
        cell.selectedView.isHidden = true
        cell.selectMark.isHidden = true
        
        for selectIndex in selectedImageIndex{
            if selectIndex == indexPath.item - 1{
                cell.selectedView.isHidden = false
                cell.selectMark.isHidden = false
                
                break
            }else{
                cell.selectedView.isHidden = true
                cell.selectMark.isHidden = true
            }
        }
        
        return cell
    }

}

