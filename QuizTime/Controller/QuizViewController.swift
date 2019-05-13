//
//  QuizViewController.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit
import Kingfisher

class QuizViewController : UIViewController {
    
    @IBOutlet weak var error_label: UILabel!
    
    @IBOutlet weak var quiz_title: UILabel!
    
    @IBOutlet weak var quiz_image: UIImageView!

    @IBOutlet weak var scroll_view: UIScrollView!
    
    
    var numberOfCorrectAnswers = 0
    var startTime = 0.0
    var endTime = 0
    
    var scrollPosition = 1
    
    var quizData : Category
    
    init(quiz_data : Category) {
        self.quizData = quiz_data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func btn_start_quiz_clicked(_ sender: Any)
    {
        self.scroll_view.isHidden = false
        numberOfCorrectAnswers = 0
        startTime = Date().timeIntervalSinceReferenceDate
        scrollPosition = 1
        self.scroll_view.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    @objc
    func buttonClicked(_ sender: AnyObject){
        let button = sender as! UIButton
        if (button.title(for: .normal)?.starts(with: String(button.tag)))!{
            button.backgroundColor = UIColor(named: "correctColor")
            numberOfCorrectAnswers += 1
        }
        else{
            button.backgroundColor = UIColor(named: "wrongColor")
        }
        if scrollPosition < quizData.questions.count{
            self.scroll_view.setContentOffset(CGPoint(x: Int(self.view.frame.width) * scrollPosition, y: 0), animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                button.backgroundColor = UIColor.white
            }
            
            scrollPosition += 1
        }
        else{
            let time = Date().timeIntervalSinceReferenceDate - startTime
            startTime = 0
            
            let quizServise = QuizService()
            let url = "https://iosquiz.herokuapp.com/api/result"
            
            quizServise.sendResults(urlString: url, quizId: quizData.id, userID: 1, numberOfCorrectAnswers: numberOfCorrectAnswers, time: time){(responseCode) in
                DispatchQueue.main.async {
                    print(responseCode)
                }
                
            }
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        
        let url = URL(string: quizData.image)
        self.quiz_image.kf.setImage(with: url)
        
        self.quiz_title.text = quizData.title
        
        self.quiz_title.backgroundColor = UIColor(named : quizData.category)
        
        setQuestionView(questionList: quizData.questions, width: self.view.frame.width, height: self.scroll_view.frame.height,viewController: self)
        
    }
    
}

func countNBA(category : Category?) -> Int{
    return category.map({
        return $0.questions
        
    })?.filter({
        return $0.question.contains("NBA")
        
    }).count ?? 0
}

func setQuestionView(questionList:[Question],width:CGFloat,height:CGFloat, viewController:QuizViewController){

    let btn_width = 300
    let btn_height = 60

    var i = 0.0
    for question in questionList{
        
        let customView = UIView(frame: CGRect(origin: CGPoint(x: Double(width) * i,y:0), size: CGSize(width: width, height: height)))
        
        let questionLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: btn_width, height: 80)))
        
        questionLabel.text = question.question
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        
        customView.addSubview(questionLabel)
        
        var n = 1
        for answer in (question.answers){
            
            let answer_btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: btn_height * n + 20), size: CGSize(width: btn_width, height: btn_height)))
            
            answer_btn.setTitle(String(n)+". " + answer, for: .normal)
            answer_btn.setTitleColor(UIColor.black, for: .normal)
            answer_btn.tag = ((question.correct_answer) + 1)
            answer_btn.addTarget(viewController, action: #selector(viewController.buttonClicked(_:)), for: .touchUpInside)
            customView.addSubview(answer_btn)
            n+=1
        }
        i += 1
        viewController.scroll_view.addSubview(customView)
    }
}




