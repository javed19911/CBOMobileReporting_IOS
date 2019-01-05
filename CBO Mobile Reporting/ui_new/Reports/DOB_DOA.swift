//
//  DOP_Anniversary.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 09/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class DOB_DOA: CustomUIViewController {

    @IBOutlet weak var myTopView: TopViewOfApplication!
    var DOB_DOA_Adaptor  : DOB_AnniversaryAdaptor!
    @IBOutlet weak var to_DatePicker: CustomDatePicker!
    @IBOutlet weak var from_DatePicker: CustomDatePicker!
    @IBOutlet weak var view_From: UIView!
    @IBOutlet weak var view_To: UIView!
    
    @IBOutlet weak var midView: UIView!
    
    @IBOutlet weak var btn_Go: CustomeUIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    var cbohelp : CBO_DB_Helper  = CBO_DB_Helper.shared
    var progressHUD :  ProgressHUD!
    let MESSAGE_INTERNET=2
    var context : CustomUIViewController!
    
    
    var summary_list = [[String : [[String : String]]]]()
    var data1 = [[String : String]]()
    var data2 = [[String : String]]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        
        context = self
        progressHUD = ProgressHUD(vc : self )
        
        
        from_DatePicker.headerTitle = customVariablesAndMethod1.currentDate(dateFormat: "dd/MM/yyyy")
        to_DatePicker.headerTitle = customVariablesAndMethod1.currentDate(dateFormat: "dd/MM/yyyy")
        
       
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
       btn_Go.addTarget(self, action: #selector(OnGoBtnClicked), for: .touchUpInside)
        
        setBorderToView(view: view_From)
        setBorderToView(view: view_To)
        from_DatePicker.setVC(vc: self)
        to_DatePicker.setVC(vc: self)
        
        midView.layer.masksToBounds = false
        midView.layer.shadowOffset = CGSize(width: 0, height: 1)
        midView.layer.shadowOpacity = 0.5
        
        update_page()
        
       
        
    }
    
    @objc func OnGoBtnClicked(){
        let T_date = to_DatePicker.getDate()
        let F_date = from_DatePicker.getDate()
        
        if(T_date.compare(F_date) == .orderedDescending ){
            update_page()
        }else{
            customVariablesAndMethod1.msgBox(vc: context,msg: "From_date can't be greater than To_date");
        }
    }
    
      func update_page() {
        
        //Start of call to service
        
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["sFdate"] = from_DatePicker.getDate(dateFormat: "MM/dd/yyyy")
        params["sTdate"] = to_DatePicker.getDate(dateFormat: "MM/dd/yyyy")
        
        var tables =  [Int]()
        tables.append(0)
        tables.append(1)
        
        progressHUD.show(text: "Please Wait.. \n Fetching data")
       
        
        CboServices().customMethodForAllServices(params: params, methodName: "DOB_DOA_List", tables: tables, response_code: MESSAGE_INTERNET, vc : context)
        
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
                data1.removeAll()
                data2.removeAll()
                
                let jsonArray =   dataFromAPI["Tables0"]!
                
                for i in 0 ..< jsonArray.count{
                    let jasonObj1 = jsonArray[i] as! [String : AnyObject]
                    var datanum1 = [String : String]()
                    datanum1["PA_NAME"] = try jasonObj1.getString(key: "PA_NAME") as? String
                    datanum1["DOB"] = try jasonObj1.getString(key: "DOB") as? String
                    datanum1["DOA"] = try jasonObj1.getString(key: "DOA") as? String
                    datanum1["MOBILE"] = try jasonObj1.getString(key: "MOBILE") as? String
                    data1.append(datanum1)
                    
                }
                
                
                let jsonArray1 =   dataFromAPI["Tables1"]!
                
                for i in 0 ..< jsonArray1.count{
                    let jasonObj1 = jsonArray1[i] as! [String : AnyObject]
                    var datanum1 = [String : String]()
                    datanum1["PA_NAME"] = try jasonObj1.getString(key: "DR_NAME") as? String
                    datanum1["DOB"] = try jasonObj1.getString(key: "DOB") as? String
                    datanum1["DOA"] = try jasonObj1.getString(key: "DOA") as? String
                    datanum1["MOBILE"] = try jasonObj1.getString(key: "MOBILE") as? String
                    data2.append(datanum1)
                    
                }
                
                summary_list.removeAll()
                summary_list.append(["Employees" : data1]);
                summary_list.append(["Doctors": data2]);
                var headers = [String]()
                
                for header in summary_list{
                    for header1 in  header{
                        headers.append(header1.key)
                    }
                }
                  DOB_DOA_Adaptor = DOB_AnniversaryAdaptor(tableView: tableview, vc: context , summaryData: summary_list, headers: headers)
               tableview.reloadData()
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

    private func setBorderToView(view : UIView){
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = AppColorClass.logo_green?.cgColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
    }

}
