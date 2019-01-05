

//
//  DCR_Report.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 18/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DCR_Report: CustomUIViewController {
    
    var monthname = [SpinnerModel]()
    var rptName = [SpinnerModel]()
    var progressHUD : ProgressHUD!
    
    @IBOutlet weak var nameFilterView: CustomFilterView!
    
    
    var userName="",userId="",last_mr_id = "",dr_id="";
    var monthName="",monthId="",pageType = "DCRRPT";
    
    
    let cbohelp = CBO_DB_Helper.shared
    let MESSAGE_INTERNET = 1,MESSAGE_INTERNET_DOCTOR = 2 , FILTERRESPONSE = 3
    var customMethodForAllServices : Custom_Variables_And_Method!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var backButton: CustomeUIButton!
    
    @IBOutlet weak var showButton: CustomeUIButton!
    
    @IBOutlet weak var nameDropDown: DropDownMenuWithLabel!
    
    @IBOutlet weak var monthDropDown: DropDownMenuWithLabel!
    @IBOutlet weak var DrDropDown: DropDownMenuWithLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameFilterView.context = self
        nameFilterView.response = FILTERRESPONSE
        
        
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        if VCIntent["type"] != nil{
            pageType = VCIntent["type"]!
        }
        
        nameFilterView.tap_Button.addTarget(self, action: #selector(tapOnNameFilterView), for: .touchUpInside)
        
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        showButton.addTarget(self, action: #selector(onClickShowButton), for: .touchUpInside)
        
        customMethodForAllServices = Custom_Variables_And_Method.getInstance()
        
        
       
        
        nameDropDown.dropDownMenu.visibleItemCount = 6
        monthDropDown.dropDownMenu.visibleItemCount = 6
        DrDropDown.dropDownMenu.visibleItemCount = 6
       
        nameDropDown.dropDownMenu.headerTitle = "--Select--"
        monthDropDown.dropDownMenu.headerTitle = "--Select--"
        DrDropDown.dropDownMenu.headerTitle = "--Select--"
        
        
        nameDropDown.dropDownMenu.headerTextBoldFontSize = 16
        monthDropDown.dropDownMenu.headerTextBoldFontSize = 16
        DrDropDown.dropDownMenu.headerTextBoldFontSize = 16

        if(pageType != "DRWISE"){
            DrDropDown.isHidden = true
        }
        
         workWithPopulate()
        
        //Start of call to service
        
        var params = [String : String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["sPaId"]  = "\(Custom_Variables_And_Method.PA_ID)"
        params["sMonthType"] = ""
        
        var tables = [ Int]()
        tables.append(0);
        tables.append(1);
        tables.append(2);
        
        progressHUD = ProgressHUD(vc: self)
        progressHUD.show(text: "Please Wait...\n")
        CboServices().customMethodForAllServices(params: params, methodName: "TEAMMONTHDIVISION_MOBILE", tables: tables, response_code: MESSAGE_INTERNET, vc : self , multiTableResponse : true)
        
        //End of call to service
 
    }
    @objc func tapOnNameFilterView(){
     
        
    }

    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }

    func  getDoctor(){
        if( !DrDropDown.isHidden){
            if (userId != ("") && last_mr_id != (userId)) {
                
                DrDropDown.dropDownMenu.items.removeAll()
                last_mr_id = userId
                dr_id=""
                
                //Start of call to service
               
                var tables = [ Int]()
                tables.append(0);
                
                var params = [String : String]()
                params["sCompanyFolder"] = cbohelp.getCompanyCode()
                params["sPaId"]  = "\(userId)"
                
                progressHUD.show(text: "Please Wait..\n" +
                " Fetching Doctors")
                CboServices().customMethodForAllServices(params: params, methodName: "GetDoctorByMR", tables: tables, response_code: MESSAGE_INTERNET_DOCTOR, vc : self )
                
                //End of call to service
            }else if (userId == ("")){
                customVariablesAndMethod1.msgBox(vc: self,msg: "Please Select MR First");
            }
        }
    }
    
    func workWithPopulate() {

        nameDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.nameDropDown.dropDownMenu.headerTitle = (self.nameDropDown.dropDownMenu.items[index].title)
            self.userId = self.nameDropDown.dropDownMenu.items[index].extra!
             self.getDoctor()
        }
        
        
        monthDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.monthDropDown.dropDownMenu.headerTitle = (self.monthDropDown.dropDownMenu.items[index].title)
            self.monthId = self.monthDropDown.dropDownMenu.items[index].extra!
         }
        
        //DrDropDown.dropDownMenu
        DrDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.DrDropDown.dropDownMenu.headerTitle = (self.DrDropDown.dropDownMenu.items[index].title)
            self.dr_id = self.DrDropDown.dropDownMenu.items[index].extra!
        }
    }
    
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        
        switch response_code {
        case MESSAGE_INTERNET:
           parser_worktype(dataFromAPI: dataFromAPI)
           progressHUD.dismiss()
        case MESSAGE_INTERNET_DOCTOR:
            parser_doctor(dataFromAPI: dataFromAPI)
            progressHUD.dismiss()
            break
        case FILTERRESPONSE:
            
            progressHUD.dismiss()
            let data = dataFromAPI["data"]!
            let innerData = data[0] as! Dictionary<String , String>
            let indexId : Int = Int(innerData["Selected_Index"]!)!
            userId =  nameFilterView.items[indexId].extra!
            nameFilterView.lbl_Header.text = nameFilterView.items[indexId].title
            getDoctor()
            break
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    
    @objc private func onClickShowButton(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DCR_ReportView") as! DCR_ReportView
        
        vc.VCIntent["title"] = VCIntent["title"]!
        vc.VCIntent["nameId"] = userId
        vc.VCIntent["monthId"] = monthId
        vc.VCIntent["dr_id"] = dr_id
        vc.VCIntent["type"] = pageType
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private func parser_doctor(dataFromAPI : [String : NSArray]){
        if !dataFromAPI.isEmpty {
          
            
            let jsonArray = dataFromAPI["Tables0"]!
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                DrDropDown.dropDownMenu.items.append(DPItem(title: innerJson["DR_NAME"]! as! String , extra: innerJson["DR_ID"]! as! String , highlight : false))
            }
            

            if DrDropDown.dropDownMenu.items.count == 1{
                DrDropDown.dropDownMenu.headerTitle = DrDropDown.dropDownMenu.items[0].title
                userId = DrDropDown.dropDownMenu.items[0].extra!
            }
            
           
        }
    }
    private func parser_worktype(dataFromAPI : [String : NSArray]){
        if !dataFromAPI.isEmpty {

            
            let jsonArray = dataFromAPI["Tables0"]!
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
            
                 nameFilterView.items.append(DPItem(title: innerJson["PA_NAME"]! as! String , extra: innerJson["PA_ID"]! as! String ))
            }
            
        
            let jsonArray1 = dataFromAPI["Tables2"]!
            for i in 0 ..< jsonArray1.count{
                let innerJson = jsonArray1[i] as! [String : AnyObject]
                monthDropDown.dropDownMenu.items.append(DPItem(title: innerJson["MONTH_NAME"]! as! String , extra: innerJson["MONTH"]! as! String ) )
            }
            
            nameFilterView.lbl_Header.text = nameFilterView.items[0].title
            userId =  nameFilterView.items[0].extra!
            
             getDoctor()
            
//            if nameDropDown.dropDownMenu.items.count == 1{
//                nameDropDown.dropDownMenu.headerTitle = nameDropDown.dropDownMenu.items[0].title
//                userId = nameDropDown.dropDownMenu.items[0].extra!
//                getDoctor()
//            }
            
            
            for month_Name in monthDropDown.dropDownMenu.items{
                if month_Name.title == Date().getMonthName(){
                    monthDropDown.dropDownMenu.headerTitle = month_Name.title
                    monthId = month_Name.extra!
                    
                }
            }
        }
    }
}
