//
//  LoggedUnloggedReport.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 07/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class LoggedUnloggedReport: CustomUIViewController , CheckBoxDelegate{
    
    private var isCheck =  false
    var emp_id = "";
    func onChackedChangeListner(sender: CheckBox, ischecked: Bool) {
        isCheck = ischecked
    }
    
    
    private var titleText = ""
    @IBOutlet weak var Show: CustomeUIButton!
    @IBOutlet weak var back: CustomeUIButton!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var statusDp: DropDownMenuWithLabel!
    @IBOutlet weak var employeeDp: DropDownMenuWithLabel!
    
    @IBOutlet weak var dateDilog: CustomDatePicker!
    @IBOutlet weak var timeDilog: CustomTimePicker!
    private var customVariablesAndMethod: Custom_Variables_And_Method!
    
    
    @IBOutlet weak var checkBoxStack: UIStackView!
    
    @IBOutlet weak var empStackView: UIStackView!
    
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var checkBok: CheckBox!
    let cbohelp = CBO_DB_Helper.shared
    var progressHUD :  ProgressHUD!
    var context : CustomUIViewController!
    let MESSAGE_INTERNET=2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        context = self
        progressHUD = ProgressHUD(vc : self )
        
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        back.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        
        statusDp.dropDownMenu.visibleItemCount = 6
        employeeDp.dropDownMenu.visibleItemCount = 6
       
        statusDp.dropDownMenu.headerTitle = "--Select--"
        employeeDp.dropDownMenu.headerTitle = "--Select--"
        
        statusDp.dropDownMenu.headerTextBoldFontSize = 16
        employeeDp.dropDownMenu.headerTextBoldFontSize = 16

        statusDp.dropDownMenu.items.append(DPItem(title:  "Logged"))
        statusDp.dropDownMenu.items.append(DPItem(title:  "UnLogged"))
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        Show.addTarget(self, action: #selector(onClickShow), for: .touchUpInside)
        
        dateDilog.setVC(vc: self)
        timeDilog.setVC(vc: self)

        GetEmployeeDetail()
        setUI()
    }
    
    private func setUI(){
        
        
        statusDp.dropDownMenu.didSelectedItemIndex = { index in
            self.statusDp.dropDownMenu.headerTitle = self.statusDp.dropDownMenu.items[index].title
            if self.statusDp.dropDownMenu.headerTitle.lowercased() == "unlogged"{
                self.empStackView.isHidden = true
                self.timeStackView.isHidden = true
                self.checkBoxStack.isHidden = true
                self.titleText = self.statusDp.dropDownMenu.headerTitle
                
            }else {
                self.empStackView.isHidden = false
                self.timeStackView.isHidden = false
                self.checkBoxStack.isHidden = false
                self.titleText = self.statusDp.dropDownMenu.headerTitle
            }
        }
        
        employeeDp.dropDownMenu.didSelectedItemIndex = { index in
            self.employeeDp.dropDownMenu.headerTitle = self.employeeDp.dropDownMenu.items[index].extra!
            self.emp_id = self.employeeDp.dropDownMenu.items[index].code!
        }
    }
    
    
    @objc func onClickShow(){
        
        if titleText == ""{
            customVariablesAndMethod.msgBox(vc: self, msg: "Select Status Please...")
        }else if titleText == "UnLogged" {
            unloggedReports()
        }else if  checkBok.isChecked(){
            myBriefReports()
        } else if titleText == "Logged" {
            myReports()
        }
        
    
    }
    
    
    func unloggedReports() {
        if dateDilog.getDateInString() == "DD-MM-YYYY" {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select Date Please...")
        }else {
    
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoggedUnloggedDetailsView") as! LoggedUnloggedDetailsView
            vc.VCIntent["title"] = titleText
            vc.VCIntent["sDATE"] = dateDilog.getDateInString()
            vc.VCIntent["time"] = ""
            vc.VCIntent["emp_id"] = ""
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func myBriefReports() {
        if employeeDp.dropDownMenu.headerTitle == "--Select--"  {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select employee Please...")
        }else if timeDilog.getTimeInString() == "HH.MM" {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select Time Please...")
        }else if dateDilog.getDateInString() == "DD-MM-YYYY" {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select Date Please...")
        }else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoggedUnloggedDetailsView") as! LoggedUnloggedDetailsView
            vc.VCIntent["title"] = titleText + "- Brief"
            vc.VCIntent["sDATE"] = dateDilog.getDateInString()
            vc.VCIntent["time"] = ""
            vc.VCIntent["emp_id"] = ""
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func myReports() {
        if employeeDp.dropDownMenu.headerTitle == "--Select--"  {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select employee Please...")
        }else if timeDilog.getTimeInString() == "HH.MM" {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select Time Please...")
        }else if dateDilog.getDateInString() == "DD-MM-YYYY" {
            customVariablesAndMethod.msgBox(vc: self, msg: "Select Date Please...")
        }else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoggedUnloggedDetailsView") as! LoggedUnloggedDetailsView
            vc.VCIntent["title"] = titleText
            vc.VCIntent["sDATE"] = dateDilog.getDateInString()
            vc.VCIntent["time"] = timeDilog.getTimeInString()
            vc.VCIntent["emp_id"] = emp_id
            self.present(vc, animated: true, completion: nil)
        }
    }

    
    func GetEmployeeDetail() {
        
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["iPRESENT"] = "0"
        
        var tables =  [Int]()
        tables.append(0)
        
        progressHUD.show(text: "Please Wait.. \n Fetching data")
        
        
        CboServices().customMethodForAllServices(params: params, methodName: "TEAMALL", tables: tables, response_code: MESSAGE_INTERNET, vc : context,multiTableResponse: false)
        
        //End of call to service
        
    }

    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case MESSAGE_INTERNET:
            parser_mail( dataFromAPI  : dataFromAPI)
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod1.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            progressHUD.dismiss()
            print("Error")
        }
    }
    
    
    public func parser_mail( dataFromAPI :[ String :NSArray]) {
        if (!dataFromAPI.isEmpty) {
            do{
                
                let jsonArray = dataFromAPI["Tables0"]!
                for i in 0 ..< jsonArray.count{
                    let jasonObj1 = jsonArray[i] as! [String : AnyObject]
                    employeeDp.dropDownMenu.items.append(DPItem(title: try jasonObj1.getString(key: "PA_NAME") as! String, extra: try jasonObj1.getString(key: "PA_ID") as! String))
                }
            
            }catch{
                customVariablesAndMethod1.getAlert(vc: context, title: "Missing field error", msg: error.localizedDescription)
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: context)
                objBroadcastErrorMail.requestAuthorization()
            }
            progressHUD.dismiss()
            
        }
    }
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }

}
