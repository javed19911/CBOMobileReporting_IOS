//
//  UploadImageVC.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 09/02/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//



import UIKit

class UploadImageVC: CustomUIViewController , FTPUploadDelegate , ImagePickerDelegate  , ImagePickerCancelDelegate{
    let cbohelp = CBO_DB_Helper.shared
    var context : CustomUIViewController!
    var objImagePicker : ImagePicker!
    var filename = ""
    let INTERNET_MESSAGE = 5
    var progess : ProgressHUD!
    @IBOutlet weak var myView: CustomBoarder!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var myImageView: UIImageView!
    var customVariablesAndMethod: Custom_Variables_And_Method!
    @IBOutlet weak var pressedClickPic: CustomeUIButton!
    @IBOutlet weak var backButton: CustomeUIButton!
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        context = CustomUIViewController()
        context = self
        pressedClickPic.setText(text: "Click Picture")
        setupImageView()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        myTopView.layer.cornerRadius = 5.0
        backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        
    }
    
    @objc func closeCurrentView(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    func cancelButtonPressed() {
        customVariablesAndMethod.msgBox(vc: self, msg: "User cancelled image capture")
    }
    
    func UploadPhotoInBackGround(){
        let tables = [0]
        var params = [String : String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["ID"]  = "0"
        params["PA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["sDATE"] = customVariablesAndMethod.currentDate()
        params["sFILENAME"] = filename
        params["sLATLONG"] = customVariablesAndMethod.get_best_latlong(context: self)
        params["sLOC"] = ""
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "MobileImageCommit", tables: tables, response_code: INTERNET_MESSAGE , vc: self, multiTableResponse: false)
        //End of call to service
//
//        return customMethodForAllServices(request,"MobileImageCommit");
        
        
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case INTERNET_MESSAGE:
            do {
                if(!dataFromAPI.isEmpty){
                   customVariablesAndMethod.getAlert(vc: self, title: "Success", msg: "File Successfully Sent....") { _ in
                        self.dismiss(animated: true, completion:nil )
                    }
                }
            }
            catch{
                print("error")
            }
            break
        
        case 99:
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    func upload_complete(IsCompleted: String) {
 
        if IsCompleted == "S"{
            print(type(of: self))
//                progess = ProgressHUD(vc: self)
//                progess.show(text: "Uploading Image.......\nplease wait")
        }else if IsCompleted == "Y"{
            progess.dismiss()
            UploadPhotoInBackGround()
           //customVariablesAndMethod.msgBox(vc: self, msg: "Photo Upload Completed")
            
        }else if IsCompleted == "ERROR"{
            customVariablesAndMethod.getAlert(vc: self, title: "Folder not found", msg: "Invalid path \nPlease contact your administrator")
        } else if (IsCompleted == "50"){
           
                progess.dismiss()
            
            customVariablesAndMethod.msgBox(vc: self,msg:"UPLOAD FAILED \n Check Your Internet Connection")
        }else if (IsCompleted == "530"){
            
               progess.dismiss()
           
            customVariablesAndMethod.msgBox(vc: self, msg: "No Details found for upload\nPlease Download Data From Utilities Page....")
        }else {
            customVariablesAndMethod.msgBox(vc: self,msg:"UPLOAD FAILED \n Please try again")
        }
    }
    
    func setupImageView()  {
        myImageView.layer.cornerRadius = 5.0
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.borderColor = AppColorClass.logo_green?.cgColor
        myImageView.clipsToBounds = true
        myImageView.layoutIfNeeded()
    }
    
    
    @IBAction func pressedClickPicture(_ sender: CustomeUIButton) {
        if pressedClickPic.titleLabel!.text == "Click Picture"{
            openCamera()
        }else {
           uploadImageToFTP()
        }
    }
    
    
    func getImage(image: UIImage) {
        
        myImageView.image = image
        pressedClickPic.setTitle("Send to H.O.", for: .normal)
        
        filename = "\(Custom_Variables_And_Method.PA_ID)_\(Custom_Variables_And_Method.DCR_ID)_\(customVariablesAndMethod.get_currentTimeStamp()).jpg";
        
    }
    
    func openCamera(){
        objImagePicker = ImagePicker(imagePickerController: imagePickerController, vc: self , source : ImagePicker.camera)
        imagePickerController.delegate = objImagePicker
        objImagePicker.delegate = self
        objImagePicker.delegateCancel = self
    }

    func uploadImageToFTP(){
        
        
        if filename != ""{
            progess = ProgressHUD(vc: self)
            progess.show(text: "Uploading Image.......\nplease wait")
            let ftpUpload = Up_Down_Ftp()
            
            ftpUpload.UploadDelegate = self

                if !(myImageView.image?.convertImageToUploadableData().isEmpty)!{
                   
            // set Image name
                    ftpUpload.uploadFile(data: (myImageView.image?.convertImageToUploadableData())!, fileName: filename)
                }
                else {
            // show alert
                }
//             progess.dismiss()
        }else {
            customVariablesAndMethod.getAlert(vc: self, title: "Upload Error...", msg: "No Details found for upload\nPlease Download Data From Utilities Page.....")
        }
    }
}





