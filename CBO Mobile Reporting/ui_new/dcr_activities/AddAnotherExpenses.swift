//
//  AddAnotherExpenses.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 19/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import DLRadioButton
class AddAnotherExpenses: CustomUIViewController  , CheckBoxDelegate , FTPUploadDelegate {
   
    var path = ""
    var progress : ProgressHUD!
    var imagePickerController = UIImagePickerController()
    var objImagePicker : ImagePicker!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var AttachmentOptionStackView: UIStackView!
    @IBOutlet weak var AttachmentImageView: UIImageView!
    @IBOutlet weak var ExpHeadDropDown :  DPDropDownMenu!
    
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var remark_txt: CustomTextView!
    @IBOutlet weak var amt_txt: CustomTextView!
    @IBOutlet weak var exp_hed_dp: DPDropDownMenu!
    @IBOutlet weak var cancel: CustomeUIButton!
    var customVariablesAndMethod : Custom_Variables_And_Method!
    
    @IBOutlet weak var attach_laout: UIStackView!
    @IBOutlet weak var add: CustomeUIButton!
    
    @IBOutlet weak var CameraButton: DLRadioButton!
    @IBOutlet weak var galleryButton: DLRadioButton!
    @IBOutlet weak var expensesView: UIView!
    var vc : CustomUIViewController!
    var dropDownList =  [DPItem]()
    var amount = ""
    var remark = ""
   
    var responseCode : Int! = 0
    var exp_id = ""
    var exp_hed = ""
    var DA_ACTION = "0"
    var dcr_id : String!
    var filename = ""
    var actual_DA_layout_isHidden = true
    var da_root_Text = ""
  
    var MESSAGE_INTERNET_SAVE_EXPENSE = 2
    
    var cbohelp = CBO_DB_Helper.shared
    
