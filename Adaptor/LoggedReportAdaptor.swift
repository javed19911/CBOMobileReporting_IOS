//
//  LoggedReportAdaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 07/08/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
class LoggedReportAdaptor : NSObject , UITableViewDelegate , UITableViewDataSource {
    
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
        let cell =  Bundle.main.loadNibNamed("LoggedReportRow", owner: self, options: nil)?.first as! LoggedReportRow
        
        cell.type.text = data[indexPath.row]["type"]
        cell.emp_name.text = data[indexPath.row]["name"]
        cell.emp_time.text = data[indexPath.row]["time"]
        cell.emp_act_area.text = data[indexPath.row]["rarea"]
        cell.emp_rpt_area.text = data[indexPath.row]["marea"]
       
        return cell
    }
}
