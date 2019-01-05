//
//  Expenses_NotWorkingVC.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 19/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import SQLite
import DPDropDownMenu
import CoreLocation
class Expenses_NotWorkingVC: CustomUIViewController,AddExpensesAdaperDalegate, ImagePickerDelegate , FTPUploadDelegate{
   
    
    func getImage(image: UIImage) {
        clickedImage = image
       filename = "\(Custom_Variables_And_Method.PA_ID)_\(Custom_Variables_And_Method.DCR_ID)_\(exp_id)_\(customVariablesAndMethod.get_currentTimeStamp()).jpg"
        
        attachPicture.text = filename
    }
    
    func onEdit(id: String, name: String) {
        
        let indexId = Int(id)
        
        Add_expense(who: "1", hed: data[indexId!]["exp_head"]! , amount: data[indexId!]["amount"]! , rem: data[indexId!]["remark"]!, path: data[indexId!]["FILE_NAME"]!, hed_id: data[indexId!]["exp_head_id"]!)
    }
    
    func onDelete(id: String, name: String) {
        getAlert(id: id, name: name, title: "Delete")
    }
   
    var clickedImage = UIImage()
    var filename = ""
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var attachPicture: UILabel!
    var imagePickerController = UIImagePickerController()
    var objImagePicker : ImagePicker!
    
    var presenter : AddExpensesAdaper!
    
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var customVariablesAndMethod : Custom_Variables_And_Method!
    @IBOutlet weak var DALayout: UIView!
    var context : CustomUIViewController!
    
    @IBOutlet weak var otherExpTableview: UITableView!
    @IBOutlet weak var dis_edit: CustomDisableTextView!
    @IBOutlet weak var datype_edit: CustomDisableTextView!
    @IBOutlet weak var Area_DA_DP: DPDropDownMenu!
    
    @IBOutlet weak var Area_Distance_Dp: DPDropDownMenu!
    @IBOutlet weak var loc: CustomTextView!
    @IBOutlet weak var loc_layout: UIStackView!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var submitBtn: CustomeUIButton!
    @IBOutlet weak var route_distance_view: UIStackView!
    
    @IBOutlet weak var areaView: UIStackView!
    
    @IBOutlet weak var area_distance_view: UIStackView!
    
    @IBOutlet weak var final_submit_remark_layout: UIStackView!
    @IBOutlet weak var final_remark: CustomTextView!
    
    @IBOutlet weak var distAmt: CustomTextView!
    @IBOutlet weak var rootDa: UILabel!
    
    @IBOutlet weak var rootDistance: UILabel!
    @IBOutlet weak var routeStausTxt: UILabel!
    @IBOutlet weak var da_root: CustomTextView!
    @IBOutlet weak var actual_DA_layout: UIStackView!
    
    var ROUTE_CLASS = "",ACTUALDA_FAREYN = "";
    
    var MESSAGE_INTERNET_ROOT=1,MESSAGE_INTERNET_AREA=5,MESSAGE_INTERNET_SAVE_EXPENSE=2,
    MESSAGE_INTERNET_DCR_COMMITEXP=3,MESSAGE_INTERNET_DCR_DELETEEXP=4,MESSAGE_INTERNET_DCR_COMMITDCR=6,GPS_TIMMER=7;
    
    
    var routeNeeded = "N"
    var dcr_id = "0"
    var PA_ID = 0
    var progressHUD : ProgressHUD!
    var data = [[String:String]]()
    var rootdata = [String]();
    
    var DistRate = "", datype_val = "" ,my_Amt = "" ;
    var my_rem = ""
    var paid = "", ttl_distance = "", exp_id = "";
    var datype_local = "", datype_ex = "", datype_ns = "";
    var dist_id3 = "",locExtra = "";
    
    var Exp_head_list = [DPItem]()
    var Area_da_list = [DPItem]()
    var Area_dis_list = [DPItem]()
    
