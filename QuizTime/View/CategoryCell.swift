//
//  CategoryCell.swift
//  QuizTime
//
//  Created by Five on 27/06/2019.
//  Copyright © 2019 Five. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    var locationNameLabel: UILabel!
    var pinImage : UIImage!
    var imageUrl : URL
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    func buildViews() {
        
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
    
}
