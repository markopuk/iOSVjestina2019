//
//  QuizService.swift
//  QuizTime
//
//  Created by Five on 03/04/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import Foundation
import UIKit

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
    
    func fetchImage(urlString: String , completion: @escaping ((Data?) -> Void)) {

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    completion(data)
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }

    }
    
    func login(urlString: String, username : String, password: String, completion: @escaping (([String]?) -> Void)) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
    
            request.httpMethod = "POST"
            
            let postString = "username=" + username + "&" + "password=" + password
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
//                    let response = response as! HTTPURLResponse
//                    print(response.statusCode)
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        
                        if let parseJSON = json {
//                            print(parseJSON.allKeys)
                            let token = parseJSON["token"] as? String
                            if token != nil  {
                                completion([token!,"1"])
                            }
//                            let id = parseJSON["user_id"] as? String
//                            print (token)
//                            print (id)
//                            if token != nil && id != nil {
//                                completion([token!,id!])
//                            }
                            else{
                                completion(nil)
                            }
                        }
                    }
                    catch{
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
    
    
    func sendResults(urlString: String, quizId : Int, userID: Int,numberOfCorrectAnswers: Int, time : Double, completion: @escaping ((String) -> Void)) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            let params = ["quiz_id" : String(quizId), "user_id": String(userID), "time": String(time), "no_of_correct": String(numberOfCorrectAnswers)]
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }catch let error{
                print("greška sa slanjem parametara:" + error.localizedDescription)
            }
            
            let defaults = UserDefaults.standard
            
            let token = defaults.string(forKey: "token")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let response = response as! HTTPURLResponse
                completion(String(response.statusCode))
            }
                
            dataTask.resume()
        } else {
            completion("bad url")
        }
    }
    
    func getLeaderboard(urlString : String, quizID : Int, completion: @escaping ((Data?) -> Void)) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            //let params = ["quiz_id" : String(quizID)]
            
//            do{
//                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//            }catch let error{
//                print("greška sa slanjem parametara:" + error.localizedDescription)
//            }
            
            let defaults = UserDefaults.standard
            
            let token = defaults.string(forKey: "token")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let response = response as! HTTPURLResponse
                completion(data)
            }
            
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
   
}
