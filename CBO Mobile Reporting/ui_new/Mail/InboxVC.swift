//
//  InboxVC.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 14/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class InboxVC: CustomUIViewController {
    
    private var progressHUD : ProgressHUD!
    private var mail_category = ""
    private var data = [[String : String]]()
    let MESSAGE_INTERNET_Mail = 1 , MESSAGE_INTERNET_SentMail = 2
    private var customVariablesAndMethod: Custom_Variables_And_Method!
    @IBOutlet weak var btn_RedView: UIView!
     let cbohelp = CBO_DB_Helper.shared
    @IBOutlet var tapRecorgnizer: UITapGestureRecognizer!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    var inbox_Adaptor : InboxVC_Adaptor!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]! )
        }
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        tapRecorgnizer.addTarget(self, action: #selector(tapOnRedView))
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        if VCIntent["title"]?.lowercased() == "inbox" {
            mail_category = "i"
            btn_RedView.isHidden = true
        }else {
            mail_category = "s"
            btn_RedView.layer.cornerRadius = btn_RedView.frame.height / 2
        }
        call_Service()
    }
    
    private func call_Service(){
        progressHUD = ProgressHUD(vc: self)
        
        var params = [String : String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPaId"] =  "\(Custom_Variables_And_Method.PA_ID)"
        params["sMailType"] = mail_category
        params["sFDate"] = ""
        let max_id=cbohelp.getMaxMailId(mail_category:mail_category);
        params["iFid"] = max_id
        let tables = [0]
        CboServices().customMethodForAllServices(params: params, methodName: "MAILGRID_1", tables: tables, response_code: MESSAGE_INTERNET_Mail, vc: self, multiTableResponse: true)
        progressHUD.show(text: "Please Wait...")
    }
    
    
    @objc func tapOnRedView(){
        
        self.dismiss(animated: false , completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ComposeMailView") as! ComposeMailView
        vc.VCIntent["title"] = "Compose"
        self.presentingViewController?.present(vc, animated: false, completion: nil)
    }
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case MESSAGE_INTERNET_Mail:
            progressHUD.dismiss()
            parser_mail(dataFromAPI: dataFromAPI)
            break
        case 99 :
            print(dataFromAPI)
            progressHUD.dismiss()
            customVariablesAndMethod.msgBox(vc: self, msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            progressHUD.dismiss()
            print("hello")
        }
    }
    
    private func parser_mail(dataFromAPI: [String : NSArray] ) {
        if(!dataFromAPI.isEmpty){
            let jsonArray =   dataFromAPI["Tables0"]!
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                cbohelp.insert_Mail(mail_id: Int(innerJson["ID"] as! String)!, who_id: innerJson["FROM_PA_ID"] as! String, who_name: innerJson["FROM_PA_NAME"] as! String,
                    date: innerJson["FWD_DATE"] as! String,
                    time: innerJson["FWD_TIME"] as! String,
                    is_read: innerJson["IS_READ"] as! String,
                    category: innerJson["MAIL_TYPE"] as! String,
                    type: innerJson["CC"] as! String,
                    subject: innerJson["SUBJECT"] as! String,
                    remark: innerJson["REMARK"] as! String,
                    file_name:  (innerJson["FILE_HEADING"] as! String).appending(",").appending( innerJson["FILE_HEADING2"] as! String ).appending(",").appending(innerJson["FILE_HEADING3"] as! String),
                    file_path: (innerJson["FILE_NAME"] as! String).appending(",").appending( innerJson["FILE_NAME2"] as! String ).appending(",").appending(innerJson["FILE_NAME3"] as! String))
            }
        }
        data=cbohelp.get_Mail(mail_category: mail_category, mail_id: "")
        inbox_Adaptor = InboxVC_Adaptor(vc: self, tableView: tableView, summaryData: data)
        tableView.isHidden = false
        tableView.reloadData()
    }
    
}