    var Back_allowed = "Y"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = self
//        otherExpTableview.dataSource = self
//        otherExpTableview.delegate = self
        progressHUD = ProgressHUD(vc : self)
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        customVariablesAndMethod.betteryCalculator()
        myTopView.backButton.addTarget(self, action: #selector(pressedBack), for: .touchUpInside )
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        routeNeeded = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "root_needed", defaultValue: "N");
        Custom_Variables_And_Method.GLOBAL_LATLON = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "shareLatLong",defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON)
        let currentBestLocation = customVariablesAndMethod.getObject(context: context,key: "currentBestLocation");
        
        if (currentBestLocation != CLLocation()) {
            locExtra = "Lat_Long  \(currentBestLocation.coordinate.latitude),  \(currentBestLocation.coordinate.longitude ), Accuracy \(currentBestLocation.horizontalAccuracy ) , Time \( currentBestLocation.timestamp), Speed \( currentBestLocation.speed ), Provider "
        }
        cameraButton.addTarget(self, action: #selector(openImageSource), for: .touchUpInside )
        
        distAmt.setHint(placeholder: "Amt.")
        distAmt.setKeyBoardType(keyBoardType: .numberPad)
        
        dcr_id = Custom_Variables_And_Method.DCR_ID;
        PA_ID = Custom_Variables_And_Method.PA_ID;
        
        setAddressToUI();
        
        if(Custom_Variables_And_Method.location_required == "Y") {
            loc_layout.isHidden = false
        }else{
            loc_layout.isHidden = true
        }
        
        
        if (VCIntent["form_type"] == "exp"){
            // submit expense only.....
            final_submit_remark_layout.isHidden = true
            submitBtn.setText(text: "Submit Expense")
        }else{
            // in case of not working.....
            final_submit_remark_layout.isHidden = false
            submitBtn.setText(text: "Final Submit")
        }
        

        if VCIntent["Back_allowed"]  != nil{
            Back_allowed = VCIntent["Back_allowed"]!
        }
        
        
        da_root.setKeyBoardType(keyBoardType: .numberPad)
        distAmt.setKeyBoardType(keyBoardType: .numberPad)
        
        if (routeNeeded == "Y") {
            rootView.isHidden = false
            areaView.isHidden = true
            //route_distance_view.isHidden = false
            area_distance_view.isHidden = true
            
            //Start of call to service
            
            var params = [String:String]()
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["iPaId"] = "\(PA_ID)"
            params["iDcrId"] =  dcr_id

            var tables = [Int]();
            tables.append(0);
            tables.append(1);
            tables.append(2);

            progressHUD.show(text: "Please Wait..." )
            //self.view.addSubview(progressHUD)
            
            
            
            CboServices().customMethodForAllServices(params: params, methodName: "DCREXPDDLALLROUTE_MOBILE", tables: tables, response_code: MESSAGE_INTERNET_ROOT, vc : self )

          
            
            //End of call to service
            
            /* new RootData().execute();*/
        } else {
            rootView.isHidden = true
            areaView.isHidden = false
            route_distance_view.isHidden = true
            attachPicture.isHidden = true
            area_distance_view.isHidden = false
            actual_DA_layout.isHidden = true
            routeStausTxt.isHidden = true
            
            dis_edit.setHint(placeholder: "Amt.")
            datype_edit.setHint(placeholder: "Amt.")
            //Start of call to service
            
            var params = [String:String]()
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["iPA_ID"] = "\(PA_ID)"

            var tables = [Int]();
            tables.append(0);
            tables.append(1);
            tables.append(2);
            tables.append(3);

            

            progressHUD.show(text: "Please Wait..." )
            //self.view.addSubview(progressHUD)
            
            
            
            CboServices().customMethodForAllServices(params: params, methodName: "ExpenseEntryDDL_Mobile", tables: tables, response_code: MESSAGE_INTERNET_AREA, vc : self )
            
            
            //End of call to service
        }
        
        //createRow()
        // Do any additional setup after loading the view.
        pressedOtherExpenses.addTarget(self, action: #selector(openAddAnotherExpenses) , for: .touchUpInside)
        submitBtn.addTarget(self, action: #selector(SubmitExp) , for: .touchUpInside)
    }
    @IBOutlet weak var pressedOtherExpenses : CustomeUIButton!
    
    func upload_complete(IsCompleted: String) {
        switch IsCompleted {
        case "S":
            //progressHUD.show(text: "Please Wait\nUploading Image")
            break
        case "Y":
            
            
            if(exp_id == "-1"){
                other_expense_commit()
            }else{
                progressHUD.dismiss()
                SubmitExpToServer()
            }
            break
            
        case "530":
            progressHUD.dismiss()
            customVariablesAndMethod.msgBox(vc: self, msg: "No Details found for upload\nPlease Download Data From Utilities Page....")
            break
        case "50":
            progressHUD.dismiss()
            break
        default:
            progressHUD.dismiss()
            customVariablesAndMethod.msgBox(vc: self,msg:"UPLOAD FAILED \n Please try again")
        }
    }
    func setAddressToUI() {
        loc.setText(text: Custom_Variables_And_Method.GLOBAL_LATLON)
    }
    
    func other_expense_commit(){
        //Start of call to service
        
        var request = [String:String]()
        request["sCompanyFolder"] = cbohelp.getCompanyCode()
        request["iDcrId"] = dcr_id
        request["iExpHeadId"] = exp_id
        request["iAmount"] = my_Amt
        request["sRemark"] = my_rem
        request["sFileName"] = filename
        
        var tables = [Int]();
        tables.append(0);
        
        //progress = ProgressHUD(vc: self)
        //progress.show(text: "Please Wait...")
        CboServices().customMethodForAllServices(params: request, methodName: "DCREXPCOMMITMOBILE_2", tables: tables, response_code: MESSAGE_INTERNET_SAVE_EXPENSE, vc: self)
        
        
        //End of call to service
    }
    func populateOtherExpenses(){
        data = cbohelp.get_Expense()
        presenter = AddExpensesAdaper(data: data, tableView: otherExpTableview, vc: self)
        otherExpTableview.delegate = presenter
        otherExpTableview.dataSource = presenter
        
        presenter.delegate = self
    }
    
    @objc func pressedBack(){
        
        if (Back_allowed == ("Y")){
            myTopView.CloseCurruntVC(vc: self)
        }else {
            customVariablesAndMethod.getAlert(vc: context,title: "Please Submit",msg: "Please complete your Final Submit");
        }
    }
    
   @objc func openAddAnotherExpenses() {
   
     Add_expense(who: "0", hed: "" , amount: "" , rem: "", path: "", hed_id: "")
    
    }
    
    
    func Add_expense(who : String, hed : String , amount : String, rem : String ,  path : String, hed_id : String) {

        
        let objAddAnotherExpenses = self.storyboard?.instantiateViewController(withIdentifier: "AddAnotherExpenses") as! AddAnotherExpenses
        
        objAddAnotherExpenses.vc =  self
        objAddAnotherExpenses.dropDownList =  Exp_head_list
        objAddAnotherExpenses.amount = amount
        objAddAnotherExpenses.remark = rem
        objAddAnotherExpenses.responseCode = MESSAGE_INTERNET_SAVE_EXPENSE
        objAddAnotherExpenses.VCIntent["Exp_Header"] = hed
        objAddAnotherExpenses.VCIntent["Exp_Id"] = hed_id
        objAddAnotherExpenses.VCIntent["path"] = path
        objAddAnotherExpenses.da_root_Text = da_root.getText()
        objAddAnotherExpenses.actual_DA_layout_isHidden = actual_DA_layout.isHidden
       
       
       objAddAnotherExpenses.VCIntent["who"] = who
        
        self.present(objAddAnotherExpenses, animated: true, completion: nil)
        
    }
    
    func AreaDa_DP_Populate() {
        
        Area_DA_DP.layer.borderWidth = CGFloat(2.0)
        Area_DA_DP.layer.cornerRadius = 8
        Area_DA_DP.headerBackgroundColor = UIColor.clear
        Area_DA_DP.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        Area_DA_DP.headerTextColor = AppColorClass.colorPrimaryDark!
        Area_DA_DP.menuTextColor = AppColorClass.colorPrimaryDark!
        Area_DA_DP.selectedMenuTextColor = AppColorClass.colorPrimaryDark!

        
        Area_DA_DP.didSelectedItemIndex = { index in
            self.Area_DA_DP.headerTitle = (self.Area_da_list[index].title)
            
            self.datype_val = self.Area_DA_DP.headerTitle
            
            if (self.datype_val == "Local" || self.datype_val == "--Select--" || self.datype_val == "DA Not Applicable") {
                self.area_distance_view.isHidden = true
                
            } else {
                self.area_distance_view.isHidden = false
            }
            if (self.datype_val == "--Select--") {
                self.datype_edit.setText(text: "");
            } else if (self.datype_val == "DA Not Applicable") {
                self.datype_edit.setText(text: "0");
                self.dis_edit.setText(text: "0");
            } else if (self.datype_val == "Local") {

                self.datype_edit.setText(text: self.datype_local);
                self.dis_edit.setText(text: "0");

            } else if (self.datype_val == "Ex-Station Double Side" || self.datype_val == "Ex-Station Single Side") {

                self.datype_edit.setText(text: self.datype_ex);


            } else {

                self.datype_edit.setText(text: self.datype_ns);

            }
            self.Area_Distance_Dp.selectedIndex = 0
        }
        Area_DA_DP.selectedIndex = 0
    }
    
    func AreaDisDP_Populate() {
        
        Area_Distance_Dp.layer.borderWidth = CGFloat(2.0)
        Area_Distance_Dp.layer.cornerRadius = 8
        Area_Distance_Dp.headerBackgroundColor = UIColor.clear
        Area_Distance_Dp.layer.borderColor =  AppColorClass.colorPrimaryDark?.cgColor
        Area_Distance_Dp.headerTextColor = AppColorClass.colorPrimaryDark!
        Area_Distance_Dp.menuTextColor = AppColorClass.colorPrimaryDark!
        Area_Distance_Dp.selectedMenuTextColor = AppColorClass.colorPrimaryDark!

        
        Area_Distance_Dp.didSelectedItemIndex = { index in
            self.Area_Distance_Dp.headerTitle = (self.Area_dis_list[index].title)
            self.dist_id3 = self.Area_dis_list[index].code!
            if (self.Area_DA_DP.headerTitle == "Ex-Station Double Side" || self.Area_DA_DP.headerTitle == "Out-Station Double Side") {
                
                
                self.ttl_distance = self.Area_Distance_Dp.headerTitle
                if (!self.ttl_distance.contains("----->")) {
                    self.dis_edit.setText(text: "");
                } else {
                    let Distance1 = self.ttl_distance.components(separatedBy: "----->");
                    
                    let ActDistance = Distance1[2];
                    let Act_dist1 = ActDistance.components(separatedBy: "K");
                    let MyDistance = Act_dist1[0].trimmingCharacters(in: .whitespaces)
                    let fare_rate = Float(self.DistRate)!;
                    let a = Float(MyDistance)!;
                    let res = a * 2 * fare_rate;
                    let MyData = "\(res)";
                    
                    self.dis_edit.setText(text: MyData);
                }
            } else if (self.Area_DA_DP.headerTitle == "Ex-Station Single Side" || self.Area_DA_DP.headerTitle == "Out-Station Single Side") {
                
                self.ttl_distance = self.Area_Distance_Dp.headerTitle
                if (!self.ttl_distance.contains("----->")) {
                    self.dis_edit.setText(text: "");
                } else {
                    let Distance1 = self.ttl_distance.components(separatedBy: "----->");
                    
                    let ActDistance = Distance1[2];
                    let Act_dist1 = ActDistance.components(separatedBy: "K");
                    let MyDistance = Act_dist1[0].trimmingCharacters(in: .whitespaces)
                    let fare_rate = Float(self.DistRate)!;
                    let a = Float(MyDistance)!;
                    let res = a * 1 * fare_rate;
                   let MyData = "\(res)";
                    
                    self.dis_edit.setText(text: MyData);
                }
            }
            
        }
        Area_Distance_Dp.selectedIndex = 0
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        switch response_code {
        case MESSAGE_INTERNET_AREA:
            parser1(dataFromAPI : dataFromAPI);
            break;
        case MESSAGE_INTERNET_SAVE_EXPENSE:
            if(exp_id == "-1"){
                let jsonArray1 =   dataFromAPI["Tables0"]!
                let object = jsonArray1[0] as! [String : AnyObject]
                do{
                    let id = try object.getString(key: "ID");
                    cbohelp.insert_Expense(exp_head_id: exp_id,exp_head: "",amount : my_Amt,remark:  my_rem,FILE_NAME: filename,ID: id as! String,time: customVariablesAndMethod1.currentTime(context: self));
                }catch{
                     print("Error")
                }
                progressHUD.dismiss();
                 SubmitExpToServer()
            }else{
                populateOtherExpenses();
                
                init_DA_type();
            }
           
            break;
        case MESSAGE_INTERNET_DCR_COMMITEXP:
             parser3(dataFromAPI : dataFromAPI);
            break;
        case MESSAGE_INTERNET_DCR_DELETEEXP:
            parser4(dataFromAPI : dataFromAPI);
            break;
        case MESSAGE_INTERNET_ROOT:
            parser5(dataFromAPI : dataFromAPI);
            break;
        case MESSAGE_INTERNET_DCR_COMMITDCR:
            parser6(dataFromAPI : dataFromAPI);
            break;
        case GPS_TIMMER:
            //FinalSubmit();
            break;
        case 99:
            progressHUD.dismiss();
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            progressHUD.dismiss();
            print("Error")
        }
    }
    
    
    private func parser4(dataFromAPI : [String : NSArray]) {
        if(!dataFromAPI.isEmpty){
            do {
            
                let jsonArray1 =   dataFromAPI["Tables0"]!
                let object = jsonArray1[0] as! [String : AnyObject]
                let value2 = try object.getString(key: "DCR_ID");
                
                
                cbohelp.delete_Expense_withID(exp_ID: exp_id)
                populateOtherExpenses()
                init_DA_type();
                
                customVariablesAndMethod.msgBox(vc: self, msg: " Exp. Deleted Sucessfully")

            }catch{
                customVariablesAndMethod.getAlert(vc: context, title: "Missing field error", msg: error.localizedDescription);
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: context)
                
                objBroadcastErrorMail.requestAuthorization()
            }
        }
    }
    
    
//    try {
//
//    String table0 = result.getString("Tables0");
//    JSONArray jsonArray1 = new JSONArray(table0);
//
//    JSONObject object = jsonArray1.getJSONObject(0);
//    String value2 = object.getString("DCR_ID");
//
//    cbohelp.delete_Expense_withID(exp_id);
//    data=cbohelp.get_Expense();
//    sm = new Expenses_Adapter(context, data);
//    mylist.setAdapter(sm);
//
//    init_DA_type(DA_layout);
//
//    customVariablesAndMethod.msgBox(context," Exp. Deleted Sucessfully");
//
//
//    } catch (JSONException e) {
//    Log.d("MYAPP", "objects are: " + e.toString());
//    CboServices.getAlert(this, "Missing field error", getResources().getString(R.string.service_unavilable) + e.toString());
//    e.printStackTrace();
//    }
//
//    }
//    //Log.d("MYAPP", "objects are1: " + result);
//    progress1.dismiss();
//    }
//
    
    
    func parser6(dataFromAPI : [String : NSArray]) {
    if(!dataFromAPI.isEmpty){
        do {
    
        let jsonArray1 =   dataFromAPI["Tables0"]!
    
        let object = jsonArray1[0] as! [String : AnyObject]
            let value2 = try object.getString(key: "ID");
    
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "DA_TYPE",value: "0");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "da_val",value: "0");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "distance_val",value: "0");
    
    
            cbohelp.delete_Expense();
            cbohelp.delete_Nonlisted_calls();
            cbohelp.deleteDcrAppraisal();
            cbohelp.deleteFinalDcr();
            cbohelp.deleteDCRDetails();
            cbohelp.deletedcrFromSqlite();
    
            Custom_Variables_And_Method.CHEMIST_NOT_VISITED = "";
            Custom_Variables_And_Method.STOCKIST_NOT_VISITED = "";
        
    
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "Final_submit",value: "Y");
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "work_type_Selected",value: "w");
    
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "dcr_date_real",value: "");
           
            
            customVariablesAndMethod.msgBox(vc: context,msg: " DCR Sucessfully Submitted",completion : {_ in
                self.myTopView.CloseAllVC(vc: self.context)
            });
    
        } catch {
        
            customVariablesAndMethod.getAlert(vc: context, title: "Missing field error", msg: error.localizedDescription);
            let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
            
            let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: context)
            
            objBroadcastErrorMail.requestAuthorization()
        }
    }
    
    progressHUD.dismiss();
}
    
    
    func parser5(dataFromAPI : [String : NSArray]) {
        if(!dataFromAPI.isEmpty){
            do {
        
                
                //Exp_head_list.append( DPItem(title: "--Select--", code: ""));
                Exp_head_list.removeAll()
                cbohelp.delete_EXP_Head();
        
                let jsonArray1 =   dataFromAPI["Tables0"]!
                
                for i in 0 ..< jsonArray1.count {
                    let jsonObject1 = jsonArray1[i] as! [String : AnyObject]
                   
                    try Exp_head_list.append( DPItem(title: jsonObject1.getString(key: "FIELD_NAME") as! String, code: jsonObject1.getString(key: "ID") as! String,type : jsonObject1.getString(key: "DA_ACTION") as! String));
                    try cbohelp.Insert_EXP_Head(FIELD_NAME: jsonObject1.getString(key: "FIELD_NAME") as! String, FIELD_ID: jsonObject1.getString(key: "ID") as! String,MANDATORY: jsonObject1.getString(key: "MANDATORY") as! String,DA_ACTION: jsonObject1.getString(key: "DA_ACTION") as! String);
                }
                if (Exp_head_list.count == 0) {
                    customVariablesAndMethod.msgBox(vc: context,msg: "No ExpHead found...");
                }
        
                data = [[String : String]]();
                data.removeAll()
                /*String table1 = result.getString("Tables1");
                 JSONArray jsonArray2 = new JSONArray(table1);
                 for (int i = 0; i < jsonArray2.length(); i++) {
                 JSONObject object = jsonArray2.getJSONObject(i);
                 Map<String, String> datanum = new HashMap<String, String>();
                 datanum.put("exp_head_id", object.getString("EXP_HEAD_ID"));
                 datanum.put("exp_head", object.getString("EXP_HEAD"));
                 datanum.put("amount", object.getString("AMOUNT"));
                 datanum.put("remark", object.getString("REMARK"));
                 datanum.put("FILE_NAME", object.getString("FILE_NAME"));
                 datanum.put("ID", object.getString("ID"));
                 data.add(datanum);
                 
                 }*/
               

                rootdata.removeAll()
               let jsonArray3 =   dataFromAPI["Tables2"]!
               
                for i in 0 ..< jsonArray3.count {
                    let object = jsonArray3[i] as! [String : AnyObject]
                    
                    try rootdata.append((object.getString(key: "DA_TYPE") as! String));
                    try rootdata.append((object.getString(key: "FARE") as! String));
                    try rootdata.append((object.getString(key: "ACTUALFAREYN") as! String));
                    try ROUTE_CLASS = (object.getString(key: "ROUTE_CLASS") as! String)
                    try ACTUALDA_FAREYN = (object.getString(key: "ACTUALDA_FAREYN") as! String)
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFAREYN",value: (try object.getString(key: "ACTUALFAREYN") as! String));


                }
                
                routeStausTxt.text = ROUTE_CLASS
                if (ROUTE_CLASS.trimmingCharacters(in: .whitespaces).isEmpty){
                     routeStausTxt.isHidden = true
                }else{
                    routeStausTxt.isHidden = false
                }
                
                da_root.setText(text: customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "da_val",defaultValue: "0"));
               
                if (ACTUALDA_FAREYN.lowercased() == ("y")){
                    actual_DA_layout.isHidden = false
                }else{
                    actual_DA_layout.isHidden = true
                }
                
                if (rootdata.count > 0) {
                    rootDa.text = rootdata[0]
                    rootDistance.text = rootdata[1]
                    if(rootdata[2].lowercased() ==  "y"){
                        route_distance_view.isHidden = false
                        attachPicture.isHidden = false
                        distAmt.setText(text: customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",defaultValue: ""));
                    }else{
                       route_distance_view.isHidden = true
                        attachPicture.isHidden = true
                        distAmt.setText(text: "");
                    }
                } else {
                    customVariablesAndMethod.msgBox(vc: context,msg: "No RootData found");
                }
                
                populateOtherExpenses();
                //                sm = new Expenses_Adapter(NonWorking_DCR.this, data);
                //                show_exp.setAdapter(sm);
                init_DA_type();
                progressHUD.dismiss();
            } catch  {
                //Log.d("MYAPP", "objects are: " + e.toString());
                customVariablesAndMethod.getAlert(vc: context,title: "Missing field error", msg: error.localizedDescription)   //getResources().getString(R.string.service_unavilable) +e.toString());
                

                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: context)
                
                objBroadcastErrorMail.requestAuthorization()
            }
        }
        //Log.d("MYAPP", "objects are1: " + result);
        progressHUD.dismiss()
    }
    
    
    func parser3(dataFromAPI : [String : NSArray]) {
        if(!dataFromAPI.isEmpty){
            do {
                
                let jsonArray1 =   dataFromAPI["Tables0"]!
                
                
                let object = jsonArray1[0] as! [String : AnyObject]
                let value2 = try object.getString(key: "DCR_ID");
                
                let chm_ok = getmydata()[0];
                let stk_ok = getmydata()[1];
                let exp_ok = getmydata()[2]
                
                
                if (exp_ok == "") {
                    cbohelp.insertfinalTest(chemist: chm_ok, stockist: stk_ok, exp: "2");
                } else {
                    cbohelp.updatefinalTest(chemist: chm_ok, stockist: stk_ok, exp: "2");
                }
                
//                new GPS_Timmer_Dialog(context,mHandler,"Final Submit in Process...",GPS_TIMMER).show();
                
                if (VCIntent["form_type"] == "exp"){
                    progressHUD.dismiss();
                    // submit expense only.....
                    customVariablesAndMethod.msgBox(vc: context,msg: "Expense Successfully Submited...", completion: {_ in self.myTopView.CloseCurruntVC(vc: self.context)})
                }else{
                    // in case of not working.....
                    FinalSubmit()
                }
            } catch{
                progressHUD.dismiss();
                customVariablesAndMethod.getAlert(vc: context,title: "Missing field error", msg: error.localizedDescription)
                
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: context)
                
                objBroadcastErrorMail.requestAuthorization()
            }
            
        }
    }
    
    
    func FinalSubmit(){
    //Start of call to service
    
        var ACTUALFARE = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",defaultValue: "");
        if (ACTUALFARE == ("")){
            ACTUALFARE = "0";
        }
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iDCRID"] =  dcr_id
        params["iNOCHEMIST"] =  "1"
        params["sNOSTOCKIST"] =  "1"
        params["sCHEMISTREMARK"] =  ""
        params["sSTOCKISTREMARK"] =  ""
        params["iPOB"] =  "0.0"
        params["iPOBQTY"] =  "0"
        params["iACTUALFAREAMT"] =  ACTUALFARE
        params["sDATYPE"] =  "NA"
        params["iDISTANCE_ID"] =  "99999"
        params["sREMARK"] =  final_remark.getText()
        params["sLOC2"] =  "\(Custom_Variables_And_Method.GLOBAL_LATLON )@\(locExtra)!^\(loc.getText())"
        params["iOUTTIME"] =  "99"
        
        var tables = [Int]();
        tables.append(0);
        
        progressHUD.text =  "Please Wait...\nFinal Submit in Progess..."
        //self.view.addSubview(progressHUD)
        
  
        CboServices().customMethodForAllServices(params: params, methodName: "DCR_COMMITFINAL_1", tables: tables, response_code: MESSAGE_INTERNET_DCR_COMMITDCR, vc : self )
     
    
    //End of call to service

    }
    
    func parser1(dataFromAPI : [String : NSArray]) {
        
        if(!dataFromAPI.isEmpty){
            do {
                Exp_head_list.removeAll()
                cbohelp.delete_EXP_Head();
                
                let jsonArray1 =   dataFromAPI["Tables2"]!
                
                for i in 0 ..< jsonArray1.count {
                    let jsonObject1 = jsonArray1[i] as! [String : AnyObject]
                    
                    try Exp_head_list.append( DPItem(title: jsonObject1.getString(key: "FIELD_NAME") as! String, code: jsonObject1.getString(key: "ID") as! String));
                    try cbohelp.Insert_EXP_Head(FIELD_NAME: jsonObject1.getString(key: "FIELD_NAME") as! String, FIELD_ID: jsonObject1.getString(key: "ID") as! String,MANDATORY: jsonObject1.getString(key: "MANDATORY") as! String,DA_ACTION: jsonObject1.getString(key: "DA_ACTION") as! String);
                }
                if (Exp_head_list.count == 0) {
                    customVariablesAndMethod.msgBox(vc: context,msg: "No ExpHead found...");
                }
                
                
                let jsonArray2 =   dataFromAPI["Tables0"]!
               
                for i in 0 ..< jsonArray2.count {
                    let jsonObject1 = jsonArray2[i] as! [String : AnyObject]
                    
                    DistRate = try jsonObject1.getString(key: "FARE_RATE") as! String;
                    datype_local = try jsonObject1.getString(key: "DA_L") as! String;
                    datype_ex = try jsonObject1.getString(key: "DA_EX") as! String;
                    datype_ns = try jsonObject1.getString(key: "DA_NS") as! String;
                }
                
               Area_dis_list.removeAll()
                let jsonArray3 =   dataFromAPI["Tables1"]!
               Area_dis_list.append(DPItem(title: "--Select--", code : ""))
                
                for i in 0 ..< jsonArray3.count {
                    let jsonObject2 = jsonArray3[i] as! [String : AnyObject]
                    try Area_dis_list.append( DPItem(title: jsonObject2.getString(key: "STATION_NAME")  as! String, code: jsonObject2.getString(key: "DISTANCE_ID")  as! String));
                }
               Area_Distance_Dp.items = Area_dis_list
               AreaDisDP_Populate()
                
                Area_da_list.removeAll()
                let jsonArray4 =   dataFromAPI["Tables3"]!
                
                Area_da_list.append(DPItem(title: "--Select--", code : ""))
                for i in 0 ..< jsonArray4.count {
                    let jsonObject2 = jsonArray4[i] as! [String : AnyObject]
                    try Area_da_list.append( DPItem(title: jsonObject2.getString(key: "PA_NAME")  as! String, code: ""));
                }
                Area_DA_DP.items = Area_da_list
                AreaDa_DP_Populate()
                
                populateOtherExpenses();
                //                sm = new Expenses_Adapter(NonWorking_DCR.this, data);
                //                show_exp.setAdapter(sm);
                init_DA_type();
                
            }catch{
                 customVariablesAndMethod.getAlert(vc: self, title: "Missing field error", msg: error.localizedDescription)
                
                
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: self)
                
                objBroadcastErrorMail.requestAuthorization()
            }
        }
            progressHUD.dismiss()
   
    }

    
    
    func getmydata() -> [String] {
        var raw = [String]();
        var chm = ""
        var stk = ""
        var exp = ""
        do {
            let statement :Statement = try cbohelp.getFinalSubmit();
            while let c = statement.next(){
                try chm = "\(chm)\(c[cbohelp.getColumnIndex(statement: statement , Coloumn_Name: "chemist")]! as! String)"
                try stk = "\(stk)\(c[cbohelp.getColumnIndex(statement: statement , Coloumn_Name: "stockist")]! as! String)"
                try exp = "\(exp)\(c[cbohelp.getColumnIndex(statement: statement , Coloumn_Name: "exp")]! as! String)";
            }
        }catch{
            print(error)
        }
        raw.append(chm);
        raw.append(stk);
        raw.append(exp);
        return raw;
    }
        
    /// submit exp -----------------
    @objc func SubmitExp(){
        let mandatory_pending_exp_head = cbohelp.get_mandatory_pending_exp_head();
        if (loc.getText() == "") {
            loc.text = "Unknown Location"
        }
        if (final_submit_remark_layout.isHidden == false && final_remark.getText() == "") {
            customVariablesAndMethod.msgBox(vc: context,msg: "Enter Remark First...");
        }else if (mandatory_pending_exp_head.count != 0) {
            
            var pending_list="";
            for i in  0 ..< mandatory_pending_exp_head.count {
                pending_list += mandatory_pending_exp_head[i]["PA_NAME"]!+"\n";
            }
            customVariablesAndMethod.getAlert(vc: context,title: "Expenses Pending",msg: pending_list);
            
        }else if(cbohelp.get_DA_ACTION_exp_head().count > 0  && actual_DA_layout.isHidden == false
            && !da_root.getText().isEmpty && da_root.getText() != ("0")){
            customVariablesAndMethod1.getAlert(vc: self,title: "Already Applied for DA...",
                                               msg: "Please make DA amount Rs 0.") {_ in
            };
        }  else if (routeNeeded == "Y") {
            
            if (route_distance_view.isHidden == false && distAmt.getText() == "") {
                customVariablesAndMethod.msgBox(vc: context,msg: "Please Enter the Actual Fare....");
            }else if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "EXP_ATCH_YN",defaultValue: "N") == "Y" && route_distance_view.isHidden == false && attachPicture.text == "* Attach Picture...." ){
                customVariablesAndMethod.msgBox(vc: context,msg: "Please Attach supporting File for Actual Fare....");
            }else if ( route_distance_view.isHidden == false ){
                
                exp_id = "-1";
                filename = attachPicture.text!
                my_Amt = distAmt.getText()
                my_rem =  "Actual Fare"
                
                if(attachPicture.text != ("* Attach Picture....")){
                    let ftpUpload = Up_Down_Ftp()
                    progressHUD.show(text: "Please Wait..\nuploading Image")
                    ftpUpload.uploadFile(data: clickedImage.convertImageToUploadableData(), fileName: filename)
                    ftpUpload.UploadDelegate = self
                }else{
                    filename = ""
                    //progressHUD = ProgressHUD(vc : self)
                    progressHUD.show(text: "Please Wait..")
                    other_expense_commit()
                }
                
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",value: distAmt.getText());
                distAmt.setText(text: "");
                
                if (distAmt.isHidden == true){
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",value: "0");
                }
            }else {
                SubmitExpToServer()
                
               
                customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",value: distAmt.getText());
                distAmt.setText(text: "");
                
                if (distAmt.isHidden == true){
                    customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context,key: "ACTUALFARE",value: "0");
                }
                
            }
        } else {
            if (datype_val == "") {
                customVariablesAndMethod.msgBox(vc: context,msg: "Select Your DA Type");
            } else {
                
               SubmitExpToServer()
                
            }
        }
    }
    
    func SubmitExpToServer(){
        
        customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc: context, key: "da_val",value: da_root.getText().trimmingCharacters(in: .whitespaces).isEmpty ? "0" : da_root.getText());

        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iDcrId"] = dcr_id
        params["sDaType"] = datype_val
        params["iDistanceId"] = dist_id3
        params["iDA_VALUE"] = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "da_val",defaultValue: "0")
        
        var tables = [Int]();
        tables.append(0);
        
        
        progressHUD.show(text: "Please Wait..." )
        
        //self.view.addSubview(progressHUD)
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCR_COMMITEXP_2", tables: tables, response_code: MESSAGE_INTERNET_DCR_COMMITEXP, vc : self )
        
        
        //End of call to service
    }

    @objc func openImageSource(){
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self,  alertControllerStyle: ImagePicker.alert, title: "Choose Image")
        imagePickerController.delegate = objImagePicker
        objImagePicker.delegate = self
    }
    
    func openSource(source : UIImagePickerControllerSourceType ){
        
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self, source: source)
        imagePickerController.delegate = objImagePicker
        objImagePicker.delegate = self
    }
    
    
    
    func getAlert(id  : String  , name : String , title : String){
        var msg = ""
        
        
        var alertViewController : UIAlertController!
       
        print(name)
        let delete = UIAlertAction(title: title.uppercased(), style: .default) { (action) in
          
            self.exp_id = name;
            var params = [String : String]();
            params["sCompanyFolder"] = self.cbohelp.getCompanyCode()
            params["iPA_ID"] =  "\(Custom_Variables_And_Method.PA_ID)"
            params["iDCR_ID"] = self.dcr_id
            params["iID"] = name
            
            let tables = [0]
//
//            progress1.setMessage("Please Wait..");
//            progress1.setCancelable(false);
//            progress1.show();
            CboServices().customMethodForAllServices(params: params, methodName: "DCREXPDELETEMOBILE_1", tables: tables, response_code: self.MESSAGE_INTERNET_DCR_DELETEEXP, vc: self, multiTableResponse: true)

        }
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
            msg = "Are you sure, you want to delete?"
            
            alertViewController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    

    func RemoveAllviewsinProduct(myStackView : UIView){
        while( myStackView.subviews.count > 0 ) {
            myStackView.subviews[0].removeFromSuperview()
        }
    }
    
    func init_DA_type(){
        
        RemoveAllviewsinProduct(myStackView: DALayout)
        var i = 0
        var heightConstraint : NSLayoutConstraint!
        // var stackViewHeightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
        var exp_data = [[String : String]]()
        exp_data.append(["DA. Type" : customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "DA_TYPE",defaultValue: "") ])
        exp_data.append(["DA. Value" :  "₹" + customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "da_val",defaultValue: "0.0")])
        var Dis_val = 0.0;
        if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "ACTUALFAREYN",defaultValue: "").uppercased() != ("Y")) {
            Dis_val = Double(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "distance_val",defaultValue: "0.0"))!
            exp_data.append(["TA. Value" : "₹\( Dis_val)"])
        }
        
        da_root.setEnabled(enable: cbohelp.get_DA_ACTION_exp_head().count == 0);
       
        var other = 0.0;
        for  i in  0 ..< data.count {
            other += Double(data[i]["amount"]!)!;
        }
        
        let net_value = Double(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "da_val",defaultValue: "0.0"))!
            + Dis_val
            + other;
        
        exp_data.append(["Other Value" :  "₹" + "\(other)"])
        exp_data.append(["Total Expenses" : "₹" + "\(net_value)"])
        
        for x1 in exp_data{
            for x in x1 {
                let myLabel = UILabel()
                
                myLabel.translatesAutoresizingMaskIntoConstraints = false
                DALayout.addSubview(myLabel)
                myLabel.text = x.key
                myLabel.textColor = .black //AppColorClass.colorPrimaryDark
                if x.key == "Total Expenses" {
                    myLabel.font = myLabel.font.bold()
                }
                myLabel.numberOfLines = 0
                
                
                let myLabel2 = UILabel()
                DALayout.addSubview(myLabel2)
                myLabel2.translatesAutoresizingMaskIntoConstraints = false
                myLabel2.numberOfLines = 0
                myLabel2.textColor = AppColorClass.colorPrimaryDark
                myLabel2.textAlignment = .right
                myLabel2.font = myLabel2.font.bold()
                myLabel2.text = x.value
                
                let myinnerStackView = UIStackView()
                myinnerStackView.axis =  .horizontal
                DALayout.addSubview(myinnerStackView)
                myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
                
                
                
                
                myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
                myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
                
                
                
                myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
                myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
                myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
                
                
                
                if i == 0{
                    myinnerStackView.topAnchor.constraint(equalTo: DALayout.topAnchor).isActive = true
                    myinnerStackView.leftAnchor.constraint(equalTo: DALayout.leftAnchor).isActive = true
                    myinnerStackView .rightAnchor.constraint(equalTo: DALayout.rightAnchor).isActive =  true
                    i = 1
                }else{
                    myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
                    myinnerStackView.leftAnchor.constraint(equalTo: DALayout.leftAnchor).isActive = true
                    myinnerStackView .rightAnchor.constraint(equalTo: DALayout.rightAnchor).isActive =  true
                }
                
                
                heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
                heightConstraint.isActive =  true
               
                widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 90)
                widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
                widthConstraint.isActive =  true
                
                previousStackView = myinnerStackView
            }
        }
            
//            let a = UIView()
//            DALayout.addSubview(a)
//            a.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive =  true
//            a.rightAnchor.constraint(equalTo: DALayout.rightAnchor ).isActive =  true
//            a.leftAnchor.constraint(equalTo: DALayout.leftAnchor).isActive =  true
//
//            heightConstraint = NSLayoutConstraint(item: a, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
//            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
//            heightConstraint.isActive =  true

            //previousStackView = a
            previousStackView.bottomAnchor.constraint(equalTo: DALayout.bottomAnchor).isActive =  true

    }
}
