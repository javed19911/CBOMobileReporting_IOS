//
//  Work_With_Dialog.swift
//  stackviewtest
//
//  Created by CBO IOS on 02/01/18.
//  Copyright © 2018 CBO IOS. All rights reserved.
//
import UIKit
import Foundation
class Work_With_Dialog{
   
    let vc : CustomUIViewController!
    let msg : [String: String]
    let responseCode : Int!
    
    init(vc : CustomUIViewController ,  msg : [String : String]  , responseCode : Int ) {
        self.vc = vc
        self.msg = msg
        self.responseCode = responseCode

    }
    
   

    func show(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "Work_with_ViewController") as! Work_with_ViewController
        myviewcontroller.vc = vc
        myviewcontroller.msg = msg
        myviewcontroller.responseCode = responseCode
        vc.present(myviewcontroller, animated: true, completion:  nil)
    }
    

}





