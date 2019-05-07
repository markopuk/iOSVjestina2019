//
//  TableViewController.swift
//  QuizTime
//
//  Created by Five on 06/05/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit

class TableViewController : UIViewController {

    let url = "https://iosquiz.herokuapp.com/api/quizzes"

    let quizService = QuizService()

    
    override func viewDidLoad() {
        quizService.fetchQuiz(urlString: url){ (quiz) in
            DispatchQueue.main.async {
                if quiz == nil{
                    
                    self.error_label.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.error_label.isHidden = true
                    }
                }
                else{
                    let categoryIndex = Int.random(in: 0..<quiz!.listOfCategories.count)
                    let category = quiz?.listOfCategories[categoryIndex]
                    
                    let questions = category?.questions
                    
                }
                
            }
    }
    
}


