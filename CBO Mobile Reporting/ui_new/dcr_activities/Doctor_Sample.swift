//
//  Doctor_Sample.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 22/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import SQLite
import CoreLocation
class Doctor_Sample: CustomUIViewController {

    @IBOutlet weak var myTopview: TopViewOfApplication!
    var context : CustomUIViewController!
    
    
    
    var remark_list = [String]()
    var currentBestLocation : CLLocation? = nil
    var locExtra = "";
    
    var doc_name = ""
    var dr_id = ""
    var docList = [SpinnerModel]();
    
    var result = 0.0, res_main = 0.0;
    var name3 = "", name4 = "", name5 = "", name6 = "", name7 = "";
    var name = "", name2 = "", MyDoctor = "",resultList="";
    
    var showRegistrtion = 1;
    let CALL_DILOG = 5 ,REMARK_DILOG = 6,WORK_WITH_DILOG=7,PRODUCT_DILOG = 8,GIFT_DILOG = 9 , SUMMARY_DILOG = 10,MESSAGE_INTERNET_SEND_FCM = 11
    var sample_name = "",sample_pob = "",sample_sample = "",sample_noc = "";
    var gift_name="",gift_qty="";
    
    var sample_name_previous="",sample_pob_previous="",sample_sample_previous="";
    var gift_name_previous="",gift_qty_previous="";
    
    
    var sample_added = false
    var  progressHUD : ProgressHUD!
    var multiCallService = Multi_Class_Service_call()
    
    @IBOutlet weak var visit_Remark: UILabel!
    @IBOutlet weak var remark: CustomTextView!
    @IBOutlet weak var loc: CustomDisableTextView!
    @IBOutlet weak var Dr_Name: UILabel!
    @IBOutlet weak var loc_layout: UIStackView!
     @IBOutlet weak var productBtn: CustomeUIButton!
    @IBOutlet weak var ProductView: UIView!
    @IBOutlet weak var GiftView: UIView!
    
    @IBOutlet weak var save: CustomeUIButton!
    @IBOutlet weak var giftBtn: CustomeUIButton!
    @IBOutlet weak var visualadsbtn: CustomeUIButton!
    @IBOutlet weak var prescribedbtn: CustomeUIButton!
    
    @IBOutlet weak var later: CustomeUIButton!
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var Back_allowed = "Y"
    
