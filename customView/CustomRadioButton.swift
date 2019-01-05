//
//  CustomRadioButton.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 24/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
class CustomRadioButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        radioButtonCircle = UIView()
    }
    let btnFont = "System"
    
    var radioButtonCircle : UIView!{
        didSet{
            radioButtonCircle = UIView()
            radioButtonCircle.frame = CGRect(x:-6, y: 0, width: self.frame.height, height: self.frame.height)
            radioButtonCircle.layer.cornerRadius = self.frame.height/2

        }
    }
    
    @IBInspectable var radioButtonTitle : String = "RadioButton"{
        didSet {
            self.setTitle(radioButtonTitle, for: .normal)
        }
    }
    @IBInspectable var titleSize : Int = 10{
        didSet {
            self.titleLabel?.font = UIFont(name: btnFont , size: CGFloat(titleSize))
        }
    }
    
   
    
    @IBInspectable var Bold : Bool = false{
        didSet {
            if Bold == true {
                self.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(titleSize))
            }
        }
    }
    
    @IBInspectable var Color : UIColor = .black{
        didSet{
            radioButtonCircle.layer.borderColor = Color.cgColor
        }
    }
    
    @IBInspectable var widthSize : CGFloat = 0{
        didSet{
            radioButtonCircle.layer.borderWidth  = widthSize
        }
    }
    
    
    var radioButtonCircleFilling : UIView!{
        didSet{
            radioButtonCircleFilling.backgroundColor = Color
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        radioButtonCircle = UIView()
    }
    
    func setText(text : String){
        self.setTitle(text, for: .normal)
    }
    func getText() -> String{
        return self.title(for: .normal)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        
        //        let gradientColor1 = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1).cgColor
        //        let gradientColor2 = UIColor(red: 42.0 / 255.0, green: 63.0 / 255.0, blue: 122.0 / 255.0, alpha: 1).cgColor
        
       
        let bthWidth = frame.width
        let btnHeight = frame.height
        
        
        self.frame.size = CGSize(width: bthWidth, height: btnHeight)
        self.frame.origin = CGPoint(x: (((superview?.frame.width)! / 2) - (self.frame.width / 2)), y: self.frame.origin.y)
        
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true

        self.backgroundColor = .white

        self.addSubview(radioButtonCircle)

    }

}
