//
//  DairyCall.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 12/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import CoreLocation
import NotificationCenter

class DairyCall: CustomUIViewController , CustomTextViewWithButtonDelegate {

    

    
    
    func onClickListnter(sender: CustomTextViewWithButton) {
        switch (sender.getTag()) {
        case WORK_WITH_DILOG:
            onClickWorkWith()
            
        default:
            print("tag not assighned")
        }
    }
    
    
    
    @IBOutlet weak var msgView: UIView!
    
    @IBOutlet weak var msgLabel: UILabel!
    
    var latLong: String?
    @IBOutlet weak var remarkTextView: CustomTextView!
    var context : CustomUIViewController!
    var live_km = ""
    var head = "Dairy" // "Poultry"
    var summary_list = [[String : [String : [String]]]]()
    var sample_name="",sample_pob="",sample_sample="" , chm_name = "", locExtra = ""
    var name = "" , name2 = "" , resultList = "", name3 = "" , name4 = ""
    var plan_type = "1" , sample = "0.0";
    var showRegistrtion = 1;
    var result = 0.0;
    var docList = [SpinnerModel]();
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var presenter : ParantSummaryAdaptor!
    let CALL_DILOG = 5 , REMARK_DILOG = 6 , WORK_WITH_DILOG=7 , PRODUCT_DILOG = 8, INTERSTED_DILOG = 9
    var dr_id = ""
    var dr_id_reg = ""
    var dr_id_index = ""
    var doc_name = ""
    var work_with_name = ""
    var work_with_id = ""
    var remark_list = [String]()
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var DOC_TYPE = ""
    var myBatteryLevel = ""
    var drKm = "0"
    var network_status : Bool!
    var TitleName : [SpinnerModel]!
    var array_sort: [SpinnerModel]!
    
    var part1 = ""
    var part2 = ""
    var part3 = ""
    var workwith1 = ""
    var workwith2 = ""
    var workwith34 = ""
   
    
    internal var textlength = 0
    internal var drInTime: String = ""
    
    
    var sample_name_previous="",sample_pob_previous="",sample_sample_previous="";
    var gift_name_previous="",gift_qty_previous="";
    
    internal var gift_name: String = ""
    internal var gift_qty:String = ""
    
    var ref_latLong = "";
    var call_latLong = ""
    
    var doctor_list = [String : [String]]();
    
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var myStackView: UIView!
    @IBOutlet weak var dairySummaryTableView: UITableView!
    
 
    var header = [String]()
    @IBOutlet weak var summaryButton: CustomHalfRoundButton!
    @IBOutlet weak var callButton: CustomHalfRoundButton!
    
    @IBOutlet weak var slelectedTabBarButtom: UIView!
    
   
    @IBOutlet weak var remarkView: CustomBoarder!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var productButton: CustomeUIButton!
    

    @IBOutlet weak var giftBtn: CustomeUIButton!
    
    @IBOutlet weak var pob_Amt: CustomTextView!
    @IBOutlet weak var lblSelect_Remark: UILabel!
    @IBOutlet weak var dairyCallView: CustomBoarder!
    
    @IBOutlet weak var dairySummaryview: CustomBoarder!
    
    @IBOutlet weak var contactPerson: CustomTextViewWithButton!
    @IBOutlet weak var loc: CustomDisableTextView!
    @IBOutlet weak var loc_layout: UIStackView!
    
    @IBOutlet weak var Dr_Name: UILabel!
    var intersed_list = [String]()
    
    @IBOutlet weak var backButton: CustomeUIButton!
    @IBOutlet weak var addDairyButton: CustomeUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
       
        productButton.isHidden = true
        addDairyButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        context = self
        
        if (Custom_Variables_And_Method.location_required == "N"){
            loc_layout.isHidden = true
        }else if(Custom_Variables_And_Method.location_required == "Y") {
            loc_layout.isHidden = false
        }else{
            loc_layout.isHidden = true
        }

        latLong = Custom_Variables_And_Method.GLOBAL_LATLON
        
    // customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "live_km",defaultValue: "");
        

