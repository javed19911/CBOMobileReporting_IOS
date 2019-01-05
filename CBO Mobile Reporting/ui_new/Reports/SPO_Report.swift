//
//  SPO_Report.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 08/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class SPO_Report: CustomUIViewController {

    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    var mIdFrom : String = ""
    var mIdTo :String = ""
    var uid :String = ""

    @IBOutlet weak var fromMonthDropDown: DPDropDownMenu!
    
    @IBOutlet weak var toMonthDropDown: DPDropDownMenu!
    
    
    @IBOutlet weak var btn_Show: CustomeUIButton!
    
    
    @IBOutlet weak var btn_Back: CustomeUIButton!
    
    let cbohelp = CBO_DB_Helper.shared
    let MESSAGE_INTERNET = 1
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        progressHUD = ProgressHUD(vc: self)
        
        btn_Back.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        btn_Show.addTarget(self, action: #selector(pressedShow), for: .touchUpInside)
        
        //Start of call to service
    
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["sPaId"]  = "\(Custom_Variables_And_Method.PA_ID)"
        params["sMonthType"] = ""
        
        var tables =  [Int]()
        tables.append(0)
        tables.append(1)
        tables.append(2)
        progressHUD.show(text: "Please Wait.. ")
        
        CboServices().customMethodForAllServices(params: params, methodName: "TEAMMONTHDIVISION_MOBILE", tables: tables, response_code: MESSAGE_INTERNET, vc : self)
        
        //End of call to service
        
        setUI()
    }
    
    private func setUI(){
        
        fromMonthDropDown.didSelectedItemIndex = { index in
            self.mIdFrom = self.fromMonthDropDown.items[index].extra!
        }

        toMonthDropDown.didSelectedItemIndex = { index in
            self.mIdTo = self.toMonthDropDown.items[index].extra!
        }
        
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        
        switch response_code {
        case MESSAGE_INTERNET:
            parser_worktype(dataFromAPI: dataFromAPI)
            progressHUD.dismiss()
            
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    @objc func pressedShow(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpoRptGrid" ) as! SpoRptGrid
        vc.VCIntent["title"] = "SPO Consignee Wise Report"
        vc.VCIntent["uid"] = uid
         vc.VCIntent["mIdFrom"] = mIdFrom
         vc.VCIntent["mIdTo"] = mIdTo
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private func parser_worktype(dataFromAPI : [String : NSArray]){
        if !dataFromAPI.isEmpty {
            
           
            let jsonArray1 = dataFromAPI["Tables2"]!
            for i in 0 ..< jsonArray1.count{
                let innerJson = jsonArray1[i] as! [String : AnyObject]
                fromMonthDropDown.items.append(DPItem(title: innerJson["MONTH_NAME"]! as! String , extra: innerJson["MONTH"]! as! String ) )
                toMonthDropDown.items.append(DPItem(title: innerJson["MONTH_NAME"]! as! String , extra: innerJson["MONTH"]! as! String ) )
            }
            
            
            for month_Name in fromMonthDropDown.items{
                if month_Name.title == Date().getMonthName(){
                    fromMonthDropDown.headerTitle = month_Name.title
                    toMonthDropDown.headerTitle = month_Name.title
                    
                    mIdTo = month_Name.extra!
                    mIdFrom = month_Name.extra!
                }
            }
        }
    }
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
  

}

