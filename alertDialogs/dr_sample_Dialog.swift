//
//  dr_sample_Dialog.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 24/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
class dr_sample_Dialog{
    
    let vc : CustomUIViewController!
    let responseCode : Int!
    var sample_name="",sample_pob="",sample_sample="",sample_noc = "";
    var sample_name_previous="",sample_pob_previous="",sample_sample_previous="";
    
    
    init(vc : CustomUIViewController , responseCode : Int,  sample_name : String ,sample_pob : String ,sample_sample : String,sample_noc :String) {
        self.vc = vc
        self.responseCode = responseCode
        self.sample_name = sample_name
        self.sample_pob = sample_pob
        self.sample_sample = sample_sample
        self.sample_noc = sample_noc
    }
    
    func setPrevious(sample_name_previous : String ,sample_pob_previous : String ,sample_sample_previous : String)-> dr_sample_Dialog {
        self.sample_name_previous = sample_name_previous
        self.sample_pob_previous = sample_pob_previous
        self.sample_sample_previous = sample_sample_previous
        return self
    }
    
    
    func show(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "dr_Sample") as! dr_Sample
        myviewcontroller.VCIntent["intent_fromRcpaCAll"] = "Dr"
        myviewcontroller.VCIntent["sample_name"] = sample_name
        myviewcontroller.VCIntent["sample_pob"] = sample_pob
        myviewcontroller.VCIntent["sample_sample"] = sample_sample
         myviewcontroller.VCIntent["sample_noc"] = sample_noc
        
        myviewcontroller.VCIntent["sample_name_previous"] = sample_name_previous
        myviewcontroller.VCIntent["sample_pob_previous"] = sample_pob_previous
        myviewcontroller.VCIntent["sample_sample_previous"] = sample_sample_previous

    
        myviewcontroller.vc = vc
        myviewcontroller.responseCode = responseCode
        vc.present(myviewcontroller, animated: true, completion:  nil)
    }
    
    
}
