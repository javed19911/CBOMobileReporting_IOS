//
//  Multi_Class_Service_call.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 26/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Multi_Class_Service_call  {
    var customVariablesAndMethod : Custom_Variables_And_Method! = nil
    var cbohelp : CBO_DB_Helper  = CBO_DB_Helper.shared
    var progressHUD :  ProgressHUD!
    let MESSAGE_INTERNET_UTILITES=2
    var vc : CustomUIViewController!
    var response_code: Int!
    
    init(){
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        // Do any additional setup after loading the view.
    }
    
//    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
//        switch response_code {
//
//        case MESSAGE_INTERNET_UTILITES:
//            parser_utilites( dataFromAPI  : dataFromAPI)
//            break
//        case 99:
//            progressHUD.dismiss()
//            customVariablesAndMethod.getAlert(vc: vc, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
//            break
//        default:
//            progressHUD.dismiss()
//            print("Error")
//        }
//    }
//

    func UploadDownLoad(vc : CustomUIViewController , response_code: Int, progressHUD :ProgressHUD){
        self.vc = vc
        self.response_code = response_code
        self.progressHUD = progressHUD
        //Start of call to service
        
        
        
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        
        let tables = [-1]
        //   progress1.setMessage("Downloading Miscellaneous data.." + "\n" + "please wait");
        // avoid deadlocks by not using .main queue here
       
        progressHUD.show(text: "Please Wait...\nDownloading Miscellaneous Data ")
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "GetItemListForLocal", tables: tables, response_code: response_code, vc : vc)
        
        
        //End of call to service
    }
    

    
     public func parser_utilites( dataFromAPI :[ String :NSArray]) {
        if (!dataFromAPI.isEmpty) {
            
            do{
                
                //table 0-11 for getitemlistforlocal
                //table 12-13 for fmgcddl_2
                
                
                //getItemforLocal
                
                
               
                //cbohelper.delete_phdoctor();
                
                
                
                
                
                //cbohelper.deleteApprisalValues();
                //cbohelper.deleteChemist();
                //getcount();
                
                let jsonArray11 =   dataFromAPI["Tables0"]!
                let jsonArray12 =   dataFromAPI["Tables1"]!
                let jsonArray13 =   dataFromAPI["Tables2"]!
                let jsonArray14 =   dataFromAPI["Tables3"]!
                let jsonArray15 =   dataFromAPI["Tables4"]!
                let jsonArray16 =   dataFromAPI["Tables5"]!
                let jsonArray17 =   dataFromAPI["Tables6"]!
                let jsonArray18 =   dataFromAPI["Tables7"]!
                let jsonArray19 =   dataFromAPI["Tables8"]!
                let jsonArray20 =   dataFromAPI["Tables9"]!
                let jsonArray22 =   dataFromAPI["Tables11"]!
                
                cbohelp.delete_phitem();
                for i in 0 ..< jsonArray11.count{
                    let jasonObj1 = jsonArray11[i] as! [String : AnyObject]
                    cbohelp.insertProducts(id: jasonObj1["ITEM_ID"] as! String, name: jasonObj1["ITEM_NAME"] as! String, stk_rate: (jasonObj1["STK_RATE"]) as! String , gift: jasonObj1["GIFT_TYPE"] as! String, SHOW_ON_TOP: jasonObj1["SHOW_ON_TOP"] as! String, SHOW_YN: jasonObj1["SHOW_YN"] as! String)
                }
                
                /*for (int b = 0; b<jsonArray2.length();b++){
                 JSONObject jasonObj2 = jsonArray2.getJSONObject(b);
                 val=cbohelper.insertDoctorData(jasonObj2.getString("DR_ID"), jasonObj2.getString("ITEM_ID"),jasonObj2.getString("item_name"));
                 Log.e("%%%%%%%%%%%%%%%", "doctor insert");
                 
                 }*/
                cbohelp.delete_phallmst();
                for i in 0 ..< jsonArray14.count {
                    
                    let jsonObject3 = jsonArray14[i] as! [String : AnyObject]
                    cbohelp.insert_phallmst(allmst_id: jsonObject3["ID"] as! String, table_name: jsonObject3["TABLE_NAME"] as! String, field_name: jsonObject3["FIELD_NAME"] as! String, remark: jsonObject3["REMARK"] as! String)
                }
                
                cbohelp.delete_phparty();
                for i in 0 ..< jsonArray15.count {
                    
                    let jsonObject4 = jsonArray15[i] as! [String : AnyObject]
                    
                    cbohelp.insert_phparty(pa_id: jsonObject4["PA_ID"] as! String, pa_name: jsonObject4["PA_NAME"] as! String , desig_id: jsonObject4["DESIG_ID"] as! String, category: jsonObject4["CATEGORY"] as! String, hqid: jsonObject4["HQ_ID"] as! String, PA_LAT_LONG: jsonObject4["PA_LAT_LONG"] as! String, PA_LAT_LONG2: jsonObject4["PA_LAT_LONG2"] as! String , PA_LAT_LONG3: jsonObject4["PA_LAT_LONG3"] as! String, SHOWYN: jsonObject4["SHOWYN"] as! String)
                }
                
                cbohelp.delete_phrelation();
                for i in 0 ..< jsonArray16.count{
                    let jsonObject5 = jsonArray16[i] as! [String : AnyObject]
                    cbohelp.insert_phrelation(pa_id: jsonObject5["PA_ID"] as! String, under_id: jsonObject5["UNDER_ID"] as! String, rank: jsonObject5["RANK"] as! String)
                }
                
                cbohelp.delete_phitemspl();
                for i in 0 ..< jsonArray17.count{
                    let jsonObject6 = jsonArray17[i] as! [String : AnyObject]
                    cbohelp.insert_phitempl(item_id: jsonObject6["ITEM_ID"] as! String , dr_spl_id: jsonObject6["DR_SPL_ID"] as! String , srno: jsonObject6["SRNO"] as! String)
                }
                
                
                cbohelp.deleteFTPTABLE();
                for i in 0 ..< jsonArray18.count{
                    let jsonObject7 = jsonArray18[i] as! [String : AnyObject]
                    cbohelp.insert_FtpData(ip: jsonObject7["WEB_IP"] as! String, user: jsonObject7["WEB_USER"] as! String, pass: jsonObject7["WEB_PWD"] as! String, port:     jsonObject7["WEB_PORT"] as! String, path: jsonObject7["WEB_ROOT_PATH"] as! String)
                }
                
                
                
                //        for i in 0 ..< jsonArray20.count{
                //            let jsonObject9 = jsonArray20[i] as! [String : AnyObject]
                //            //let count = jsonObject9["NO_DR"] as! Int
                //          //  let chem_count = jsonObject9["NO_CHEM"] as! Int
                //    }
                
                let jsonObjectLoginUrl = jsonArray22[0] as! [String : AnyObject]
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "Login_Url", value: jsonObjectLoginUrl["LOGIN_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key :"DR_ADDNEW_URL", value :jsonObjectLoginUrl["DR_ADDNEW_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "CHEM_ADDNEW_URL",value : jsonObjectLoginUrl["CHEM_ADDNEW_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "DRSALE_ADDNEW_URL",value : jsonObjectLoginUrl["DRSALE_ADDNEW_URL"] as! String)
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "TP_ADDNEW_URL",value : jsonObjectLoginUrl["TP_ADDNEW_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "CHALLAN_ACK_URL",value : jsonObjectLoginUrl["CHALLAN_ACK_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "SECONDARY_SALE_URL",value : jsonObjectLoginUrl["SECONDARY_SALE_URL"] as! String)
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc , key  :"TP_APPROVE_URL", value : jsonObjectLoginUrl["TP_APPROVE_URL"] as! String)
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key :"PERSONAL_INFORMATION_URL", value : jsonObjectLoginUrl["PERSONAL_INFORMATION_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc ,key : "CHANGE_PASSWORD_URL", value : jsonObjectLoginUrl["CHANGE_PASSWORD_URL"] as! String )
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc , key : "CIRCULAR_URL", value:  jsonObjectLoginUrl["CIRCULAR_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key : "DECLARATION_OF_SAVING_URL",value:  jsonObjectLoginUrl["DECLARATION_OF_SAVING_URL"] as! String)
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key:  "SALARY_SLIP_URL", value:  jsonObjectLoginUrl["SALARY_SLIP_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc,key:  "FORM16_URL", value:  jsonObjectLoginUrl["FORM16_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key:  "ROUTE_MASTER_URL", value:  jsonObjectLoginUrl["ROUTE_MASTER_URL"] as! String)
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : vc, key:  "HOLIDAY_URL", value:  jsonObjectLoginUrl["HOLIDAY_URL"] as! String)
                
                
                // fmcgddl_2
                
                let jsonArray23 = dataFromAPI["Tables12"]!
                
                let jsonArray24 = dataFromAPI["Tables13"]!
                
                for  i in  0  ..< jsonArray23.count {
                    
                    let c = jsonArray23[i] as! [String : AnyObject]
                    
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc , key : "fmcg_value", value: try c.getString(key: "FMCG") as! String)
                    
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc , key:  "root_needed", value:  try c.getString(key: "ROUTE") as! String )
                    
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key : "gps_needed", value:  try c.getString(key: "GPRSYN") as! String)
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key :"version", value:  try c.getString(key: "VER") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc  ,key : "doryn", value : try c.getString(key: "DORYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc , key : "dosyn", value:  try c.getString(key: "DOSYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key:  "internet",value:  try c.getString(key: "INTERNET_RQD") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "live_km",value:  try c.getString(key: "LIVE_KM") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc , key :"leave_yn", value:  try c.getString(key: "LEAVEYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "WEBSERVICE_URL",value:  try c.getString(key: "WEBSERVICE_URL") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "WEBSERVICE_URL_ALTERNATE",value:  try c.getString(key: "WEBSERVICE_URL_ALTERNATE") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "FLASHYN",value: try  c.getString(key: "FLASHYN") as! String )
                    //customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,"FLASHYN", c.getString("FLASHYN"as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCR_REMARK_NA",value:  try c.getString(key: "DCR_REMARK_NA") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCR_DR_REMARKYN", value:  try c.getString(key: "DCR_DR_REMARKYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "ROUTEDIVERTYN", value:  try c.getString(key: "ROUTEDIVERTYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCR_ADDAREANA", value: try c.getString(key: "DCR_ADDAREANA") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "VISUALAIDPDFYN", value: try c.getString(key: "VISUALAIDPDFYN") as! String )
                    
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "SAMPLE_POB_MANDATORY", value: try c.getString(key: "SAMPLE_POB_MANDATORY") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "REMARK_WW_MANDATORY", value: try c.getString(key: "REMARK_WW_MANDATORY") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "SAMPLE_POB_INPUT_MANDATORY", value : try c.getString(key: "SAMPLE_POB_INPUT_MANDATORY") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "MISSED_CALL_OPTION", value : try c.getString(key: "MISSED_CALL_OPTION") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "APPRAISALMANDATORY", value : try c.getString(key: "APPRAISALMANDATORY")as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "USER_NAME", value : try c.getString(key: "USER_NAME") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "PASSWORD", value : try c.getString(key: "PASSWORD") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "VISUALAID_DRSELITEMYN",value : try c.getString(key: "VISUALAID_DRSELITEMYN")as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DOB_REMINDER_HOUR", value : try c.getString(key: "DOB_REMINDER_HOUR") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "SYNCDRITEMYN", value : try c.getString(key: "SYNCDRITEMYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "GEO_FANCING_KM", value : try c.getString(key: "GEO_FANCING_KM") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "FIRST_CALL_LOCK_TIME", value :  try c.getString(key: "FIRST_CALL_LOCK_TIME") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "mark", value : try c.getString(key: "FLASH_MESSAGE") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "NOC_HEAD", value : try c.getString(key: "NOC_HEAD") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "USER_PIC",value : try c.getString(key: "USER_PIC") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCR_LETREMARK_LENGTH", value : try c.getString(key: "DCR_LETREMARK_LENGTH") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "SAMPLEMAXQTY", value : try c.getString(key: "SAMPLEMAXQTY") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "POBMAXQTY", value : try c.getString(key: "POBMAXQTY") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "ASKUPDATEYN", value : try c.getString(key: "ASKUPDATEYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "MOBILEDATAYN", value : try c.getString(key: "MOBILEDATAYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "CALLWAITINGTIME", value : try c.getString(key: "CALLWAITINGTIME") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "COMPANY_PIC", value : try c.getString(key: "COMPANY_PIC") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "RE_REG_KM", value : try c.getString(key: "RE_REG_KM") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "ERROR_EMAIL", value : try c.getString(key: "ERROR_EMAIL") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DIVERT_REMARKYN", value : try c.getString(key: "DIVERT_REMARKYN") as! String )
                    
                    // MARK:- Diary
                    
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "NLC_PIC_YN", value : try c.getString(key: "NLC_PIC_YN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "RX_MAX_QTY", value : try c.getString(key: "RX_MAX_QTY") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "SHOW_ADD_REGYN", value : try c.getString(key: "SHOW_ADD_REGYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "EXP_ATCH_YN", value : try c.getString(key: "EXP_ATCH_YN") as! String )
                     customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "FARMERADDFIELDYN", value : try c.getString(key: "FARMERADDFIELDYN") as! String )
                    
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "NO_DR_CALL_REQ", value : try c.getString(key: "NO_DR_CALL_REQ") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DR_RX_ENTRY_YN", value : try c.getString(key: "DR_RX_ENTRY_YN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "RETAILERCHAINYN", value : try c.getString(key: "RETAILERCHAINYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCR_SUBMIT_TIME", value : try c.getString(key: "DCR_SUBMIT_TIME") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCR_SUBMIT_SPEACH", value : try c.getString(key: "DCR_SUBMIT_SPEACH") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "ALLOWED_APP", value : try c.getString(key: "ALLOWED_APP") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DCRGIFT_QTY_VALIDATE", value : try c.getString(key: "DCRGIFT_QTY_VALIDATE") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "SAMPLE_BTN_CAPTION", value : try c.getString(key: "SAMPLE_BTN_CAPTION") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "GIFT_BTN_CAPTION", value : try c.getString(key: "GIFT_BTN_CAPTION") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "DIVERTWWYN", value : try c.getString(key: "DIVERTWWYN") as! String )
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE( vc : vc ,key: "PIN_ALLOWED_MSG", value : try c.getString(key: "PIN_ALLOWED_MSG") as! String )
                }
                
                cbohelp.deleteMenu();
                for i in 0 ..< jsonArray24.count {
                    let c =  jsonArray24[i] as! [String : AnyObject]
                    let menu = try c.getString(key: "MAIN_MENU") as! String
                    let menu_code = try c.getString(key: "MENU_CODE") as! String
                    let menu_name = try c.getString(key: "MENU_NAME") as! String
                    let menu_url = try c.getString(key: "URL") as! String
                    let main_menu_srno = try c.getString(key: "MAIN_MENU_SRNO") as! String
                    
                    cbohelp.insertMenu(menu: menu, menu_code: menu_code, menu_name: menu_name, menu_url: menu_url, main_menu_srno: main_menu_srno)
                }
                
                /*Custom_Variables_And_Method.ip = "0";
                 Custom_Variables_And_Method.user = "0";
                 Custom_Variables_And_Method.pwd = "0";
                 Custom_Variables_And_Method.db = "0";
                 
                 cbohelp.insertLoginDetail(company_code, ols_ip, ols_db_name, ols_db_user, ols_db_password, version_new);*/
                
                customVariablesAndMethod.getAlert(vc: vc, title: "Complete  !!!!", msg: "Upload Download Sucessfully Completed.....")
              
            }catch{
                customVariablesAndMethod.getAlert(vc: vc, title: "Missing field error", msg: error.localizedDescription)
                
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: vc)
                
                objBroadcastErrorMail.requestAuthorization()
                
                
                
            }
            
            progressHUD.dismiss()
            
        }
        
    }
    
    
    
    func DownLoadAll(vc : CustomUIViewController , response_code: Int, progressHUD :ProgressHUD){
        self.vc = vc
        self.response_code = response_code
        self.progressHUD = progressHUD
        
        Custom_Variables_And_Method.GCMToken = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: vc,key: "GCMToken", defaultValue: "");
        
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPA_ID"] = String(Custom_Variables_And_Method.PA_ID)
        params["sDcrId"] = Custom_Variables_And_Method.DCR_ID
        params["sRouteYn"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: vc,key: "root_needed",defaultValue: "Y")
        params["sGCM_TOKEN"] = Custom_Variables_And_Method.GCMToken
        
        params["sMobileId"] = customVariablesAndMethod.getDeviceInfo()
        params["sVersion"] = Custom_Variables_And_Method.VERSION
        
        var tables =  [Int]()
        tables.append(0)
        tables.append(1);
        tables.append(2);
        tables.append(3);
        tables.append(4);
        tables.append(5);
        tables.append(6);
        tables.append(7);
        tables.append(8);
        tables.append(9);
        tables.append(10);
        
        progressHUD.show(text: "Please Wait..\nFetching your Utilitis for the day")
        
       
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCRCOMMIT_DOWNLOADALL", tables: tables, response_code: response_code, vc : vc)
        
        
        //End of call to service
    }
    
    
    func SendFCMOnCall(vc : CustomUIViewController , response_code: Int, progressHUD :ProgressHUD, DocType : String,  Id : String, latlong : String){
    
    
        self.vc = vc
        self.response_code = response_code
        self.progressHUD = progressHUD
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance();
    
        var latlong_new = latlong
        
    
        if(!customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: vc,key: "FCMHITCALLYN",defaultValue: "").contains(DocType)){
            threadMsg(msg: "Ok");
            return;
        }
        if (latlong_new == ("")){
            latlong_new = cbohelp.getLatLong(type: DocType,id: Id);
        }
        
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["sPA_ID"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: vc,key: "work_with_id",defaultValue: "0,")+"0"
        params["sMessage"] = "[{\"msgtyp\":\"CALL\"},{\"tilte\":\"" + Id + "\"},{\"msg\":\"" + DocType + "\"},{\"url\":\" " + latlong_new + "\"},{\"logo\":\"\"}]"
        params["iDESIG_ID"] = ""
        params["iKEY"] = ""
        
        
        var tables =  [Int]()
        tables.append(0)
        progressHUD.show(text: "Please Wait..\nUpdating Team's DCR...")
        
        CboServices().customMethodForAllServices(params: params, methodName: "GCM_MessagePush_Domain", tables: tables, response_code: response_code + 100, vc : vc)
        
    //End of call to service
    
    }

    func threadMsg( msg : String) {
        var ReplyMsg = [String : String]()
        ReplyMsg["msg"]  = msg
        vc.getDataFromApi(response_code: response_code, dataFromAPI: ["data" : [ReplyMsg]])
    }
    
    
    func parser_FCM(dataFromAPI : [String : NSArray]) {
        do {
            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
                let one = jsonArray[0] as! [String : AnyObject]
                let MyDaType = try one.getString(key: "DCRID") as! String;
                threadMsg(msg: "OK");
            }
        }catch {
            print("MYAPP", "objects are: \(error)")
            customVariablesAndMethod.getAlert(vc: vc, title: "Missing field error", msg: error.localizedDescription )
            
            
            
            let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
            let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: vc)
            
            objBroadcastErrorMail.requestAuthorization()
        }
          progressHUD.dismiss()
    }
    
    func parser_DCRCOMMIT_DOWNLOADALL(dataFromAPI : [String : NSArray]) {
        
        do {
            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
                let one = jsonArray[0] as! [String : AnyObject]
                let MyDaType = try one.getString(key: "DA_TYPE") as! String;
                var da_val = "0";
                let rate = try Float(one.getString(key: "FARE_RATE") as! String);
                let kms = try Float(one.getString(key: "KM") as! String);
                
                if (MyDaType == "L") {
                    da_val = try one.getString(key: "DA_L_RATE") as! String;
                } else if (MyDaType == "EX" || MyDaType == "EXS") {
                    da_val = try one.getString(key: "DA_EX_RATE") as! String;
                } else if (MyDaType == "NSD" || MyDaType == "NS") {
                    da_val = try one.getString(key: "DA_NS_RATE") as! String;
                }
                
                var  distance_val = "0";
                if (MyDaType == "EX" || MyDaType == "NSD") {
                    distance_val = String(kms! * rate! * 2)
                    
                } else {
                    distance_val = String(kms! * rate!);
                }
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: vc,key: "DA_TYPE",value: MyDaType);
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: vc,key: "da_val",value: da_val);
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: vc,key: "distance_val",value: distance_val);
                
                let table1 = try dataFromAPI.getString(key: "Tables1");
                cbohelp.delete_phdoctor();
                for i in 0 ..< table1.count{
                    let c = table1[i] as! [String : AnyObject]
                    
                    try cbohelp.insert_phdoctor(dr_id: Int(c.getString(key: "DR_ID") as! String)!, dr_name: c.getString(key: "DR_NAME") as! String, dr_code: "", area: "",spl_id: Int(c.getString(key: "SPL_ID") as! String)!,LAST_VISIT_DATE: c.getString(key: "LASTCALL") as! String,
                                                CLASS: c.getString(key: "CLASS") as! String, PANE_TYPE: c.getString(key: "PANE_TYPE") as! String,POTENCY_AMT: c.getString(key: "POTENCY_AMT") as! String,
                                                ITEM_NAME: c.getString(key: "ITEM_NAME") as! String, ITEM_POB: c.getString(key: "ITEM_POB") as! String, ITEM_SALE: c.getString(key: "ITEM_SALE") as! String ,DR_AREA: c.getString(key: "AREA") as! String,DR_LAT_LONG: c.getString(key: "DR_LAT_LONG") as! String
                        , FREQ: c.getString(key: "FREQ") as! String ,NO_VISITED: c.getString(key: "NO_VISITED") as! String , DR_LAT_LONG2: c.getString(key: "DR_LAT_LONG2") as! String ,DR_LAT_LONG3: c.getString(key: "DR_LAT_LONG3") as! String ,COLORYN: c.getString(key: "COLORYN") as! String, CRM_COUNT: c.getString(key: "CRM_COUNT") as! String, DRCAPM_GROUP: c.getString(key: "DRCAPM_GROUP") as! String, SHOWYN: c.getString(key: "SHOWYN") as! String);
                    
                }
                
                let Tables2 = try dataFromAPI.getString(key: "Tables2");
                cbohelp.deleteChemist();
                for i in 0 ..< Tables2.count{
                    let c = Tables2[i] as! [String : AnyObject]
                    try cbohelp.insert_Chemist(chid: Int(c.getString(key: "CHEM_ID") as! String)!, chname: c.getString(key: "CHEM_NAME") as! String, area: "", chem_code: "",LAST_VISIT_DATE: c.getString(key: "LAST_VISIT_DATE") as! String ,DR_LAT_LONG: c.getString(key: "DR_LAT_LONG") as! String, DR_LAT_LONG2: c.getString(key: "DR_LAT_LONG2") as! String,DR_LAT_LONG3: c.getString(key: "DR_LAT_LONG3") as! String, SHOWYN: c.getString(key: "SHOWYN") as! String);
                    
                }
                
                
                //
                let Tables3 = try dataFromAPI.getString(key: "Tables3");
                cbohelp.deleteDcrAppraisal();
                for i in 0 ..< Tables3.count{
                    let c = Tables3[i] as! [String : AnyObject]
                    try cbohelp.setDcrAppraisal(PA_ID: c.getString(key: "PA_ID") as! String, PA_NAME: c.getString(key: "PA_NAME") as! String,DR_CALL: c.getString(key: "DR_CALL") as! String, DR_AVG: c.getString(key: "DR_AVG") as! String,CHEM_CALL: c.getString(key: "CHEM_CALL") as! String, CHEM_AVG: c.getString(key: "CHEM_AVG") as! String, FLAG: "0", sAPPRAISAL_ID_STR: "", sAPPRAISAL_NAME_STR: "", sGRADE_STR: "", sGRADE_NAME_STR: "", sOBSERVATION: "",sACTION_TAKEN: "");
                    
                }
                //
                let Tables4 = try dataFromAPI.getString(key: "Tables4");
                cbohelp.delete_phdoctoritem();
                for i in 0 ..< Tables4.count{
                    let c = Tables4[i] as! [String : AnyObject]
                    try cbohelp.insertDoctorData(dr_id: Int(c.getString(key: "DR_ID") as! String)!, item_id: Int(c.getString(key: "ITEM_ID") as! String)!,item_name: c.getString(key: "ITEM_NAME") as! String)
                    
                    
                }
                
                //
                let Tables5 = try dataFromAPI.getString(key: "Tables5");
                cbohelp.delete_Doctor_Call_Remark();
                for i in 0 ..< Tables5.count{
                    let c = Tables5[i] as! [String : AnyObject]
                    try cbohelp.insertDoctorCallRemark( item_id: c.getString(key: "PA_ID") as! String,item_name: c.getString(key: "PA_NAME") as! String);
                }
                //
                //
                let Tables6 = try dataFromAPI.getString(key: "Tables6");
                cbohelp.delete_phparty();
                for i in 0 ..< Tables6.count{
                    let c = Tables6[i] as! [String : AnyObject]
                    
                    try cbohelp.insert_phparty(pa_id: c.getString(key: "PA_ID") as! String, pa_name: c.getString(key: "PA_NAME") as! String, desig_id: c.getString(key: "DESIG_ID") as! String, category: c.getString(key: "CATEGORY") as! String, hqid: c.getString(key: "HQ_ID") as! String, PA_LAT_LONG: c.getString(key: "PA_LAT_LONG") as! String, PA_LAT_LONG2: c.getString(key: "PA_LAT_LONG2") as! String, PA_LAT_LONG3: c.getString(key: "PA_LAT_LONG3") as! String, SHOWYN: c.getString(key: "SHOWYN") as! String);
                }
                
                
                let Tables7 = try dataFromAPI.getString(key : "Tables7")
                cbohelp.delete_phdairy();
                
            
          
                for i in 0 ..< Tables7.count{
                    let c = Tables7[i] as! [String : AnyObject]
//                    JSONObject jasonObj2 = jsonArray8.getJSONObject(b);
                    
                    try cbohelp.insert_phdairy(DAIRY_ID: Int(c.getString(key: "ID") as! String)!, DAIRY_NAME: c.getString(key: "DAIRY_NAME") as! String, DOC_TYPE: c.getString(key: "DOC_TYPE") as! String, LAST_VISIT_DATE: "", DR_LAT_LONG: c.getString(key:  "DAIRY_LAT_LONG") as! String, DR_LAT_LONG2: c.getString(key: "DAIRY_LAT_LONG2") as! String, DR_LAT_LONG3: c.getString(key: "DAIRY_LAT_LONG3") as! String )
                }
                        
                        
