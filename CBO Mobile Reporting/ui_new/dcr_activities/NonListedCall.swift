//
//  NonListedCall.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 27/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import DLRadioButton


class NonListedCall: CustomUIViewController , CustomFieldRightButton{
  
    var uploadedImage : UIImage!
    var senderTag : Int!
    var imagePickerController = UIImagePickerController()
    var objImagePicker : ImagePicker!
    @IBOutlet weak var categoryDropDown: DPDropDownMenu!
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var categoryTF: CustomFieldWithborader!
    
    // ================================ Doctor Objects ===========================//

    @IBOutlet weak var nameStackView: UIStackView!
    
    @IBOutlet weak var addressStackView: UIStackView!
    
    @IBOutlet weak var emailStackView: UIStackView!
    
    @IBOutlet weak var potentialStackview: UIStackView!
    
    @IBOutlet weak var areaStackView: UIStackView!
    
    @IBOutlet weak var classDropDown: DropDownMenuWithLabel!
    
    @IBOutlet weak var specialityDropDown: DropDownMenuWithLabel!
    
    @IBOutlet weak var QFLDropDown: DropDownMenuWithLabel!
    
    @IBOutlet weak var mobileNoStackview: UIStackView!
    
    @IBOutlet weak var businessDetailsStackview: UIStackView!
    
    @IBOutlet weak var refByStackView: UIStackView!
    
    @IBOutlet weak var callDetailStackView: UIStackView!
    
    @IBOutlet weak var classStackView: UIStackView!
    
    @IBOutlet weak var specialityStackView: UIStackView!
    
    @IBOutlet weak var qfl_StackView: UIStackView!
    

    
    // ================================ C&F Objects ===========================//

    @IBOutlet weak var organizationStackView: UIStackView!
    
    @IBOutlet weak var contactPersonStackView: UIStackView!
    
    @IBOutlet weak var dlNoStackview: UIStackView!
    
    @IBOutlet weak var TINStackView: UIStackView!
    
    @IBOutlet weak var requirementStackView: UIStackView!
    
    @IBOutlet weak var businessStackView: UIStackView!
    
    @IBOutlet weak var pricelistDropDown: DropDownMenuWithLabel!
    
    @IBOutlet weak var dispatchTimeStackView: UIStackView!
    
    @IBOutlet weak var sampleDetailsStackView: UIStackView!
    
    @IBOutlet weak var courierStackView: UIStackView!
    

    
    // objects
    
    @IBOutlet weak var nameTF: CustomFieldWithborader!
    
    @IBOutlet weak var attachPicture_Name: UILabel!
    @IBOutlet weak var organizationTF: CustomFieldWithborader!
    
    @IBOutlet weak var addressTF: CustomFieldWithborader!
    
    @IBOutlet weak var contactPerson: CustomFieldWithborader!
    
    @IBOutlet weak var emailTF: CustomFieldWithborader!
    
    @IBOutlet weak var areaTF: CustomFieldWithborader!
    
    @IBOutlet weak var mobileNumberTF: CustomFieldWithborader!
    
    @IBOutlet weak var DI_No_TF: CustomFieldWithborader!
    
    @IBOutlet weak var attachPicture_DLNo: UILabel!
    
    @IBOutlet weak var TIN_No_TF: CustomFieldWithborader!
    
    @IBOutlet weak var requirementTF: CustomFieldWithborader!
    
    @IBOutlet weak var courierTF: CustomFieldWithborader!
    
    @IBOutlet weak var businessDetailsTF: CustomFieldWithborader!
    
    @IBOutlet weak var ref_By_TF: CustomFieldWithborader!
    
    @IBOutlet weak var callDetailsAndRemark: CustomTextView!
    
   
    @IBOutlet weak var potentialTF: CustomFieldWithborader!
    
    @IBOutlet weak var callDetailsOrRemark: UILabel!
    
    @IBOutlet weak var businessStartDatePicker: CustomDatePicker!
    
