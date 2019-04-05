//
//  QuizService.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import Foundation

class QuizService {
    func fetchQuiz(urlString: String , completion: @escaping ((Quiz?) -> Void)) {
        var listOfCategories : [Category] = []
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        
                        if let dictionary = json as? [String: Any] {
                        
                            let dict = dictionary["quizzes"] as? NSArray
                            for category in dict!{
                                let c = category as? [String: Any]
                                if c != nil {
                                    let cat = Category(json: c )
                                    if cat != nil {
                                        listOfCategories.append(cat!)
                                        
                                    }
                                }
                            }
                            
                        }

                        
                        completion(Quiz(list: listOfCategories))
                    } catch {
                        completion(nil)
                    }
                    
                    
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
        
    }
}
