//
//  MyAdapter.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 18/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
import UIKit
import Foundation
class MyAdapter : CheckBoxDelegate,CustomTextViewDelegate {
    func onTextChangeListner(sender: CustomTextView, text: String) {
        let tag = sender.getTag() as! [Any]
        let from =  tag[0] as! Int
        let index = tag[1] as! Int
        let cell = tag[2] as! SamplePOBTableViewCell
        switch from {
        case sample_tag:
            list[index].setSample(sample: text)
            if(text == "" && list[index].getScore() == ""  && !list[index].isSelected()) {
                list[index].setSelected(selected: false);
            }else {
                list[index].setSelected(selected: true);
            }
            cell.Promoted.setChecked(checked: list[index].isSelected());
            break
        case pob_tag:
            let element  = list[index];
            if(element.getBalance() >=  Int(text.isEmpty ? "0" : text)!  || !DCRGIFT_QTY_VALIDATE.contains( AdaptorType == "GIFT" ? "G" : "S")) {
              element.setScore(score: text)
            }else{
                
                vc.customVariablesAndMethod1.getAlert(vc: vc,title: "Out Of Stock!!!",
                                                  msg:  "Only \( element.getBalance() ) is available in the Stock") {_ in
                                                     element.setScore(score:"\(element.getBalance())");
                                                     cell.POB_txt.setText(text: "\(element.getBalance())");
                                                   };
            }
            
            
            if(text == "" && element.getSample() == ""  && !element.isSelected()) {
                element.setSelected(selected: false);
            }else {
                element.setSelected(selected: true);
            }
             cell.Promoted.setChecked(checked: element.isSelected());
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
    var list : [GiftModel]!
    var name = ""
    var id = ""
    var checked = true
    var selectedPosition = -1
    var tableView : UITableView!
    var AdaptorType = "",DCRGIFT_QTY_VALIDATE = ""
    
    let promoted_tag = 0,sample_tag = 1,pob_tag = 2
    
    
    
    
    init(vc : CustomUIViewController, tableView : UITableView, list : [GiftModel]) {
        self.vc = vc
        self.list = list
        self.tableView = tableView
        DCRGIFT_QTY_VALIDATE = vc.customVariablesAndMethod1.getDataFrom_FMCG_PREFRENCE(vc: vc,key: "DCRGIFT_QTY_VALIDATE",defaultValue: "");
    }
    
    init(vc : CustomUIViewController, tableView : UITableView, list : [GiftModel], AdaptorType : String) {
        self.vc = vc
        self.list = list
        self.tableView = tableView
        self.AdaptorType = AdaptorType
        DCRGIFT_QTY_VALIDATE = vc.customVariablesAndMethod1.getDataFrom_FMCG_PREFRENCE(vc: vc,key: "DCRGIFT_QTY_VALIDATE",defaultValue: "");
    }
    
    
    
    
    func getView(index : Int) -> SamplePOBTableViewCell {
        let cell = Bundle.main.loadNibNamed("SamplePOBTableViewCell", owner: vc, options: nil)?.first as! SamplePOBTableViewCell
        
        cell.selectionStyle = .none
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        
        cell.Sample_txt.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
        cell.Sample_txt.setHint(placeholder: "Sample")
        //cell.textViewLeft.setSecureTextEnable(enable: true)
        cell.POB_txt.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
        cell.POB_txt.setHint(placeholder: "POB")
        
        
        cell.NOC_txt.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
        cell.NOC_txt.setHint(placeholder: "NOC")
        
        switch AdaptorType {
        case "GIFT":
            cell.POB_txt.setHint(placeholder: "QTY")
            cell.NOC_txt.isHidden = true
            cell.Sample_txt.isHidden = true
            cell.Promoted.isHidden = true
            cell.Pescribed.isHidden = true
        default:
           cell.NOC_txt.isHidden = true
        }
        
        
        cell.Name_txt.text = list[index].getName()
        
        
        
        cell.Promoted.delegate = self
        cell.Promoted.setTag(tag: [promoted_tag,index,cell] )
        cell.Sample_txt.delegate = self
        cell.Sample_txt.setTag(tag: [sample_tag,index,cell] )
        cell.POB_txt.delegate = self
        cell.POB_txt.setTag(tag: [pob_tag,index,cell] )


        
       
    
        cell.POB_txt.setText(text: list[index].getScore());
        cell.Sample_txt.setText(text: list[index].getSample());
        cell.Promoted.setChecked(checked: list[index].isSelected());
        if (list[index].isHighlighted()){
            cell.Name_txt.textColor = UIColor(hex: "FF8333");
        }else {
            cell.Name_txt.textColor = UIColor(hex: "000000");
        }
        
        return cell
    }
    

    
    
}