    @IBOutlet weak var dispatchDatePicker: CustomDatePicker!
    
    @IBOutlet weak var yesRadioButton: DLRadioButton!
    
    @IBOutlet weak var noRodioButton: DLRadioButton!
    
    @IBOutlet weak var submit: CustomeUIButton!
    
    @IBOutlet weak var smpl_dtl_edt: CustomFieldWithborader!
    
    var category : String = ""
    var customVariablesAndMethod : Custom_Variables_And_Method!
    let cbohelp = CBO_DB_Helper.shared
    let NLC_CALL_DAILOG = 5,CNF_CALL_DAILOG = 6
    var progressHUD : ProgressHUD!
    

    var sDrName = "", sAdd1 = "", sMobileNo = "", sRemark = "", sOrganization_Name = "",sPerson = ""
    var spl_Name = "", spl_Id = "";
    var qfl_Name = "", qfl_Id = "",price_Name = "",price_id = "";
    var class_Name = "", class_Id = "";
    var sDocType = "",docType_name = "";
    
   
    let  MESSAGE_INTERNET_Spinner = 1,MESSAGE_INTERNET_SUBMIT = 2;
    
    var filename="";
    
    @IBAction func setOnCheckedChangeListener(_ sender: DLRadioButton) {
        if(yesRadioButton.isSelected){
            smpl_dtl_edt.isHidden = false
        }else{
            smpl_dtl_edt.isHidden = true
            smpl_dtl_edt.text = ""
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        businessStartDatePicker.setVC(vc: self)
        dispatchDatePicker.setVC(vc: self)
    
        nameTF.delegateRight = self
        DI_No_TF.delegateRight = self
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        categoryTF.isHidden = true
        mobileNumberTF.setKeyBoardType(keyBoardType: .numberPad)
        setupUI(valuForCNF: true, valueForDoctor: false, valueForOthers: false)
        classDropDown.dropDownMenu.headerTitle = "--Select--"
        specialityDropDown.dropDownMenu.headerTitle = "--Select--"
        QFLDropDown.dropDownMenu.headerTitle = "--Select--"
        pricelistDropDown.dropDownMenu.headerTitle = "--Select--"
        
        callDetailsAndRemark.setHint(placeholder: "")
        
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        var tables = [Int]()
        tables.append(0)
        tables.append(1)
        tables.append(2)
        tables.append(3)
        tables.append(4)
        
        var params = [String: String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCRNLCDDL_MOBILE", tables: tables, response_code: NLC_CALL_DAILOG, vc: self, multiTableResponse: true)
        progressHUD = ProgressHUD(vc: self)
        progressHUD.show(text: "Please wait...." )
    
        categoryDropDown.didSelectedItemIndex = { index in
            self.categoryDropDown.headerTitle = self.categoryDropDown.items[index].title
            self.SetUpUI_By_Category(index : index)
        }
    
        classDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.classDropDown.dropDownMenu.headerTitle = self.classDropDown.dropDownMenu.items[index].title
            self.class_Id = self.classDropDown.dropDownMenu.items[index].extra!
            self.class_Name = self.classDropDown.dropDownMenu.items[index].title
        }
    
        specialityDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.specialityDropDown.dropDownMenu.headerTitle = self.specialityDropDown.dropDownMenu.items[index].title
            
            self.spl_Id = self.specialityDropDown.dropDownMenu.items[index].extra!
            self.spl_Name = self.specialityDropDown.dropDownMenu.items[index].title
        }
        
        QFLDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.QFLDropDown.dropDownMenu.headerTitle = self.QFLDropDown.dropDownMenu.items[index].title
            self.qfl_Id = self.QFLDropDown.dropDownMenu.items[index].extra!
            self.qfl_Name = self.QFLDropDown.dropDownMenu.items[index].title
        }
        
