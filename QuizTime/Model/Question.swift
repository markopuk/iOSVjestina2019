//
//  Question.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import Foundation
class Question{
    
    let answers : [String]
    let correct_answer : Int
    let id : Int
    let question : String

    init(answers: [String], correctAnswer : Int, id : Int, question : String){
        self.answers = answers
        self.correct_answer = correctAnswer
        self.id = id
        self.question = question
    }
    
    init?(json: Any) {

        if let jsonDict = json as? [String: Any],
            let answers = jsonDict["answers"] as? [String],
            let correct_answer = jsonDict["correct_answer"] as? Int,
            let id = jsonDict["id"] as? Int,
            let question = jsonDict["question"] as? String
            {
                self.answers = answers
                self.correct_answer = correct_answer
                self.id = id
                self.question = question

            }
        else{
            return nil
        }
    }

}

