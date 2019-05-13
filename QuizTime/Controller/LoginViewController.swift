//
//  LoginViewController.swift
//  QuizTime
//
//  Created by Five on 07/05/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let url = "https://iosquiz.herokuapp.com/api/session"
    
    let quizService = QuizService()

    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
   
    @IBAction func login_btn_clicked(_ sender: Any) {
        let userName = username.text ?? ""
        let passWord = password.text ?? ""
        userLogin(url: url, username: userName, password: passWord, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

func userLogin(url : String, username: String, password : String ,viewController: LoginViewController){
    
    viewController.quizService.login(urlString: url, username: username, password: password){ (result) in
        DispatchQueue.main.async {
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
                    let defaults = UserDefaults.standard
                    defaults.set(token, forKey: "token")
                    defaults.set(id, forKey: "id")
                }
            viewController.navigationController?.popViewController(animated: true)
            }
            
        }
    }
}
