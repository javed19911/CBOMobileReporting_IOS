//
//  Work_with_ViewController.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import SQLite
class Work_with_ViewController: CustomUIViewController, UITableViewDataSource , UITableViewDelegate,CustomTextViewDelegate{
    func onTextChangeListner(sender: CustomTextView, text: String) {
        let tag = sender.getTag() as! Int
        switch tag {
        case Search_tag:
            searchInList(search: text)
            break
            
        default:
            print ("no tag assigned")
        }
    }
    
    var progressHUD : ProgressHUD!
    var customVariablesAndMethod : Custom_Variables_And_Method! = nil
    var objWorkWithAdaptor : Word_With_Adaptor! = nil
    @IBOutlet weak var workWithTableView: UITableView!
    
    @IBOutlet weak var filter: CustomTextView!
    @IBOutlet weak var header: UIView!
    
    var list = [DCR_Workwith_Model]()
    var data = [String]()
    var data1 = [String]()
    var data2 = [String]()
    var data3 = [String]()
    
    var selected_list = [String]()
    var independent_list = [String]()
    
    var sb : String=""
    var sb2 : String=""
    var sb3 : String=""
    var sb4 : String=""
    var dcrDAte : String = ""
    var vc : CustomUIViewController!
    var msg : [String: String] = [:]
    var responseCode : Int!
    
    let INTERNET_MSG_WORK_WITH = 0
    let Search_tag = 1;
    
    let cbohelp: CBO_DB_Helper = CBO_DB_Helper.shared
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        cbohelp.deleteDRWorkWith()
        for i in 0 ..< list.count {
            
            let  check = list[i].isSelected();
            let check1 = list[i].isindependentSelected();
            if(check){
                data.append(list[i].getId())
                data1.append(list[i].getName())

            }else if(check1){
                data2.append(list[i].getId())
                data3.append(list[i].getName())
            }
        }
     
        for i in 0 ..< data.count {
         sb = "\(sb)\(data[i]),"
            sb2 = "\(sb2)\(data1[i]),"
            cbohelp.insertDrWorkWith(wwname: data1[i], wwid: data[i])
        }
        for i in 0 ..< data2.count {
            sb = "\(sb)\(data2[i]),"   //id
            sb2 = "\(sb2)\(data3[i])," //name
            
            sb3 = "\(sb3)\(data3[i]),"  //name
            sb4 = "\(sb4)\(data2[i])," //id
        }
        
            var ReplyMsg = [String : String]()
        
            ReplyMsg["workwith_id"]  = sb
            ReplyMsg["workwith_name"] = sb2
            ReplyMsg["work_with_individual_name"] = sb3
            ReplyMsg["work_with_individual_id"] = sb4
    
