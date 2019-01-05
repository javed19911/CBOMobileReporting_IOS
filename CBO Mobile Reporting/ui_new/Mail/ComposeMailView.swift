//
//  ComposeMailView.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 13/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.


import UIKit

class ComposeMailView: CustomUIViewController{
    
    private var progress : ProgressHUD!
    let TO = 4 , CC = 5,MESSAGE_INTERNET_MAIL_COMMIT = 6, AREA_DILOG = 7
    private var list = [DCR_Workwith_Model]()
    
    private var toid = "", ccid = "", mail_type = "", Msg_Id = "0"
    
    private var cbohelop = CBO_DB_Helper.shared
    private var customVariablesAndMethod : Custom_Variables_And_Method!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var view_CC: UIView!
    
    @IBOutlet weak var btn_Back: CustomeUIButton!
    
    @IBOutlet weak var btn_Send: CustomeUIButton!
    
    @IBOutlet weak var btn_TO_Send: UIButton!
    
    @IBOutlet weak var btn_CC_Send: UIButton!
    
    @IBOutlet weak var customTextView_TO: CustomTextView!
    
    @IBOutlet weak var customTextView_CC: CustomTextView!
    
    @IBOutlet weak var customTextView_SUBJECT: CustomTextView!
    
    @IBOutlet weak var customTextView_COMPOSEMAIL: CustomTextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        if VCIntent["replyTo"] != nil{
            customTextView_TO.setText(text: VCIntent["replyTo"]!)
            view_CC.isHidden = true
            btn_TO_Send.isHidden = true
        }else {
            view_CC.isHidden = false
            btn_TO_Send.isHidden = false
            
        }
        if VCIntent["mailSubject"] != nil{
         
            customTextView_SUBJECT.setText(text: VCIntent["mailSubject"]!)
           
        }
        if VCIntent["remark"] != nil{
            customTextView_COMPOSEMAIL.setText(text: VCIntent["remark"]!)
            
        }
        
       
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        customTextView_TO.setHint(placeholder:  "---Select----")
        customTextView_CC.setHint(placeholder: "---Select----")
 
        customTextView_SUBJECT.setHint(placeholder: "Subject")
        customTextView_COMPOSEMAIL.setHint(placeholder: "Compose Mail")
        
        btn_Back.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        btn_Send.addTarget(self, action: #selector(clickOnSend), for: .touchUpInside)
        btn_TO_Send.addTarget(self, action: #selector(pressedToButton), for: .touchUpInside)
        btn_CC_Send.addTarget(self, action: #selector(pressedCCButton), for: .touchUpInside)
      
    }

    
    @objc func pressedToButton(){
         openDialog(responseCode: TO)
    }
    
    @objc func pressedCCButton(){
        openDialog(responseCode: CC)
    }

    
    private func openDialog(responseCode : Int){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Area_DialogViewController") as! Area_DialogViewController
        vc.who = "MAIL"
        vc.vc = self
        vc.responseCode = responseCode
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    @objc func clickOnSend(){
        
        var params = [String : String]()
        
        params["sCompanyFolder"] = cbohelop.getCompanyCode()
        params["sSESSION_ID"] = customVariablesAndMethod1.get_currentTimeStamp()
        params["iSEND_PA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["sREMARK"] = customTextView_COMPOSEMAIL.getText()
        params["sSUBJECT"] = customTextView_SUBJECT.getText()
        params["sFILE_NAME"] = ""
        params["sToPaId"] = toid
        params["sCC_ToPaId"] = ccid
        params["sMAIL_TYPE"] = mail_type
        params["iMAIL_ID"] = Msg_Id
        let tables = [0]
        
        CboServices().customMethodForAllServices(params: params, methodName: "MAILCOMMIT_ALL_1", tables: tables, response_code:  MESSAGE_INTERNET_MAIL_COMMIT, vc: self)
        
        print("send button pressed")
    }
    
    
    
    private func setDataToVC(dataFromAPI: [String : NSArray] , custonTextView : CustomTextView){
        let data = dataFromAPI["data"]!
        let inderData = data[0] as! Dictionary<String , String>
        //print(inderData)
        custonTextView.setText(text: String(inderData["area_name"]!.replacingOccurrences(of: "+", with: ",").dropLast()))
        if(custonTextView == customTextView_TO){
            toid = String(inderData["area_id"]!.replacingOccurrences(of: "+", with: ",").dropLast())
        }else  if(custonTextView == customTextView_CC){
            ccid = String(inderData["area_id"]!.replacingOccurrences(of: "+", with: ",").dropLast())
        }
        
    }
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case TO:
            setDataToVC(dataFromAPI: dataFromAPI, custonTextView: customTextView_TO)
            break
        case CC:
            setDataToVC(dataFromAPI: dataFromAPI, custonTextView: customTextView_CC)
            break
        case MESSAGE_INTERNET_MAIL_COMMIT :
            customVariablesAndMethod.msgBox(vc: self, msg: "Mail Sent Successful",completion: {_ in self.myTopView.CloseCurruntVC(vc: self)})
            break
        case 99:
             customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
        default:
            print("hello")
            break
        }
    }
}

