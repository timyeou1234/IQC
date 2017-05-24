//
//  MenuViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/15.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

protocol GotoRootDelegate {
    func gotoRoot()
}

protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
}

class MenuViewController: UIViewController, GotoRootDelegate{

    var isFromSub = false
    var menuActionDelegate:MenuActionDelegate? = nil
    
    @IBAction func aboutAction(_ sender: Any){
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.isFromMenu = true
        menuActionDelegate?.openSegue("About", sender: nil)
    }
    
    @IBAction func declareAction(_ sender: Any) {
        menuActionDelegate?.openSegue("Declare", sender: nil)
    }
    
    @IBAction func SubscribeAction(_ sender: Any) {
        menuActionDelegate?.openSegue("Subscribe", sender: nil)
    }

    @IBAction func openFacebookAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/iqc.com.tw/")!)
    }
    
    @IBAction func openSite(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://iqc.com.tw/")!)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFromSub{
            dismiss(animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationController = segue.destination as? AboutViewController{
            destinationController.gotoRoot = self
        }
    }

    func gotoRoot() {
        dismiss(animated: false, completion: nil)
    }
}
