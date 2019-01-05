//
//  DCR_Area_new.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 27/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import DPDropDownMenu
import CoreLocation
class DCR_Area_new: CustomUIViewController , CustomTextViewWithButtonDelegate,CheckBoxWithLabelDelegate {
    func onCheckedChangeListner(sender: CheckBoxWithLabel, ischecked: Bool) {
        divert_remark.isHidden = !ischecked
    }
    
    func onClickListnter(sender: CustomTextViewWithButton) {
        switch (sender.getTag()) {
        case WORK_WITH_DILOG:
            onClickWorkWith()
        case AREA_DILOG:
            onClickAreaLayout()
        case ROUTE_DILOG:
            onClickRouteLayout()
        default:
            print("tag not assighned")
        }
    }
    
    

    //var VCIntent = [String:String]()
    
    var progressHUD : ProgressHUD!
    var customVariablesAndMethod : Custom_Variables_And_Method! = nil
    let cbohelp: CBO_DB_Helper = CBO_DB_Helper.shared
    @IBOutlet weak var workinkWithDropDown :  DPDropDownMenu!

    @IBOutlet weak var workwithlayout: CustomTextViewWithButton!
    @IBOutlet weak var stackLocationStackView: UIStackView!
    @IBOutlet weak var lblDcrPendingDate: MarqueeLabel!
 
    
    
    
    
    @IBOutlet weak var late_remark: CustomTextView!
    @IBOutlet weak var divert_remark: CustomTextView!
    @IBOutlet weak var ROUTEDIVERTYN: CheckBoxWithLabel!
    //    @IBOutlet weak var workWithLayout: UIView!

    @IBOutlet weak var areaLayout: CustomTextViewWithButton!
    @IBOutlet weak var loc: UnderlineTextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var back: CustomeUIButton!
    
    @IBOutlet weak var save: CustomeUIButton!
    
    
    var list = [DPItem]()
    
    var PA_ID : Int = 0
    var paid1 = "";
    var root_id = "";
    var root_name = "", myArea : String = ""
    var Root_Needed : String = ""
    var currentBestLocation = CLLocation()
    var mLatLong : String = ""
    var mAddress = "" , LocExtra = ""
    var fmcg_Live_Km = "";
    
    var workwith1 = "", workwith2 = "", workwith34 = "", workWith4 = "", workWith5 = "", workWith6 = "", workWith7 = "", workWith8 = "", address = "", work_withme = "", work_name = "";
    var part1 = "", part2 = "", part3 = "", part4 = "", part5 = "", part6 = "", part7 = "", part8 = "";
    var real_date = "";
    var work_val = "",work_type_code = "";
    var work_with_name = "", work_with_id = "", area_name = "", area_id = "";
    
    
    var work_type_Selected = ""
    let  MESSAGE_INTERNET_WORKTYPE=1,MESSAGE_INTERNET_SUBMIT_WORKING=2,MESSAGE_INTERNET_DCRCOMMIT_DOWNLOADALL=3,GPS_TIMMER=4;
    let  WORK_WITH_DILOG=5,ROUTE_DILOG=6,AREA_DILOG=7;
    
