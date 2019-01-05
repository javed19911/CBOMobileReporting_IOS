//
//  Work_With_Dialog.swift
//  stackviewtest
//
//  Created by CBO IOS on 02/01/18.
//  Copyright © 2018 CBO IOS. All rights reserved.
//
import UIKit
import Foundation
class Area_Dialog{
    
    let vc : CustomUIViewController!
    let msg : [String: String]
    let responseCode : Int!
    var  who = "DCR"
    init(vc : CustomUIViewController ,  msg : [String : String]  , responseCode : Int ) {
        self.vc = vc
        self.msg = msg
        self.responseCode = responseCode
        
    }
    
    init(vc : CustomUIViewController ,  msg : [String : String]  , responseCode : Int , who : String) {
        self.vc = vc
        self.msg = msg
        self.responseCode = responseCode
        self.who = who
        
    }
    
    func show(){
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "Area_DialogViewController") as! Area_DialogViewController
        myviewcontroller.vc = vc
        myviewcontroller.msg = msg
        myviewcontroller.responseCode = responseCode
        myviewcontroller.who = who
        
        vc.present(myviewcontroller, animated: true, completion:  nil)
        
        
    }
    
    
}


