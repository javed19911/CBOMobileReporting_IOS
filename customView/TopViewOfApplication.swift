//
//  TopViewOfApplication.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class TopViewOfApplication: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
   
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var rightButton1: UIButton!
    
    @IBOutlet weak var rightButton2: UIButton!
    
    @IBOutlet weak var rightButton3: UIButton!
    
    
   
    func setText(title : String){
        self.title.text = title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("TopViewOfApplication", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        //view.backgroundColor =  AppColorClass.colorPrimary
    
        view.layer.shadowRadius = 3.0
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.backgroundColor =  AppColorClass.colorPrimary

        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func CloseCurruntVC(vc : CustomUIViewController)  {
        vc.dismiss(animated: true, completion: nil)
    }
    func CloseAllVC(vc : CustomUIViewController)  {
        vc.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    

    func CloseCurruntVC(vc : CustomUIViewController, compilation : () -> Void)  {
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    
}
