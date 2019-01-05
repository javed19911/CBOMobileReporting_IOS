//
//  Route_Adaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//
import UIKit
import Foundation
class Route_Adaptor : CheckBoxDelegate {
    func onChackedChangeListner(sender: CheckBox, ischecked: Bool) {
            checked = false
            let tag = sender.getTag() as! [Int]
            let from =  tag[0]
            let index = tag[1]
            switch from {
            case 0:
                selectedPosition = index
                tableView.reloadData()
                name = list[index].getName()
                id = list[index].getId()
                break
            case 1:
                list[index].setindependentSelected(independent_list: ischecked);
                break
            default:
                print ("no tag assigned")
            }
      
    }
    
    var vc : CustomUIViewController!
    var list : [DCR_Workwith_Model]!
    var name = ""
    var id = ""
    var checked = true
    var selectedPosition = -1
    var tableView : UITableView!
    init(vc : CustomUIViewController, tableView : UITableView, list : [DCR_Workwith_Model]) {
        self.vc = vc
        self.list = list
        self.tableView = tableView
        tableView.separatorStyle = .none
    }
    
    
    
    
    
    func getView(index : Int) -> WorkWithRow {
        let cell = Bundle.main.loadNibNamed("WorkWithRow", owner: vc, options: nil)?.first as? WorkWithRow
        cell?.btnWorkWith.tag = index
        cell?.selectionStyle = .none
        //cell?.btnWorkWith.addTarget(self, action: #selector(Word_With_Adaptor.btnWorkWithPressed), for: .touchUpInside)
        cell?.workWithLabel.numberOfLines = 0
        cell?.workWithLabel.text = list[index].getName()
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        
        cell?.btnIndep.delegate = self
        cell?.btnWorkWith.delegate = self
        cell?.btnIndep.setTag(tag: [1,index] )
        cell?.btnWorkWith.setTag(tag: [0,index])
        cell?.btnIndep.isHidden = true
        cell?.btnWorkWith.setChecked(checked: index == selectedPosition)
        return cell!
    }
    

    
}

