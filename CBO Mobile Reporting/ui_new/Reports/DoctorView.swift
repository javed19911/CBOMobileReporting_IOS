//
//  DoctorView.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 08/05/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DoctorView: CustomUIViewController {

    var progressHUD : ProgressHUD!
    var presenter : ParantSummaryAdaptor!
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var summary_list = [[String : [String : [String]]]]()
    var doctor_list = [String : [String]]();
    let DOCTOR_REPORT = 2, CHEMIST_REPORT = 3, STOCKIST_REPORT = 4 , REMINDER_REPORT = 5,NLC_REPORT = 6
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var call_type = "D"
    
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var backButton: CustomeUIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        super.viewDidLoad()
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        progressHUD = ProgressHUD(vc: self)
        
        if VCIntent["Title"] != nil{
            myTopView.setText(title: VCIntent["Title"]!)
        }
        call_type = VCIntent["call_type"]!
        
         if(call_type == "D" || call_type == "R") {
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPaId"] = VCIntent["pa_id"] //"\(Custom_Variables_And_Method.PA_ID)"
            params["sDCR_DATE"] = VCIntent["date"]
            params["sCALL_TYPE"] = VCIntent["call_type"]



            let tables = [0]
            progressHUD.show(text: "Please wait ..." )

             CboServices().customMethodForAllServices(params: params, methodName: "DOCTOR_VIEW_1", tables: tables, response_code: DOCTOR_REPORT, vc: self, multiTableResponse: false)
         }else if(call_type == "C"){
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPaId"] = VCIntent["pa_id"]// "\(Custom_Variables_And_Method.PA_ID)"
            params["sDCR_DATE"] = VCIntent["date"]
            //params["sCALL_TYPE"] = VCIntent["call_type"]
            let tables = [0]
            progressHUD.show(text: "Please wait ..." )
             CboServices().customMethodForAllServices(params: params, methodName: "CHEMIST_VIEW", tables: tables, response_code: CHEMIST_REPORT, vc: self, multiTableResponse: false)
           
        }else if(call_type == "S"){
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPaId"] = VCIntent["pa_id"] //"\(Custom_Variables_And_Method.PA_ID)"
            params["sDCR_DATE"] = VCIntent["date"]
            //params["sCALL_TYPE"] = VCIntent["call_type"]
            let tables = [0]
            progressHUD.show(text: "Please wait ..." )
            CboServices().customMethodForAllServices(params: params, methodName: "STOCKIST_VIEW", tables: tables, response_code: STOCKIST_REPORT, vc: self, multiTableResponse: false)
            
         }else if(call_type == "NLC"){
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPaId"] = VCIntent["pa_id"] //"\(Custom_Variables_And_Method.PA_ID)"
            params["sDcrDate"] = VCIntent["date"]
            let tables = [0]
            progressHUD.show(text: "Please wait ..." )
            CboServices().customMethodForAllServices(params: params, methodName: "NLCVIEW_MOBILE", tables: tables, response_code: NLC_REPORT, vc: self, multiTableResponse: false)
            
        }
        
    }
    
    
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    

    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        
        var nameList,timeList,sample_name,sample_qty,sample_pob,sample_noc,remark,gift_name,gift_qty,dr_class_list,dr_potential_list,dr_area_list,dr_work_with_list : [String]!
       
       
        var  visible_status = [String]()
        nameList = [String]()
        timeList = [String]()
        sample_name = [String]()
        sample_qty = [String]()
        sample_pob = [String]();
        sample_noc = [String]();
        remark = [String]()
        var show_edit_delete = [String]()
        gift_name = [String]()
        gift_qty = [String]()
        dr_class_list = [String]()
        dr_potential_list = [String]()
        dr_area_list = [String]()
        dr_work_with_list = [String]()
        
        let dr_gift_name = "";
        let dr_gift_qty = "";
        
     
        
    
        
        
        switch response_code {
        
        case DOCTOR_REPORT :

            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
                
                for i in 0 ..< jsonArray.count{
                    let innerJson = jsonArray[i] as! [String : AnyObject]
                    
                    nameList.append(innerJson["DR_NAME"]! as! String )
                    timeList.append(innerJson["IN_TIME"]! as! String )
                    sample_name.append(innerJson["PRODUCT"]! as! String)
                    sample_qty.append(innerJson["QTY"]! as! String);
                    sample_pob.append(innerJson["POB_QTY"]! as! String);
                    sample_noc.append(innerJson["NOC"]! as! String)
                    remark.append(innerJson["REMARK"]! as! String);
                    visible_status.append("1");
                    gift_name.append(dr_gift_name);
                    gift_qty.append(dr_gift_qty);
                    show_edit_delete.append("0")
                    dr_area_list.append(innerJson["AREA"]! as! String)
                    dr_class_list.append(innerJson["CLASS"]! as! String);
                    dr_potential_list.append(innerJson["POTENCY_AMT"]! as! String);
                    dr_work_with_list.append(innerJson["WORK_WITH"]! as! String)
                    
                }
            }
            
             setDataForReport(nameList: nameList , timeList: timeList , sample_name: sample_name , sample_qty: sample_qty, sample_pob: sample_pob, sample_noc: sample_noc, visible_status: visible_status, remark: remark, gift_name: gift_name, gift_qty: gift_qty, area_Array: dr_area_list, class_Arrya: dr_class_list, potential_Array: dr_potential_list, workwith_array: dr_work_with_list, show_edit_delete: show_edit_delete)

             progressHUD.dismiss()
            break
            
            
        case STOCKIST_REPORT :
            
 
            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
                
                for i in 0 ..< jsonArray.count{
                    let innerJson = jsonArray[i] as! [String : AnyObject]
                    
                    
                    nameList.append(innerJson["PA_NAME"] as! String)
                    timeList.append(innerJson["IN_TIME"] as! String)
                    sample_name.append(innerJson["PRODUCT"] as! String)
                    sample_qty.append(innerJson["QTY"] as! String)
                    sample_pob.append(innerJson["POB_QTY"] as! String);
                    sample_noc.append("0");
                    remark.append(innerJson["REMARK"] as! String);
                    
                    visible_status.append("1");
                    
                    gift_name.append(dr_gift_name);
                    gift_qty.append(dr_gift_qty);
                    
                    show_edit_delete.append("0")
                    dr_area_list.append("")
                    dr_class_list.append("");
                    dr_potential_list.append("");
                    dr_work_with_list.append("")
                    
                }
            }
            
            
             setDataForReport(nameList: nameList , timeList: timeList , sample_name: sample_name , sample_qty: sample_qty, sample_pob: sample_pob, sample_noc: sample_noc, visible_status: visible_status, remark: remark, gift_name: gift_name, gift_qty: gift_qty, area_Array: dr_area_list, class_Arrya: dr_class_list, potential_Array: dr_potential_list, workwith_array: dr_work_with_list, show_edit_delete: show_edit_delete )
            progressHUD.dismiss()
            break
        
            case CHEMIST_REPORT:
            

            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
                
                for i in 0 ..< jsonArray.count{
                    let innerJson = jsonArray[i] as! [String : AnyObject]
                    
                    nameList.append(innerJson["chem_NAME"] as! String)
                    timeList.append(innerJson["IN_TIME"] as! String)
                    sample_name.append(innerJson["PRODUCT"] as! String)
                    sample_qty.append(innerJson["QTY"] as! String)
                    sample_pob.append(innerJson["POB_QTY"] as! String);
                    sample_noc.append("0");
                    remark.append(innerJson["REMARK"] as! String);
                    visible_status.append("1");
                    
                    gift_name.append(dr_gift_name);
                    gift_qty.append(dr_gift_qty);
                    
                    show_edit_delete.append("0")
                    dr_area_list.append("")
                    dr_class_list.append("");
                    dr_potential_list.append("");
                    dr_work_with_list.append("")

                    
                }
            }
            
            
            setDataForReport(nameList: nameList , timeList: timeList , sample_name: sample_name , sample_qty: sample_qty, sample_pob: sample_pob, sample_noc: sample_noc, visible_status: visible_status, remark: remark, gift_name: gift_name, gift_qty: gift_qty, area_Array: dr_area_list, class_Arrya: dr_class_list, potential_Array: dr_potential_list, workwith_array: dr_work_with_list, show_edit_delete: show_edit_delete)
            progressHUD.dismiss()
            break
        case NLC_REPORT:
            
            
            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
              
            
                for i in 0 ..< jsonArray.count{
                    let innerJson = jsonArray[i] as! [String : AnyObject]
                    
                    nameList.append("\(innerJson["DR_NAME"]!)  (\(innerJson["DOC_TYPE"]!))" )
                    timeList.append(innerJson["IN_TIME"] as! String)
                    sample_name.append("\(innerJson["QFL"]!)  (\(innerJson["SPL"]!))" )
                    sample_qty.append(innerJson["ADDRESS"] as! String)
                    sample_pob.append(innerJson["MOBILE_NO"] as! String);
                    sample_noc.append("0");
                    remark.append(innerJson["REMARK"] as! String);
                    visible_status.append("1");
                    
                    gift_name.append("");
                    gift_qty.append("");
                    
                    show_edit_delete.append("0")
                    dr_area_list.append(innerJson["NLC_AREA"] as! String)
                    dr_class_list.append(innerJson["CLASS"] as! String);
                    dr_potential_list.append(innerJson["POTENCY_AMT"] as! String);
                    dr_work_with_list.append("")
                    
                    
                }
            }
            
            
            setDataForReport(nameList: nameList , timeList: timeList , sample_name: sample_name , sample_qty: sample_qty, sample_pob: sample_pob, sample_noc: sample_noc, visible_status: visible_status, remark: remark, gift_name: gift_name, gift_qty: gift_qty, area_Array: dr_area_list, class_Arrya: dr_class_list, potential_Array: dr_potential_list, workwith_array: dr_work_with_list, show_edit_delete: show_edit_delete)
            
             progressHUD.dismiss()
            break
       
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
             progressHUD.dismiss()
            print("Error")

        }
       
    }
    
 
    
    private func setDataForReport(nameList:[String] , timeList : [String] , sample_name : [String] , sample_qty : [String] , sample_pob : [String] , sample_noc: [String] ,visible_status:[String] , remark : [String] ,  gift_name : [String] ,gift_qty : [String] , area_Array : [String] , class_Arrya: [String], potential_Array : [String] , workwith_array:[String] , show_edit_delete : [String] ){
        var headers = [String]()
        var isCollaps = [Bool]()
        doctor_list.removeAll()
       
        doctor_list["name"] = nameList
        doctor_list["time"] = timeList
        doctor_list["sample_name"] = sample_name
        doctor_list["sample_qty"] = sample_qty
        doctor_list["sample_pob"] = sample_pob
        doctor_list["sample_noc"] = sample_noc
        doctor_list["visible_status"] = visible_status
        doctor_list["remark"] = remark
        
        doctor_list["gift_name"] = gift_name
        doctor_list["gift_qty"] = gift_qty
        
        doctor_list["area"] = area_Array
        doctor_list["class"] = class_Arrya
        doctor_list["potential"] = potential_Array
        doctor_list["workwith"] = workwith_array
        doctor_list["show_edit_delete"] = show_edit_delete
        
       
        summary_list.append([ VCIntent["Title"]! : doctor_list])
       
        for header in summary_list{
            for header1 in  header{
                headers.append(header1.key)
                isCollaps.append(false)
            }
        }
        
        myTopView.setText(title: headers[0])
        
        presenter = ParantSummaryAdaptor(tableView: tableView, vc: self , summaryData : summary_list , headers : headers, isCollaps: isCollaps  )
        
        tableView.reloadData()
        tableView.dataSource = presenter
        tableView.delegate = presenter
        
        
    }
    

}
