//
//  PobAdapter.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 24/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//


import Foundation
import UIKit
import Foundation
class PobAdapter : CheckBoxDelegate,CustomTextViewDelegate {
    func onTextChangeListner(sender: CustomTextView, text: String) {
        let tag = sender.getTag() as! [Any]
        let from =  tag[0] as! Int
        let index = tag[1] as! Int
        let cell = tag[2] as! SamplePOBTableViewCell
        switch from {
        case sample_tag:
            list[index].setScore(score: text)
            if(text == "" && list[index].getPob() == ""  && !list[index].isSelected()) {
                list[index].setSelected(selected: false);
            }else {
                list[index].setSelected(selected: true);
            }
            cell.Promoted.setChecked(checked: list[index].isSelected());
            break
        case pob_tag:
            list[index].setPob(pob: text)
            if(text == "" && list[index].getScore() == ""  && !list[index].isSelected()) {
                list[index].setSelected(selected: false);
            }else {
                list[index].setSelected(selected: true);
            }
            cell.Promoted.setChecked(checked: list[index].isSelected());
            break
        default:
            print ("no tag assigned")
        }
    }
    
    
    func onChackedChangeListner(sender: CheckBox, ischecked: Bool) {
        
        let tag = sender.getTag() as! [Any]
        let from =  tag[0] as! Int
        let index = tag[1] as! Int
        //let cell = tag[2] as! SamplePOBTableViewCell
        switch from {
        case promoted_tag:
            list[index].setSelected(selected: ischecked)
            break
        default:
            print ("no tag assigned")
        }
        
    }
    
    var vc : CustomUIViewController!
    var list : [PobModel]!
    var name = ""
    var id = ""
    var checked = true
    var selectedPosition = -1
    var tableView : UITableView!
    
    let promoted_tag = 0,sample_tag = 1,pob_tag = 2,noc_tag = 3,prescribed_tag = 4
    
    
    
    
    init(vc : CustomUIViewController, tableView : UITableView, list : [PobModel]) {
        self.vc = vc
        self.list = list
        self.tableView = tableView
    }
    
    
    
    
    
    func getView(index : Int) -> SamplePOBTableViewCell {
        let cell = Bundle.main.loadNibNamed("SamplePOBTableViewCell", owner: vc, options: nil)?.first as! SamplePOBTableViewCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        cell.selectionStyle = .none
        
        cell.Sample_txt.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
        cell.Sample_txt.setHint(placeholder: "Sample")
        //cell.textViewLeft.setSecureTextEnable(enable: true)
        cell.POB_txt.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
        cell.POB_txt.setHint(placeholder: "POB")
        
        
        cell.NOC_txt.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
        cell.NOC_txt.setHint(placeholder: "NOC")
        cell.NOC_txt.isHidden = true
        cell.Name_txt.text = list[index].getName()
        
        
        cell.Pescribed.delegate = self
        cell.Pescribed.setTag(tag: [prescribed_tag,index,cell] )
        cell.Promoted.delegate = self
        cell.Promoted.setTag(tag: [promoted_tag,index,cell] )
        cell.Sample_txt.delegate = self
        cell.Sample_txt.setTag(tag: [sample_tag,index,cell] )
        cell.POB_txt.delegate = self
        cell.POB_txt.setTag(tag: [pob_tag,index,cell] )
        cell.NOC_txt.delegate = self
        cell.NOC_txt.setTag(tag: [noc_tag,index,cell] )
        
        
        
        
        
        cell.POB_txt.setText(text: list[index].getPob());
        cell.Sample_txt.setText(text: list[index].getScore());
        cell.Promoted.setChecked(checked: list[index].isSelected());
        cell.NOC_txt.setText(text: list[index].getNOC());
        cell.Pescribed.setChecked(checked: list[index].isSelected_Rx());
        
        
        if (list[index].isHighlighted()){
            cell.Name_txt.textColor = UIColor(hex: "FF8333");
        }else if (list[index].isdr_item() == "0"){
            cell.Name_txt.textColor = UIColor(hex: "008333");
        }else {
            cell.Name_txt.textColor = UIColor(hex: "000000");
        }
        
        
        return cell
    }
    
    
    
    
}


