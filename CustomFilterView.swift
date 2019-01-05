//
//  CustomFilterView.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 26/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
@IBDesignable
class CustomFilterView: UIView {

    var context : CustomUIViewController!
    var response : Int!
    var items = [DPItem]()
    @IBOutlet var view: UIView!
    @IBOutlet weak var lbl_Header: UILabel!
    
    @IBOutlet weak var slash_View: UIView!
    
    @IBOutlet weak var tap_Button: UIButton!
    var SelfObj : CustomFilterView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setuUp()
    }
    
    func setuUp(){
        Bundle.main.loadNibNamed("CustomFilterView", owner: self, options: nil)
        self.addSubview(view)
        SelfObj = self
        view.frame = self.bounds
        lbl_Header.textColor = AppColorClass.colorPrimary
        layer.borderColor = AppColorClass.colorPrimary?.cgColor
       

    }
    
    
    func setHeaderText( headerText : String ){
        lbl_Header.text = headerText
    }
    
    override func awakeFromNib() {
        
        tap_Button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = AppColorClass.colorPrimary?.cgColor
        if cornerRadius == 0{
            self.layer.cornerRadius =  CGFloat(2)
        }else {
            self.layer.cornerRadius =  CGFloat(cornerRadius)
        }
        if boarderWidth == 0{
            self.layer.borderWidth =  CGFloat(2)
        }else {
            self.layer.borderWidth =  CGFloat(boarderWidth)
        }
        
        
    }
    
    @objc func tapOnButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterView") as! FilterView
        
        vc.VCIntent["title"] = "Select..."
        vc.vc = context
        vc.items = items
        vc.responseCode = response
        context.present(vc, animated: true, completion: nil)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    
    @IBInspectable var boarderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = boarderWidth
        }
    }

}
