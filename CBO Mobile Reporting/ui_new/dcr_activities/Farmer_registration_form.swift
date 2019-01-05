//
//  Farmer_registration_form.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 13/10/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation

class Farmer_registration_form : CustomUIViewController{
    
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressHUD = ProgressHUD(vc : self)
        customVariablesAndMethod1.betteryCalculator()
        myTopView.backButton.addTarget(self, action: #selector(pressedBack), for: .touchUpInside )
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
    }
    
    @objc func pressedBack(){
        myTopView.CloseCurruntVC(vc: self)
    }
}
