//
//  WelcomePageViewController.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/17.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        let userDefaults = Foundation.UserDefaults.standard
        if userDefaults.value(forKey: "isFirst") == nil{
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.setValue(true, forKey: "isFirst")
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.performSegue(withIdentifier: "showIntro", sender: nil)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: when) {
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.setValue(true, forKey: "isFirst")
                userDefaults.setValue(true, forKey: "isFirstSafe")
                userDefaults.setValue(true, forKey: "isFirstJournal")
                self.performSegue(withIdentifier: "showMain", sender: nil)
            }
        }
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
