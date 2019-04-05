//
//  QuizViewController.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit

class QuizViewController : UIViewController {
    
    @IBOutlet weak var error_label: UILabel!
    
    @IBOutlet weak var fun_fact_label: UILabel!
    
    @IBOutlet weak var quiz_title: UILabel!
    
    
    @IBOutlet weak var quiz_image: UIImageView!

    
    @IBOutlet weak var custom_view: UIView!
    
    @IBAction func btn_dohvati_clicked(_ sender: Any) {
        
        let url = "https://iosquiz.herokuapp.com/api/quizzes"
        
        let quizService = QuizService()
        quizService.fetchQuiz(urlString: url){ (quiz) in
            DispatchQueue.main.async {
                if quiz?.listOfCategories.count == 0 {
                    self.error_label.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.error_label.isHidden = true
                    }
                }
                else{
                    let category = quiz?.listOfCategories[0]
                    
                    var nba = 0
                    nba += category.map({
                         return $0.questions
                        
                    })?.filter({
                            return $0.question.contains("NBA")
                        
                    }).count ?? 0
                    
                    
                    self.fun_fact_label.text = "Fun fact: there are " + String(nba) + " questions that are connected with NBA"
                    
                    self.quiz_title.text = category?.title
                    //TODO dohvat slike s url
                    let image = category?.image
                    
                    if image != nil {
                        self.quiz_image.image = UIImage(named: image!)
                    }
                    
                    self.quiz_title.backgroundColor = UIColor(named :"sportColor")
                    self.quiz_image.backgroundColor = UIColor(named: "sportColor")
                    
                    let question = category?.questions[0]
                    
                    let width = 300
                    let height = 40
                    
                    let question_label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: width, height: height)))
                    
                    question_label.text = question?.question
                    
                    self.custom_view.addSubview(question_label)
                    
                    if question?.answers != nil{
                        var n = 1
                        for answer in (question?.answers)!{
                            let answer_btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: height * n + 10), size: CGSize(width: width, height: height)))
                            
                            answer_btn.setTitle(String(n)+". " + answer, for: .normal)
                            answer_btn.setTitleColor(UIColor.blue, for: .normal)
                            answer_btn.tag = ((question?.correct_answer)! + 1)
                            answer_btn.addTarget(self, action: #selector(QuizViewController.buttonClicked(_:)), for: .touchUpInside)
                            self.custom_view.addSubview(answer_btn)
                            n+=1
                        }
                    }
                }
                
            }
        }
        
    }
    @objc
    func buttonClicked(_ sender: AnyObject){
        let button = sender as! UIButton
        if (button.title(for: .normal)?.starts(with: String(button.tag)))!{
            button.backgroundColor = UIColor.green
        }
        else{
            button.backgroundColor = UIColor.red
        }
    }
    
    override func viewDidLoad() {
        
        error_label.text = "Nažalost ne možemo dohvatiti kviz, pokušajte kasnije."
        
    }
}
