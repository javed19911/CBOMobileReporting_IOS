//
//  CheckBoxWithLabel.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 11/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit


protocol CheckBoxWithLabelDelegate : class {
    
    func onCheckedChangeListner(sender : CheckBoxWithLabel, ischecked : Bool);
}

class CheckBoxWithLabel: UIView ,CheckBoxDelegate{
    func onChackedChangeListner(sender: CheckBox, ischecked: Bool) {
        delegate?.onCheckedChangeListner(sender: self, ischecked: ischecked)
    }
    

  
    
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet var view: UIView!
    weak var delegate: CheckBoxWithLabelDelegate?
    
    
    
    func setText(text : String){
            myLabel.text = text
    }
    
    func isChecked() -> Bool {
        return checkBox.isChecked()
    }
    func setcheched(checked : Bool){
        self.checkBox.setChecked(checked: checked)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CheckBoxWithLabel", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        myLabel.text = ""
        
        checkBox.delegate = self
        
    }
}
