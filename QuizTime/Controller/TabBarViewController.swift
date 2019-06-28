//
//  TabBarViewController.swift
//  QuizTime
//
//  Created by Five on 26/06/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import CoreData
import UIKit

class TabBarViewController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableNavigationController = UINavigationController()
        let tableVC = TableViewController()
        
        tableNavigationController.addChild(tableVC)
        tableVC.tabBarItem = UITabBarItem(title: "Quiz list",image: UIImage(named: "list"), tag: 0)
        
        let searchNavigationController = UINavigationController()
        let searchVC = SearchViewController()
        
        searchNavigationController.addChild(searchVC)
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        viewControllers = [tableNavigationController,searchNavigationController,settingsVC]
    
        
    }
    
}
