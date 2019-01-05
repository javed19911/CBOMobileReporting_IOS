//
//  Call_Dialog.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 17/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
class Call_Dialog{
    let vc : CustomUIViewController!
    let dr_List : [SpinnerModel]
    let responseCode : Int!
    var callTyp  = "D"
    let title : String
    
    init(vc : CustomUIViewController ,title : String,  dr_List : [SpinnerModel]  ,callTyp : String , responseCode : Int ) {
        self.vc = vc
        self.dr_List = dr_List
        self.responseCode = responseCode
        self.callTyp = callTyp
        self.title = title
    }
    
    
    
    func show(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "CallListVC") as! CallListVC
        myviewcontroller.vc = vc
        myviewcontroller.VCIntent["title"] = title
        myviewcontroller.dr_List = dr_List
        
        myviewcontroller.responseCode = responseCode
        myviewcontroller.callTyp = callTyp
        vc.present(myviewcontroller, animated: true, completion:  nil)
    }
    
    
}
