//
//  AppDelegate.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = TableViewController()
        let login_vc = LoginViewController()
        
        let navigationController : UINavigationController
        
        if defaults.string(forKey: "token") == nil{
            navigationController = UINavigationController(rootViewController: login_vc)
        }
        else{
            navigationController = UINavigationController(rootViewController: vc)
        }
        
        
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

