//
//  LoginViewController.swift
//  QuizTime
//
//  Created by Five on 07/05/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit
import PureLayout

class LoginViewController: UIViewController {
    
    let url = "https://iosquiz.herokuapp.com/api/session"
    
    let quizService = QuizService()

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
   
    @IBAction func login_btn_clicked(_ sender: Any) {
        let userName = username.text ?? ""
        let passWord = password.text ?? ""
        userLogin(url: url, username: userName, password: passWord, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        username.center.x -= view.bounds.width
        password.center.x -= view.bounds.width
        loginBtn.center.x -= view.bounds.width
        
        loginLabel.alpha = 0.0
        self.loginLabel.frame.size.height = 0.0
        self.loginLabel.frame.size.width = 0.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut],
                       animations: {
                        self.username.center.x += self.view.bounds.width
        },
                       completion: nil
        )

        UIView.animate(withDuration: 1.0, delay: 0.3, options: [.curveEaseInOut],
                       animations: {
                        self.password.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 1.0, delay: 0.6, options: [.curveEaseInOut],
                       animations: {
                        self.loginBtn.center.x += self.view.bounds.width
        },
                       completion: nil
        )

        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseInOut],
                       animations: {
                        self.loginLabel.alpha = 1.0
                        self.loginLabel.frame.size.height = 30.0
                        self.loginLabel.frame.size.width = 60.0
        },
                       completion: nil
        )


    }
}

func userLogin(url : String, username: String, password : String ,viewController: LoginViewController){
    
    viewController.quizService.login(urlString: url, username: username, password: password){ (result) in
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            
            defaults.set(username, forKey: "username")
            
            if result == nil{
                
                viewController.error_label.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    viewController.error_label.isHidden = true
                }
            }
            else{
                let token = result?[0]
                let id = result?[1]
                if token != nil && id != nil{
                    defaults.set(token, forKey: "token")
                    defaults.set(id, forKey: "id")
                }
                let tabVC = TabBarViewController()
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                UIView.animate(withDuration: 1.0, delay: 0.3, options: [.curveEaseInOut],
                               animations: {
                                viewController.username.center.y -= viewController.view.bounds.height
                },
                               completion: nil
                )
                
                UIView.animate(withDuration: 1.0, delay: 0.6, options: [.curveEaseInOut],
                               animations: {
                                viewController.password.center.y -= viewController.view.bounds.height
                },
                               completion: nil
                )
                
                UIView.animate(withDuration: 1.0, delay: 0.9, options: [.curveEaseInOut],
                               animations: {
                                viewController.loginBtn.center.y -= viewController.view.bounds.height
                },
                               completion: nil
                )
                
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut],
                               animations: {
                                viewController.loginLabel.center.y -= viewController.view.bounds.height
                },
                               completion: nil
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                    appDelegate.window?.rootViewController = tabVC
                }
    
            }
            
        }
    }
}
