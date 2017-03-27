//
//  TabBarViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/2.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension TabBarViewController: UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let userDefaults = Foundation.UserDefaults.standard
        switch item.title! {
        case "食在安心":
            if userDefaults.value(forKey: "isFirstSafe") == nil{
                userDefaults.setValue(true, forKey: "isFirstSafe")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SafeCoach")
                self.present(vc!, animated: false, completion: nil)
            }
            return
        case "IQC食安誌":
            if userDefaults.value(forKey: "isFirstJournal") == nil{
                userDefaults.setValue(true, forKey: "isFirstJournal")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JournalCoach")
                self.present(vc!, animated: false, completion: nil)
            }
            return
        default:
            break
        }
        
        let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
        rootView.popToRootViewController(animated: false)
    }
}
