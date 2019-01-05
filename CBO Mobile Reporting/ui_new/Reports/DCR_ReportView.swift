//
//  DCR_ReportView.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 18/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DCR_ReportView: CustomUIViewController {
    
    
    var presenter : RptAdaptor!
    var doctorVisitAdaptor : Doctor_Visit_Adapter!
    var tp_adapter : TP_Adapter!
    var lastPaId = "",monthID="",dr_id = "",pageType = "DCRRPT"
    let cbohelp = CBO_DB_Helper.shared
    let DCR_REPORT = 5, DR_WISE = 6, TP_REPORT = 7
    
    var rptData = [RptModel]()
    
    var progressHUD : ProgressHUD!
    
    @IBOutlet weak var myTableView : UITableView!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        lastPaId = VCIntent["nameId"]!
        monthID = VCIntent["monthId"]!
        dr_id = VCIntent["dr_id"]!
        
         if VCIntent["title"] != nil{
            pageType = VCIntent["type"]!
        }
        
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        var params = [String : String]()
        if (pageType == "DRWISE"){
            
            //Start of call to service
            
           
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["iPaId"] = lastPaId
            params["sMONTH"] = monthID
            params["iDRID"] = dr_id
            
           let tabels = [0]
            
            progressHUD = ProgressHUD(vc : self)
            progressHUD.show(text: "Please Wait.. \n" +
                "Checking your DCR Status")
            
             CboServices().customMethodForAllServices(params: params, methodName: "DOCTOR_VISIT_1", tables: tabels, response_code: DR_WISE, vc: self)
            
            //End of call to service
        }else if (pageType == "DCRRPT"){
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["sPaId"] = lastPaId
            params["sMonth"] = monthID
            params["sVerify"] = "0"
            params["sLoginPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
            params["sEntryDate"] = "0"
            
            let tabels = [0]
            progressHUD = ProgressHUD(vc : self)
            progressHUD.show(text: "Please Wait...\n")
            
            CboServices().customMethodForAllServices(params: params, methodName: "DCRLISTWITHEXPENSEGRID", tables: tabels, response_code: DCR_REPORT, vc: self, multiTableResponse: false)
        }else if (pageType == "TP"){
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["iPaId"] = lastPaId
            params["sMONTH"] = monthID
          
            let tabels = [0]
            progressHUD = ProgressHUD(vc : self)
            progressHUD.show(text: "Please Wait...\n")

            CboServices().customMethodForAllServices(params: params, methodName: "TP_VIEW", tables: tabels, response_code: TP_REPORT, vc: self, multiTableResponse: false)
           
        }
    }
    
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
 
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
       
        do {
            switch response_code {
            case DCR_REPORT:
                rptData.removeAll()
                if !dataFromAPI.isEmpty{
                    let jsonArray = dataFromAPI["Tables0"]!
                    for i in 0 ..< jsonArray.count{
                        let innerJson = jsonArray[i] as! [String : AnyObject]
                        
                        let rptModel = RptModel()
                        rptModel.setWith(with: innerJson["STATION"] as! String)
                        rptModel.setDate(date: innerJson["DCR_DATE"] as! String)
                        rptModel.setTtlexp(exp: innerJson["DA_TYPE"] as! String)
                        rptModel.setTtldr(dr: innerJson["MVVVTotal"] as! String)
                        rptModel.setRemark(remark: innerJson["REMARK"] as! String)
                        rptModel.setTtlchm(chm: innerJson["NoOFChemist"] as! String)
                        rptModel.setTtlstk(stk: innerJson["NO_STOCKIST"] as! String)
                        rptModel.setTtlDrRiminder(ttlDrRiminder: innerJson["DR_RC"] as! String)
                        rptModel.setTtlTenivia( ttlTenivia: innerJson["DRRX_TOTAL"] as! String)
                        rptModel.setTtlMissedCall(ttlMissedCall: innerJson["MISS_DR"] as! String)
                        rptModel.setTtlNonDoctor(ttlNonDoctor: innerJson["NLC_TOTAL"] as! String)
                        rptData.append(rptModel)
                    }
                }
                progressHUD.dismiss()
               
                presenter = RptAdaptor(tableView: myTableView, vc: self, rptData: rptData)
                myTableView.dataSource = presenter
                myTableView.reloadData()
                
                break
            case DR_WISE:
                
                if !dataFromAPI.isEmpty{
                    let jsonArray = dataFromAPI["Tables0"]!
                    var data = [[String : String]]()
                    for i in 0 ..< jsonArray.count{
                        let c = jsonArray[i] as! [String : AnyObject]
                        
                    
                        var datanum = [String : String]()
                        
                        datanum["DR_NAME"] = try c.getString(key: "DR_NAME") as? String
                        datanum["FREQ"] =  try  c.getString(key: "FREQ") as? String
                        datanum["CALL_DATE"] =  try c.getString(key: "CALL_DATE") as? String
                        datanum["DR_CODE"] = try c.getString(key: "DR_CODE") as? String
                        datanum["REMARK"] = try  c.getString(key: "REMARK") as? String
                        
                        datanum["NO_CALL"] = try c.getString(key: "NO_CALL") as? String
                        datanum["MISSEDCALL"] = try c.getString(key: "MISSEDCALL") as? String
                        datanum["CLASS"] = try c.getString(key: "CLASS") as? String
                        datanum["AREA"] = try c.getString(key: "AREA") as? String
                        datanum["DR_SALE"] = try c.getString(key: "DR_SALE") as? String
                        
                        datanum["LASTCALL"] = try c.getString(key: "LASTCALL") as? String
                        datanum["DR_CAMP"] = try c.getString(key: "DR_CAMP") as? String
                        datanum["HOSPITAL_NAME"] = try c.getString(key: "HOSPITAL_NAME") as? String
                        datanum["SPRODUCT"] = try c.getString(key: "SPRODUCT") as? String
                        
                        data.append(datanum);
                    }
                    progressHUD.dismiss()
                    
                     doctorVisitAdaptor = Doctor_Visit_Adapter(tableView: myTableView, vc: self, summaryData: data, month: "")
                    myTableView.reloadData()
                }
                
                break
            case TP_REPORT:
                
                if !dataFromAPI.isEmpty{
                    let jsonArray = dataFromAPI["Tables0"]!
                    var data = [[String : String]]()
                    for i in 0 ..< jsonArray.count{
                        let c = jsonArray[i] as! [String : AnyObject]
                        
                        
                        var datanum = [String : String]()
                        
                        datanum["date"] = try c.getString(key: "TP_DATE") as? String
                        datanum["work_with"] =  try  c.getString(key: "WORK_WITH") as? String
                        datanum["station"] =  try c.getString(key: "STATION") as? String
                        datanum["station_remark"] = try c.getString(key: "STATION_REMARK") as? String
                        datanum["doctor"] = try  c.getString(key: "DOCTOR") as? String
                        
                        datanum["area"] = try c.getString(key: "AREA") as? String
                        datanum["class"] = try c.getString(key: "CLASS") as? String
                        datanum["potential"] = try c.getString(key: "POTENTIAL") as? String
                        
                    
                        
                        data.append(datanum);
                    }
                    progressHUD.dismiss()
                    
                    tp_adapter = TP_Adapter(tableView: myTableView, vc: self, summaryData: data, month: "")
                    myTableView.reloadData()
                }
                
                break
            case 99:
                progressHUD.dismiss()
                customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
                break
            default:
                print("Error")
            }
        
        }catch{
            progressHUD.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Missing field error", msg: error.localizedDescription)
            
            let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
            let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: self)
            
            objBroadcastErrorMail.requestAuthorization()
        }
        
    }
    
   
}
