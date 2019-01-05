//
//  MailDetailsVC.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 15/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class MailDetailsVC: CustomUIViewController {

    private let MAIL_POPULATE = 1
    private var mailAdaptor : MailDetailsAdaptor!
    
    private let summarydata = ["vikas","vaibhav","mukesh","deepak","sudhanshu","Akash","bharat", "Amrita"]
    private var customVariablesAndMethod: Custom_Variables_And_Method!
    private var progressHUD : ProgressHUD!
    
    private var cbohelp : CBO_DB_Helper!
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lbl_DateTime: UILabel!
    
    @IBOutlet weak var lbl_From: UILabel!

    @IBOutlet weak var lbl_Subject: UILabel!
    
    
    @IBOutlet weak var lbl_Remark: UILabel!
    
    @IBOutlet weak var btn_Attachment: UIButton!
    
    @IBOutlet weak var btn_Reply: UIButton!
    
    @IBOutlet weak var btn_Forward: UIButton!
    
    @IBOutlet weak var btn_Reply2: UIButton!
    
    @IBOutlet weak var btn_Forward2: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        if VCIntent["title"] != nil{
            myTopView.setText(title:  VCIntent["title"]!)
        }
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        btn_Reply.addTarget(self, action: #selector(pressedReply), for: .touchUpInside)
        
        btn_Forward.addTarget(self, action: #selector(pressedForward), for: .touchUpInside)
        
        btn_Reply2.addTarget(self, action: #selector(pressedReply), for: .touchUpInside)
    
        btn_Forward2.addTarget(self, action: #selector(pressedForward), for: .touchUpInside)
    
        
    
        cbohelp = CBO_DB_Helper.shared
        
        var params = [String : String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["iId"] =  VCIntent["mail_id"]!
        params["sMailType"] = "i"
        let tables = [0,1]
        progressHUD = ProgressHUD(vc: self)
        progressHUD.show(text: "Please Wait...")
        CboServices().customMethodForAllServices(params: params, methodName: "MailPopulate", tables: tables, response_code: MAIL_POPULATE , vc: self, multiTableResponse: true)
        
    }
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    @objc func pressedReply(){
        composeMail(replyYN: "Y")
    }
    
    private func composeMail(replyYN : String){
        
        self.dismiss(animated: false , completion: nil)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ComposeMailView") as! ComposeMailView
        
        if replyYN == "Y"{
            vc.VCIntent["replyTo"] = lbl_From.text!
        }
        vc.VCIntent["mailSubject"] = lbl_Title.text!
        vc.VCIntent["remark"] = lbl_Remark.text
        
        vc.VCIntent["title"] = "Compose"
        self.presentingViewController?.present(vc, animated: false, completion: nil)
    }
    
    @objc func pressedForward(){
         composeMail(replyYN: "N")
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        
        switch response_code {
        case MAIL_POPULATE:
            progressHUD.dismiss()
            parser_MailData(dataFromAPI: dataFromAPI)
            break
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod.msgBox(vc: self, msg: (dataFromAPI["Error"]![0] as! String))
            
            break
        default:
            progressHUD.dismiss()
            print("print")
        }
    }
    
    
    
    private func parser_MailData(dataFromAPI: [String : NSArray]){
        if !dataFromAPI.isEmpty{
            let jsonArray =   dataFromAPI["Tables0"]!
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                
                lbl_Title.text = (innerJson["SUBJECT"] as! String)
                lbl_DateTime.text = (innerJson["DOC_DATE"] as! String)
                lbl_Remark.text = (innerJson["REMARK"] as! String)
                if VCIntent["from"] != nil{
                    lbl_From.text = VCIntent["from"]!
                }
                print(innerJson)
            }
            
            let jsonArray1 =   dataFromAPI["Tables1"]!
            
            
            mailAdaptor = MailDetailsAdaptor(vc: self, tableView: tableView, data: jsonArray1 as! [[String : AnyObject]])
            tableView.reloadData()
        }
    }
}
