//
//  Chm_sample_Dialog.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 17/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
class Chm_sample_Dialog{
    
    let vc : CustomUIViewController!
    let dr_List : [SpinnerModel]
    let responseCode : Int!
    var showGeoFencing : Int = 0
    var sample_name="",sample_pob="",sample_sample="";
    var sample_name_previous="",sample_pob_previous="",sample_sample_previous="";
    
    init(vc : CustomUIViewController ,  dr_List : [SpinnerModel]  ,showGeoFencing : Int , responseCode : Int ,  sample_name : String ,sample_pob : String ,sample_sample : String) {
        self.vc = vc
        self.dr_List = dr_List
        self.responseCode = responseCode
        self.showGeoFencing = showGeoFencing
        self.sample_name = sample_name
        self.sample_pob = sample_pob
        self.sample_sample = sample_sample
    }
    
    
    func setPrevious(sample_name_previous : String ,sample_pob_previous : String ,sample_sample_previous : String)-> Chm_sample_Dialog {
        self.sample_name_previous = sample_name_previous
        self.sample_pob_previous = sample_pob_previous
        self.sample_sample_previous = sample_sample_previous
        return self
    }
    
    
    func show(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myviewcontroller =  storyboard.instantiateViewController(withIdentifier: "Chm_sample") as! Chm_sample
        myviewcontroller.VCIntent["intent_fromRcpaCAll"] = "Chemist"
        myviewcontroller.VCIntent["sample_name"] = sample_name
        myviewcontroller.VCIntent["sample_pob"] = sample_pob
        myviewcontroller.VCIntent["sample_sample"] = sample_sample
        
        myviewcontroller.VCIntent["sample_name_previous"] = sample_name_previous
        myviewcontroller.VCIntent["sample_pob_previous"] = sample_pob_previous
        myviewcontroller.VCIntent["sample_sample_previous"] = sample_sample_previous

        myviewcontroller.vc = vc
        myviewcontroller.dr_List = dr_List
        myviewcontroller.responseCode = responseCode
        myviewcontroller.showGeoFencing = showGeoFencing
        vc.present(myviewcontroller, animated: true, completion:  nil)
    }
    
    
}
