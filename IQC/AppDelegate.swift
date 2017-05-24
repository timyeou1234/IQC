//
//  AppDelegate.swift
//  IQC
//
//  Created by YeouTimothy on 2017/2/6.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GodEye

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.portrait
    var window: UIWindow?
    var isFromMenu:Bool?

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .default
        UINavigationBar.appearance().barTintColor = UIColor.white
        let backImg: UIImage = UIImage(named: "nav_back_prs")!
        let backImage = backImg.withRenderingMode(.alwaysOriginal).resizableImage(withCapInsets: UIEdgeInsetsMake(backImg.size.height, backImg.size.width, 0, 0))
//        let renderedImage = backImg.withRenderingMode(.alwaysTemplate)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImage, for: [], barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-400, 0), for: .default)
        
        UINavigationBar.appearance().tintColor = UIColor(colorLiteralRed:155/255, green: 155/255, blue: 155/255, alpha: 1)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(colorLiteralRed: 0/255, green: 182/255, blue: 196/255, alpha: 1)
        UITabBar.appearance().barTintColor = UIColor.white
        
//        GodEye.makeEye(with:self.window!)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

