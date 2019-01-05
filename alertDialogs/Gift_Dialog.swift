//
//  Gift_Dialog.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 25/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
class Gift_Dialog{
    
    let vc : CustomUIViewController!
    let responseCode : Int!
    var gift_name="",gift_qty="",gift_typ = "chem"
    var gift_name_previous = "",gift_qty_previous = ""
    
    init(vc : CustomUIViewController , responseCode : Int ,  gift_name : String ,gift_qty : String,gift_typ : String
        ,gift_name_previous : String , gift_qty_previous : String) {
        self.vc = vc
        self.responseCode = responseCode
        self.gift_name = gift_name
        self.gift_qty = gift_qty
        self.gift_typ = gift_typ
        self.gift_qty_previous = gift_qty_previous
        self.gift_name_previous = gift_name_previous
    }
    
    
    
    func show(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "Chem_Gift") as! Chem_Gift
        myviewcontroller.VCIntent["intent_fromRcpaCAll"] = "Chemist"
        myviewcontroller.VCIntent["gift_name"] = gift_name
        myviewcontroller.VCIntent["gift_qty"] = gift_qty
        myviewcontroller.VCIntent["gift_typ"] = gift_typ
        
        myviewcontroller.VCIntent["gift_name_previous"] = gift_name_previous
        myviewcontroller.VCIntent["gift_qty_previous"] = gift_qty_previous
        
        myviewcontroller.vc = vc
        myviewcontroller.responseCode = responseCode
        vc.present(myviewcontroller, animated: true, completion:  nil)
    }
    
    
}

