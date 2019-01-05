//
//  Work_with_ViewController.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Route_DialogViewController: CustomUIViewController, UITableViewDataSource , UITableViewDelegate{
    var progressHUD : ProgressHUD!
    var customVariablesAndMethod : Custom_Variables_And_Method! = nil
    var objRouteAdaptor : Route_Adaptor! = nil
    
    @IBOutlet weak var routeWithTableView: UITableView!
    var list = [DCR_Workwith_Model]()
    var sAllYn : String = ""
    var vc : CustomUIViewController!
    var msg : [String: String] = [:]
    var responseCode : Int!
    
    let INTERNET_MSG_WORK_WITH = 0
    
    let cbohelp: CBO_DB_Helper = CBO_DB_Helper.shared
    
     var mr_id1 = "0",mr_id2 = "0" ,mr_id3 = "0";
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        var ReplyMsg = [String : String]()
        
        ReplyMsg["route_name"]  = objRouteAdaptor.name
        ReplyMsg["route_id"] = objRouteAdaptor.id
        
        self.dismiss(animated: true, completion: nil)
        vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
        
    }
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = ProgressHUD(vc : self)
        routeWithTableView.dataSource = self
        routeWithTableView.delegate = self
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        //self.workWithTableView.register(WorkWithRow.self, forCellReuseIdentifier: "cell")
        myTopView.backButton.addTarget(self, action: #selector(closeCurruntVC), for: .touchUpInside)
        myTopView.title.text = msg["header"]
        sAllYn = msg["sAllYn"]!
        
        self.routeWithTableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        
        Custom_Variables_And_Method.work_with_area_id="";
        
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["iMR_ID1"]  = mr_id1
        params["iMR_ID2"] = mr_id2
        params["iMR_ID3"]  = mr_id3
        params["iMR_ID4"] = "0"
        params["sWORKTYPE"]  = Custom_Variables_And_Method.work_val
        params["sDCR_DATE"] = Custom_Variables_And_Method.DCR_DATE_TO_SUBMIT
        params["sAllYn"]  = sAllYn
        
        let tables = [0]
        
        // avoid deadlocks by not using .main queue here
        progressHUD.show(text: "Please Wait...")
        
        CboServices().customMethodForAllServices(params: params, methodName: "DCRAREADDL_ROUTE_2", tables: tables, response_code: INTERNET_MSG_WORK_WITH, vc : self , multiTableResponse: false)
    
    }
    
    
    func setMrids(){
    
        var  selected_list = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self,key: "work_with_id",defaultValue: "").replacingOccurrences(of: "+", with: ",").split(separator: ",")
        
        let mr_size = selected_list.count
        if(mr_size == 1)
        {
            mr_id1 = String(selected_list[0])
            mr_id2 = "0";
            mr_id3 = "0";
        }
        else if(mr_size == 2)
        {
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3="0";
        }
        else if(mr_size > 2)
        {
            mr_id1 = String(selected_list[0])
            mr_id2 = String(selected_list[1])
            mr_id3 = String(selected_list[2])
        }
    }
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]){
        parser_utilities(dataFromAPI : dataFromAPI)
        
    }
    
    private func parser_utilities(dataFromAPI : [String : NSArray])
    {
        if(!dataFromAPI.isEmpty){
            let jsonArray =   dataFromAPI["Tables0"]!
            
            list.removeAll()
            for i in 0 ..< jsonArray.count{
                let innerJson = jsonArray[i] as! [String : AnyObject]
                list.append( DCR_Workwith_Model (name: innerJson["ROUTE_NAME"] as! String,id: innerJson["DISTANCE_ID"] as! String))
            }
            objRouteAdaptor = Route_Adaptor(vc: self ,tableView : routeWithTableView,  list : list )
            routeWithTableView.reloadData()
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
        
        return objRouteAdaptor.getView(index: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

