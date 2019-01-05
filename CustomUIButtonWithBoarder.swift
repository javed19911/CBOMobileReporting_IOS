//
//  CustomUIButtonWithBoarder.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 08/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
@IBDesignable
class CustomUIButtonWithBoarder: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = AppColorClass.colorPrimary?.cgColor
        }
    }
    //Normal state bg and border
    @IBInspectable var BorderColor: UIColor? {
        didSet {

                layer.borderColor = BorderColor?.cgColor
        }
    }
    
    @IBInspectable var radius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }

   
}
