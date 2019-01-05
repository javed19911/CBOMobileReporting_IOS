//
//  CustomFieldWithborader.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 27/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//
import UIKit

protocol CustomFieldLeftButton {
    func onClickLeftButton(sender : CustomFieldWithborader )
}

protocol CustomFieldRightButton {
    func onClickRightButton(sender : CustomFieldWithborader)
}

class  CustomFieldWithborader : UITextField{
   
    var delegateLeft : CustomFieldLeftButton!
    var delegateRight : CustomFieldRightButton!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.doneAccessory = true
        updateView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.doneAccessory = true
        updateView()
    }
    
   
    
    override func draw(_ rect: CGRect) {
        //            let darkGrey = UIColor(hexNum: 23323323 , alpha: 1.0)
        let lightGrey =  BorderColor
        //  let lightGreyRect = UIBezierPath(rect: rect)
        
        
        self.layer.borderColor = lightGrey.cgColor
        self.layer.borderWidth = borderWidgth
        self.layer.cornerRadius = CornerRadius
        
        lightGrey.setFill()
       
    }
    
    
    @IBInspectable var BorderColor : UIColor = AppColorClass.colorPrimary!{
        didSet{
            updateView()
        }
    }

    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += rightPadding
        return textRect
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var rightPadding : CGFloat = -5
    
    @IBInspectable var rightSlashW : CGFloat = 1{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var rightButton: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightButtonImage : UIImage?{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var rightSlashColor : UIColor = .black{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftButton : Bool = false {
        didSet{
            updateView()
        }
    }

    @IBInspectable var leftButtonImage : UIImage?{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftSlashColor : UIColor = .black{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftSlashW: CGFloat = 1{
        didSet{
            updateView()
        }
    }
  

    @IBInspectable var leftPadding: CGFloat = 5
   

    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var borderWidgth : CGFloat = 0
    @IBInspectable var CornerRadius : CGFloat = 0
    

    
    func createButton() -> CGRect{
        return CGRect(x: 0, y: 3, width: frame.height  , height: frame.height - 5)
    }
    
    
    func updateView() {
     
        self.layer.borderColor = BorderColor.cgColor
        self.layer.borderWidth = borderWidgth
        self.layer.cornerRadius = CornerRadius
      
        if leftButton == true{
            let button = UIButton(frame:createButton())
            button.setImage(leftButtonImage, for: .normal)
            button.layer.borderColor = UIColor.clear.cgColor
            leftViewMode = UITextFieldViewMode.always
            leftView = button
            
             let slashLeft = UIView(frame: CGRect(x: button.frame.width , y: 1.0, width: leftSlashW, height: self.frame.size.height - 8))
                slashLeft.backgroundColor = leftSlashColor
              leftView?.addSubview(slashLeft)
            button.addTarget(self, action: #selector(pressedLeftClick), for: .touchUpInside)
            
            
            
        } else if rightButton == true{
            let button = UIButton(frame: createButton())
            button.setImage(rightButtonImage, for: .normal)
             button.layer.borderColor = UIColor.clear.cgColor
            rightViewMode = UITextFieldViewMode.always
            rightView = button
            
            let slashRight = UIView(frame: CGRect(x: 0 , y: 1.0, width: rightSlashW, height: self.frame.size.height - 8))
            slashRight.backgroundColor = rightSlashColor
              rightView?.addSubview(slashRight)
            
            button.addTarget(self, action: #selector(pressedRighttClick), for: .touchUpInside)
        }
    }
    
    func setKeyBoardType(keyBoardType: UIKeyboardType){
        self.keyboardType = keyBoardType
    }
    
    
    func setSecureTextEnable(enable: Bool){
        self.isSecureTextEntry = enable
    }
    
    
    @objc func pressedLeftClick(){
        delegateLeft.onClickLeftButton(sender: self)
    }

    @objc func pressedRighttClick(){
        delegateRight.onClickRightButton(sender: self)
    }
    



//        // Placeholder text color
//        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
//
//
}


extension UITextField{
    
    @IBInspectable  var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    public func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

//extension CustomFieldWithborader{
//
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
//        }
//    }
//
//
//}

    

