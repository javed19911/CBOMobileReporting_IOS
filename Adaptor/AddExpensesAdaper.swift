//
//  AddExpensesAdaper.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 15/05/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation

protocol AddExpensesAdaperDalegate  {
    func onEdit(id : String , name : String)
    func onDelete(id : String , name: String)
}


class AddExpensesAdaper : NSObject , UITableViewDelegate , UITableViewDataSource {
    
    
    var delegate : AddExpensesAdaperDalegate?
    var data = [[String:String]]()
    var tableView : UITableView!
    var vc: CustomUIViewController!
    
    
    init(data : [[String:String]] , tableView : UITableView , vc : CustomUIViewController) {
        
        self.vc = vc
        self.tableView = tableView
        self.data = data
        self.tableView.rowHeight = UITableViewAutomaticDimension
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AnotherExpensesRow1", owner: self, options: nil)?.first as! AnotherExpensesRow1
        cell.selectionStyle = .none
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        
        cell.hed.text = data[indexPath.row]["exp_head"]
        cell.hed.textColor = AppColorClass.colorPrimaryDark
        
        cell.slashView.backgroundColor = AppColorClass.colorPrimaryDark
        cell.amount.text = data[indexPath.row]["amount"]
        cell.Remark.text = data[indexPath.row]["remark"]
        cell.attached.isHidden = (data[indexPath.row]["FILE_NAME"] == "") ? true : false
        
        cell.editButton.addTarget(self, action: #selector(pressedEditButton(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.editButton.descriptiveName = data[indexPath.row]["exp_head_id"]
        
        cell.deleteButton.descriptiveName = data[indexPath.row]["ID"]
        
        cell.deleteButton.addTarget(self, action: #selector(pressedDeleteButton(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func pressedEditButton(sender : UIButton){
        
//        print(sender.tag , sender.descriptiveName!)
        delegate?.onEdit(id: "\(sender.tag)", name: sender.descriptiveName!)

    }
    
 
    @objc func pressedDeleteButton(sender : UIButton){
        delegate?.onDelete(id: "\(sender.tag)", name:sender.descriptiveName!)
    }
    
    
}
