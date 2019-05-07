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
    
    @IBOutlet weak var quiz_title: UILabel!
    
    @IBOutlet weak var quiz_image: UIImageView!

    @IBOutlet weak var scroll_view: UIScrollView!
    
    var numberOfCorrectAnswers = 0
    var startTime = 0
    var endTime = 0
    
    @IBAction func btn_start_quiz_clicked(_ sender: Any)
    {
        self.scroll_view.isHidden = false
        numberOfCorrectAnswers = 0
        startTime = Calendar.current.component(.second, from: Date())
        
    }
    
    @objc
    func buttonClicked(_ sender: AnyObject){
        let button = sender as! UIButton
        if (button.title(for: .normal)?.starts(with: String(button.tag)))!{
            button.backgroundColor = UIColor(named: "correctColor")
        }
        else{
            button.backgroundColor = UIColor(named: "wrongColor")
        }
    }
    
    override func viewDidLoad() {
        let quizService = QuizService()
        
        //self.quiz_title.text = category?.title
        self.quiz_title.text = "naslov"
        

        self.quiz_image.image = UIImage(named:"Image")
        //self.quiz_title.backgroundColor = UIColor(named : category?.category ?? "SPORTS")
        self.quiz_title.backgroundColor = UIColor(named : "SPORTS")
        
        //setQuestionView(questionList: questions ?? [], width: self.view.frame.width, height: self.scroll_view.frame.height,viewController: self)
        setQuestionView(questionList: [], width: self.view.frame.width, height: self.scroll_view.frame.height,viewController: self)
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
    let btn_height = 40

    for question in questionList{
        
        let customView = UIView(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: width, height: height)))
        
        let questionLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: btn_width, height: btn_height)))
        
        questionLabel.text = question.question
        questionLabel.numberOfLines = 0
        
        customView.addSubview(questionLabel)
        
        var n = 1
        for answer in (question.answers){
            
            let answer_btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: btn_height * n + 10), size: CGSize(width: btn_width, height: btn_height)))
            
            answer_btn.setTitle(String(n)+". " + answer, for: .normal)
            answer_btn.setTitleColor(UIColor.black, for: .normal)
            answer_btn.tag = ((question.correct_answer) + 1)
            answer_btn.addTarget(viewController, action: #selector(viewController.buttonClicked(_:)), for: .touchUpInside)
            customView.addSubview(answer_btn)
            n+=1
        }
        viewController.scroll_view.addSubview(customView)
    }
}