        pricelistDropDown.dropDownMenu.didSelectedItemIndex = { index in
            self.pricelistDropDown.dropDownMenu.headerTitle = self.pricelistDropDown.dropDownMenu.items[index].title
            self.price_id = self.pricelistDropDown.dropDownMenu.items[index].extra!
            self.price_Name = self.pricelistDropDown.dropDownMenu.items[index].title
        }
        
        submit.addTarget(self, action: #selector(onClickSubmit), for: .touchUpInside)

    }

    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }

    private func setupUI(valuForCNF : Bool , valueForDoctor : Bool , valueForOthers : Bool){

        // CNF
        organizationStackView.isHidden = valuForCNF
        contactPersonStackView.isHidden = valuForCNF
        dlNoStackview.isHidden = valuForCNF
        TINStackView.isHidden = valuForCNF
        requirementStackView.isHidden = valuForCNF
        businessStackView.isHidden = valuForCNF
        pricelistDropDown.isHidden = valuForCNF
        
        dispatchTimeStackView.isHidden = valuForCNF
        sampleDetailsStackView.isHidden = valuForCNF
        courierStackView.isHidden  = valuForCNF
        
        // doctor
        classStackView.isHidden = valueForDoctor
        specialityStackView.isHidden = valueForDoctor
        qfl_StackView.isHidden = valueForDoctor
        
        
        potentialStackview.isHidden = valueForDoctor
        areaStackView.isHidden = valueForDoctor
        classDropDown.isHidden = valueForDoctor
        QFLDropDown.isHidden = valueForDoctor
        specialityDropDown.isHidden = valueForDoctor
        
        
        // other
        
        nameStackView.isHidden = valueForOthers
        emailStackView.isHidden = valueForOthers
        businessDetailsStackview.isHidden = valueForOthers
        refByStackView.isHidden = valueForOthers
        
    }
    

    
    
    private func SetUpUI_By_Category(index : Int){
        attachPicture_Name.text =  "* Attach Picture"
        attachPicture_DLNo.text =  "* Attach File for DL."
        callDetailsOrRemark.text = "Call Details"
        sDocType = categoryDropDown.items[index].extra!
        switch  sDocType {
        case "D":
            setupUI(valuForCNF: true, valueForDoctor: false, valueForOthers: false)
            categoryTF.isHidden = true
            break
            
//        case "C":
//            setupUI(valuForCNF: true, valueForDoctor: true, valueForOthers: false)
//            categoryTF.isHidden = true
//            break
//
//        case "S":
//            setupUI(valuForCNF: true, valueForDoctor: true, valueForOthers: false)
//            categoryTF.isHidden = true
//            break
            
        case "CNF":
            setupUI(valuForCNF: false, valueForDoctor: true, valueForOthers: true)
            categoryTF.isHidden = true
            callDetailsOrRemark.text = "Remarks"
            noRodioButton.isSelected = true
            getPrice()
            break
            
        case "O":
            setupUI(valuForCNF: true, valueForDoctor: true, valueForOthers: false)
            categoryTF.isHidden = false
            break
            
        default:
            setupUI(valuForCNF: true, valueForDoctor: true, valueForOthers: false)
            categoryTF.isHidden = true
        
        }
    }
    
    
    func getPrice(){
        
        //Start of call to service
        
        var tables = [Int]()
        tables.append(0)
        
        var params = [String: String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        
        progressHUD = ProgressHUD(vc: self)
        progressHUD.show(text: "Please wait...." )
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCR_NLC_CNF_DDL", tables: tables, response_code: CNF_CALL_DAILOG, vc: self, multiTableResponse: true)
  
        
        //End of call to service
    }
    
    @objc func onClickSubmit() {
    
        if(sDocType == "CNF"){
            onClickSubmit_CNF();
        }else{
            onClickSubmit_NLC();
        }
    }
    
    
    func onClickSubmit_NLC() {
        
        sDrName = nameTF.text!
        sAdd1 = addressTF.text!
        sMobileNo = mobileNumberTF.text!
        sRemark = callDetailsAndRemark.text
        
        if (sDrName == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Name Can't be Empty...");
        } else if (sAdd1 == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Address Can't be Empty...");
        } else if (sMobileNo == ("") || sMobileNo.count != 10) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Mobile No. is always of 10 digit...");
        } else if (sRemark == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Call Details Can't be Empty...");
        } else if (sDocType == "" ) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Error Please open the page again...");
        }  else if ( sDocType == ("O") &&  categoryTF.text == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Category Can't be Empty...");
        } else if ( customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: mcontext,key: "NLC_PIC_YN",defaultValue: "N") == ("Y") && filename == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Please Attach a Picture....");
        }else {
            
            if (filename != ("")){
                
                let ftpUpload = Up_Down_Ftp()
                progressHUD.show(text: "Please Wait..\nuploading Image")
                ftpUpload.uploadFile(data: uploadedImage.convertImageToUploadableData(), fileName: filename)
                ftpUpload.UploadDelegate = self
                
                
            }else{
                SubmitNLC();
            }
            
        }
    }
    
    func onClickSubmit_CNF() {
    
        sPerson = contactPerson.text!
        sOrganization_Name = organizationTF.text!
        sDrName = nameTF.text!
        sAdd1 = addressTF.text!
        sMobileNo = mobileNumberTF.text!
        sRemark = callDetailsAndRemark.text
    
        if (sOrganization_Name == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Orgamization Name Can't be Empty...");
        } else if (sPerson == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Contact Name Can't be Empty...");
        } else if (sAdd1 == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Address Can't be Empty...");
        } else if (sMobileNo.count != 10 ) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Mobile No. is always of 10 digit...");
        } else if (sRemark == ("")) {
            customVariablesAndMethod.msgBox(vc: mcontext,msg: "Remark Can't be Empty...");
        } else {
            if (filename != ("")){
                
                let ftpUpload = Up_Down_Ftp()
                progressHUD.show(text: "Please Wait..\nuploading Image")
                ftpUpload.uploadFile(data: uploadedImage.convertImageToUploadableData(), fileName: filename)
                ftpUpload.UploadDelegate = self
                
                
            }else{
                SubmitCNF();
            }
        }
    }

    func SubmitCNF(){
        //Start of call to service
        
        var request = [String : String]()
        
        request["sCompanyFolder"] = cbohelp.getCompanyCode()
        request["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        request["iDcrId"] = "\(Custom_Variables_And_Method.DCR_ID)"
        request["sDOC_TYPE"] =  sDocType
        
        request["sOrganization_Name"] = sOrganization_Name
        request["sAdd1"] = sAdd1
        
        request["sAdd2"] = ""
        request["sAdd3"] =  ""
         request["sPerson"] = sPerson
        request["sMobileNo"] =  sMobileNo
        
        request["sDL_NO"] =   DI_No_TF.text!
        request["sTIN_NO"] =  TIN_No_TF.text!
        
        if (businessStartDatePicker.getDateInString() == ("--MM/DD/YYYY--")){
            request["sBUSS_START_DATE"] =  ""
        }else {
            request["sBUSS_START_DATE"] =  businessStartDatePicker.getDate(dateFormat: "MM/dd/YYYY")
        }
        request["sREQUIREMENT"] =  requirementTF.text!
        request["sRemark"] =  sRemark
        
        request["sFILE_NAME"] =  filename
        request["iPRICE_LIST_ID"] =  price_id
        request["iSAMPLE_YN"] =  smpl_dtl_edt.text!
        
        if (dispatchDatePicker.getDateInString()  == ("--MM/DD/YYYY--")){
            request["sDISPATCH_DATE"] =  ""
        }else {
            request["sDISPATCH_DATE"] =   dispatchDatePicker.getDate(dateFormat: "MM/dd/YYYY")
        }
        request["sCOURIOR_NAME"] =   courierTF.text!
        
        request["sNLC_LOC"] =  customVariablesAndMethod.get_best_latlong(context: mcontext)
        
        
        
        var tables = [Int]()
        tables.append(0)
        
        progressHUD.show(text: "Please Wait.. \n Processing...." )
        
        
        CboServices().customMethodForAllServices(params: request, methodName: "DCRNLC_CNF_Commit_1", tables: tables, response_code: MESSAGE_INTERNET_SUBMIT, vc : mcontext )
        
        
        //End of call to service
    }
    
    func SubmitNLC(){
        //Start of call to service
        
        var request = [String : String]()
        
        request["sCompanyFolder"] = cbohelp.getCompanyCode()
        request["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        request["iDcrId"] = "\(Custom_Variables_And_Method.DCR_ID)"
        request["sDocType"] =  sDocType
        
        request["sDrName"] = sDrName
        request["sAdd1"] = sAdd1
        
        request["sAdd2"] = ""
        request["sAdd3"] =  ""
        
        request["sMobileNo"] =  sMobileNo
        request["sRemark"] = sRemark
        request["iSplId"] =  spl_Id
        request["iQflId"] =  qfl_Id
        
        request["iSrno"] = ""
            request["iInTime"] = customVariablesAndMethod.currentTime(context: mcontext)
        
        request["sClass"] = class_Name
        request["iPotencyAmt"] =  potentialTF.text!
        request["sArea"] = areaTF.text!
        
        request["sOTHER_REMARK"] =  categoryTF.text!
        request["sEMAIL"] =  emailTF.text!
        request["sBUSINESS_DETAILS"] = businessDetailsTF.text!
        request["sREF_BY"] = ref_By_TF.text!
        
        request["sNLC_LOC"] = customVariablesAndMethod.get_best_latlong(context: mcontext)
        request["sNLC_FILE"] = filename
    
        
        var tables = [Int]()
        tables.append(0)
        
        progressHUD.show(text: "Please Wait.. \n Processing...." )
        
        
        CboServices().customMethodForAllServices(params: request, methodName: "DCRNLC_Commit_3", tables: tables, response_code: MESSAGE_INTERNET_SUBMIT, vc : mcontext )
   
    
        //End of call to service
    }

    
    func parser_submit(dataFromAPI : [String : NSArray]) {
        //customVariablesAndMethod.SetLastCallLocation(mcontext);
        
        if(sDocType == "CNF"){
            cbohelp.insert_NonListed_Call(sDocType: docType_name,sDrName: sOrganization_Name,sAdd1: sAdd1,sMobileNo: sMobileNo,sRemark: sRemark,iSplId: filename,iSpl: "c&f",iQflId: "",iQfl: sPerson,iSrno: "",loc: customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: mcontext,key: "shareLatLong",defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON),time: customVariablesAndMethod.currentTime(context: mcontext),CLASS: DI_No_TF.text!,POTENCY_AMT: TIN_No_TF.text!,AREA: businessDetailsTF.text!);
        }else{
             cbohelp.insert_NonListed_Call(sDocType: docType_name,sDrName: sDrName,sAdd1: sAdd1,sMobileNo: sMobileNo,sRemark: sRemark,iSplId: spl_Id,iSpl: spl_Name,iQflId: qfl_Id,iQfl: qfl_Name,iSrno: "",loc: customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: mcontext,key: "shareLatLong",defaultValue: Custom_Variables_And_Method.GLOBAL_LATLON),time: customVariablesAndMethod.currentTime(context: mcontext),CLASS: class_Name,POTENCY_AMT: potentialTF.text!,AREA: areaTF.text!);
        }
       
        progressHUD.dismiss()
        customVariablesAndMethod.msgBox(vc: mcontext,msg: "Successfully Submitted",completion : {_ in
            self.myTopView.CloseAllVC(vc: self.mcontext)
        });

    }
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        
        switch response_code {
            case NLC_CALL_DAILOG:
                if !dataFromAPI.isEmpty{
                    let jsonArray0 =   dataFromAPI["Tables0"]!
                    print(jsonArray0)
                    for i in 0 ..< jsonArray0.count{
                        let innerJson = jsonArray0[i] as! [String : AnyObject]
                        specialityDropDown.dropDownMenu.items.append(DPItem(title: innerJson["SPL"]! as! String , extra: innerJson["SPL_ID"]! as! String ) )
                    }
                    
                    
                    let jsonArray1 =   dataFromAPI["Tables1"]!
                    print(jsonArray1)
                    for i in 0 ..< jsonArray1.count{
                        let innerJson = jsonArray1[i] as! [String : AnyObject]
                        QFLDropDown.dropDownMenu.items.append(DPItem(title: innerJson["QFL"]! as! String , extra: innerJson["QFL_ID"]! as! String ) )
                    }
                    
                   
                    let jsonArray3 =   dataFromAPI["Tables3"]!
                    print(jsonArray3)
                    for i in 0 ..< jsonArray3.count{
                        let innerJson = jsonArray3[i] as! [String : AnyObject]
                        classDropDown.dropDownMenu.items.append(DPItem(title: innerJson["FIELD_NAME"]! as! String , extra: innerJson["ID"]! as! String ) )
                    }
                   
                    
                    let jsonArray4 =   dataFromAPI["Tables4"]!
                    print(jsonArray4)
                    for i in 0 ..< jsonArray4.count{
                        let innerJson = jsonArray4[i] as! [String : AnyObject]
                        categoryDropDown.items.append(DPItem(title: innerJson["PA_NAME"]! as! String , extra: innerJson["PA_ID"]! as! String ) )
                    }
                    categoryDropDown.headerTitle = categoryDropDown.items[0].title
                    SetUpUI_By_Category(index: 0)
                    
                }
                progressHUD.dismiss()
                
                break
        case CNF_CALL_DAILOG:
            if !dataFromAPI.isEmpty{
                let jsonArray0 =   dataFromAPI["Tables0"]!
                pricelistDropDown.dropDownMenu.items.removeAll()
                for i in 0 ..< jsonArray0.count{
                    let innerJson = jsonArray0[i] as! [String : AnyObject]
                    pricelistDropDown.dropDownMenu.items.append(DPItem(title: innerJson["PA_NAME"]! as! String , extra: innerJson["PA_ID"]! as! String ) )
                    
                    
                }
            }
            progressHUD.dismiss()
        case MESSAGE_INTERNET_SUBMIT:
            
            parser_submit(dataFromAPI: dataFromAPI)
            break;
        case 99:
                progressHUD.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
            default:
                progressHUD.dismiss()
                print("Error")
        }
    }
}


extension NonListedCall : ImagePickerDelegate, FTPUploadDelegate{
   
    func upload_complete(IsCompleted: String) {
        switch IsCompleted {
        case "S":
            //progressHUD.show(text: "Please Wait\nUploading Image")
            break
        case "Y":
            if(sDocType == "CNF"){
                SubmitCNF();
            }else{
                SubmitNLC();
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

    func getImage(image: UIImage  ) {
        
        uploadedImage = UIImage()
        uploadedImage = image
        attachPicture_DLNo.text = "\(Custom_Variables_And_Method.PA_ID)_\(Custom_Variables_And_Method.DCR_ID)_\(customVariablesAndMethod.get_currentTimeStamp()).jpg"
        attachPicture_Name.text = attachPicture_DLNo.text
        
    
        
    }


    func onClickRightButton(sender: CustomFieldWithborader) {
        
        switch sender.tag {
        case 1:
            print("name 1")
            senderTag = sender.tag
            
            break
        case 2:
            senderTag = sender.tag
            print("name 2")
            break
        default:
            print("name 3")
        }
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self , source : UIImagePickerControllerSourceType.camera)
        imagePickerController.delegate = objImagePicker
        objImagePicker.delegate = self
    }
    
}
