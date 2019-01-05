//
//  Work_with_ViewController.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Area_DialogViewController: CustomUIViewController, UITableViewDataSource , UITableViewDelegate {
    var customVariablesAndMethod : Custom_Variables_And_Method! = nil
    var objWorkWithAdaptor : Word_With_Adaptor!
    @IBOutlet weak var areaWithTableView: UITableView!
    var list = [DCR_Workwith_Model]()
    var data = [String]()
    var data1 = [String]()
    var data2 = [String]()
    var data3 = [String]()
    var selected_list = [String]()
    
    var sb : String=""
    var sb2 : String=""
    var sb3 : String=""
    var sb4 : String=""
    var dcrDAte : String = ""
    var vc : CustomUIViewController!
    var msg : [String: String] = [:]
    var responseCode : Int!
    var who : String = "DCR"
    var progressHUD : ProgressHUD!
    
    let INTERNET_MSG_ADDITIONAL_AREA = 1 , TO_INTERNET_MSG_ADDITIONAL_AREA = 2 , CC_INTERNET_MSG_ADDITIONAL_AREA = 3
    
    var mr_id1 = "0" ,mr_id2 = "0",mr_id3 = "0",mr_id4 = "0",mr_id5 = "0",mr_id6 = "0",mr_id7 = "0",mr_id8 = "0";
    
    let cbohelp: CBO_DB_Helper = CBO_DB_Helper.shared
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        for i in 0 ..< list.count {
            let  check = list[i].isSelected();
            if(check){
                data.append(list[i].getId())
                data1.append(list[i].getName())
            }
        }
        
        for i in 0 ..< data.count {
            sb = "\(sb)\(data[i]),"
            sb2 = "\(sb2)\(data1[i])+"
        }
        
        var ReplyMsg = [String : String]()
        
        ReplyMsg["area_id"]  = sb
        ReplyMsg["area_name"] = sb2
        
        if who == "DCR"{
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc : self ,key : "area_name" , value : sb2)
            customVariablesAndMethod.setDataInTo_FMCG_PREFRENCE(vc :  self , key : "area_id", value: sb)
        }
        self.dismiss(animated: true, completion: nil)
        vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
        
    }
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        
        areaWithTableView.separatorStyle = .none
        progressHUD = ProgressHUD(vc : self)
        self.areaWithTableView.rowHeight = UITableViewAutomaticDimension
        
        areaWithTableView.dataSource = self
        areaWithTableView.delegate = self
        //self.workWithTableView.register(WorkWithRow.self, forCellReuseIdentifier: "cell")
        myTopView.backButton.addTarget(self, action: #selector(closeCurruntVC), for: .touchUpInside)
        myTopView.title.text = msg["header"]
        
        if who == "DCR"{
            let sAllYn = msg["sAllYn"]!
            
            Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "DCR_DATE",defaultValue: "");
            
            setMrids();
            
            selected_list = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "area_name",defaultValue: "").replacingOccurrences(of: "+", with: ",").components(separatedBy: ",")   //.split(separator: ",")
            
            //selected_list = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "work_with_id",defaultValue: "").replacingOccurrences(of: "+", with: ",").split(separator: ",")
            
            
            
            //Start of call to service
            
            var params = [String:String]()
            params["sCompanyFolder"]  = cbohelp.getCompanyCode()
            params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
            params["iMR_ID1"] = mr_id1
            params["iMR_ID2"]  = mr_id2
            params["iMR_ID3"] = mr_id3
            params["iMR_ID4"]  = mr_id4
            params["iMR_ID5"] = mr_id5
            params["iMR_ID6"]  = mr_id6
            params["iMR_ID7"]  = mr_id7
            params["iMR_ID8"]  = mr_id8
            params["sWorkType"] = Custom_Variables_And_Method.work_val
            params["sDcrDate"] = Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT
            params["iDivertYn"] = sAllYn
            
            
            
            let tables = [0]
            // avoid deadlocks by not using .main queue here
            progressHUD.show(text: "Please Wait..." )
            
            CboServices().customMethodForAllServices(params: params, methodName: "DCRAREADDL_2", tables: tables, response_code: INTERNET_MSG_ADDITIONAL_AREA, vc : self )
            
            //End of call to service
            Custom_Variables_And_Method.work_with_area_id="";
        }else if who == "MAIL"{
            progressHUD.show(text: "Please Wait..." )
            var params = [String : String]()
            params["sCompanyFolder"] = cbohelp.getCompanyCode()
            params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
             let tables = [0]
            CboServices().customMethodForAllServices(params: params, methodName: "MAILTODDL", tables: tables, response_code: TO_INTERNET_MSG_ADDITIONAL_AREA, vc: self, multiTableResponse: false)
            
            
        }
        
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        switch response_code {
            
        case INTERNET_MSG_ADDITIONAL_AREA:
            parser_utilities(dataFromAPI : dataFromAPI)
            break
            
        case TO_INTERNET_MSG_ADDITIONAL_AREA :
            parser_utilities2(dataFromAPI: dataFromAPI)
            break
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
           
            print("Error")
        }
         progressHUD.dismiss()
    }
    
    private func parser_utilities2(dataFromAPI : [String : NSArray]){
        if(!dataFromAPI.isEmpty){
            let jsonArray =   dataFromAPI["Tables0"]!
            list.removeAll()
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                list.append( DCR_Workwith_Model (name: innerJson["PA_NAME"] as! String,id: "\(innerJson["PA_ID"] as! String)"))
                
            }
            
            
            objWorkWithAdaptor = Word_With_Adaptor(vc: self , tableView: areaWithTableView, list : list,selected_list: selected_list)
            areaWithTableView.reloadData()
        
        }
    }
    
    private func parser_utilities(dataFromAPI : [String : NSArray])
    {
       
        if(!dataFromAPI.isEmpty){
            let jsonArray =   dataFromAPI["Tables0"]!
            list.removeAll()
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                list.append( DCR_Workwith_Model (name: innerJson["AREA"] as! String,id: "\(i)"))
                
            }
            
            
            objWorkWithAdaptor = Word_With_Adaptor(vc: self , tableView: areaWithTableView, list : list,selected_list: selected_list)
            areaWithTableView.reloadData()
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
    
    
    func setMrids(){
        var selected_list = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "work_with_id",defaultValue: "").replacingOccurrences(of: "+", with: ",").split(separator: ",")
        
    let mr_size = selected_list.count
    //int mr_size=getMrId().size();
        if(mr_size == 1){
            mr_id1 = String(selected_list[0])
            mr_id2 = "0";
            mr_id3 = "0";
            mr_id4 = "0";
            mr_id5 = "0";
            mr_id6 = "0";
            mr_id7 = "0";
            mr_id8 = "0";
        }else if(mr_size == 2){
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3 = "0";
            mr_id4 = "0";
            mr_id5 = "0";
            mr_id6 = "0";
            mr_id7 = "0";
            mr_id8 = "0";
        }else if(mr_size==3){
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3 = String(selected_list[2])
            mr_id4 = "0";
            mr_id5 = "0";
            mr_id6 = "0";
            mr_id7 = "0";
            mr_id8 = "0";
        }else if(mr_size==4){
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3 = String(selected_list[2])
            mr_id4 = String(selected_list[3])
            mr_id5 = "0";
            mr_id6 = "0";
            mr_id7 = "0";
            mr_id8 = "0";
        }else if(mr_size==5){
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3 = String(selected_list[2])
            mr_id4 = String(selected_list[3])
            mr_id5 = String(selected_list[4])
            mr_id6 = "0";
            mr_id7 = "0";
            mr_id8 = "0";
        }else if(mr_size==6){
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3 = String(selected_list[2])
            mr_id4 = String(selected_list[3])
            mr_id5 = String(selected_list[4])
            mr_id6 = String(selected_list[5])
            mr_id7 = "0";
            mr_id8 = "0";
        }else if(mr_size==7){
                mr_id1 = String(selected_list[0])
                mr_id2 = String(selected_list[1])
                mr_id3 = String(selected_list[2])
                mr_id4 = String(selected_list[3])
                mr_id5 = String(selected_list[4])
                mr_id6 = String(selected_list[5])
                mr_id7 = String(selected_list[6])
            mr_id8 = "0";
        }else if(mr_size>7){
                mr_id1 = String(selected_list[0])
                mr_id2 = String(selected_list[1])
                mr_id3 = String(selected_list[2])
                mr_id4 = String(selected_list[3])
                mr_id5 = String(selected_list[4])
                mr_id6 = String(selected_list[5])
                mr_id7 = String(selected_list[6])
            mr_id8 = String(selected_list[7])
        }
    }

    
}

