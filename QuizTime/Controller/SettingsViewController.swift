//
//  SettingsViewController.swift
//  QuizTime
//
//  Created by Five on 26/06/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    let defaults = UserDefaults.standard
    
    @objc
    func logoutButtonClicked(_ sender: AnyObject){
        
        defaults.removeObject(forKey: "token")
        
        let loginVC = LoginViewController()
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = loginVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let username = defaults.string(forKey: "username")
        
        usernameLabel.text = username
        
        logoutBtn.addTarget(self, action: #selector(self.logoutButtonClicked(_:)), for: .touchUpInside)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
