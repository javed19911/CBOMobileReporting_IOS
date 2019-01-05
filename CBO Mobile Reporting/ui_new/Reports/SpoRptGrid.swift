//
//  SPO_ReportHeadquaterWise.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 08/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class SpoRptGrid : CustomUIViewController {

    var adapter : SpoRptAdapter!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    let cbohelp = CBO_DB_Helper.shared
    let MESSAGE_INTERNET = 1
    var progressHUD : ProgressHUD!
    var dataList =  [SpoModel]()
    var spoIdExtra = "0",rpt_typ = "c"
    var clickCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        myTopView.backButton.addTarget(self, action:#selector(closeVC), for: .touchUpInside)
        
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        if VCIntent["spoId"] != nil{
            spoIdExtra =  VCIntent["spoId"]!
        }
        
        if VCIntent["clickCount"] != nil{
            clickCount = Int(VCIntent["clickCount"]!)!
        }
        
        if VCIntent["rpt_typ"] != nil{
            rpt_typ = VCIntent["rpt_typ"]!
        }
        progressHUD = ProgressHUD(vc: self)
       
        GetSpoCNFGrid()
        
        
    }
    
    
    func GetSpoCNFGrid(){
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPA_ID"]  = "\(Custom_Variables_And_Method.PA_ID)"
        params["sFDATE"] = VCIntent["mIdFrom"]
        params["sTDATE"] = VCIntent["mIdTo"]
        params["sType"]  = rpt_typ
        if(clickCount == 2 || clickCount == 3){
            params["iCompanyId"] = "0"
            params["iHqId"] = spoIdExtra
        }else{
            params["iCompanyId"] = spoIdExtra
            params["iHqId"] = "0"
        }
        
        var tables =  [Int]()
        tables.append(0)
        progressHUD.show(text: "Please Wait.. ")
        
        CboServices().customMethodForAllServices(params: params, methodName: "SpoCNFGrid", tables: tables, response_code: MESSAGE_INTERNET, vc : self,multiTableResponse: false)
        
        //End of call to service
    }
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        
        switch response_code {
        case MESSAGE_INTERNET:
            parser_SpoCNF(dataFromAPI: dataFromAPI)
            progressHUD.dismiss()
            
        case 99:
            progressHUD.dismiss();
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }

    private func parser_SpoCNF(dataFromAPI : [String : NSArray]){
        if !dataFromAPI.isEmpty {
            
       do{
        
        dataList.removeAll()
            let jsonArray1 = dataFromAPI["Tables0"]!
            for i in 0 ..< jsonArray1.count{
                let object = jsonArray1[i] as! [String : AnyObject]
                
                let spoModel =  SpoModel()
                
                let id = try object.getString(key: "ID") as! String
                spoModel.setId(id: id);
                
                let con = try object.getString(key: "COMPANY_NAME") as! String
                spoModel.setConsignee(consignee: con);
                //Consignee.add(con);
                
                let salAmt = try object.getString(key: "SALE_AMT") as! String
                spoModel.setSalAmt(salAmt: salAmt);
                //Sales_Amount.add(salAmt);
                
                let salReturn = try object.getString(key: "SALER_AMT") as! String
                spoModel.setSaleReturn(saleReturn: salReturn);
                //Sales_Return.add(salReturn);
                
                let breakExp = try object.getString(key: "SALER_BR_AMT") as! String
                spoModel.setBreageExpiry(breageExpiry: breakExp);
                //Breakage_Expiry.add(breakExp);
                
                let cridtOther = try object.getString(key: "CN_AMT") as! String
                //Credit_Note_Other.add(cridtOther);
                spoModel.setCreditNotOrther(creditNotOrther: cridtOther);
                
                let netSales = try object.getString(key: "NET_SALE_AMT") as! String
                spoModel.setNetSales(netSales: netSales);
                //Net_Sales.add(netSales);
                
                let secSales = try object.getString(key: "SEC_AMT") as! String
                spoModel.setSecSales(priSales: secSales);
                //Secondary_Sales.add(secSales);
                
                let recipict = try object.getString(key: "RCPT_AMT") as! String
                spoModel.setRecipt(recipt: recipict);
                //Receipt.add(recipict);
                
                let outStanding = try object.getString(key: "OUTST_AMT") as! String
                spoModel.setOutStanding(outStanding: outStanding);
                //Outstanding.add(outStanding);
                
                let stkAmt = try object.getString(key: "STOCK_AMT") as! String
                spoModel.setStockAmt(stockAmt: stkAmt);
                //Stock_Amount.add(stkAmt);
                
                dataList.append(spoModel);
            }
            
            
            if (dataList.count == 2 && Custom_Variables_And_Method.pub_desig_id == "1" && spoIdExtra == "0"){

                let spoIdFromList = dataList[0].getId();
                if(clickCount<3){
                   clickCount = clickCount+1;
                }
                if (spoIdFromList != ("0")) {

//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpoRptGrid" ) as! SpoRptGrid
//                    vc.VCIntent["title"] = "SPO Hedquarter Wise Report"
//                    vc.VCIntent["uid"] = ""
//                    vc.VCIntent["mIdFrom"] = VCIntent["mIdFrom"]
//                    vc.VCIntent["mIdTo"] = VCIntent["mIdTo"]
//                    vc.VCIntent["spoId"] = spoIdFromList
//                    vc.VCIntent["clickCount"] = "\(clickCount)"
//                    vc.VCIntent["rpt_typ"] = "h"
//                    self.present(vc, animated: true, completion: nil)
                    
                    myTopView.setText(title: "SPO Hedquarter Wise Report")
                    spoIdExtra = spoIdFromList
                    rpt_typ =  "h"
                    GetSpoCNFGrid()
                }

            }else {
                adapter = SpoRptAdapter(tableView: tableView, vc: self,dataList : dataList,clickCount: clickCount)
                tableView.reloadData()
           }
        
        
           }catch{
                customVariablesAndMethod1.getAlert(vc: self, title: "Missing field error", msg: error.localizedDescription)
            
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: self)
            
                objBroadcastErrorMail.requestAuthorization()
            
            
        
            }
        }
    }
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
       // return .landscapeRight
        return .all
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
    
}