        if (dcrDAte != "1") {
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : self ,key : "work_with_name" , value : sb2)
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : self , key : "work_with_individual_name", value: sb3)
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc :  self , key : "work_with_id", value: sb)
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : self ,key :"work_with_individual_id",value:  sb4)

        }
        self.dismiss(animated: true, completion: nil)
        vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
        
    }
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = ProgressHUD(vc : self)
         customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        self.workWithTableView.rowHeight = UITableViewAutomaticDimension
        
            workWithTableView.dataSource = self
            workWithTableView.delegate = self
        //self.workWithTableView.register(WorkWithRow.self, forCellReuseIdentifier: "cell")
        myTopView.backButton.addTarget(self, action: #selector(closeCurruntVC), for: .touchUpInside)
        myTopView.title.text = msg["header"]
        dcrDAte = msg["sDCR_DATE"]!
        
        header.isHidden = true
        filter.delegate = self
        filter.setTag(tag: Search_tag)
        filter.setHint(placeholder: "Enter Name to Search..")
        
        
        if (dcrDAte != "1") {
            
            if (Custom_Variables_And_Method.pub_desig_id != ("1")) {
                header.isHidden = false
            }
        
            selected_list = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "work_with_name",defaultValue: "").replacingOccurrences(of: "+", with: ",").components(separatedBy: ",")   //.split(separator: ",")
        
             independent_list = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "work_with_individual_name",defaultValue: "").replacingOccurrences(of: "+", with: ",").components(separatedBy: ",")
            
            let a = independent_list.count
            print(a," ", type(of: independent_list))
            //MARK:- hit service
            
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
            params["sDCR_DATE"]  = dcrDAte
            params["sAREA1"] = ""
            params["sAREA2"]  = ""
            params["sAREA3"] = ""
            params["sAREA4"]  = ""
            params["sAREA5"] = ""
            params["sAREA6"]  = ""
            params["iDIVERTWWYN"] = msg["DIVERTWWYN"]!
            params["sWorking_Type"]  = msg["sWorking_Type"]!
            
            
            let tables = [0]
            // avoid deadlocks by not using .main queue here
           
            progressHUD.show(text: "Please Wait..." )
           
            


            CboServices().customMethodForAllServices(params: params, methodName: "WORKWITH_2", tables: tables, response_code: INTERNET_MSG_WORK_WITH, vc : self , multiTableResponse: false)
           
            
            // end of service call
        }else{
            
            if( msg["DAIRY_ID"] == nil){
                do {
                let statement = try cbohelp.getDR_Workwith();
                    while let c = statement.next() {
                       try list.append( DCR_Workwith_Model(name: c[cbohelp.getColumnIndex(statement : statement, Coloumn_Name: "workwith")]! as! String,id: c[cbohelp.getColumnIndex(statement : statement, Coloumn_Name:"wwid")]! as! String));
                    }
                    
                    objWorkWithAdaptor = Word_With_Adaptor(vc: self ,  tableView: workWithTableView, list : list )
                    
                }catch{
                    print (error)
                }
            
            }else{
                do {
                    let statement = try cbohelp.get_phdairy_person(DAIRY_ID: msg["DAIRY_ID"]!);
                    while let c = statement.next() {
                        try list.append( DCR_Workwith_Model(name: c[cbohelp.getColumnIndex(statement : statement, Coloumn_Name: "PERSON_NAME")]! as! String,id: "\(c[cbohelp.getColumnIndex(statement : statement, Coloumn_Name:"PERSON_ID")]!)"));
                    }
                    
                    objWorkWithAdaptor = Word_With_Adaptor(vc: self ,  tableView: workWithTableView, list : list )
                    
                }catch{
                    print (error)
                }
            }
            
        
        }
                
        
        
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        switch response_code {
        case INTERNET_MSG_WORK_WITH:
            parser_utilities(dataFromAPI : dataFromAPI)
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
        progressHUD.dismiss()
    }
    
    
    
    private func parser_utilities(dataFromAPI : [String : NSArray])
    {
        if(!dataFromAPI.isEmpty){
            let jsonArray =   dataFromAPI["Tables0"]!
            list.removeAll()
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                list.insert( DCR_Workwith_Model (name: innerJson["PA_NAME"] as! String,id: innerJson["PA_ID"] as! String, ResigYN: innerJson["RESIGYN"] as! String, LeaveYN: innerJson["LEAVEYN"] as! String,
                                                 WorkWithYN: msg["PlanType"] == ("p") ? innerJson["WORKWITHYN"] as! String : "0" ), at: i)
              
            }
            objWorkWithAdaptor = Word_With_Adaptor(vc: self ,  list : list, tableView: workWithTableView,selected_list: selected_list ,independent_list: independent_list)
            workWithTableView.reloadData()
            progressHUD.dismiss()
        }
    }
    
    @objc func closeCurruntVC(){
        myTopView.CloseCurruntVC(vc: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return objWorkWithAdaptor.getView( index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func searchInList(search : String){
        
        for l in 0 ..< list.count {
            if (search != "" && search.count <= list[l].getName().count) {
                if (list[l].getName().lowercased().contains(search.lowercased())) {
                    //mydr_List.smoothScrollToPosition(l);
                    let indexPath = IndexPath(row: l, section: 0)
                    workWithTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    
                    break;
                }
            }
        }
        workWithTableView.reloadData()
    }
    
}
