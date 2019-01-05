//
//  LoggedUnloggedAdaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 19/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
class LoggedBriefAdaptor : NSObject , UITableViewDelegate , UITableViewDataSource {
    
    private var tableView : UITableView!
    private var vc : CustomUIViewController!
    var data = [[String: String]]();
    
    init(vc: CustomUIViewController , tableView : UITableView,data : [[String: String]]) {
        super.init()
        self.vc = vc
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
        self.data = data;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  Bundle.main.loadNibNamed("comp_logged_rpt_view", owner: self, options: nil)?.first as! comp_logged_rpt_view
        
        cell.lbl_S_No.text = data[indexPath.row]["sno"]
        cell.lbl_Emp_Name.text = data[indexPath.row]["Emp_Name"]
        cell.lbl_Working_Type.text = data[indexPath.row]["WORKING_TYPE"]
        cell.lbl_Joining_Area.text = data[indexPath.row]["joining_area"]
        cell.lbl_Join_Time.text = data[indexPath.row]["join_time"]
        cell.lbl_Route_Number.text = data[indexPath.row]["route"]
        cell.lbl_Work_With.text = data[indexPath.row]["WORK_WITH"]
        cell.lbl_Head_Qtr.text = data[indexPath.row]["Head_Qtr"]
        cell.lbl_TP_Planned.text = data[indexPath.row]["TP_PLANE"]
        cell.lbl_Call_Timming.text = data[indexPath.row]["FIRST_CALL"]
        cell.lbl_Submit_Date.text = data[indexPath.row]["DCR_DATE"]
        cell.lbl_Calls.text = data[indexPath.row]["TOTAL_CALL"]
        
        
        return cell
    }
}
