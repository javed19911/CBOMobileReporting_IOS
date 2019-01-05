//
//  Notification_Adaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 14/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
class Notification_Adaptor : NSObject, UITableViewDelegate , UITableViewDataSource{
    
    private var vc : CustomUIViewController!
    private var tableView : UITableView!
    private var notification = [String : [String]]()
    private var cboDbHelper : CBO_DB_Helper = CBO_DB_Helper.shared
    
    init(vc : CustomUIViewController , tableView : UITableView , notification : [String : [String]]){
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        self.tableView = tableView
        self.vc = vc
        self.notification = notification
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification["Title"]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NotificationRow", owner: self, options: nil)?.first as! NotificationRow
        cell.selectionStyle = .none
        
//        data["Title"] = Title
//        data["Des"] = des
//        data["Time"] = time
//        data["Date"] = date
//        data["Status"] = status
//        data["Logo_url"] = logo_url
//        data["Info_url"] = info_url
//        data["ID"] = id
        cell.lbl_Title.text = notification["Title"]![indexPath.row]
         cell.lbl_Date.text = notification["Date"]![indexPath.row]
         cell.lbl_Time.text = notification["Time"]![indexPath.row]
         cell.lbl_UserName.text = notification["Des"]![indexPath.row]
        
        if (notification["Status"]![indexPath.row] == ("1")){
            cell.backgroundColor = UIColor(hex: "FFFFFF");
        }else{
            cell.backgroundColor = UIColor(hex: "C0C0C0");
        }
        cell.btn_Delete.descriptiveName = notification["ID"]![indexPath.row]
        
        cell.btn_Delete.addTarget(self, action: #selector(pressedEditButton(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func pressedEditButton(sender : UIButton){
        
        //        print(sender.tag , sender.descriptiveName!)
       // delegate?.onEdit(id: "\(sender.tag)", name: sender.descriptiveName!)
        vc.customVariablesAndMethod1.getAlert(vc: vc,title:"Delete",msg: "Are you sure to delete?" , completion :  {_ in
            self.cboDbHelper.notificationDeletebyID(id: sender.descriptiveName!);
            self.notification = self.cboDbHelper.getNotificationMsg();
            self.tableView.reloadData()
        });
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationRow
        notification["Status"]![indexPath.row] = "1"
        cboDbHelper.updateNotificationStatus(id: notification["ID"]![indexPath.row] , status: "1");
        cell.backgroundColor = UIColor(hex: "C0C0C0");
        vc.customVariablesAndMethod1.getAlert(vc: vc,title: notification["Title"]![indexPath.row],msg: notification["Des"]![indexPath.row].replacingOccurrences(of: "^", with: "\n") , completion :  {_ in
           self.tableView.reloadData()
            if(!self.notification["Info_url"]![indexPath.row].isEmpty){
                self.vc.customVariablesAndMethod1.setDataForWebView(vcself: self.vc, mode: 0, title: self.notification["Title"]![indexPath.row], url: self.notification["Info_url"]![indexPath.row])
            }
        });
        
    }
    
}
