//
//  Remark_Dialog.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 22/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
class Remark_Dialog{
    
    let vc : CustomUIViewController!
    let List : [String]
    let responseCode : Int!
    let title : String
    
    init(vc : CustomUIViewController ,title : String,  List : [String]  , responseCode : Int ) {
        self.vc = vc
        self.List = List
        self.title = title
        self.responseCode = responseCode
    }
    
    
    
    func show(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "Remark") as! Remark
        myviewcontroller.vc = vc
        myviewcontroller.VCIntent["title"] = title
        myviewcontroller.List = List
        myviewcontroller.responseCode = responseCode
        vc.present(myviewcontroller, animated: true, completion:  nil)
    }
    
    
}
