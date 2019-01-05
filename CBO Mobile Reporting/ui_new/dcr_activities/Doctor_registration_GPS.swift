//
//  Doctor_registration_GPS.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 29/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Doctor_registration_GPS: CustomUIViewController {

    @IBOutlet weak var latlong: CustomDisableTextView!
    @IBOutlet weak var MyTopView: TopViewOfApplication!
    @IBOutlet weak var dr_name: CustomDisableTextView!
    
    @IBOutlet weak var cancel: CustomeUIButton!
    @IBOutlet weak var register: CustomeUIButton!
    @IBOutlet weak var loc_img: UIImageView!
    @IBOutlet weak var refresh: CustomeUIButton!
    
    var dr_id = ""
    var lastLatLong = ""
    var callTyp = "D"
    
    var cbohelp = CBO_DB_Helper.shared
    
    
    var syncServices: SyncService!
    var progess : ProgressHUD!
    var vc : CustomUIViewController!
    let MESSAGE_INTERNET_SYNC=1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        refresh.addTarget(self, action: #selector(setLetLong), for: .touchUpInside)
        register.addTarget(self, action: #selector(Submit_register), for: .touchUpInside)
        
        dr_name.setText(text: VCIntent["dr_name"]!)
        dr_id = VCIntent["dr_id"]!
        
        callTyp = VCIntent["callTyp"]!
        if callTyp == "D" {
            MyTopView.setText(title: "Doctor Registration...")
        }else if callTyp == "C" {
            MyTopView.setText(title: "Chemist Registration...")
        }else if callTyp == "DA" {
             callTyp = "DP";
            MyTopView.setText(title: "Dairy Registration...")
        }else if callTyp == "PA" {
             callTyp = "DP";
            MyTopView.setText(title: "Poultry Registration...")
        }else{
            MyTopView.setText(title: "Stockist Registration...")
        }
        
        setLetLong()
        
    }
    
    @objc func Submit_register(){
        setLetLong()
        if(lastLatLong != nil && lastLatLong != ("")){
            lastLatLong = customVariablesAndMethod1.get_best_latlong(context: self);
            cbohelp.updateLatLong(latlong: lastLatLong,id: dr_id,type: callTyp,index: "");
            
            if(!customVariablesAndMethod1.internetConneted(context: self , ShowAlert: false,SkipMadatory: true)){
                customVariablesAndMethod1.getAlert(vc: self, title: "Registered", msg: dr_name.getText() + "\nRegistration Successfully Completed... ", completion: {_ in
                    self.MyTopView.CloseCurruntVC(vc: self)
                });
            }else{
                syncServices = SyncService(context: self)
                progess = ProgressHUD(vc : self)
                progess.show(text: "Please Wait.. \nRegistration in progess..." )
                syncServices.DCR_sync_all(responseCode: MESSAGE_INTERNET_SYNC,ReplyYN : "Y")
            }
           
        }else{
            customVariablesAndMethod1.msgBox(vc: self, msg: "Unknown location....\n Cannot reister at this moment")
            
        }
    }
    
    
    @objc func setLetLong() {
        lastLatLong =  customVariablesAndMethod1.getDataFrom_FMCG_PREFRENCE(vc: self, key: "shareLatLong", defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON)
        latlong.setText(text: lastLatLong)
        setLocImg();
    }

    
    func setLocImg(){
        if(lastLatLong != nil && lastLatLong != ("")){
            loc_img.image = #imageLiteral(resourceName: "loc.jpg")
        }else{
             loc_img.image = #imageLiteral(resourceName: "un_loc.png")
           
        }
    }
    
    @objc func closeCurrentView()
    {
        MyTopView.CloseCurruntVC(vc: self)
    }
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case MESSAGE_INTERNET_SYNC:
            syncServices.parser_sync(result: dataFromAPI)
            customVariablesAndMethod1.getAlert(vc: self, title: "Registered", msg: dr_name.getText() + "\nRegistration Successfully Completed... ", completion: {_ in
                self.MyTopView.CloseCurruntVC(vc: self)
            });
        case 99:
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            self.dismiss(animated: true, completion: nil)
            print("Error")
        }
        progess.dismiss()
    }

}