    var doctor_list = [String : [String]]()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = self
        progressHUD  =  ProgressHUD(vc : context)
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        myTopview.backButton.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside )
        
        later.addTarget(self, action: #selector(pressedLaterButton), for: .touchUpInside )

       
        myTopview.setText(title: VCIntent["title"]!)
        Back_allowed = VCIntent["Back_allowed"]!
        
        
        
        customVariablesAndMethod.betteryCalculator()
        
        setAddressToUI();
        remark.setHint(placeholder: "Enter Remark")
        visit_Remark.isHidden = true
        remark.isHidden = true
        remark_list = cbohelp.get_Doctor_Call_Remark();
        
        if(Custom_Variables_And_Method.location_required == "Y") {
            loc_layout.isHidden = false
        }else{
            loc_layout.isHidden = true
        }
        
        let ProductCaption = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "SAMPLE_BTN_CAPTION", defaultValue: "")
        if (!ProductCaption.isEmpty){
            productBtn.setText( text: ProductCaption)
        }
        productBtn.addTarget(self, action: #selector(OnProductLoad), for: .touchUpInside )
        
        let GiftCaption = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "GIFT_BTN_CAPTION", defaultValue: "")
        if (!GiftCaption.isEmpty){
            giftBtn.setText( text: GiftCaption)
        }
        giftBtn.addTarget(self, action: #selector(OnGiftLoad), for: .touchUpInside )
        
         save.addTarget(self, action: #selector(submit), for: .touchUpInside )
        visualadsbtn.isHidden = false
        prescribedbtn.isHidden = true
        
        
        visualadsbtn.addTarget(self, action: #selector(pressedVisualAd), for: .touchUpInside)
        
        if VCIntent["dr_id"] != nil{
            
            dr_id = VCIntent["dr_id"]!
            doc_name = VCIntent["dr_name"]!
            docList.removeAll()
            docList.append(
                SpinnerModel(name: doc_name,id: dr_id)
            );
            Dr_Name.text = doc_name
            showProductGift(IsDrSelected: true)
        }
        
    }
    @objc func pressedVisualAd(){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowVisualAd") as! ShowVisualAd
        
        if (docList.isEmpty) {
            customVariablesAndMethod.getAlert(vc: self, title: "", msg: "No Doctor in List...")
        }
        if (dr_id == "0") {
            customVariablesAndMethod.getAlert(vc: self, title: "", msg: "Select Doctor from List...");
        } else {
            
            vc.VCIntent["title"] = "Visual Ad"
            vc.VCIntent["who"] = "0"
            vc.VCIntent["sample_name"] = sample_name
            vc.VCIntent["sample_pob"] = sample_pob
            vc.VCIntent["sample_sample"] = sample_sample
        
            self.present(vc, animated: true, completion: nil)
            // startActivity(i);
            //startActivityForResult(i, 0);
        }

    }
    
    
    @IBAction func selectDr_Dropdown(_ sender: UIButton) {
        OnClickDrLoad()
    }
    
    @IBOutlet weak var lblSelect_Remark: UILabel!
    @IBAction func selectRemark_Dropdwon(_ sender: UIButton) {
        OnClickRemarkLoad()
    }
    
    func setAddressToUI() {
        loc.setText(text: Custom_Variables_And_Method.GLOBAL_LATLON)
    }
    
    @objc func OnProductLoad(){
        
        if( doc_name == ""){
            customVariablesAndMethod.msgBox(vc: context, msg: "Please select Doctor....")
        } else {
            Custom_Variables_And_Method.DR_ID = dr_id
            dr_sample_Dialog(vc: self, responseCode: PRODUCT_DILOG, sample_name: sample_name, sample_pob: sample_pob, sample_sample: sample_sample,sample_noc: sample_noc).setPrevious(sample_name_previous: sample_name_previous, sample_pob_previous: sample_pob_previous, sample_sample_previous: sample_sample_previous).show()
        }
    }
   
    
    @objc func pressedBackButton(_ sender: UIButton) {
        if (Back_allowed != ("Y")) {
            if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "SAMPLE_POB_MANDATORY",defaultValue: "") != ("Y") || sample_name != ("")) {
                self.myTopview.CloseAllVC(vc: self.context)
            }else {
                customVariablesAndMethod.msgBox(vc: context,msg: "Plese enter POB quantity");
            }
        }else{
            Custom_Variables_And_Method.closeCurrentPage(vc: self)
        }
        
    }
    
    @objc func pressedLaterButton(_ sender: UIButton) {
        if (Back_allowed != ("Y")) {
             self.myTopview.CloseAllVC(vc: self.context)
        }else{
            Custom_Variables_And_Method.closeCurrentPage(vc: self)
        }
       
    }
    
    @objc func OnGiftLoad(){
        if (doc_name == "") {
            
            customVariablesAndMethod.msgBox(vc: context,msg: "Please select Doctor....");
        } else {
            Custom_Variables_And_Method.DR_ID = dr_id
            Gift_Dialog(vc: self, responseCode: GIFT_DILOG, gift_name: gift_name, gift_qty: gift_qty, gift_typ: "dr",gift_name_previous: gift_name_previous,gift_qty_previous: gift_qty_previous).show()
        }
        
    }

    func OnClickRemarkLoad(){
        if( doc_name == ""){
            customVariablesAndMethod.msgBox(vc: context, msg: "Please select Doctor....")
        }else{
            Remark_Dialog(vc: self, title: "Select Remark....", List: remark_list, responseCode: REMARK_DILOG).show()
        }
    }
    
    @objc func submit(){
        if (docList.isEmpty) {
            customVariablesAndMethod.msgBox(vc: context,msg: "No Doctor in List...");
        }
        if (dr_id == ("")) {
            customVariablesAndMethod.msgBox(vc: context,msg: "Select Doctor from List...");
        } else if (!sample_added) {
            customVariablesAndMethod.msgBox(vc: context,msg: "Please select atleast one promoted product");
        }else if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "REMARK_WW_MANDATORY", defaultValue: "").contains("D") &&  remark.getText() == ("")) {
            customVariablesAndMethod.msgBox(vc: context,msg: "Please enter remak");
        }else {
            
            cbohelp.updateRemark_TempDrInLocal(drid: dr_id,dr_remark: remark.getText());
            
    
         customVariablesAndMethod.msgBox(vc: context,msg: doc_name + "'s Sample/POB Added Successfully", completion: {_ in
            self.multiCallService.SendFCMOnCall(vc: self, response_code: self.MESSAGE_INTERNET_SEND_FCM, progressHUD: self.progressHUD, DocType: "D",Id: self.dr_id,latlong: "")})
            
            
        }
    
    }

    // on call
    
    func OnClickDrLoad(){
        do{
            let statement = try cbohelp.getDoctorName();
            // chemist.add(new SpinnerModel("--Select--",""));
            let db = cbohelp
            docList.removeAll()
            while let c = statement.next() {
                docList.append(
                    try SpinnerModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "dr_name")]! as! String,
                                     id: c[db.getColumnIndex(statement: statement, Coloumn_Name: "dr_id")]! as! String
                    )
                );
            }
            
            Call_Dialog(vc: self, title: "Select Doctor....", dr_List: docList, callTyp: "DS", responseCode: CALL_DILOG).show()
            //docList = new ArrayList<SpinnerModel>();
            //GPS_Timmer_Dialog(context,mHandler,"Scanning Doctors...",GPS_TIMMER).show();
        }catch {
            print(error)
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
            Dr_Name.text = doc_name
            Custom_Variables_And_Method.DR_ID = dr_id
            showProductGift(IsDrSelected: true)
            break
            
        case REMARK_DILOG:
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            lblSelect_Remark.text = remark_list[Int(inderData["Selected_Index"]!)!]
            if (lblSelect_Remark.text?.lowercased() == "other"){
                remark.setText(text: "");
                remark.isHidden = false
            }else{
                remark.setText(text: lblSelect_Remark.text!);
                remark.isHidden = true
            }
            break
            
        case PRODUCT_DILOG:
            let data = dataFromAPI["data"]!
            let inderData = data[0] as! Dictionary<String , String>
            name = inderData["val"]!   //id
            name2 = inderData["val2"]!   //qty pob
            result = Double(inderData["resultpob"]!)! //pob value
            //let sample = inderData["sampleQty"]!
            resultList = inderData["resultList"]!
            
            
            showProductGift(IsDrSelected: false)
          break
            
        case GIFT_DILOG:
            showProductGift(IsDrSelected: false)
            break
        case MESSAGE_INTERNET_SEND_FCM + 100 :
            self.multiCallService.parser_FCM(dataFromAPI: dataFromAPI)
            break
        case MESSAGE_INTERNET_SEND_FCM :
            progressHUD.dismiss()
            self.myTopview.CloseAllVC(vc: self.context)
            break
        case 99:
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    
    func showProductGift(IsDrSelected : Bool){
        
        // for summery use getCallDetails
        doctor_list=cbohelp.getCallDetail(table: "tempdr",look_for_id: dr_id,show_edit_delete: "0");
        
        if (doctor_list["sample_name"]![0] != "") {
            sample_added = true
            sample_name = doctor_list["sample_name"]![0]
            sample_sample = doctor_list["sample_qty"]![0]
            sample_pob = doctor_list["sample_pob"]![0]
            sample_noc = doctor_list["sample_noc"]![0]
            
            let sample_name1 = sample_name.components(separatedBy: ",");
            let sample_qty1 = sample_sample.components(separatedBy: ",");
            let sample_pob1 = sample_pob.components(separatedBy: ",");
            let sample_noc1 = sample_noc.components(separatedBy: ",");
            
            ShowDrSampleProduct(sample_name: sample_name1, sample_qty: sample_qty1, sample_pob: sample_pob1);
        }else{
            sample_added = false
            sample_name = ""
            sample_sample = ""
            sample_pob = ""
            sample_noc = ""
            RemoveAllviewsinProduct(myStackView: ProductView)
        }
        if (doctor_list["gift_name"]![0] != "") {
            
            gift_name = doctor_list["gift_name"]![0]
            gift_qty = doctor_list["gift_qty"]![0]
            
            name4 = gift_qty
            
            let gift_name1 = gift_name.components(separatedBy: ",");
            let gift_qty1 = gift_qty.components(separatedBy: ",");
            ShowDrSampleGift(gift_name: gift_name1, gift_qty: gift_qty1);
        }else{
            gift_name = ""
            gift_qty = ""
            name4 = gift_qty
            RemoveAllviewsinProduct(myStackView: GiftView)
        }
        
        //if IsDrSelected {
            sample_name_previous=sample_name;
            sample_pob_previous=sample_pob;
            sample_sample_previous=sample_sample;
            
            gift_name_previous = gift_name;
            gift_qty_previous = gift_qty;
       // }
        
        
    }
    
    func RemoveAllviewsinProduct(myStackView : UIView){
        while( myStackView.subviews.count > 0 ) {
            myStackView.subviews[0].removeFromSuperview()
        }
    }
    
    func ShowDrSampleProduct( sample_name : [String],  sample_qty : [String], sample_pob : [String]){
        
        let myStackView = ProductView!
        RemoveAllviewsinProduct(myStackView: myStackView)
        
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
    
    func ShowDrSampleGift( gift_name : [String],  gift_qty : [String]){
        let myStackView = GiftView!
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        // var stackViewHeightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Gift"
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
        myLabel2.text =  "Qty."
        
        
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
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
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< gift_name.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  gift_name[i]
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
            myLabel2.text =  gift_qty[i]
            
            
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
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
            
            
            previousStackView = myinnerStackView
            
            
        }
        
        
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
        
        
        
    }
    

    
}