    @IBOutlet weak var amt_lbl: UILabel!
    @IBOutlet weak var remark_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(value: true)
        
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self , source : ImagePicker.camera)
//        AttachmentImageView.image = objImagePicker.getPhotoFromCustomAlbum()
        
        
   //    AttachmentImageView.image = UIImage(contentsOfFile: objImagePicker.getImageFromApplicationFolder(FOLDER_NAME: objImagePicker.albumName, filename: "4282_23__1526365193.40796.jpg"))
        
        

        expensesView.layer.cornerRadius = 5.0
        ExpHeadDropDown.layer.borderWidth = CGFloat(2.0)
        ExpHeadDropDown.layer.cornerRadius = 8
        ExpHeadDropDown.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        ExpHeadDropDown.headerTextColor = AppColorClass.colorPrimaryDark!
        ExpHeadDropDown.menuTextColor = AppColorClass.colorPrimaryDark!
        ExpHeadDropDown.selectedMenuTextColor = AppColorClass.colorPrimaryDark!
        checkBox.delegate = self
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        CameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        
       
        
        // Do any additional setup after loading the view.
        
        dcr_id = Custom_Variables_And_Method.DCR_ID
        
        cancel.addTarget(self, action: #selector(pressedBack), for: .touchUpInside )
         add.addTarget(self, action: #selector(addExp), for: .touchUpInside )
        
        amt_txt.setText(text: amount)
        remark_txt.setText(text: remark)
        amt_txt.setKeyBoardType(keyBoardType: .numberPad)
        ExpHeadDropDown.items = dropDownList
        ExpHeadDropDown.selectedIndex = 0
        ExpHeadDropDown.layer.borderColor = UIColor.white.cgColor
        
        if VCIntent["who"] != "0"{
            exp_hed_dp.headerTitle = VCIntent["Exp_Header"]!
            exp_id = VCIntent["Exp_Id"]!
//            exp_hed = VCIntent["Exp_Header"]!
            exp_hed_dp.isUserInteractionEnabled  = false
            
        }
        
        
        ExpHeadDropDown.didSelectedItemIndex = { index in
            self.exp_id = self.dropDownList[index].code!
            self.exp_hed = self.dropDownList[index].title
            self.DA_ACTION = self.dropDownList[index].getType()
            //filename="";
//            attach_img.setImageDrawable(null);
//            add_attachment.setChecked(false);
            
            if (self.exp_id == ("3119")) {
                self.amt_txt.setHint(placeholder: "K.M.");
                self.remark_lbl.text = ("K.M. Remark.");
                self.amt_lbl.text = ("K.M.");
            } else {
                self.amt_txt.setHint(placeholder: "Amt.");
                self.remark_lbl.text = ("Exp Remark.");
                self.amt_lbl.text = ("Amount");
                
            }
        }
//        AttachmentImageView.isHidden  = false
    }
    
    
    
    @objc func addExp(){
        amount = amt_txt.getText()
        remark = remark_txt.getText()
       
        
        if (exp_id == ("")) {
            customVariablesAndMethod1.msgBox(vc: self,msg: "First Select the Expense...");
        } else if (amount.trimmingCharacters(in: .whitespaces).isEmpty) {
            customVariablesAndMethod1.msgBox(vc: self,msg: "Please Enter the Expense Amt....");
        } else if (Int(amount)! == 0) {
            customVariablesAndMethod1.msgBox(vc: self,msg: "Expense Amt. can't be zero...");
        } else if (remark.trimmingCharacters(in: .whitespaces).isEmpty) {
            customVariablesAndMethod1.msgBox(vc: self,msg: "Please Enter the Remark....");
        } else if ( self.DA_ACTION == ("1") && actual_DA_layout_isHidden == false
            && da_root_Text != ("0") && !da_root_Text.isEmpty) {
            
            customVariablesAndMethod1.getAlert(vc: self,title: "Already Applied for DA...",
                                              msg: "Please make DA amount Rs 0.") {_ in
                              self.dismiss(animated: true, completion: nil)
            };
           
        }else {
        
                if (filename != ""){
                    
                    objImagePicker.saveImageDocumentDirectory(fileName: filename, image: AttachmentImageView.image!, FOLDER_NAME: objImagePicker.albumName)
                    
    
//                  AttachmentImageView.image! = objImagePicker.getPhotoFromCustomAlbum()

                    let ftpUpload = Up_Down_Ftp()

                    ftpUpload.UploadDelegate = self
//2
                    progress = ProgressHUD(vc: self)
                    if !(UIImage(contentsOfFile: objImagePicker.getImageFromApplicationFolder(FOLDER_NAME: objImagePicker.albumName, filename: filename))!.convertImageToUploadableData().isEmpty){
                        
                        print(objImagePicker.getImageFromApplicationFolder(FOLDER_NAME: objImagePicker.albumName, filename: filename))
                        // set Image name
                        ftpUpload.uploadFile(data: (AttachmentImageView.image?.convertImageToUploadableData())!, fileName: filename)

                    }
                    else {
                        // show alert
                    }
                }

            if(VCIntent["path"] != ""){
                
                filename = VCIntent["path"]!
            }

            if (filename == "") {
                expense_commit()
            }
        }
    }
    
   
    
    func expense_commit(){
        //Start of call to service
        
        var request = [String:String]()
        request["sCompanyFolder"] = cbohelp.getCompanyCode()
        request["iDcrId"] = dcr_id
        request["iExpHeadId"] = exp_id
        request["iAmount"] = amount
        request["sRemark"] = remark
        request["sFileName"] = filename
        
        var tables = [Int]();
        tables.append(0);
        
        progress = ProgressHUD(vc: self)
        progress.show(text: "Please Wait...")
        CboServices().customMethodForAllServices(params: request, methodName: "DCREXPCOMMITMOBILE_2", tables: tables, response_code: MESSAGE_INTERNET_SAVE_EXPENSE, vc: self)
        

        //End of call to service
        amt_txt.setText(text: "");
        remark_txt.setText(text: "");
        //dialog.dismiss();
    }
    
    func upload_complete(IsCompleted: String) {
        
        
        switch IsCompleted {
            
        case "S":
            progress.show(text: "Please Wait...\nUploading Image")
            break
            
        case "Y":
            progress.dismiss()
            //customVariablesAndMethod.msgBox(vc: self, msg: "Photo Upload Completed")
             expense_commit()
            break
        case "530":
            progress.dismiss()
            customVariablesAndMethod.msgBox(vc: self, msg: "No Details found for upload\nPlease Download Data From Utilities Page....")
            break
        case "50":
            progress.dismiss()
            break
            
        default:
            progress.dismiss()
            customVariablesAndMethod.msgBox(vc: self,msg:"UPLOAD FAILED \n Please try again")
        }
        
    }
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        switch response_code {
        case MESSAGE_INTERNET_SAVE_EXPENSE:
            progress.dismiss()
            parser2(dataFromAPI : dataFromAPI);
            break;
       
        case 99:
            progress.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
           
            print("Error")
        }
    }
    
    
   func parser2(dataFromAPI: [String : NSArray]) {
    if(!dataFromAPI.isEmpty){
        do {
            
            let jsonArray1 =   dataFromAPI["Tables0"]!
            let object = jsonArray1[0] as! [String : AnyObject]
           
            let value = try object.getString(key: "DCRID");
            let id = try object.getString(key: "ID");
            cbohelp.insert_Expense(exp_head_id: exp_id,exp_head: exp_hed,amount : amount,remark:  remark,FILE_NAME: filename,ID: id as! String,time: customVariablesAndMethod1.currentTime(context: self));
            
            self.dismiss(animated: true, completion: nil)
            var ReplyMsg = [String : String]()
            
            ReplyMsg["result"]  = "ok"
            vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
//            self.dismiss(animated: true, completion: nil)
//            vc.getDataFromApi(response_code: responseCode, dataFromAPI: dataFromAPI)
//            data=cbohelp.get_Expense();
//            sm = new Expenses_Adapter(ExpenseRoot.this, data);
//            mylist.setAdapter(sm);
//            init_DA_type(DA_layout);
//
//            customVariablesAndMethod.msgBox(context, " Exp. Added Sucessfully");
//            exp_id="";
//            exp_hed="";
//            my_Amt="";
//            my_rem ="";
//            filename="";
//            id="";
    
            } catch {
                
                customVariablesAndMethod1.getAlert(vc: self, title: "Missing field error", msg: error.localizedDescription);
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: self)
                
                objBroadcastErrorMail.requestAuthorization()
            }
        }
    
    }
    
    
    @objc func pressedBack(){
        Custom_Variables_And_Method.closeCurrentPage(vc: self);
    }
    
    func onChackedChangeListner(sender: CheckBox, ischecked: Bool) {
        
        
        AttachmentOptionStackView.isHidden = !ischecked
        AttachmentImageView.isHidden = true
        AttachmentImageView.image = nil
        galleryButton.deselectOtherButtons()
        CameraButton.deselectOtherButtons()

//          setupUI(value: !ischecked)
    }
    
    
    func setupUI(value : Bool){
        AttachmentOptionStackView.isHidden =  value
        AttachmentImageView.isHidden = value
    }
}

extension AddAnotherExpenses : ImagePickerDelegate{
    func getImage(image: UIImage) {
        setupUI(value: false)
        AttachmentImageView.image = image
        
        // filename
        filename = "\(Custom_Variables_And_Method.PA_ID)_\(Custom_Variables_And_Method.DCR_ID)_\(exp_id)_\(customVariablesAndMethod.get_currentTimeStamp()).jpg"
    }
    
    
    
    @objc func openCamera(){
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self , source : ImagePicker.camera)
        imagePickerController.delegate = objImagePicker
        objImagePicker.delegate = self
        objImagePicker.createFolderinApplicationDirectory(FOLDER_NAME: objImagePicker.albumName)
//        objImagePicker.FetchCustomAlbumPhotos()
    }
    
    @objc func openGallery(){
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self , source : ImagePicker.gallery)
        imagePickerController.delegate = objImagePicker
        objImagePicker.delegate = self
        
        objImagePicker.createFolderinApplicationDirectory(FOLDER_NAME: objImagePicker.albumName)
    }

}