    var context : CustomUIViewController!
    //MARK: - Open Wrok with
    func onClickWorkWith() {
        var msg = [String : String]()
        msg["header"] = "Work With"
        msg["sDCR_DATE"] = real_date
        msg["PlanType"] = VCIntent["plan_type"]
        msg["DIVERTWWYN"] = "0"
        msg["sWorking_Type"] = work_val
        Work_With_Dialog(vc: self, msg: msg, responseCode: WORK_WITH_DILOG).show()
    }
    
    
    func onClickAreaLayout(){
        
        work_name = workwithlayout.getText()
        
        if (work_name == "" &&  !work_type_code.contains("_W")) {
            customVariablesAndMethod.getAlert(vc: context,title: "Work with !!!",msg: "Please Select Work with First...");
        }  else {
            
            var sAllYn = "0", dcr_root_divert = "0";
            if(ROUTEDIVERTYN.isChecked() ){
                sAllYn="1";
                dcr_root_divert="1";
            }
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "dcr_root_divert",value: dcr_root_divert);
            
            var msg = [String : String]()
            msg["header"] = "Select Area..."
            msg["sAllYn"] = sAllYn
            Area_Dialog(vc: self, msg: msg, responseCode: AREA_DILOG).show()
        }
    }
    
    
    func onClickRouteLayout () {
        work_name = workwithlayout.getText()
        if (Custom_Variables_And_Method.pub_desig_id == "1" && checkforCalls()) {
            customVariablesAndMethod.getAlert(vc: context,title: "Call Found",msg: "Can not change Root !!! \nSome Calls found in your Day Summary.\nElse Reset your Day Plan from Utilies");
        }else if (work_name == "" &&  !work_type_code.contains("_W")) {
            customVariablesAndMethod.getAlert(vc: context,title: "Work with !!!",msg: "Please Select Work with First...");
        } else {
            
            //Intent i = new Intent(context, DcrRoot.class);
            var sAllYn = "N", dcr_root_divert = "0";
            if(ROUTEDIVERTYN.isChecked() ){
                sAllYn="Y";
                dcr_root_divert="1";
            }
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "dcr_root_divert",value: dcr_root_divert);
            
            
            var msg = [String : String]()
            msg["header"] = "Route List"
            msg["sAllYn"] = sAllYn
            Route_Dialog(vc: self, msg: msg, responseCode: ROUTE_DILOG).show()
            
        }
    }
    
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        setView(view: myContentView)
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = ProgressHUD(vc : self)
        workwithlayout.setTag(tag: WORK_WITH_DILOG)
        areaLayout.setTag(tag: AREA_DILOG)
        
        
        workwithlayout.setHint(placeholder: "Press the + sign for Work-With")
        areaLayout.setHint(placeholder: "Press the + sign for Additional Area")
        
        divert_remark.setHint(placeholder: "Enter Divert Remark")
        late_remark.setHint(placeholder: "Enter Late Remark")
        ROUTEDIVERTYN.setText(text: "Divert Area")
        
        workwithlayout.delegate = self
        areaLayout.delegate = self
        
        context = self
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        customVariablesAndMethod.betteryCalculator()
        
        myTopView.backButton.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        
        myTopView.title.text = "Dcr Day Open"
        
        back.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        
        
        Custom_Variables_And_Method.GLOBAL_LATLON = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "shareLatLong",defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON);
        
        PA_ID = Custom_Variables_And_Method.PA_ID;
        paid1 = "\(PA_ID)"
        
        currentBestLocation = customVariablesAndMethod.getObject(context: context,key: "currentBestLocation")
        
        mLatLong = Custom_Variables_And_Method.GLOBAL_LATLON;
        mAddress = Custom_Variables_And_Method.global_address;
        
        if (currentBestLocation != CLLocation()) {
            LocExtra = "Lat_Long  \(currentBestLocation.coordinate.latitude),  \(currentBestLocation.coordinate.longitude ), Accuracy \(currentBestLocation.horizontalAccuracy ) , Time \( currentBestLocation.timestamp), Speed \( currentBestLocation.speed ), Provider "
        }
        
        Custom_Variables_And_Method.ROOT_NEEDED = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "root_needed",defaultValue: "Y");
        Root_Needed = Custom_Variables_And_Method.ROOT_NEEDED;
        fmcg_Live_Km = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "live_km",defaultValue: "");
        
        Custom_Variables_And_Method.DCR_DATE = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "DATE_NAME",defaultValue: "");
        date.text = Custom_Variables_And_Method.DCR_DATE
        Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT=customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "DCR_DATE",defaultValue: "");
        real_date = Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT;
        
        
        //scrollview.isScrollEnabled = true
        // scrollview.contentSize = CGSize(width: scrollview.frame.width, height: 1000)
        
        
        if ((Custom_Variables_And_Method.DcrPending_datesList.count == 1) || (Custom_Variables_And_Method.DcrPending_datesList.count == 0)) {
            lblDcrPendingDate.isHidden = true
        } else {
            
            lblDcrPendingDate.text = Custom_Variables_And_Method.DcrPending_datesList.joined(separator: ",")
            marqueeRun(myMarqueeLabel : lblDcrPendingDate)
            
        }
        
        setAddressToUI();
        
        if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "DCR_ADDAREANA",defaultValue: "") == "Y"){
            areaLayout.isHidden = true
        }
        
        if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "ROUTEDIVERTYN",defaultValue: "").uppercased() == "Y"){
            ROUTEDIVERTYN.isHidden = false
            divert_remark.isHidden = true
            
        }else{
            ROUTEDIVERTYN.isHidden = true
            divert_remark.isHidden = true
        }
        
        
        ROUTEDIVERTYN.delegate = self
        
        divert_remark.setText(text: "")
        
        
        if (Custom_Variables_And_Method.location_required != "Y") {
            stackLocationStackView.isHidden = true
        }
        
        
        workinkWithDropDown.layer.borderWidth = CGFloat(2.0)
        workinkWithDropDown.layer.cornerRadius = 8
        workinkWithDropDown.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        workinkWithDropDown.headerTextColor = AppColorClass.colorPrimaryDark!
        workinkWithDropDown.menuTextColor = AppColorClass.colorPrimaryDark!
        workinkWithDropDown.selectedMenuTextColor = AppColorClass.colorPrimaryDark!
        
        
        
        if(VCIntent["plan_type"] == "p") {
            
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "area_name",value: "");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "work_with_name",value: "");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "work_with_individual_name",value: "");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "route_name",value: "");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "sDivert_Remark",value: "");
            
            if (!customVariablesAndMethod.IsBackDate(context: context) ) {
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "IsBackDate",value: "1"); //not back date entry
            }else{
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "IsBackDate",value: "0");
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "BackDateReason",value: "");
            }
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc :context,key:"ROUTEDIVERTYN_Checked",value: "N");
            
            //Start of call to service
            
            
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
              params["sDCR_DATE"] = Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT
            let tables = [0]
            
            // avoid deadlocks by not using .main queue here
            progressHUD.show(text: "Please Wait.. \n Fetching your worktype" )
            
            
            CboServices().customMethodForAllServices(params: params, methodName: "DCRWORKINGTYPE_MOBILE_2", tables: tables, response_code: MESSAGE_INTERNET_WORKTYPE, vc : self )
            
            
            //End of call to service
        }else {
            myTopView.title.text = "Dcr Day Replan"
            work_val=customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "working_head",defaultValue: "Working" );
            work_type_code=customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "working_code", defaultValue: "W");
            
            list.removeAll()
            list.append( DPItem(title : work_val,code : work_type_code) )
            workinkWithDropDown.items.append(list[0])
            
            workWithPopulate()
            
            
            work_with_name =  customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "route_Ww_Name",defaultValue: "");
            work_with_id = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "route_Ww_ID",defaultValue: "");
            root_name = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "route_Route_Name",defaultValue: "");
            root_id = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "route_Route_ID",defaultValue: "");
            
            print(root_id)
            
            area_name = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "route_area_Name",defaultValue: "");
            area_id = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "route_area_ID",defaultValue: "");
            
            if((work_with_name != "") && (area_name != "")){
                
                workwithlayout.setText(text: work_with_name)
                areaLayout.setText(text: area_name)
                
            }
            
        }
        
        if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "IsBackDate",defaultValue: "0") == ("1") ) {
            late_remark.setText(text: "");
            late_remark.isHidden = true
        }else{
            late_remark.isHidden = false
            late_remark.setText(text: customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "BackDateReason",defaultValue: ""));
        }
        
        
        // onclick Savelistener
        
        save.addTarget(self, action: #selector(onclickSavelistener), for: .touchUpInside)
        
    }
    
    func setAddressToUI() {
        
        if (Custom_Variables_And_Method.global_address != "") {
            loc.text = Custom_Variables_And_Method.global_address
        } else
            if (loc.text == "") {
                loc.text = Custom_Variables_And_Method.GLOBAL_LATLON
                
            } else {
                loc.text = Custom_Variables_And_Method.GLOBAL_LATLON
        }
        
        
    }
    
    
    
    
    func workWithPopulate() {

        workinkWithDropDown.didSelectedItemIndex = { index in
            self.workinkWithDropDown.headerTitle = (self.list[index].title)
            self.work_val = (self.list[index].title)
            self.work_type_code = (self.list[index].code)!
            
            Custom_Variables_And_Method.work_val = self.work_val;
            
            if(self.customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc : self ,key :"ROUTEDIVERTYN", defaultValue: "") == "Y"){
                self.ROUTEDIVERTYN.isHidden = false
                //areaLayout.setVisibility(View.GONE);
            }
            
            var code = self.work_type_code;
            if (self.work_type_code.contains("NR")){
                code = "W";
            }
            switch (code){
            case "OCC" , "OSC" , "CSC" , "W" , "M" ,"WBZ":
                self.workwithlayout.isHidden = false
                self.areaLayout.isHidden = false
                break;

            case "HM" :
                self.workwithlayout.isHidden = true
                self.areaLayout.isHidden = true
                self.ROUTEDIVERTYN.isHidden = true
                break ;
            case "LR" :
                var url = self.cbohelp.getMenuUrl(menu: "TRANSACTION", menu_code: "T_LR1");
                var url1 = self.cbohelp.getMenuUrl(menu: "PERSONAL_INFO", menu_code: "LEAVE");
                if (url != "") {
                    if ( url.contains("?")) {
                        url = url +  "&DATE=" + Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT ;
                    }else{
                        url = url + "?DATE=" + Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT;
                    }
                    self.customVariablesAndMethod.setDataForWebView(vcself: self, mode: 0, title: "Leave Request", url: url,CloseParent: true)
                    
                } else if (url1 != "") {
                    if ( url1.contains("?")) {
                        url1 = url1 +  "&DATE=" + Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT ;
                    }else{
                        url1 = url1 + "?DATE=" + Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT;
                    }
                    self.customVariablesAndMethod.setDataForWebView(vcself: self, mode: 0, title: "Leave Request", url: url1,CloseParent: true)
                }else {
                    self.customVariablesAndMethod.getAlert(vc: self, title: "Under Devlopment", msg: "\(self.work_val) is presently under Development...")
                }
               
                break;
           
            default:
                
                self.ROUTEDIVERTYN.setcheched(checked: self.customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self, key: "ROUTEDIVERTYN_Checked", defaultValue: "") == "Y")
                
                if (self.work_type_code.contains("_")){
                    if (self.work_type_code.contains("_W")) {
                        self.workwithlayout.isHidden = true
                    }else{
                        self.workwithlayout.isHidden = false
                    }
                   
                    
                    if (self.work_type_code.contains("_A")) {
                        self.areaLayout.isHidden = true
                    }else{
                        self.areaLayout.isHidden = false
                    }
                }else{
                    self.workwithlayout.isHidden = false
                    self.areaLayout.isHidden = false
                }
            }
            
            if(self.customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "DCR_ADDAREANA",defaultValue: "") == "Y"){
                self.areaLayout.isHidden = true
            }
        }
        workinkWithDropDown.selectedIndex = 0
    }
    
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        progressHUD.dismiss()
        switch response_code {
        case WORK_WITH_DILOG:
            
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            //lblWorkWith.text = String(inderData["workwith_name"]!.dropLast())
            
            
            work_with_name = inderData["workwith_name"]!
            work_with_id = inderData["workwith_id"]!
            
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "route_Ww_Name", value: work_with_name);
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "route_Ww_ID", value: work_with_id);
            workwithlayout.setText(text: work_with_name)
            //customVariablesAndMethod.getAlert(vc: context, title: "Error", msg: work_with_name)
            break
       
        case AREA_DILOG:
            
            
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            //lblAdditionalArea.text = String(inderData["workwith_name"]!.dropLast())
            
            area_name = inderData["area_name"]!
            area_id = inderData["area_id"]!
            
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "route_area_Name", value: area_name);
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "route_area_ID", value: area_id)
            
            areaLayout.setText(text: area_name)
            
            break
        case MESSAGE_INTERNET_WORKTYPE:
            parser_workType(dataFromAPI : dataFromAPI)
        case MESSAGE_INTERNET_SUBMIT_WORKING:
            parser_submit_for_working(dataFromAPI : dataFromAPI);
            break;
        case MESSAGE_INTERNET_DCRCOMMIT_DOWNLOADALL:
            parser_DCRCOMMIT_DOWNLOADALL(dataFromAPI : dataFromAPI);
            break;
        case GPS_TIMMER:
            //submitDCR();
            break;
        case 99:
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    
    private func parser_workType(dataFromAPI : [String : NSArray])
    {
        progressHUD.dismiss()
        if(!dataFromAPI.isEmpty){
            let jsonArray =   dataFromAPI["Tables0"]!
            list.removeAll()
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                list.append( DPItem(title : innerJson["FIELD_NAME"] as! String,code : innerJson["WORKING_TYPE"] as! String) )
                workinkWithDropDown.items.append(list[i])
            }
            workWithPopulate()
        }
    }
    
    
    
    func checkforCalls() -> Bool {
        var result = 0;
        //result += cbo_helper.getmenu_count("phdcrdr_rc");
        result += cbohelp.getmenu_count(table: "tempdr");
        result += cbohelp.getmenu_count(table: "chemisttemp");
        //result += cbo_helper.getmenu_count("phdcrstk");
        if (result==0){
            return false;
        }else {
            return true;
        }
    }
    
    
    
    
    // MARK:- pressedBackButton
    fileprivate func marqueeRun( myMarqueeLabel : MarqueeLabel  )   {
        myMarqueeLabel.tag = 301
        myMarqueeLabel.type = .continuous
        myMarqueeLabel.speed = .rate(70.0)
        myMarqueeLabel.fadeLength = 10.0
        myMarqueeLabel.leadingBuffer = 30.0
        myMarqueeLabel.trailingBuffer = 20.0
        myMarqueeLabel.textAlignment = .center
        //  myMarqueeLabel.textColor = UIColor.white
        //        let myMarqueeMsg = " hello CBO's users  this is end of the year 2017 ... we are wishing you happy new year"
        //        myMarqueeLabel.text =  myMarqueeMsg
    }
    
    
    
    // MARK:- pressedBackButton
    @objc func pressedBackButton(_ sender: UIButton) {
        Custom_Variables_And_Method.closeCurrentPage(vc: self)
    }
    
    
    @objc func onclickSavelistener(_ sender: UIButton) {
        // TODO Auto-generated method stub
        setAddressToUI();
        if (loc.text == "") {
            loc.text = "UnKnown Location"
        }
        
        
        address = loc.text!
        if address == ""{
                customVariablesAndMethod.getAlert(vc: self, title: "Network Error", msg: "Slow Network Connection" + "\n" + "Please Re-Start Your Device And Try Again .....")
        }
        myArea = areaLayout.getText()
        
        
        cbohelp.deletedcrFromSqlite();
        cbohelp.deleteUtils();
        cbohelp.deleteDCRDetails();
        
        if(VCIntent["plan_type"] == "p") {
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "srno", value: "0");
        }
        let FIRST_CALL_LOCK_TIME = Float(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "FIRST_CALL_LOCK_TIME",defaultValue: "0"));
        if (FIRST_CALL_LOCK_TIME==0) {
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "CALL_UNLOCK_STATUS",value: "[CALL_UNLOCK]");
        }else{
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "CALL_UNLOCK_STATUS",value: "");
        }
        
        
        
        cbohelp.insertUtils(area: Custom_Variables_And_Method.pub_area);
        
        cbohelp.insertDcrDetails(dcrid: Custom_Variables_And_Method.DCR_ID, pubarea: Custom_Variables_And_Method.pub_area);
        
        
        let routeCheck = root_id;
        
        let remarkLenght = Int(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "DCR_LETREMARK_LENGTH",defaultValue: "0"));
        if (work_type_code.isEmpty) {
            customVariablesAndMethod.getAlert(vc: context,title: "WorkType !!",msg: "Please Select worktype.....");
        }else if (!divert_remark.isHidden && divert_remark.getText().isEmpty) {
            customVariablesAndMethod.getAlert(vc: context,title: "Divert Remark !!!",msg: "Please enter Divert Remark");
        }else if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "IsBackDate",defaultValue: "1") == "0" && late_remark.getText().count < remarkLenght! ) {
            customVariablesAndMethod.getAlert(vc: context,title: "Back-Date entry !!!",msg: "Please enter Late Remark for Back-Date entry in not less then \(remarkLenght!) letters",completion :{ _ in
                self.late_remark.myCustomeTextVIew.becomeFirstResponder()})
        }else if (routeCheck.contains("^")) {
            
            
            var splitData = customVariablesAndMethod.splitRouteData(route: routeCheck);
            root_id = splitData[0]
            
            print(splitData[0])
            
            let freq = splitData[1]
            let visited = splitData[2];
            let f = Int(freq);
            let vis = Int(visited);
            if (f! > 0) {
                if (vis! >= f!) {
                    customVariablesAndMethod.getAlert(vc: context, title: "Limit reached", msg: "Route Visit Frequency is -\(f!) \n You already Visited - \(vis!)");
                } else {
                    //new GPS_Timmer_Dialog(context,mHandler,"Day Plan in Process...",GPS_TIMMER).show();
                    submitDCR();
                }
            }
        } else {
            //new GPS_Timmer_Dialog(context,mHandler,"Day Plan in Process...",GPS_TIMMER).show();
            submitDCR();
        }
    }
    
    func forWorking(){
        if (workwithlayout.getText() == "") {
            customVariablesAndMethod.getAlert(vc: context,title: "Alert !!!",msg: "Please Select Work With Fisrt .....");
        } else if (areaLayout.getText() == "") {
            customVariablesAndMethod.getAlert(vc: context,title: "Alert !!!",msg: "Please Select Area Fisrt .....");
        } else {
            submitWorking();
        }
    }
    
    
    func submitDCR() {
        work_name = workwithlayout.getText()
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : self, key : "ROUTEDIVERTYN_Checked",value: ROUTEDIVERTYN.isChecked() ? "Y":"N") ;
        mLatLong = customVariablesAndMethod.get_best_latlong(context: context);
        
        var code = work_type_code;
        if (work_type_code.contains("NR")){
            code = "W";
        }
        switch (code){
       
        case "W","OCC","CSC","OSC" :
            forWorking()
            break;
        case "HM" :
            submitLeave();
            break ;
        case "M" :
            if (areaLayout.getText() == "") {
                customVariablesAndMethod.getAlert(vc: context,title: "Alert !!!",msg: "Please Select Area Fisrt .....");
            } else {
                getWorkWith();
                submitforMeeting();
            }
            break ;
        case "WBZ" :
             getWorkWith();
             Custom_Variables_And_Method.SELECTED_AREA = areaLayout.getText()
             submitforMeeting();
             break ;
        default:
            if (work_type_code.contains("_")){
                if (work_name == "" && !work_type_code.contains("_W")) {
                    customVariablesAndMethod.getAlert(vc: context,title: "Alert !!!",msg: "Please Select Work With Fisrt .....");
                } else if (root_name == "" && !work_type_code.contains("_A")) {
                    customVariablesAndMethod.getAlert(vc: context,title: "Alert !!!",msg: "Please Select Area Fisrt .....");
                } else {
                    getWorkWith();
                    submitforMeeting();
                }
            }else{
                if (areaLayout.getText() == "") {
                    customVariablesAndMethod.getAlert(vc: context,title: "Alert !!!",msg: "Please Select Area Fisrt .....");
                } else {
                    getWorkWith();
                    submitforMeeting();
                }
            }
        }
    }
    
    
    func getWorkWith() {
        var parts = work_with_id.components(separatedBy: ",");
        if (parts.count == 1) {
            part1 = parts[0];
        }
        if (parts.count == 2) {
            part1 = parts[0];
            part2 = parts[1];
        }
        if (parts.count == 3) {
            part1 = parts[0];
            part2 = parts[1];
            part3 = parts[2];
        }
        if (parts.count == 4) {
            part1 = parts[0];
            part2 = parts[1];
            part3 = parts[2];
            part4 = parts[3];
        }
        if (parts.count == 5) {
            part1 = parts[0];
            part2 = parts[1];
            part3 = parts[2];
            part4 = parts[3];
            part5 = parts[4];
        }
        if (parts.count == 6) {
            part1 = parts[0];
            part2 = parts[1];
            part3 = parts[2];
            part4 = parts[3];
            part5 = parts[4];
            part6 = parts[5];
        }
        if (parts.count == 7) {
            part1 = parts[0];
            part2 = parts[1];
            part3 = parts[2];
            part4 = parts[3];
            part5 = parts[4];
            part6 = parts[5];
            part7 = parts[6];
        }
        if (parts.count == 8) {
            part1 = parts[0];
            part2 = parts[1];
            part3 = parts[2];
            part4 = parts[3];
            part5 = parts[4];
            part6 = parts[5];
            part7 = parts[6];
            part8 = parts[7];
        }
        
        workwith1 = part1;
        
        workwith2 = part2;
        
        workwith34 = part3;
        workWith4 = part4;
        workWith5 = part5;
        workWith6 = part6;
        workWith7 = part7;
        workWith8 = part8;
    }
    
    
    
    func submitWorking() {
        
        getWorkWith();
        /*cbo_helper.delete_phdoctor();
         cbo_helper.deleteChemist();*/
        
         let dcr_root_divert = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "dcr_root_divert",defaultValue: "0");
      
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPA_ID"] = String( Custom_Variables_And_Method.PA_ID);
        params["sDCR_DATE"] = String( real_date);
        params["sSTATION"] = String( myArea);
        params["iTOTAL_DR"] = "1"
        params["iIN_TIME"] = "99"
        params["iOUT_TIME"] = "0.0"
        params["sM_E1"] = ""
        params["sM_E2"] = ""
        params["sM_E3"] = ""
        params["iIN_TIME1"] = "0.0"
        params["iIN_TIME2"] = "0.0"
        params["iIN_TIME3"] = "0.0"
        params["iOUT_TIME1"] = "0.0"
        params["iOUT_TIME2"] = "0.0"
        params["iOUT_TIME3"] = "0.0"
        params["iWORK_WITH1"] = workwith1
        params["iWORK_WITH2"] = workwith2
        params["iWORK_WITH3"] = workwith34
        params["sDA_TYPE"] = work_val
        params["iDISTANCE_ID"] = "0"
        params["sREMARK"] = ""
        params["sLOC1"] =   "\(mLatLong )@\(LocExtra)!^\(mAddress)"
        params["iRETID"] =  "0"
        params["sWorkingType"] =  work_val
        params["iWORK_WITH4"] =  workWith4
        params["iWORK_WITH5"] =  workWith5
        params["iWORK_WITH6"] =  workWith6
        params["iWORK_WITH7"] =  workWith7
        params["iWORK_WITH8"] =  workWith8
        params["iDiverYn"] =  dcr_root_divert
        params["sLate_Remark"] =  late_remark.getText()
        params["sMOBILE_TIME"] = customVariablesAndMethod.currentTime(context: context,addServerTimeDifference: false)
        params["sINDP_WW"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "work_with_individual_id",defaultValue: "")
        params["sDivert_Remark"] = divert_remark.getText()
        
        let tables = [0]
        
        progressHUD.show(text: "Please Wait.. \nYour Day is being Planed" )
        
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCR_COMMIT_7", tables: tables, response_code: MESSAGE_INTERNET_SUBMIT_WORKING, vc : self )
        
        
        
        //End of call to service
        work_type_Selected="w";
        
    }
    
    func submitLeave() {
        
        /* cbo_helper.delete_phdoctor();
         cbo_helper.deleteChemist();*/
        let dcr_root_divert=customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "dcr_root_divert",defaultValue: "0");
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPA_ID"] = String(Custom_Variables_And_Method.PA_ID);
        params["sDCR_DATE"] = String(real_date);
        params["sSTATION"] = String(work_val);
        params["iTOTAL_DR"] = "1"
        params["iIN_TIME"] = "99"
        params["iOUT_TIME"] = "0.0"
        params["sM_E1"] = ""
        params["sM_E2"] =  ""
        params["sM_E3"] =  ""
        params["iIN_TIME1"] =  "0.0"
        params["iIN_TIME2"] = "0.0"
        params["iIN_TIME3"] = "0.0"
        params["iOUT_TIME1"] = "0.0"
        params["iOUT_TIME2"] =  "0.0"
        params["iOUT_TIME3"] = "0.0"
        params["iWORK_WITH1"] = ""
        params["iWORK_WITH2"] =  ""
        params["iWORK_WITH3"] =  ""
        params["sDA_TYPE"] = String(work_val)
        params["iDISTANCE_ID"] =  "0"
        params["sREMARK"] =  "0"
        params["sLOC1"] =   "\(mLatLong )@\(LocExtra)!^\(mAddress)"
        params["iRETID"] =  "0"
        params["iWORK_WITH4"] =  "0"
        params["iWORK_WITH5"] =  "0"
        params["iWORK_WITH6"] = "0"
        params["iWORK_WITH7"] =  "0"
        params["iWORK_WITH8"] =  "0"
        params["sWorkingType"] =  work_val
        params["iDiverYn"] = dcr_root_divert
        params["sLate_Remark"] =  late_remark.getText()
        params["sMOBILE_TIME"] =  customVariablesAndMethod.currentTime(context: context,addServerTimeDifference: false)
        params["sINDP_WW"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "work_with_individual_id",defaultValue: "")
        params["sDivert_Remark"] = divert_remark.getText()
        
        
        
        let tables = [0]
        
        progressHUD.show(text: "Please Wait.. \nYour Day is being Planed" )
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCR_COMMIT_7", tables: tables, response_code: MESSAGE_INTERNET_SUBMIT_WORKING, vc : self )
        
        
        //End of call to service
        work_type_Selected="l";
    }
    
    func submitforMeeting(){
        
        getWorkWith();
        
        let dcr_root_divert=customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "dcr_root_divert",defaultValue: "0");
        
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPA_ID"] = String(Custom_Variables_And_Method.PA_ID);
        params["sDCR_DATE"] = real_date
        params["sSTATION"] = work_val
        params["iTOTAL_DR"] = "1"
        params["iIN_TIME"] = "99"
        params["iOUT_TIME"] = "0.0"
        params["sM_E1"] = ""
        params["sM_E2"] = ""
        params["sM_E3"] = ""
        params["iIN_TIME1"] =  "0.0"
        params["iIN_TIME2"] = "0.0"
        params["iIN_TIME3"] = "0.0"
        params["iOUT_TIME1"] = "0.0"
        params["iOUT_TIME2"] = "0.0"
        params["iOUT_TIME3"] = "0.0"
        params["iWORK_WITH1"] = workwith1
        params["iWORK_WITH2"] = workwith2
        params["iWORK_WITH3"] = workwith34
        params["sDA_TYPE"] = work_val
        params["iDISTANCE_ID"] = String(root_id);
        params["sREMARK"] = ""
        params["sLOC1"] = "\(mLatLong )@\(LocExtra)!^\(mAddress)"
        params["iRETID"] = "0"
        params["sWorkingType"] = work_val
        params["iWORK_WITH4"] = workWith4
        params["iWORK_WITH5"] = workWith5
        params["iWORK_WITH6"] = workWith6
        params["iWORK_WITH7"] = workWith7
        params["iWORK_WITH8"] = workWith8
        params["iDiverYn"] = dcr_root_divert
        params["sLATE_REMARK"] = late_remark.getText()
        params["sMOBILE_TIME"] = customVariablesAndMethod.currentTime(context: context,addServerTimeDifference: false)
        params["sINDP_WW"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "work_with_individual_id",defaultValue: "")
        params["sDivert_Remark"] = divert_remark.getText()
        
        let tables = [0]
        
        progressHUD.show(text: "Please Wait.. \nYour Day is being Planed" )
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCR_COMMIT_7", tables: tables, response_code: MESSAGE_INTERNET_SUBMIT_WORKING, vc : self )
        
        
        //End of call to service
        work_type_Selected="n";
    }
    
    
    func setReultForNonWork() {
        if ((Custom_Variables_And_Method.DCR_ID != "0")) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Expenses_NotWorkingVC") as!
            Expenses_NotWorkingVC
            vc.VCIntent["title"] = "Final Submit"
            vc.VCIntent["form_type"] = "final"
            vc.VCIntent["Back_allowed"] = "N"
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    func parser_submit_for_working(dataFromAPI : [String : NSArray]) {
        
        do {
            if(!dataFromAPI.isEmpty){
                let jsonArray =   dataFromAPI["Tables0"]!
                for i in 0 ..< jsonArray.count{
                    let c = jsonArray[i] as! [String : AnyObject]
                    Custom_Variables_And_Method.DCR_ID = try c.getString(key: "DCRID") as! String;
                    try customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "DIVERTLOCKYN", value: c.getString(key: "DIVERTLOCKYN") as! String );
                    
                    try customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "FCMHITCALLYN", value: c.getString(key: "FCMHITCALLYN") as! String );
                    if c["FCMHITCALLYN"] as! String  != "" && c["FCMHITCALLYN"] as! String != "N" {
                        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "MOBILEDATAYN", value: "Y");
                        
                    }
                    
                    if (Custom_Variables_And_Method.DCR_ID == "0" ){
                        
                         progressHUD.dismiss()
                        
                        Custom_Variables_And_Method.DCR_ID = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "DCR_ID", defaultValue: "0")
                        try Alert(title: "Alert !!!",msg: c.getString(key: "MSG") as! String);
                    }else if try ( c.getString(key: "DIVERTLOCKYN") as! String == "Y"){
                         progressHUD.dismiss()
                        try customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "DCR_ID", value: c.getString(key: "DCRID") as! String);
                        try customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "DcrPlanTime_server", value: c.getString(key: "IN_TIME") as! String );
                        try Alert(title: "Alert !!!",msg: c.getString(key: "MSG") as! String);
                        
                       
                    }else{
                        
                        try customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "DCR_ID", value: c.getString(key: "DCRID") as! String);
                        try customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "DcrPlanTime_server", value: c.getString(key: "IN_TIME") as! String );
                        DownloadAll();
                    }
                }
                
            }
            
        } catch {
             progressHUD.dismiss()
            print("MYAPP", "objects are: \(error)")
            customVariablesAndMethod.getAlert(vc: self, title: "Missing field error", msg: error.localizedDescription )
            
            
            let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
            let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: self)
            
            objBroadcastErrorMail.requestAuthorization()
        }
        
       
        
    }
    //Log.d("MYAPP", "objects are1: " + result);
    
    
    
    
    func Alert(title : String , msg : String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel , handler:  { (alert: UIAlertAction!) in
            self.DownloadAll();
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func DownloadAll(){
        if (Custom_Variables_And_Method.DCR_ID != "0") {
            
            if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "dcr_date_real", defaultValue: "") == ""){
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "OveAllKm", value: "0.0");
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "DayPlanLatLong", value: customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "shareLatLong", defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON));
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "DcrPlantimestamp", value: customVariablesAndMethod.get_currentTimeStamp());
            }
            
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "working_head", value: work_val);
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "working_code", value: work_type_code);
            
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "BackDateReason", value: late_remark.getText())
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "sDivert_Remark", value: divert_remark.getText())
            
            
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "dcr_date_real", value: real_date);
            cbohelp.putDcrId(dcrid: Custom_Variables_And_Method.DCR_ID);
            Custom_Variables_And_Method.GCMToken = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "GCMToken", defaultValue: "");
            
            //Start of call to service
            
            var params = [String:String]()
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["iPA_ID"] = String(Custom_Variables_And_Method.PA_ID)
            params["sDcrId"] = Custom_Variables_And_Method.DCR_ID
            params["sRouteYn"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "root_needed",defaultValue: "Y")
            params["sGCM_TOKEN"] = Custom_Variables_And_Method.GCMToken
            
            params["sMobileId"] = customVariablesAndMethod.getDeviceInfo()
            params["sVersion"] = Custom_Variables_And_Method.VERSION
            
            var tables =  [Int]()
            tables.append(0);
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
            
            progressHUD.dismiss()
            progressHUD.show(text: "Please Wait..\nFetching your Utilitis for the day")
            
            
            CboServices().customMethodForAllServices(params: params, methodName: "DCRCOMMIT_DOWNLOADALL", tables: tables, response_code: MESSAGE_INTERNET_DCRCOMMIT_DOWNLOADALL, vc : self )
            
            //End of call to service
            
            
            if (fmcg_Live_Km == "5" || fmcg_Live_Km == "Y5") {
                var lat = "" , lon = "" , time = "", km = "0.0";
                customVariablesAndMethod.deleteFmcg_ByKey(vc: context,key: "myKm1");
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "Tracking", value: "Y");
                lat = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "shareLat",defaultValue: "0.0");
                lon = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "shareLon",defaultValue: "0.0");
                time = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "shareMyTime", defaultValue: customVariablesAndMethod.currentTime(context: self));
                km = "0.0";
                //customMethod.insertDataInOnces_Minute(lat, lon, km, time);
                
                //new Thread(r1).start();
                //new Thread(r2).start();
            }
            
            if(VCIntent["plan_type"] == "p") {
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "Final_submit",value: "N");
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFAREYN",value: "");
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",value: "");
                cbohelp.deleteAllRecord10();
                cbohelp.delete_DCR_Item(ID: nil,item_id: nil,ItemType: nil,Category: nil);
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "Dcr_Planed_Date", value: customVariablesAndMethod.currentDate());
            }
        
            
        }
        
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
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "DA_TYPE",value: MyDaType);
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "da_val",value: da_val);
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "distance_val",value: distance_val);
                
                let table1 = try dataFromAPI.getString(key: "Tables1");
                cbohelp.delete_phdoctor();
                for i in 0 ..< table1.count{
                    let c = table1[i] as! [String : AnyObject]
                    
                    try cbohelp.insert_phdoctor(dr_id: Int(c.getString(key: "DR_ID") as! String)!, dr_name: c.getString(key: "DR_NAME") as! String, dr_code: "", area: "",spl_id: Int(c.getString(key: "SPL_ID") as! String)!,LAST_VISIT_DATE: c.getString(key: "LASTCALL") as! String,
                                                CLASS: c.getString(key: "CLASS") as! String, PANE_TYPE: c.getString(key: "PANE_TYPE") as! String,POTENCY_AMT: c.getString(key: "POTENCY_AMT") as! String,
                                                ITEM_NAME: c.getString(key: "ITEM_NAME") as! String, ITEM_POB: c.getString(key: "ITEM_POB") as! String, ITEM_SALE: c.getString(key: "ITEM_SALE") as! String ,DR_AREA: c.getString(key: "AREA") as! String,DR_LAT_LONG: c.getString(key: "DR_LAT_LONG") as! String
                        , FREQ: c.getString(key: "FREQ") as! String ,NO_VISITED: c.getString(key: "NO_VISITED") as! String , DR_LAT_LONG2: c.getString(key: "DR_LAT_LONG2") as! String ,DR_LAT_LONG3: c.getString(key: "DR_LAT_LONG3") as! String ,COLORYN: c.getString(key: "COLORYN") as! String, CRM_COUNT: c.getString(key: "CRM_COUNT") as! String, DRCAPM_GROUP: c.getString(key: "DRCAPM_GROUP") as! String , SHOWYN: c.getString(key: "SHOWYN") as! String);
                   
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
                
                
                let Tables7 = try dataFromAPI.getString(key: "Tables7");
                cbohelp.delete_phdairy();
                for i in 0 ..< Tables7.count{
                    let c = Tables7[i] as! [String : AnyObject]

                    try cbohelp.insert_phdairy(DAIRY_ID: Int(c.getString(key: "ID") as! String)!, DAIRY_NAME: c.getString(key: "DAIRY_NAME" ) as! String, DOC_TYPE: c.getString(key: "DOC_TYPE") as! String , LAST_VISIT_DATE: "", DR_LAT_LONG: c.getString(key: "DAIRY_LAT_LONG") as! String, DR_LAT_LONG2: c.getString(key: "DAIRY_LAT_LONG2") as! String, DR_LAT_LONG3: c.getString(key: "DAIRY_LAT_LONG3") as! String )
                }

                let Tables8 = try dataFromAPI.getString(key: "Tables8");
                cbohelp.delete_phdairy_person();
                for i in 0 ..< Tables8.count{
                    let c = Tables8[i] as! [String : AnyObject]

                    try cbohelp.insert_phdairy_person(DAIRY_ID: Int(c.getString(key: "DAIRY_ID") as! String )!, PERSON_ID: Int(c.getString(key: "PERSON_ID") as! String )!, PERSON_NAME: c.getString(key: "PERSON_NAME") as! String)
                }

                let Tables9 = try dataFromAPI.getString(key: "Tables9")

                cbohelp.delete_phdairy_reason();

                for i in 0 ..< Tables9.count{
                    let c = Tables9[i] as! [String : AnyObject]
                    try cbohelp.insert_phdairy_reason(PA_ID: Int(c.getString(key: "PA_ID") as! String)!, PA_NAME: c.getString(key: "PA_NAME") as! String )
                }
                
                let table10 =  try dataFromAPI.getString(key : "Tables10");
                
                cbohelp.delete_Item_Stock();
                for i in 0 ..< table10.count{
                    let c = table10[i] as! [String : AnyObject]
                    try cbohelp.insert_Item_Stock( ITEM_ID: c.getString(key: "ITEM_ID") as! String, STOCK_QTY: Int(c.getString(key: "STOCK_QTY") as! String)! );
                }
                
                switch (work_type_Selected){
                case "w":
                    myTopView.CloseCurruntVC(vc: context)
                    break;
                case "l":
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "FinalSubmit") as!
                    FinalSubmit
                    vc.VCIntent["title"] = "Final Submit"
                    vc.VCIntent["Back_allowed"] = "N"
                    self.present(vc, animated: true, completion: nil)
                    break;
                case "n":
                    setReultForNonWork();
                    break;
                default:
                    print(work_type_Selected)
                }
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "work_type_Selected",value: work_type_Selected);
                
               //Custom_Variables_And_Method.closeCurrentPage(vc: self)
            }
        }catch {
            print("MYAPP", "objects are: \(error)")
            customVariablesAndMethod.getAlert(vc: self, title: "Missing field error", msg: error.localizedDescription )
            
            let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
            let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: self)
            
            objBroadcastErrorMail.requestAuthorization()
        }
        
    }
    //Log.d("MYAPP", "objects are1: " + result);
    
    
    
    
}


