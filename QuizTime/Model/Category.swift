

//
//  Quiz.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import Foundation
class Category{
    
    let category: String
    let description: String
    let id: Int
    let image : String
    let level : Int
    var questions : [Question] = []
    let title : String
    

    init?(json: Any) {
        
        let jsonDict = json as! [String: Any]

        let category = jsonDict["category"] as? String
        let description = jsonDict["description"] as? String
        let id = jsonDict["id"] as? Int
        let image = jsonDict["image"] as? String
        let level = jsonDict["level"] as? Int
        let title = jsonDict["title"] as? String
    
        self.category = category!
        self.description = description ?? ""
        self.id = id!
        self.image = image ?? ""
        self.level = level!
        self.title = title!
        
        let questions = jsonDict["questions"] as? NSArray
        
        for q in questions!{
            let question = q as? [String:Any]
            self.questions.append(Question(json: question)!)
            }
        
        
    }
}
    



