//
//  TableViewController.swift
//  QuizTime
//
//  Created by Five on 06/05/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

class TableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var error_label: UILabel!
    
    let url = "https://iosquiz.herokuapp.com/api/quizzes"
    
    let quizService = QuizService()
    
    var categoriesDict : [String : [Category]] = [:]
    
    var categories : [Category] = []
    
    var images : [UIImage] = []
    
    var tableView = UITableView()
    
    let defaults = UserDefaults.standard
    
    @objc
    func logoutButtonClicked(_ sender: AnyObject){
        
        defaults.removeObject(forKey: "token")
        self.error_label.isHidden = false
        self.error_label.text = "Logged out"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.error_label.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        
        if defaults.string(forKey: "token") == nil{
            let loginViewController = LoginViewController()
            
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        
        fetchQuiz(quizService: quizService, url: url, viewController: self)
        
        tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height - self.error_label.frame.height - 20
        
        //tableView.contentInset.top = 20
        tableView.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight)
        
        view.addSubview(tableView)
        
//        self.tableView.estimatedRowHeight = 400
//        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        let key = Array(categoriesDict.keys)[indexPath.section]
        if let category = categoriesDict[key]?[indexPath.row]{
            setCellView(category: category, viewController: self, cell: cell)
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > Array(categoriesDict.keys).count - 1{
            //logout section
            return 0
        }
        else{
            let key = Array(categoriesDict.keys)[section]
            return categoriesDict[key]?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesDict.keys.count + 1
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        if section > Array(categoriesDict.keys).count - 1 {
            // logout section
            let title = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0 ), size: CGSize(width: 300, height: 60)))
            title.setTitle("log out", for: .normal)
            title.setTitleColor(UIColor.blue, for: .normal)
            title.addTarget(self, action: #selector(self.logoutButtonClicked(_:)), for: .touchUpInside)
            view.addSubview(title)
            
            title.autoCenterInSuperview()
        }
        else{
            let title = UILabel()
            view.backgroundColor = UIColor(named : Array(categoriesDict.keys)[section] )
            title.text = Array(categoriesDict.keys)[section]
            view.addSubview(title)
            
            title.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            title.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = Array(categoriesDict.keys)[indexPath.section]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        if let category = categoriesDict[key]?[indexPath.row]{
            
            let quizViewController = QuizViewController(quiz_data: category)
            
            self.navigationController?.pushViewController(quizViewController, animated: true)
        
        }
    }
    
    
    
}

func fetchQuiz(quizService:QuizService, url : String, viewController: TableViewController){
    quizService.fetchQuiz(urlString: url){ (quiz) in
        DispatchQueue.main.async {
            if quiz == nil{
                
                viewController.error_label.isHidden = false
                viewController.error_label.text = "Nažalost ne možemo dohvatiti kviz, pokušajte kasnije."
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    viewController.error_label.isHidden = true
                }
            }
            else{
                viewController.categories = quiz?.listOfCategories ?? []
                for category in quiz?.listOfCategories ?? []{
                    if viewController.categoriesDict.keys.contains(category.category){
                        viewController.categoriesDict[category.category]?.append(category)
                    }
                    else{
                       viewController.categoriesDict[category.category] = [category]
                    }
                }
                viewController.tableView.reloadData()
            }
            
        }
    }
}

func setCellView(category : Category, viewController : TableViewController,cell : UITableViewCell) {
    
    let imageUrl = URL(string : category.image)
    
    let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: cell.frame.width, height :cell.frame.height)))
    
    let imageView = UIImageView ()
    
    imageView.kf.setImage(with: imageUrl)
    
    imageView.layer.borderWidth = 3.0
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    
    view.addSubview(imageView)
    
    let titleView = UILabel()
    titleView.text = category.title
    
    view.addSubview(titleView)
    
    let descriptionView = UILabel()
    descriptionView.text = category.description
    descriptionView.numberOfLines = 0
    
    view.addSubview(descriptionView)
    
    let levelView = UILabel()
    levelView.text = String(repeating: "*", count: category.level)
    levelView.textColor = UIColor.blue
    
    view.addSubview(levelView)
    
    //PureLayout
    imageView.autoSetDimensions(to: CGSize(width: cell.frame.width / 6 , height: cell.frame.height / 6 ))
    
    imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
    imageView.autoPinEdge(toSuperviewEdge: .left, withInset: 10 )
    imageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
    imageView.autoPinEdge(.right, to: .left, of: titleView, withOffset: -10)
    
    titleView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
    titleView.autoPinEdge(.right, to: .left, of: levelView, withOffset: -10.0)
    
    descriptionView.autoPinEdge(.top, to: .bottom, of: titleView, withOffset: 10.0)
    descriptionView.autoPinEdge(.left, to: .right, of: imageView, withOffset: 10.0)
    descriptionView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
    
    levelView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
    levelView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
//    levelView.autoPinEdge(.left, to: .right, of: titleView, withOffset: 5.0)
    
    
    cell.addSubview(view)
    
    
}




