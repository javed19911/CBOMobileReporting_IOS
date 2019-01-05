//
//  DrRptTask.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 25/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DrRptTask : NSObject ,
UITableViewDataSource, UITableViewDelegate{
    var headers = [String]()
    var tableView : UITableView!
    var isCollaps = [Bool]()
    var context : CustomUIViewController!
    var summaryData = [[String : String ]]()
    
    init(tableView : UITableView , vc : CustomUIViewController , summaryData : [[String : String ]] , headers :[String] , isCollaps : [Bool] ) {
        super.init()
        self.summaryData = summaryData
        self.tableView = tableView
        self.isCollaps = isCollaps
        context = vc
        
        let headerNib = UINib.init(nibName: "ExpandableTableViewHeader", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ExpandableTableViewHeader")
        
        self.headers = headers
        
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCollaps[indexPath.section] == true {
            return 0
        }else {
            return  UITableViewAutomaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return summaryData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = Bundle.main.loadNibNamed("ExpandableInnerCell", owner: self, options: nil)?.first as! ExpandableInnerCell
        
        
        
        
        
        
         return UITableViewCell()
    }
    
    
    
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
     let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpandableTableViewHeader") as! ExpandableTableViewHeader
    
        headerView.itemCount.backgroundColor = AppColorClass.colorPrimary
        headerView.itemCount.layer.masksToBounds = true
        headerView.itemCount.layer.cornerRadius = CGFloat(5)
        
        headerView.mylabel.textColor = AppColorClass.colorPrimaryDark
        headerView.headerButton.textColor = AppColorClass.colorPrimaryDark
        headerView.mylabel.text = headers[0]
         headerView.headerTapButton.addTarget(self, action: #selector(headerButtonPressed), for: .touchUpInside)
        
        return headerView
        
    }
    @objc func headerButtonPressed(sender : UIButton){
        isCollaps[sender.tag] = !isCollaps[sender.tag]
        tableView.reloadData()
    }
    
    
    func ShowDrSampleProduct( sample_name : [String],  sample_qty : [String], sample_pob : [String] , myStackView : UIView ){
        
        
        print(sample_pob , sample_qty , sample_name)
        
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        var previousStackView : UIStackView!
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Product"
        myLabel.numberOfLines = 0
        myLabel.font = myLabel.font.withSize(13)
        myLabel.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel.textColor = .white
        
        
        let myLabel2 = UILabel()
        myStackView.addSubview(myLabel2)
        myLabel2.translatesAutoresizingMaskIntoConstraints = false
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel2.font = myLabel2.font.withSize(13)
        myLabel2.textAlignment = .center
        myLabel2.textColor = .white
        myLabel2.text =  "Sample"
        
        let myLabel3 = UILabel()
        myStackView.addSubview(myLabel3)
        myLabel3.translatesAutoresizingMaskIntoConstraints = false
        myLabel3.numberOfLines = 0
        myLabel3.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel3.font = myLabel3.font.withSize(13)
        
        myLabel3.textAlignment = .center
        myLabel3.textColor = .white
        myLabel3.text =  "POB"
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        
        myLabel3.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel3.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
        myLabel3.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel2.rightAnchor.constraint(equalTo: myLabel3.leftAnchor ).isActive =  true
        myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        
        
        //if i == 0{
        
        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        
        //        }else{
        //
        //            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
        //            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        //            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        //
        //        }
        
        
        heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        heightConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< sample_name.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  sample_name[i]
            myLabel.numberOfLines = 0
            myLabel.textColor = AppColorClass.colorPrimaryDark
            //myLabel.backgroundColor = .gray
            
            
            let myLabel2 = UILabel()
            myStackView.addSubview(myLabel2)
            myLabel2.translatesAutoresizingMaskIntoConstraints = false
            myLabel2.numberOfLines = 0
            //myLabel2.backgroundColor = .lightGray
            myLabel2.textAlignment = .center
            myLabel2.textColor = AppColorClass.colorPrimaryDark
            myLabel2.text =  sample_qty[i]
            
            let myLabel3 = UILabel()
            myStackView.addSubview(myLabel3)
            myLabel3.translatesAutoresizingMaskIntoConstraints = false
            myLabel3.numberOfLines = 0
            //myLabel3.backgroundColor = .red
            myLabel3.textAlignment = .center
            myLabel3.textColor = AppColorClass.colorPrimaryDark
            myLabel3.text =  sample_pob[i]
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            
            
            myLabel3.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel3.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
            myLabel3.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel2.rightAnchor.constraint(equalTo: myLabel3.leftAnchor ).isActive =  true
            myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            
            //            if i == 0{
            //
            //                myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
            //                myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            //                myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            //
            //            }else{
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            
            //}
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            heightConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            previousStackView = myinnerStackView
            
            
        }
        
        
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
        
        
        
    }
    
    
    func RemoveAllviewsinProduct(myStackView : UIView){
        while( myStackView.subviews.count > 0 ) {
            myStackView.subviews[0].removeFromSuperview()
        }
    }
    
    func ShowDrSampleGift( gift_name : [String],  gift_qty : [String]  , myStackView : UIView){
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        // var stackViewHeightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Gift"
        myLabel.numberOfLines = 0
        myLabel.font = myLabel.font.withSize(13)
        myLabel.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel.textColor = .white
        
        
        let myLabel2 = UILabel()
        myStackView.addSubview(myLabel2)
        myLabel2.translatesAutoresizingMaskIntoConstraints = false
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel2.font = myLabel2.font.withSize(13)
        myLabel2.textAlignment = .center
        myLabel2.textColor = .white
        myLabel2.text =  "Qty."
        
        
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
        myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        
        
        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        
        
        
        heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< gift_name.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  gift_name[i]
            myLabel.numberOfLines = 0
            myLabel.textColor = AppColorClass.colorPrimaryDark
            //myLabel.backgroundColor = .gray
            
            
            let myLabel2 = UILabel()
            myStackView.addSubview(myLabel2)
            myLabel2.translatesAutoresizingMaskIntoConstraints = false
            myLabel2.numberOfLines = 0
            //myLabel2.backgroundColor = .lightGray
            myLabel2.textAlignment = .center
            myLabel2.textColor = AppColorClass.colorPrimaryDark
            myLabel2.text =  gift_qty[i]
            
            
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
            myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            
            
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            
            previousStackView = myinnerStackView
            
        }
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
    }
    
    
    func Doc_Detail( titleName : [String],  itemName : [String]  , myStackView : UIView){
        myStackView.backgroundColor = UIColor.white
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
        
        
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        
        
        
        if itemName.count == 0{
            myStackView.superview?.isHidden = true
        }else {
            
            
            let lineView = UIView()
            myinnerStackView.addSubview(lineView)
            lineView.backgroundColor = AppColorClass.colorPrimaryDark
            lineView.isHidden = false
            lineView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            lineView.topAnchor.constraint(equalTo: myStackView.topAnchor , constant : 0).isActive = true
            lineView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            
            myinnerStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor , constant : 5).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            heightConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            heightConstraint.isActive =  true
            
            
            
            myStackView.superview?.isHidden = false
        }
        
        
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< titleName.count{
            
            if itemName[i] != ""{
                
                
                let myLabel = UILabel()
                myLabel.translatesAutoresizingMaskIntoConstraints = false
                myStackView.addSubview(myLabel)
                myLabel.text =  titleName[i]
                myLabel.numberOfLines = 0
                myLabel.textColor = UIColor.black
                myLabel.font =  UIFont.boldSystemFont(ofSize: 14.0)
                //myLabel.backgroundColor = .gray
                
                
                let myLabel2 = UILabel()
                myStackView.addSubview(myLabel2)
                myLabel2.translatesAutoresizingMaskIntoConstraints = false
                myLabel2.numberOfLines = 0
                //myLabel2.backgroundColor = .lightGray
                myLabel2.textAlignment = .right
                myLabel2.textColor = UIColor.black
                myLabel2.font = UIFont(name:"HelveticaNeue", size: 14.0)
                myLabel2.text =  itemName[i]
                
                
                
                let myinnerStackView = UIStackView()
                myinnerStackView.axis =  .horizontal
                myStackView.addSubview(myinnerStackView)
                myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
                
                
                myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor ).isActive =  true
                myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor , constant : -5).isActive =  true
                myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ).isActive = true
                
                myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
                myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor ).isActive =  true
                myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ).isActive = true
                
                
                
                myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
                myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
                myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
                
                
                
                heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
                heightConstraint.isActive =  true
                
                
                previousStackView = myinnerStackView
                
            }
        }
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor , constant : -5).isActive =  true
        
    }
    
    
    
    private func workWithDetails(workWith: [String], myStackView : UIView ){
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        var previousStackView : UIStackView!
        
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        
        if workWith[0] == ""{
            myStackView.superview?.isHidden = true
        }else {
            let lineView = UIView()
            myinnerStackView.addSubview(lineView)
            lineView.backgroundColor = AppColorClass.colorPrimaryDark
            lineView.isHidden = false
            lineView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            lineView.topAnchor.constraint(equalTo: myStackView.topAnchor , constant : 0).isActive = true
            lineView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            
            myinnerStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor , constant : 5).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            heightConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            heightConstraint.isActive =  true
            
            myStackView.superview?.isHidden = false
        }
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Work-with"
        myLabel.numberOfLines = 0
        myLabel.font = UIFont.boldSystemFont(ofSize: 13)
        myLabel.textColor = .black
        
        
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        
        
        //        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
        //        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        //        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        previousStackView = myinnerStackView
        
        heightConstraint = NSLayoutConstraint(item: myLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        widthConstraint = NSLayoutConstraint(item: myLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        
        
        
        for i in 0 ..< workWith.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  workWith[i]
            myLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
            myLabel.numberOfLines = 0
            myLabel.textColor = .black
            //myLabel.backgroundColor = .gray
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor , constant : -5).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor , constant : 5).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor ).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            previousStackView = myinnerStackView
            
        }
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
        
    }
    
}
