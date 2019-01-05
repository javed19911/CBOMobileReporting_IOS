//
//  InboxVC_Adaptor.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 14/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
class InboxVC_Adaptor : NSObject , UITableViewDelegate , UITableViewDataSource{
    private var summaryData : [[String : String]]!
    private var tableView : UITableView!
    private var vc : CustomUIViewController!

    
    init(vc : CustomUIViewController , tableView : UITableView , summaryData : [[String : String]]) {
        super.init()
        self.vc = vc
        self.summaryData = summaryData
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("InboxVC_Row", owner: self, options: nil)?.first as! InboxVC_Row
        cell.selectionStyle = .none
        //print(summaryData[indexPath.row])
        cell.lbl_From.text = summaryData[indexPath.row]["from"]!
        cell.lbl_Msg.text = summaryData[indexPath.row]["REMARK"]!
        cell.lbl_To.text = summaryData[indexPath.row]["sub"]!
        cell.lbl_Date.text = summaryData[indexPath.row]["date"]!
        
        if summaryData[indexPath.row]["FILE_NAME"]! == ""{
            cell.attached.isHidden = true
        }
//        cell.lbl_To.text = summaryData[indexPath.row]
//
        cell.lbl_FirstLatter.text = summaryData[indexPath.row]["from"]!.substringFrom(offSetTo: 0).uppercased()
        cell.nameIcon.layer.cornerRadius = cell.nameIcon.frame.height / 2
        cell.nameIcon.backgroundColor = randomColor()
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(summaryData[indexPath.row])
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mailDetailsVC = storyboard.instantiateViewController(withIdentifier: "MailDetailsVC" ) as! MailDetailsVC
        mailDetailsVC.VCIntent["title"] = "Mail Details"
        mailDetailsVC.VCIntent["mail_id"] = summaryData[indexPath.row]["mail_id"]!
        mailDetailsVC.VCIntent["category"] = summaryData[indexPath.row]["category"]!

        mailDetailsVC.VCIntent["from"] = summaryData[indexPath.row]["from"]!
        
        vc.present(mailDetailsVC, animated: true, completion: nil)
        
    }
    
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
    }
    
    
}