        live_km = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self, key: "live_km", defaultValue: "")

        if customVariablesAndMethod.internetConneted(context: self){
            network_status = customVariablesAndMethod.internetConneted(context: self)
        }
        
        
        customVariablesAndMethod.getBatteryLevel()
        
        remark_list = cbohelp.get_phdairy_reason()
        
        showRegistrtion = Int(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self, key: "IsBackDate", defaultValue: "1"))!
        myBatteryLevel = Custom_Variables_And_Method.BATTERYLEVEL
        dairySummaryTableView.separatorStyle = .none
        
        if VCIntent["title"] != nil  {
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        if  VCIntent["docType"] != nil{
            DOC_TYPE = VCIntent["docType"]!
        }
        if DOC_TYPE == "P"{
            addDairyButton.setText(text: "Add Poultry")
            head = "Poultry"
        }
        
        remarkTextView.setHint(placeholder: "Remark Here..")
        
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        setAddressToUI();
        setTabsUI()
        remark_list = cbohelp.get_phdairy_reason()
        pob_Amt.myCustomeTextVIew.isUserInteractionEnabled = false
        pob_Amt.setHint(placeholder: "POB Amt.")
      
        contactPerson.delegate = self
        contactPerson.setTag(tag: WORK_WITH_DILOG)
        contactPerson.setHint(placeholder: "Click + sign for Contact Person")
        
        
        var ProductCaption = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "SAMPLE_BTN_CAPTION", defaultValue: "")
        if (!ProductCaption.isEmpty){
            productButton.setText( text: ProductCaption)
        }
        
        productButton.addTarget(self, action: #selector(onClickProductLoad), for: .touchUpInside)
       
        intersed_list.append("Interserted")
        intersed_list.append("Not Interserted")
     
        callButton.addTarget(self, action: #selector(pressedCallButton), for: .touchUpInside)
        summaryButton.addTarget(self, action: #selector(pressedSummaryButton), for: .touchUpInside)

        genrateSummary()
        presenter.delegate = self
    }
    

    
    @objc func onClickProductLoad(){
        let stkName = Dr_Name.text
        if (stkName == "--Select--") {
            customVariablesAndMethod.getAlert(vc: self, title: "Select !!!", msg: "Please Select " + head + " First..");
        } else {
            stk_sample_Dialog(vc: self, responseCode: PRODUCT_DILOG, sample_name: sample_name, sample_pob: sample_pob, sample_sample: sample_sample).setPrevious(sample_name_previous: sample_name_previous, sample_pob_previous: sample_pob_previous, sample_sample_previous: sample_sample_previous).show()
        }
    }
    
    @objc func pressedCallButton(){
        setTabsUI()
    }
    
    @objc func pressedSummaryButton(){
        callButton.setButtonColor(color: AppColorClass.tab_unsellected!)
        summaryButton.setButtonColor(color: AppColorClass.tab_sellected!)
        dairySummaryview.isHidden = false
        dairyCallView.isHidden = true
    }
    @objc private func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    //MARK:-  submit button
    @objc func submit(){
        print("submit button pressed")
        
         myBatteryLevel = Custom_Variables_And_Method.BATTERYLEVEL
         setAddressToUI()
        if loc.getText() == "" || loc.getText() == nil{
            loc.setText(text: Custom_Variables_And_Method.GLOBAL_LATLON)
        }
        
        
        if latLong == nil || latLong == "0.0,0.0" || latLong == ""{
            latLong = Custom_Variables_And_Method.GLOBAL_LATLON
        }
        
        if dr_id == ""{
            customVariablesAndMethod.getAlert(vc: self, title: "Selectc!!!", msg: "Please select a \(head)")
        }else if  docList.isEmpty && dr_id == "" {
            customVariablesAndMethod.msgBox(vc: self, msg: "No  Data in List")
        }else if (contactPerson.getText() == ""){
            customVariablesAndMethod.msgBox(vc: self, msg: "Please Select a Person...")
        }else if selectLabel.text == intersed_list[0] && sample_name == "" {
            customVariablesAndMethod.msgBox(vc: self, msg: "Please Select a Product...")
            
        }else if remarkTextView.getText() == ""{
             customVariablesAndMethod.msgBox(vc: self, msg: "Please Enter Remark...")
        }else {
            let getCurrentTime = customVariablesAndMethod.get_currentTimeStamp()
            
            let planTime = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self, key: "DcrPlantimestamp", defaultValue: customVariablesAndMethod.get_currentTimeStamp())
            let t1 = Float(getCurrentTime)
            let t2 = Float(planTime)
            
            let t3 = t1! - t2!
            if (t3 >= 0 || t3 >= -0.9){
                submitDoctor()
            }else {
                customVariablesAndMethod.msgBox(vc: self, msg: "Your Plan Time can not be \n Higher Than Current time..." )
            }
        }
    }
    

    func setAddressToUI() {
        loc.setText(text: Custom_Variables_And_Method.GLOBAL_LATLON)
    }
    
    
    // MARK:- genrateSummary
    func genrateSummary(){
        var headers = [ String]()
        var isCollaps = [Bool]()
        doctor_list = cbohelp.getCallDetail(table: "Dairy",look_for_id: "",show_edit_delete: "1")
        do {
            if DOC_TYPE == "D" {
               
                
                doctor_list = cbohelp.getCallDetail(table: "Dairy",look_for_id: "",show_edit_delete: "1")
                
                if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "Dairy_NOT_REQUIRED", defaultValue: "Y") == "N"){
                    summary_list.append([try cbohelp.getMenuNew(menu:  "DCR",code :     "D_DAIRY").getString(key: "D_DAIRY"): doctor_list])
                }
            }else {
                
                 doctor_list = cbohelp.getCallDetail(table: "Poultry",look_for_id: "",show_edit_delete: "1")
                if( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "Polutary_NOT_REQUIRED", defaultValue:"Y") == "N"){
                    summary_list.append([try cbohelp.getMenuNew(menu:  "DCR",code : "D_POULTRY").getString(key : "D_POULTRY") :doctor_list]);
                }
            }
        }catch{
            print(error)
        }
        
        for header in summary_list{
            for header1 in  header{
                headers.append(header1.key)
                isCollaps.append(false)
            }
        }
        
        presenter = ParantSummaryAdaptor(tableView: dairySummaryTableView, vc: self , summaryData : summary_list , headers : headers, isCollaps: isCollaps )
        
        dairySummaryTableView.dataSource = presenter
        dairySummaryTableView.delegate = presenter
    }
    @IBAction func selectDr_Dropdown(_ sender: UIButton) {
        OnClickDrLoad()
        
    }
  
    @IBAction func selectTapGesture(_ sender: UITapGestureRecognizer) {
        onClickDrCallIntersed()
    }
    
    @IBAction func otherRemarksTapGesture(_ sender: UITapGestureRecognizer) {
        OnClickRemarkLoad()
    }
    
    func OnClickDrLoad(){
    
        do{
            let statement = try cbohelp.getphdairy(DOC_TYPE: DOC_TYPE)
            
            // chemist.add(new SpinnerModel("--Select--",""));
            let db = cbohelp
            docList.removeAll()
            while let c = statement.next() {
                docList.append(
                    try SpinnerModel(name: (c[db.getColumnIndex(statement: statement, Coloumn_Name: "DAIRY_NAME")]! as! String),
                        id: "\(c[db.getColumnIndex(statement: statement, Coloumn_Name: "DAIRY_ID")]!)",
                        last_visited:  c[db.getColumnIndex(statement: statement, Coloumn_Name: "LAST_VISIT_DATE")]! as! String,
                        DR_LAT_LONG:  c[db.getColumnIndex(statement: statement, Coloumn_Name:"DR_LAT_LONG")]! as! String,
                        DR_LAT_LONG2:  c[db.getColumnIndex(statement: statement, Coloumn_Name: "DR_LAT_LONG2")]! as! String,
                        DR_LAT_LONG3:  c[db.getColumnIndex(statement: statement, Coloumn_Name:"DR_LAT_LONG3")]! as! String,
                        CALLYN:  "\(c[db.getColumnIndex(statement: statement, Coloumn_Name:"CALLYN")]!)"
                    )
                )
            }
            
            
            
            Call_Dialog(vc: self, title: "Select " + head + "....", dr_List: docList, callTyp: DOC_TYPE + "A", responseCode: CALL_DILOG).show()
            //docList = new ArrayList<SpinnerModel>();
            //GPS_Timmer_Dialog(context,mHandler,"Scanning Doctors...",GPS_TIMMER).show();
        }catch {
            print(error)
        }
    }
    
    func onClickDrCallIntersed(){
        if( doc_name == ""){
            customVariablesAndMethod.msgBox(vc: self, msg: "Please select " + head + "....")
        }else{
            Remark_Dialog(vc: self, title: "Select Remark....", List: intersed_list, responseCode: INTERSTED_DILOG).show()
        }
    }
    
    
    func OnClickRemarkLoad(){
        remark_list.append("other")
        if( doc_name == ""){
            customVariablesAndMethod.msgBox(vc: self, msg: "Please select " + head + "....")
        }else{
            Remark_Dialog(vc: self, title: "Select Remark....", List: remark_list, responseCode: REMARK_DILOG).show()
        }
    }
    

    
    private func UpadteUI_If_Called(){
//        msgView.isHidden = true
//        msgLabel.text = ""
        doctor_list = cbohelp.getCallDetail(table: head, look_for_id: dr_id, show_edit_delete: "0")
        if (doctor_list["id"]!.contains(dr_id)) {
            
            if (doctor_list["time"]![0] != "") {
                remarkTextView.isHidden = false
                msgView.isHidden = false
                msgLabel.text = "You have visited today"
            } else {
                msgView.isHidden = true
                msgLabel.text = ""
            }
    
            if (doctor_list["workwith"]![0] != "") {
                work_with_name = doctor_list["workwith"]![0]
                contactPerson.setText(text: work_with_name)
    
            } else {
                work_with_name = ""
                contactPerson.setText(text : work_with_name)
            }
    
            remarkTextView.setText(text: doctor_list["remark"]![0])
            if (doctor_list["sample_name"]![0] != "") {
  
                sample_name = doctor_list["sample_name"]![0]
                sample_sample = doctor_list["sample_qty"]![0]
                sample_pob = doctor_list["sample_pob"]![0]
    
               
            }else{
                sample_name = ""
                sample_sample = ""
                sample_pob = ""
                
            }
    
            
            ShowDrSampleProduct(sample_name: sample_name.components(separatedBy: ","), sample_qty: sample_sample.components(separatedBy: ","), sample_pob: sample_pob.components(separatedBy: ","), myStackView: myStackView)
   
    
            if (doctor_list["gift_name"]![0] != "") {
                gift_name = doctor_list["gift_name"]![0]
                gift_qty = doctor_list["gift_qty"]![0]
    
            }else{
                gift_name = ""
                gift_qty = ""
            }
    
//
//    init_gift(doc_detail, gift_name.split(",".toRegex()).dropLastWhile({ it.isEmpty() }).toTypedArray(), gift_qty.split(",".toRegex()).dropLastWhile({ it.isEmpty() }).toTypedArray())
//
            if (doctor_list["remark"]![0] != "") {
                var remark = doctor_list["remark"]?[0]
                if (remark?.contains("₹"))!{
           // remark = remark.split("\\n".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()[1]
                }
                if (remark_list.contains(remark!)) {
                    lblSelect_Remark.text = remark
                    remarkTextView.isHidden = true
                } else {
                    lblSelect_Remark.text = remark_list[remark_list.count - 1]
                    remarkTextView.isHidden = false
                }
                remarkTextView.setText( text : remark!)
                selectLabel.text = (gift_name.isEmpty && sample_name.isEmpty) ? intersed_list[1] : intersed_list[0]
    
            } else {
                remarkTextView.setText(text : "")
                lblSelect_Remark.text = "---Select Remark---"
                selectLabel.text = intersed_list[0]
            }
    
            SetInterested()
            
            addDairyButton.setText(text: "Update \(head)")
    //save.setText("Update Dairy")
        }else{
            work_with_name = ""
            contactPerson.setText( text : work_with_name)
    
            sample_name = ""
            sample_sample = ""
            sample_pob = ""
    
            
            ShowDrSampleProduct(sample_name: sample_name.components(separatedBy: ","), sample_qty: sample_sample.components(separatedBy: ","), sample_pob: sample_pob.components(separatedBy: ","), myStackView: myStackView)
    
    
            gift_name = ""
            gift_qty = ""
//    init_gift(doc_detail, gift_name.split(",".toRegex()).dropLastWhile({ it.isEmpty() }).toTypedArray(), gift_qty.split(",".toRegex()).dropLastWhile({ it.isEmpty() }).toTypedArray())
    
            remarkTextView.setText(text : "")
            lblSelect_Remark.text = "---Select Remark---"
            selectLabel.text = intersed_list[0]
//            SetInterested()
    
            addDairyButton.setText(text : "ADD \(head)")
        }
        
        sample_name_previous=sample_name;
        sample_pob_previous=sample_pob;
        sample_sample_previous=sample_sample;
        
        gift_name_previous = gift_name;
        gift_qty_previous = gift_qty;
    
    }

    
    
    
    private func SetInterested(){
//        if (selectLabel.text == (intersed_list[0])) {
//            remarkTextView.isHidden = false
//            myStackView.isHidden = true
//        } else if(selectLabel.text == intersed_list[1]) {
//            remarkTextView.isHidden = true
//
//            myStackView.isHidden = true
//            sample_name = ""
//            sample_sample = ""
//            sample_pob = ""
//            gift_name = ""
//            gift_qty = ""
//        }else{
//            remarkTextView.setText(text : "")
//            remarkTextView.isHidden = true
//
//            myStackView.isHidden =  true
//
//            sample_name = ""
//            sample_sample = ""
//            sample_pob = ""
//            gift_name = ""
//            gift_qty = ""
//        }
        
        if selectLabel.text == intersed_list[0]{
            
            remarkView.isHidden = true
            productButton.isHidden = false
            remarkTextView.isHidden = false
            //remarkTextView.setText(text: "")
        }else{
            productButton.isHidden = true
            remarkView.isHidden = false
            remarkTextView.isHidden = true
            //remarkTextView.setText(text: "")
            
            sample_name = ""
            sample_sample = ""
            sample_pob = ""
            gift_name = ""
            gift_qty = ""
        }
    }
    
    
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        switch response_code {
        case CALL_DILOG:
            
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            //Dr_Name.text = docList[Int(inderData["Selected_Index"]!)!].getName()
            dr_id = docList[Int(inderData["Selected_Index"]!)!].getId()
            doc_name = docList[Int(inderData["Selected_Index"]!)!].getName().components(separatedBy: "-")[0];
            ref_latLong =  docList[Int(inderData["Selected_Index"]!)!].getREF_LAT_LONG()
            call_latLong = inderData["latLong"]!
//             doctor_list = cbohelp.getCallDetail(table: "Dairy",look_for_id:dr_id,show_edit_delete: "0");
           
            
            Dr_Name.text = doc_name
            remarkTextView.isHidden = true

            if Dr_Name.text == "--Select--"{
                productButton.isHidden = true
                remarkTextView.isHidden = true
            }else{
                selectLabel.text = intersed_list[0]
                productButton.isHidden = false
                remarkTextView.isHidden = false
            }
            // showing details
            
            let titleNAme = ["Area","Class","Potential","Last Visited"]
            let itemName = [docList[Int(inderData["Selected_Index"]!)!].getAREA() , docList[Int(inderData["Selected_Index"]!)!].getCLASS() , docList[Int(inderData["Selected_Index"]!)!].getPOTENCY_AMT(), docList[Int(inderData["Selected_Index"]!)!].getLastVisited() ]
            
//            if DOC_TYPE == "P"{
//                doctor_list.removeAll()
//                doctor_list = cbohelp.getCallDetail(table: "Poultry",look_for_id:dr_id,show_edit_delete: "0");
//            }
            
            
//            let sample_name1 = (doctor_list["sample_name"]![0]).components(separatedBy: ",")
//            let sample_qty1 = (doctor_list["sample_qty"]![0]).components(separatedBy: ",")
//            let sample_pob1 = (doctor_list["sample_pob"]![0]).components(separatedBy: ",")
//
//            if sample_name1[0] != ""{
//                ShowDrSampleProduct(sample_name: sample_name1, sample_qty: sample_qty1, sample_pob: sample_pob1, myStackView: myStackView)
//                contactPerson.setText(text: doctor_list["workwith"]![0])
//            }
            UpadteUI_If_Called()
            
            break
            
        case PRODUCT_DILOG:
            

            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            name = inderData["val"]!   //id
            name2 = inderData["val2"]!   //qty pob
            result = Double(inderData["resultpob"]!)! //pob value
            sample = inderData["sampleQty"]!
            resultList = inderData["resultList"]!
            
            pob_Amt.setText(text: inderData["resultpob"]!)
            sample_name=resultList;
            sample_sample=sample;
            sample_pob=name2;
            
            let sample_name1 = resultList.components(separatedBy: ",");
            let sample_qty1 = sample.components(separatedBy: ",");
            let sample_pob1 = name2.components(separatedBy: ",");
            ShowDrSampleProduct(sample_name: sample_name1, sample_qty: sample_qty1, sample_pob: sample_pob1, myStackView: myStackView)
            break
            
        case INTERSTED_DILOG:
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            selectLabel.text = intersed_list[Int(inderData["Selected_Index"]!)!]
            
           SetInterested()
            
            
            print(dataFromAPI)

            break
            
        case REMARK_DILOG:
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            lblSelect_Remark.text = remark_list[Int(inderData["Selected_Index"]!)!]
            
            if (lblSelect_Remark.text?.lowercased() == "other"){
                remarkTextView.setText(text: "");
                remarkTextView.isHidden = false
            }else{
                remarkTextView.setText(text: lblSelect_Remark.text!);
                remarkTextView.isHidden = true
            }
            
            break
        case WORK_WITH_DILOG:
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            
            work_with_name = inderData["workwith_name"]!
            work_with_id = inderData["workwith_id"]!
            
            contactPerson.setText(text: work_with_name)
            break
        case 99:
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    
        func OnProductLoad(){
        if (chm_name == "") {
            customVariablesAndMethod.msgBox(vc: self,msg: "Please Select " + head + " First..");
        } else {
            Chm_sample_Dialog(vc: self, dr_List: docList, showGeoFencing: showRegistrtion, responseCode: PRODUCT_DILOG, sample_name: sample_name, sample_pob: sample_pob, sample_sample: sample_sample).show()
        }
    }
    
    func onClickWorkWith() {
        if( doc_name == ""){
            customVariablesAndMethod.msgBox(vc: self, msg: "Please select " + head + "....")
        }else{
            var msg = [String : String]()
            msg["header"] = "Select Contact Person..."
            msg["sDCR_DATE"] = "1"
            msg["DAIRY_ID"] = dr_id
            Work_With_Dialog(vc: self, msg: msg, responseCode: WORK_WITH_DILOG).show()
        }
    }
  
    
    func remAdded() -> [String] {
        doctor_list = cbohelp.getCallDetail(table: head, look_for_id: "", show_edit_delete: "0")
        return doctor_list["id"]!
    }

    
    
        func submitDoctor() {
        let mydr : Double = 0
        var msg1 = "\(head) Added successfully"
        let PobAmt = pob_Amt.getText()
        let AllItemId = name
        let AllItemQty = name2
        let AllGiftId = name3
        let AllSampleQty = sample
        let AllGiftQty = name4
        var remark =  ""
        
        
        
        if selectLabel.text == intersed_list[0]{
            remark = remarkTextView.getText()
        }else if selectLabel.text == intersed_list[1]{
            if lblSelect_Remark.text?.lowercased() == "other"{
                remark = remarkTextView.getText()
            }else{
                remark = lblSelect_Remark.text!
            }
        }
        print(remark)
        if (remAdded().contains(dr_id)) {

        
    //customVariablesAndMethod.msgBox(context, "$dr_name Allready Added...")
            cbohelp.update_phdairy_dcr(DAIRY_ID: dr_id, DAIRY_NAME: doc_name, DOC_TYPE: DOC_TYPE, dr_remark: remark , person_name: work_with_name, person_id: work_with_id, pob_amt: PobAmt, allitemid: AllItemId, allitemqty: AllItemQty, sample: AllSampleQty, allgiftid: AllGiftId, allgiftqty: AllGiftQty, file: "", IS_INTRESTED: selectLabel.text!)


//                dr_id, doc_name,DOC_TYPE,dr_remark.text.toString(),work_with_name,work_with_id,PobAmt,AllItemId,AllItemQty,AllSampleQty,AllGiftId,AllGiftQty,"")
            msg1 = "\(head) Updated successfully"
            
            customVariablesAndMethod.msgBox(vc: self, msg: msg1) { (action) in
                self.myTopView.CloseCurruntVC(vc: self.context)
            }
            
            
            

        } else {

            Custom_Variables_And_Method.GLOBAL_LATLON = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self, key: "shareLatLong" , defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON)

            let currentBestLocation = customVariablesAndMethod.getObject(context: self,key: "currentBestLocation")


            if (currentBestLocation != CLLocation()) {
                locExtra = "Lat_Long  \(currentBestLocation.coordinate.latitude),  \(currentBestLocation.coordinate.longitude ), Accuracy \(currentBestLocation.horizontalAccuracy ) , Time \( currentBestLocation.timestamp), Speed \( currentBestLocation.speed ), Provider "
            }



//            if currentBestLocation != CLLocation(){
//    locExtra = "Lat_Long " + currentBestLocation!!.getLatitude() + "," + currentBestLocation!!.getLongitude() + ", Accuracy " + currentBestLocation!!.getAccuracy() + ", Time " + currentBestLocation!!.getTime() + ", Speed " + currentBestLocation!!.getSpeed() + ", Provider " + currentBestLocation!!.getProvider()

//        }
            
            
        cbohelp.insert_phdairy_dcr(DAIRY_ID: dr_id, DAIRY_NAME: doc_name, DOC_TYPE: DOC_TYPE, visit_time: customVariablesAndMethod.currentTime(context: self), DR_LAT_LONG: Custom_Variables_And_Method.GLOBAL_LATLON, batteryLevel: myBatteryLevel, dr_address: Custom_Variables_And_Method.global_address, dr_remark: remark, dr_km: drKm, srno: customVariablesAndMethod.srno(context: self), person_name: work_with_name, person_id: work_with_id, pob_amt: PobAmt, allitemid: AllItemId, allitemqty: AllItemQty, sample: AllSampleQty, allgiftid: AllGiftId, allgiftqty: AllGiftQty, file: "", LOC_EXTRA: locExtra, IS_INTRESTED: selectLabel.text!,Ref_latlong: ref_latLong)
            
             msg1 = "Add \(head) successfully"
            
            
            customVariablesAndMethod.msgBox(vc: self, msg: msg1) { (action) in
                self.myTopView.CloseAllVC(vc: self.context)
            }
       


//            dr_id, ,DOC_TYPE, customVariablesAndMethod.currentTime(context),Custom_Variables_And_Method.GLOBAL_LATLON,myBatteryLevel, Custom_Variables_And_Method.global_address,dr_remark.text.toString(),drKm,customVariablesAndMethod.srno(context),work_with_name,work_with_id,PobAmt,AllItemId,AllItemQty,AllSampleQty,AllGiftId,AllGiftQty,"",locExtra)
        }

//    if (mydr > 0) {
//    customVariablesAndMethod.msgBox(context, msg)
//    if (networkUtil.internetConneted(context)!!) {
//    if (live_km.equals("Y", ignoreCase = true) || live_km.equals("Y5", ignoreCase = true)) {
//    val myCustomMethod = MyCustomMethod(context)
//    myCustomMethod.stopAlarm10Minute()
//    myCustomMethod.startAlarmIn10Minute()
//    } else {
//    startService(Intent(context, Sync_service::class.java))
//    }
//    }
//    finish()
//    } else {
//    customVariablesAndMethod.msgBox(context, "Insertion fail")
    }
   

    
    
    func RemoveAllviewsinProduct(myStackView : UIView){
         while( myStackView.subviews.count > 0 ) {
            myStackView.subviews[0].removeFromSuperview()
         }
    }
        
    func ShowDrSampleProduct( sample_name : [String],  sample_qty : [String], sample_pob : [String] , myStackView : UIView  ){
        
        if sample_name[0] == ""{
            myStackView.isHidden = true
            return
        }
        
        RemoveAllviewsinProduct(myStackView: myStackView)
         myStackView.isHidden = false
        var heightConstraint : NSLayoutConstraint!
        // var stackViewHeightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Product"
        myLabel.numberOfLines = 0
        myLabel.font = myLabel.font.withSize(13)
        myLabel.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel.textColor = .white
        
        
        let myLabel2 = UILabel()
        myStackView.addSubview(myLabel2)
        myLabel2.translatesAutoresizingMaskIntoConstraints = false
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel2.font = myLabel2.font.withSize(13)
        myLabel2.textAlignment = .center
        myLabel2.textColor = .white
        myLabel2.text =  "Sample"
        
        let myLabel3 = UILabel()
        myStackView.addSubview(myLabel3)
        myLabel3.translatesAutoresizingMaskIntoConstraints = false
        myLabel3.numberOfLines = 0
        myLabel3.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel3.font = myLabel3.font.withSize(13)
        
        myLabel3.textAlignment = .center
        myLabel3.textColor = .white
        myLabel3.text =  "POB"
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        
        
        myLabel3.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel3.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
        myLabel3.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel2.rightAnchor.constraint(equalTo: myLabel3.leftAnchor ).isActive =  true
        myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        
        
        //if i == 0{
        
        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        
        //        }else{
        //
        //            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
        //            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        //            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        //
        //        }
        
        
        heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        heightConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< sample_name.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  sample_name[i]
            myLabel.numberOfLines = 0
            myLabel.textColor = AppColorClass.colorPrimaryDark
            //myLabel.backgroundColor = .gray
            
            
            let myLabel2 = UILabel()
            myStackView.addSubview(myLabel2)
            myLabel2.translatesAutoresizingMaskIntoConstraints = false
            myLabel2.numberOfLines = 0
            //myLabel2.backgroundColor = .lightGray
            myLabel2.textAlignment = .center
            myLabel2.textColor = AppColorClass.colorPrimaryDark
            myLabel2.text =  sample_qty[i]
            
            let myLabel3 = UILabel()
            myStackView.addSubview(myLabel3)
            myLabel3.translatesAutoresizingMaskIntoConstraints = false
            myLabel3.numberOfLines = 0
            //myLabel3.backgroundColor = .red
            myLabel3.textAlignment = .center
            myLabel3.textColor = AppColorClass.colorPrimaryDark
            myLabel3.text =  sample_pob[i]
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            
            
            myLabel3.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel3.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
            myLabel3.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel2.rightAnchor.constraint(equalTo: myLabel3.leftAnchor ).isActive =  true
            myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            
            //            if i == 0{
            //
            //                myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
            //                myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            //                myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            //
            //            }else{
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            
            //}
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            heightConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            previousStackView = myinnerStackView
            
        }

        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
        
    }
        
        func ShowDrSampleGift( titleName : [String],  itemName : [String]  , myStackView : UIView){
            myStackView.backgroundColor = UIColor.white
            
            RemoveAllviewsinProduct(myStackView: myStackView)
            
            var heightConstraint : NSLayoutConstraint!
            
            var previousStackView : UIStackView!
            
            
            //        let myLabel = UILabel()
            //        myLabel.translatesAutoresizingMaskIntoConstraints = false
            //        myStackView.addSubview(myLabel)
            //        myLabel.text =  "Gift"
            //        myLabel.numberOfLines = 0
            //        myLabel.font = myLabel.font.withSize(13)
            //        myLabel.backgroundColor = UIColor.white
            //        myLabel.textColor = .white
            //        myLabel.isHidden = true
            //
            //        let myLabel2 = UILabel()
            //        myStackView.addSubview(myLabel2)
            //        myLabel2.translatesAutoresizingMaskIntoConstraints = false
            //        myLabel2.numberOfLines = 0
            //        myLabel2.backgroundColor =  UIColor.white
            //        myLabel2.font = myLabel2.font.withSize(13)
            //        myLabel2.textAlignment = .center
            //        myLabel2.textColor = .white
            //        myLabel2.text =  "Qty."
            //        myLabel2.isHidden = true
            
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            //        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            //        myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
            //        myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            //
            //        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            //        myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
            //        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
            //        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            
            myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor , constant : 5).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            
            //        heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
            //        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            //        heightConstraint.isActive =  true
            //
            //
            //        widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            //        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            //        widthConstraint.isActive =  true
            
            previousStackView = myinnerStackView
            
            for i in 0 ..< titleName.count{
                
                if itemName[i] != ""{
                    
                    
                    let myLabel = UILabel()
                    myLabel.translatesAutoresizingMaskIntoConstraints = false
                    myStackView.addSubview(myLabel)
                    myLabel.text =  titleName[i]
                    myLabel.numberOfLines = 0
                    myLabel.textColor = UIColor.black
                    myLabel.font =  UIFont.boldSystemFont(ofSize: 14.0)
                    //myLabel.backgroundColor = .gray
                    
                    
                    let myLabel2 = UILabel()
                    myStackView.addSubview(myLabel2)
                    myLabel2.translatesAutoresizingMaskIntoConstraints = false
                    myLabel2.numberOfLines = 0
                    //myLabel2.backgroundColor = .lightGray
                    myLabel2.textAlignment = .right
                    myLabel2.textColor = UIColor.black
                    myLabel2.font = UIFont(name:"HelveticaNeue", size: 14.0)
                    myLabel2.text =  itemName[i]
                    
                    
                    
                    let myinnerStackView = UIStackView()
                    myinnerStackView.axis =  .horizontal
                    myStackView.addSubview(myinnerStackView)
                    myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
                    
                    
                    myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor ).isActive =  true
                    myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor , constant : -5).isActive =  true
                    myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ).isActive = true
                    
                    myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                    myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
                    myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor , constant : 5).isActive =  true
                    myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ).isActive = true
                    
                    
                    
                    myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
                    myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
                    myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
                    
                    
                    
                    heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                    heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
                    heightConstraint.isActive =  true
                    
                    
                    previousStackView = myinnerStackView
                }
            }
            previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor , constant : -5).isActive =  true
        }
}


