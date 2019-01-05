//
//  Word_With_Adaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//
import UIKit
import Foundation
class Word_With_Adaptor : CheckBoxDelegate{
    func onChackedChangeListner(sender: CheckBox, ischecked: Bool) {
        let tag = sender.getTag() as! [Int]
        
            
        let from =  tag[0]
        let index = tag[1]
        switch from {
        case 0:
             if (list[index].getResigYN() == ("0")) {
                list[index].setSelected(selected: ischecked);
                if( list[index].isindependentSelected()){
                    list[index].setindependentSelected(independent_list: false);
                }
                tableView.reloadData()
             }else if(ischecked){
                var title = "Vacant";
            
                if (!list[index].getName().lowercased().contains("vacant")){
                    title = "Resigned";
                }
                customVariablesAndMethod.getAlert(vc: vc,title: title,
                                                  msg: list[index].getName() + " is vacant Hq\nYou can only work as Independent..") {_ in
                                                    self.list[index].setSelected(selected: false);
                                                    self.self.list[index].setindependentSelected(independent_list: true);
                                                    self.tableView.reloadData()
                };
             }
            break
        case 1:
            
            
            if (list[index].getLeaveYN() == ("1")) {
                list[index].setindependentSelected(independent_list: ischecked);
                if(list[index].isSelected()){
                    list[index].setSelected(selected: false);
                }
                
                tableView.reloadData()
            }else if (checked){
                
                let title = "Not on Leave...";
                customVariablesAndMethod.getAlert(vc: vc,title: title,
                                                  msg: list[index].getName() + " is \n"+title+"\nYou cannot work as Independent..") {_ in
                                                    self.list[index].setSelected(selected: true);
                                                    self.self.list[index].setindependentSelected(independent_list: false);
                                                    self.tableView.reloadData()
                };
        
            }
            break
        default:
            print ("no tag assigned")
        }
    }

    
    var vc : CustomUIViewController!
    var list : [DCR_Workwith_Model]!
    var checked = true
    var selected_list = [String]()
    var independent_list = [String]()
    var show_independent = false
    var tableView : UITableView!
    var customVariablesAndMethod : Custom_Variables_And_Method!
    
    init(vc : CustomUIViewController, tableView : UITableView, list : [DCR_Workwith_Model]) {
        self.vc = vc
        self.list = list
        self.tableView = tableView
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
    }
    
    init(vc : CustomUIViewController,  list : [DCR_Workwith_Model], tableView : UITableView, selected_list : [String], independent_list :  [String]) {
        self.vc = vc
        self.list = list
        self.selected_list = selected_list
        if(Custom_Variables_And_Method.pub_desig_id != "\(1)") {
            self.independent_list = independent_list
            show_independent = true
        }
        self.tableView = tableView
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
    }
    
    init(vc : CustomUIViewController, tableView : UITableView, list : [DCR_Workwith_Model], selected_list : [String] ) {
        self.vc = vc
       
        self.selected_list = selected_list
        self.tableView = tableView
        for index in 0 ..< list.count{
            if (selected_list.contains(list[index].getName()) && !independent_list.contains(list[index].getName()) ){
                list[index].setSelected(selected: true)
            }
            
            if (independent_list.contains(list[index].getName()) ){
                list[index].setindependentSelected(independent_list: true)
            }
        }
        
         self.list = list
    }
  
    func getView(index : Int) -> WorkWithRow {
        let cell = Bundle.main.loadNibNamed("WorkWithRow", owner: vc, options: nil)?.first as? WorkWithRow
        //cell?.btnWorkWith.tag = index
       
//        cell?.btnWorkWith.addTarget(self, action: #selector(Word_With_Adaptor.btnWorkWithPressed), for: .touchUpInside)
    
        cell?.workWithLabel.numberOfLines = 0
        cell?.workWithLabel.text = list[index].getName()
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        
        cell?.btnIndep.delegate = self
        cell?.btnWorkWith.delegate = self
        cell?.btnIndep.setTag(tag: [1,index] )
        cell?.btnWorkWith.setTag(tag: [0,index])
        
        cell?.selectionStyle = .none
        
        cell?.btnWorkWith.setChecked(checked: list[index].isSelected())
        
        if show_independent {
            cell?.btnIndep.isHidden = false
            cell?.btnIndep.setChecked(checked: list[index].isindependentSelected())
        }else{
            cell?.btnIndep.isHidden = true
        }
        
        return cell!
    }
  
    
}
