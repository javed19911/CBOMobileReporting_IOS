//
//  DCRSummery.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 16/02/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DCRSummery: CustomUIViewController {

    var presenter : ParantSummaryAdaptor!
    
    
    var customVariablesAndMethod : Custom_Variables_And_Method!
    @IBOutlet weak var myTopview: TopViewOfApplication!
    @IBOutlet weak var customTableView: UITableView!
    var context : CustomUIViewController!
    var Back_allowed = "Y"
    let cbohelp : CBO_DB_Helper = CBO_DB_Helper.shared


    var summary_list = [[String : [String : [String]]]]()
    var doctor_list = [String : [String]]();
    var stockist_list = [String : [String]]();
    var chemist_list = [String : [String]]();
    var reminder_list = [String : [String]]();
    var expense_list = [String : [String]]();
    var nonListed_call = [String : [String]]();
    var appraisal = [String : [String]]();
    var tenivia_traker = [String : [String]]();
    var Dairy = [String : [String]]();
    var Poultry = [String : [String]]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        context = CustomUIViewController()

        
        if  VCIntent["title"] != nil{
            myTopview.setText(title: VCIntent["title"]!)
        }
        
        
        doctor_list = cbohelp.getCallDetail(table: "tempdr",look_for_id: "",show_edit_delete: "0")
        
//        print(doctor_list)
        chemist_list = cbohelp.getCallDetail(table: "chemisttemp",look_for_id: "",show_edit_delete: "0")
        stockist_list = cbohelp.getCallDetail(table: "phdcrstk",look_for_id: "",show_edit_delete: "0")
        reminder_list = cbohelp.getCallDetail(table: "phdcrdr_rc",look_for_id:  "",show_edit_delete: "0")
        expense_list = cbohelp.getCallDetail(table: "Expenses",look_for_id: "",show_edit_delete: "0")
        nonListed_call = cbohelp.getCallDetail(table: "nonListed_call",look_for_id: "",show_edit_delete: "0")
        appraisal = cbohelp.getCallDetail(table: "appraisal",look_for_id: "",show_edit_delete: "0")
        tenivia_traker = cbohelp.getCallDetail(table: "tenivia_traker",look_for_id: "",show_edit_delete: "0")
        Dairy = cbohelp.getCallDetail(table: "Dairy",look_for_id: "",show_edit_delete: "0");
        Poultry = cbohelp.getCallDetail(table: "Poultry",look_for_id: "",show_edit_delete: "0");
        
        
        
        do {
        
            if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "Doctor_NOT_REQUIRED", defaultValue: "Y") == "N"){
                summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_DRCALL").getString(key: "D_DRCALL") :    doctor_list])
            }
            
            if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc : context, key : "CHEMIST_NOT_REQUIRED", defaultValue: "Y") == "N"){
                 summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_CHEMCALL").getString(key: "D_CHEMCALL") :    chemist_list])
            }
            
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "STOCKIST_NOT_REQUIRED", defaultValue: "Y") == "N"){
                 summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_STK_CALL").getString(key: "D_STK_CALL") :    stockist_list])
            }
            
            if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "Doctor_RC_NOT_REQUIRED", defaultValue: "Y") == "N"){
                 summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_RCCALL").getString(key: "D_RCCALL") :    reminder_list])
            }
            
            
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "Dairy_NOT_REQUIRED", defaultValue: "Y") == "N"){
                summary_list.append([try cbohelp.getMenuNew(menu:  "DCR",code : "D_DAIRY").getString(key: "D_DAIRY"): Dairy])
            }
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "Polutary_NOT_REQUIRED", defaultValue:"Y") == "N"){
                summary_list.append([try cbohelp.getMenuNew(menu:  "DCR",code : "D_POULTRY").getString(key : "D_POULTRY") :Poultry]);
            }
            
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "NonListed_NOT_REQUIRED", defaultValue: "Y") == "N"){
                summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_NLC_CALL").getString(key: "D_NLC_CALL") :    nonListed_call])
            }
            
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "Appraisal_NOT_REQUIRED", defaultValue: "Y") == "N"){
                summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_AP").getString(key: "D_AP") :    appraisal])
            }
            
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "Tenivia_NOT_REQUIRED", defaultValue: "Y") == "N"){
                summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_DR_RX").getString(key: "D_DR_RX") :    tenivia_traker])
            }
            
            if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc : context,key: "Expense_NOT_REQUIRED", defaultValue: "Y") == "N"){
                 summary_list.append([try cbohelp.getMenuNew(menu: "DCR", code: "D_EXP").getString(key: "D_EXP") :    expense_list])
            }
        
        } catch {
            print(error)
        }
        var headers = [ String]()
        var isCollaps = [Bool]()
        
        for header in summary_list{
            for header1 in  header{
                headers.append(header1.key)
                isCollaps.append(true)
            }
        }
        
        presenter = ParantSummaryAdaptor(tableView: customTableView, vc: self , summaryData : summary_list , headers : headers, isCollaps: isCollaps  )
       

        customTableView.dataSource = presenter
        customTableView.delegate = presenter

        myTopview.backButton.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside )
    }
    
    
    @objc func pressedBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
