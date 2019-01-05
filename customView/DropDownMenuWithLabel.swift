//
//  DropDownMenuWithLabel.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 18/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DropDownMenuWithLabel: UIView {

    var SelfObj : DropDownMenuWithLabel!
    
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var dropDownMenu: DPDropDownMenu!
    @IBOutlet var view: UIView!
    
  
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("DropDownMenuWithLabel", owner: self, options: nil)
        self.addSubview(view)
        SelfObj = self
        view.frame = self.bounds

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable public var leftTitleText: String = "Header" {
        didSet {
           
            leftTitle.text = leftTitleText
        }
    }

    
    @IBInspectable public var leftTitleTextFont: CGFloat = 15 {
        didSet {
            leftTitle.font = leftTitle.font.withSize(leftTitleTextFont)
        }
    }
    
    @IBInspectable public var spaces: Int = 0 {
        didSet {
            let space = " "
            for i in 0 ... spaces{
                leftTitleText += space
            }
            
            leftTitle.text = leftTitleText
        }
    }
    
    
}
