//
//  SearchViewController.swift
//  QuizTime
//
//  Created by Five on 26/06/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
        
    @IBAction func searchBtnTapped(_ sender: Any) {
    
        let searchWord = searchTextField.text
        if searchWord!.count > 0{
            categoriesDict = [:]
        }
        else{
            categoriesDict = allCategoriesDict
        }
        for categoryType in allCategoriesDict.keys{
            for category in allCategoriesDict[categoryType]!{
                if category.title.lowercased().contains(searchWord!) || category.description.lowercased().contains(searchWord!){
                    if categoriesDict.keys.contains(category.category){
                         categoriesDict[category.category]?.append(category)
                    }
                    else{
                        categoriesDict[category.category] = [category]
                    }
                }
            }
        }
        sTableView.reloadData()
    }
    
    let quizService = QuizService()
    
    var sTableView = UITableView()
    
    var categoriesDict : [String : [Category]] = [:]
    var allCategoriesDict : [String : [Category]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchQuiz(quizService: quizService, viewController: self)
        
        sTableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        sTableView.dataSource = self
        sTableView.delegate = self
        sTableView.backgroundColor = UIColor.white
        
        sTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height - searchTextField.frame.height
        
        sTableView.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight)
        
        tableView.addSubview(sTableView)

        
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
            //            // logout section
            //            let title = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0 ), size: CGSize(width: 300, height: 60)))
            //            title.setTitle("log out", for: .normal)
            //            title.setTitleColor(UIColor.blue, for: .normal)
            //            title.addTarget(self, action: #selector(self.logoutButtonClicked(_:)), for: .touchUpInside)
            //            view.addSubview(title)
            //
            //            title.autoCenterInSuperview()
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

func fetchQuiz(quizService:QuizService, viewController: SearchViewController){
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    viewController.categoriesDict = [:]
    
    //dohavt iz baze mobitela
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
    
    request.returnsObjectsAsFaults = false
    
    do{
        let results = try context.fetch(request)
        
        for object in results
        {
            guard let objectData = object as? NSManagedObject else {continue}
            context.delete(objectData)
        }
        print( "u bazi se nalaze  " + String(results.count) + " zapisa")
        for result in results as! [NSManagedObject] {
            let id = result.value(forKey: "id") as! Int
            let title = result.value(forKey: "title") as! String
            let description = result.value(forKey: "categoryDescription") as! String
            let categoryName = result.value(forKey: "category") as! String
            let level = result.value(forKey: "level") as! Int
            let image = result.value(forKey: "image") as! String
            let quest = result.value(forKey: "questions") as! NSMutableSet
            let questions = quest.allObjects as! [Questions]
            
            var questionList : [Question] = []
            for q in questions {
                let answers = q.value(forKey: "answers") as! [String]
                let correctAnswer = q.value(forKey: "correctAnswer") as! Int
                let questionId = q.value(forKey: "id") as! Int
                let ques = q.value(forKey: "question") as! String
                
                let question = Question(answers: answers, correctAnswer: correctAnswer, id: questionId, question: ques)
                
                questionList.append(question)
            }
            
            let category = Category(category: categoryName, description: description, id: id, image: image, level: level, questions: questionList, title: title)
            
            
            if viewController.categoriesDict.keys.contains(category.category){
                viewController.categoriesDict[category.category]?.append(category)
            }
                
            else{
                viewController.categoriesDict[category.category] = [category]
            }
            
        }
        print("postavljene kategorije iz baze")
        //viewController.categoriesDict = [:]
        print(viewController.categoriesDict.keys)
        viewController.allCategoriesDict = viewController.categoriesDict
        viewController.sTableView.reloadData()
    }
    catch{
        print("error in reading data from core data")
    }
    
}

func setCellView(category : Category, viewController : SearchViewController,cell : UITableViewCell) {
    
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
    
    let oldView = cell.subviews[0] as UIView
    oldView.removeFromSuperview()
    
    let blankView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: cell.frame.width, height :cell.frame.height)))
    blankView.backgroundColor = .white
    cell.addSubview(blankView)
    cell.addSubview(view)
    
    
    
}