extension DairyCall : ParantSummaryAdaptorDalegate{
    
    
    func onEdit(id: String , name : String) {
        print(id , name)
        getAlert(id:id, name : name ,  title: "Edit")
    }
    
    func onDelete(id: String , name: String) {
        
        getAlert(id : id ,name : name , title: "Delete")
        
    }
    
    func getChild(groupPosition : Int , childname : String) -> [String : [String]]{
        return summary_list[groupPosition][childname]!
    }
    
    
    
    // alert msg
    
    func getAlert(id  : String  , name : String , title : String){
        var msg = ""
        
        
        var alertViewController : UIAlertController!
        let edit = UIAlertAction(title: title.uppercased(), style: .default) { (action) in
            self.setTabsUI()
            self.doc_name = name
            self.dr_id = id
            self.Dr_Name.text = self.doc_name
            self.UpadteUI_If_Called()
        }
        
        let delete = UIAlertAction(title: title.uppercased(), style: .default) { (action) in
            self.setTabsUI()
            self.doc_name = name
            self.dr_id = id
            self.Dr_Name.text = self.doc_name
            self.cbohelp.delete_phdairy_dcr(DAIRY_ID: self.dr_id)
            self.closeVC()
        }
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        
        if title.lowercased() == "delete"{
            msg = "Do you Really want to\(title.lowercased()) \(name) ?"
            
            alertViewController = UIAlertController(title: "\(title)!!!", message: msg, preferredStyle: .alert)
            
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            
        }else {
            msg = "Do you want to\(title.lowercased()) \(name) ?"
            alertViewController = UIAlertController(title: "\(title)!!!", message: msg, preferredStyle: .alert)
            alertViewController.addAction(cancel)
            alertViewController.addAction(edit)
        }
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func setTabsUI(){
        slelectedTabBarButtom.backgroundColor = AppColorClass.tab_sellected
        callButton.setButtonColor(color: AppColorClass.tab_sellected!)
        summaryButton.setButtonColor(color: AppColorClass.tab_unsellected!)
        dairyCallView.isHidden  = false
        dairySummaryview.isHidden = true
    }
}
