//
//  LeaderboardViewController.swift
//  QuizTime
//
//  Created by Five on 27/06/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var quizID : Int
    var results : [Int] = []
    
    init(quiz_id : Int) {
        self.quizID = quiz_id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let quizService = QuizService()
        let urlString = "https://iosquiz.herokuapp.com/api/score"
        quizService.getLeaderboard(urlString: urlString, quizID: quizID){ (results) in
            
            DispatchQueue.main.async {

                if var res = results {
                    res.sort()
                    res = res.suffix(20)
                    res.reverse()
                    res.forEach({ (result) in
                        self.results.append(Int(result))
                    })
                    self.tableView.reloadData()
                    print("data loaded")
                    
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let result = String(results[indexPath.row])
        setCellView(result: result, position: indexPath.row, cell: cell)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

func setCellView(result : String, position: Int,cell : UITableViewCell) {
    
    cell.textLabel?.text = String(position + 1) + ".  " + result
    
    
}