//                        jasonObj2.getInt("ID"), jasonObj2.getString("DAIRY_NAME"),jasonObj2.getString("DOC_TYPE"),
//                                              "", jasonObj2.getString("DAIRY_LAT_LONG"),jasonObj2.getString("DAIRY_LAT_LONG2"),jasonObj2.getString("DAIRY_LAT_LONG3"));
//                }
                
                
                let Tables8 = try dataFromAPI.getString(key :"Tables8")
                cbohelp.delete_phdairy_person();
                for i in 0 ..< Tables8.count{
                    let c = Tables8[i] as! [String : AnyObject]
                    try cbohelp.insert_phdairy_person(DAIRY_ID: Int(c.getString(key: "DAIRY_ID") as! String)! , PERSON_ID: Int(c.getString(key: "PERSON_ID") as! String)!, PERSON_NAME: c.getString(key: "PERSON_NAME") as! String)
                        
//                        cbohelp.insert_phdairy_person( jasonObj2.getInt("DAIRY_ID"),jasonObj2.getInt("PERSON_ID"),jasonObj2.getString("PERSON_NAME"));
                }
                
                
                let Tables9 = try dataFromAPI.getString(key : "Tables9")
                cbohelp.delete_phdairy_reason()
               for i in 0 ..< Tables9.count{
                    let c = Tables9[i] as! [String : AnyObject]
                    try cbohelp.insert_phdairy_reason(PA_ID: Int(c.getString(key: "PA_ID") as! String)! , PA_NAME: c.getString(key: "PA_NAME") as! String)
                }
                
                let table10 =  try dataFromAPI.getString(key : "Tables10");
               
                cbohelp.delete_Item_Stock();
                for i in 0 ..< table10.count{
                    let c = table10[i] as! [String : AnyObject]
                    try cbohelp.insert_Item_Stock( ITEM_ID: c.getString(key: "ITEM_ID") as! String, STOCK_QTY: Int(c.getString(key: "STOCK_QTY") as! String)! );
                }
                
            }
        }catch {
            print("MYAPP", "objects are: \(error)")
            customVariablesAndMethod.getAlert(vc: vc, title: "Missing field error", msg: error.localizedDescription )
            
            
            
            let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
            let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: vc)
            
            objBroadcastErrorMail.requestAuthorization()
        }
        
    }
    
    
    func releseResources(mContext : CustomUIViewController) {
        
        Custom_Variables_And_Method.CHEMIST_NOT_VISITED = "";
        Custom_Variables_And_Method.STOCKIST_NOT_VISITED = "";
        cbohelp.deleteDoctorRc();
        cbohelp.deleteDoctorItem();
        cbohelp.deleteDoctorItemPrescribe();
        cbohelp.deleteDoctor();
        cbohelp.deleteFinalDcr();
        cbohelp.deleteDCRDetails();
        cbohelp.deletedcrFromSqlite();
        cbohelp.deleteTempChemist();
        cbohelp.deleteChemistSample();
        cbohelp.deleteChemistRecordsTable();
        cbohelp.deleteStockistRecordsTable();
        cbohelp.deleteTempStockist();
        cbohelp.deleteAllRecord();
        cbohelp.deleteAllRecordFromOneMinute();
        cbohelp.deleteAllRecord10();
        cbohelp.deleteTempDr();
        cbohelp.deleteDoctormore();
        cbohelp.delete_phallmst();
        cbohelp.deleteDCRDetails();
        cbohelp.deleteRcpa_Table();
        cbohelp.deleteFarmar_Table();
        cbohelp.delete_Rx_Table();
        
        cbohelp.delete_Expense();
        cbohelp.delete_Nonlisted_calls();
        cbohelp.deleteDcrAppraisal();
        cbohelp.delete_EXP_Head();
        cbohelp.delete_tenivia_traker();
        cbohelp.delete_Lat_Long_Reg();
        
        cbohelp.delete_phdairy_dcr(DAIRY_ID: nil);
        
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "DCR_ID");
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "DcrPlantime");
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "D_DR_RX_VISITED");
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "CHEMIST_NOT_VISITED");
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "STOCKIST_NOT_VISITED");
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "dcr_date_real");
        customVariablesAndMethod.deleteFmcg_ByKey(vc: mContext,key: "Dcr_Planed_Date");
        
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "myKm1", value: "0.0");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "OveAllKm",value: "0.0");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "final_km",value: "0.0");
        
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "DA_TYPE",value: "0");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "da_val",value: "0");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "distance_val",value: "0");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "Final_submit",value: "Y");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: mContext,key: "work_type_Selected",value: "w");
        
        
        //cbohelp.close();
        
    
    }
    
    
    func ResetDCR(vc : CustomUIViewController , response_code: Int, progressHUD :ProgressHUD){
        self.vc = vc
        self.response_code = response_code
        self.progressHUD = progressHUD
        //Start of call to service
        
        
        
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["DCRID"] = "\(Custom_Variables_And_Method.DCR_ID)"
        
        let tables = [-1]
        //   progress1.setMessage("Downloading Miscellaneous data.." + "\n" + "please wait");
        // avoid deadlocks by not using .main queue here
        
        progressHUD.show(text: "Please Wait...\nDownloading Miscellaneous Data ")
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "DcrReset_1", tables: tables, response_code: response_code, vc : vc)
        
        
        //End of call to service
    }
    
     func parser_Reset(vc : CustomUIViewController,dataFromAPI : [String : NSArray]) {
    
        reset_pin_delete_all_calls(vc : vc);
        if(progressHUD != nil){
            progressHUD.dismiss()
        }
        vc.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let mainstoryboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc1 = mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        appDelegate.window?.rootViewController = vc1
//        vc.dismiss(animated: true, completion: nil)
    }
    
    func reset_pin_delete_all_calls(vc : CustomUIViewController){
        cbohelp.deleteLogin();
        cbohelp.deleteLoginDetail();
        cbohelp.deleteFTPTABLE();
        cbohelp.delete_Mail(mail_id: "");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: vc, key: "WEBSERVICE_URL", value: "");
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: vc, key: "DOB_DOA_notification_date", value: "");
        //myCustomMethod.stopDOB_DOA_Remainder();
        
        cbohelp.DropDatabase();
        
        cbohelp = CBO_DB_Helper.shared
        
        //    Intent i = new Intent(getApplicationContext(), LoginMain.class);
        //    i.putExtra("picture", byteArray);
        //    startActivity(i);
    }
}


