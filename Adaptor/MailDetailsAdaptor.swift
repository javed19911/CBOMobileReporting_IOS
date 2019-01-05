//
//  MailDetailsAdaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 15/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class MailDetailsAdaptor : NSObject , UITableViewDelegate , UITableViewDataSource{
    
    private var vc  : CustomUIViewController!
    private var tableView : UITableView!
    private var data : [[String : AnyObject]]!
    
    init(vc : CustomUIViewController , tableView : UITableView , data : [[String : AnyObject]]  ) {
        super.init()
        self.vc = vc
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        self.data = data
        self.tableView = tableView
        print(data)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("InboxVC_Row", owner: self, options: nil)?.first as! InboxVC_Row
        cell.selectionStyle = .none
        cell.nameIcon.layer.cornerRadius = cell.nameIcon.frame.height / 2
        cell.lbl_FirstLatter.text = cell.lbl_From.text?.substringFrom(offSetTo: 0).uppercased()
        
        cell.lbl_To.text = data[indexPath.row]["TO_PA_NAME"] as? String
        cell.lbl_Date.text = data[indexPath.row]["FWD_DATE"] as? String
        cell.lbl_From.text = data[indexPath.row]["FROM_PA_NAME"] as? String
        cell.lbl_Msg.text = data[indexPath.row]["REPLY_REMARK"] as? String
        cell.attached.isHidden = true
        cell.lineView.isHidden = false
        cell.nameIcon.backgroundColor =  randomColor()
        cell.lbl_FirstLatter.text = (data[indexPath.row]["TO_PA_NAME"] as! String).substringFrom(offSetTo: 0).uppercased()
        return cell
        
        
    }
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
}
