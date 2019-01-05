//
//  DashboardReport.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 06/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
class DashboardReport : CustomUIViewController {
    
    @IBOutlet var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var backbtn: CustomeUIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var previousbtn: UIButton!
    @IBOutlet weak var nextbtn: UIButton!
    var month = 0
    
    @IBOutlet weak var monthTxt: UILabel!
    
    var cbohelp : CBO_DB_Helper  = CBO_DB_Helper.shared
    var progressHUD :  ProgressHUD!
    let MESSAGE_INTERNET_Dash=2
    var dashboardAdapter : ExpandableDashboardAdapter!
    var context : CustomUIViewController!
    var customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
    
    
    var summary_list = [[String : [[String : String]]]]()
    var data1 = [[String : String]]()
    var data2 = [[String : String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if VCIntent["title"] != nil{
            myTopView.setText(title: VCIntent["title"]!)
        }
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
       
        context = self
        progressHUD = ProgressHUD(vc : self )
     
        backbtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        previousbtn.addTarget(self, action: #selector(onClickLeftButton), for: .touchUpInside)
        nextbtn.addTarget(self, action: #selector(onClickRightButton), for: .touchUpInside)
        
        update_page()

    }

    func update_page() {
        switch (getDate(date_format: "MM")){
            case "04":
                previousbtn.isHidden = true
                nextbtn.isHidden = false
            break;
            case "03":
                previousbtn.isHidden = false
                nextbtn.isHidden = true
            break;
            default:
                previousbtn.isHidden = false
                nextbtn.isHidden = false
        }
    
        if (month>=0){
            month=0;
            nextbtn.isHidden = true
        }else{
            nextbtn.isHidden = false
        }
    
        monthTxt.text = (getDate(date_format: "MMM-yyyy"))
        
        //Start of call to service
        
        let methodName = "DashBoardFinal_1"
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["sMONTH"] = getDate(date_format: "MM/dd/yyyy")
        
        var tables =  [Int]()
        tables.append(0)
        tables.append(1)
        // avoid deadlocks by not using .main queue here
        
        
        progressHUD.show(text: "Please Wait.. \n Fetching data")
        
        
        CboServices().customMethodForAllServices(params: params, methodName: methodName, tables: tables, response_code: MESSAGE_INTERNET_Dash, vc : self)

        //End of call to service
    
    }

    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case MESSAGE_INTERNET_Dash:
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
                    datanum1["REMARK"] = try jasonObj1.getString(key: "REMARK") as? String
                    datanum1["AMOUNT"] = try jasonObj1.getString(key: "AMOUNT") as? String
                    datanum1["AMOUNT_CUMM"] = try jasonObj1.getString(key: "AMOUNT_CUMM") as? String
                    data1.append(datanum1)
                
                }
                
                
                let jsonArray1 =   dataFromAPI["Tables1"]!
                
                for i in 0 ..< jsonArray1.count{
                    let jasonObj1 = jsonArray1[i] as! [String : AnyObject]
                    var datanum1 = [String : String]()
                    datanum1["REMARK"] = try jasonObj1.getString(key: "REMARK") as? String
                    datanum1["AMOUNT"] = try jasonObj1.getString(key: "AMOUNT") as? String
                    datanum1["AMOUNT_CUMM"] = try jasonObj1.getString(key: "AMOUNT_CUMM") as? String
                    data2.append(datanum1)
                    
                }
                
                summary_list.removeAll()
                summary_list.append(["Marketing" : data1]);
                summary_list.append(["Sales": data2]);
                var headers = [String]()
                var isCollaps = [Bool]()
                
                for header in summary_list{
                    for header1 in  header{
                        headers.append(header1.key)
                        isCollaps.append(true)
                    }
                }
                
                dashboardAdapter = ExpandableDashboardAdapter(tableView: tableView, vc: self, summaryData: summary_list, headers: headers, isCollaps: isCollaps,month: getDate(date_format: "MMM"))
                tableView.reloadData()
            }catch{
                customVariablesAndMethod.getAlert(vc: context, title: "Missing field error", msg: error.localizedDescription)
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )", vc: context)
                objBroadcastErrorMail.requestAuthorization()
            }
            progressHUD.dismiss()
        
        }
    }

    func getDate( date_format : String) -> String{
        var date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = date_format //"MM/dd/yyyy"
        var dateComponent = DateComponents()
        dateComponent.month = month
        date = Calendar.current.date(byAdding: dateComponent, to: date)!
        let currentDate = dateFormatter.string(from: date)
        return currentDate;
    }
    
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    @objc func onClickLeftButton(){
        month -= 1
        update_page();
    }
    
    
    @objc func onClickRightButton(){
        month += 1
        update_page();
    }
    
    
}
