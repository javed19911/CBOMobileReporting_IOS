//
//  SPO_ReportHeadquaterWiseAdapter.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 08/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
class SpoRptAdapter : NSObject , UITableViewDelegate , UITableViewDataSource{
    var tableView : UITableView!
    var context : CustomUIViewController!
    var dataList = [SpoModel]()
    var clickCount  = 0;
    
    init(tableView : UITableView , vc : CustomUIViewController ,dataList :  [SpoModel], clickCount : Int) {
        super.init()
        self.tableView = tableView
        self.context = vc
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.dataList = dataList
        self.clickCount = clickCount
        
        let headerNib = UINib.init(nibName: "SPO_ReportHeader", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SPO_ReportHeader")
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SPO_ReportRow", owner: self, options: nil)?.first as! SPO_ReportRow
        cell.selectionStyle = .none

        let position = indexPath.row
        cell.consignee.setTitle(dataList[position].getConsignee(), for: .normal)
        cell.salAmt.text = (dataList[position].getSalAmt());
        cell.salReturn.text = (dataList[position].getSaleReturn());
        cell.breakage_Exp.text = (dataList[position].getBreageExpiry());
        cell.creaditNt_Other.text = (dataList[position].getCreditNotOrther());
        cell.netSales.text = (dataList[position].getNetSales());
        cell.secSales.text = (dataList[position].getSecSales());
        cell.recipt.text = (dataList[position].getRecipt());
        cell.outStnding.text = (dataList[position].getOutStanding());
    
        cell.stkAmt.setTitle(dataList[position].getStockAmt(), for: .normal)
    
        cell.stkAmt.addTarget(self, action: #selector(OnstkAmtClick), for: .touchUpInside)
        cell.consignee.addTarget(self, action: #selector(OnconsigneeClick), for: .touchUpInside)
        cell.stkAmt.tag = indexPath.row
        cell.consignee.tag = indexPath.row
        
        return cell
    }
 
    @objc func OnconsigneeClick(sender : CustomeUIButton){
        
        let position = sender.tag
        let spoIdFromList = dataList[position].getId();

        if(clickCount < 3){
            clickCount += 1;
        }

//        if(context.clickCount==2){
//            Title="SPO Stockist Wise Report";
//            cnftxt="Stockist";
//            rpt_typ="P";
//        }else if(SpoRptAdapter.clickCount==3){
//            Title="SPO Bill Wise Report";
//            cnftxt="Bill";
//            rpt_typ="B";
//        }
//
        if (clickCount == 1){
            if (spoIdFromList != ("0")) {
               
                
                let vc = context.storyboard?.instantiateViewController(withIdentifier: "SpoRptGrid" ) as! SpoRptGrid
                vc.VCIntent["title"] = "SPO Hedquarter Wise Report"
                vc.VCIntent["uid"] = ""
                vc.VCIntent["mIdFrom"] = context.VCIntent["mIdFrom"]
                vc.VCIntent["mIdTo"] = context.VCIntent["mIdTo"]
                vc.VCIntent["spoId"] = spoIdFromList
                vc.VCIntent["clickCount"] = "\(clickCount)"
                vc.VCIntent["rpt_typ"] = "h"
                context.present(vc, animated: true, completion: nil)
                
               // vc.customVariablesAndMethod1.msgBox(vc: vc,msg: "\(SpoRptAdapter.clickCount)");
            }
            else {
                context.customVariablesAndMethod1.msgBox(vc: context,msg: dataList[position].getConsignee());
            }

        }else if (clickCount == 2){
            if (spoIdFromList != ("0")) {
                
                
                let vc = context.storyboard?.instantiateViewController(withIdentifier: "SpoRptGrid" ) as! SpoRptGrid
                vc.VCIntent["title"] = "SPO Stockist Wise Report"
                vc.VCIntent["uid"] = ""
                vc.VCIntent["mIdFrom"] = context.VCIntent["mIdFrom"]
                vc.VCIntent["mIdTo"] = context.VCIntent["mIdTo"]
                vc.VCIntent["spoId"] = spoIdFromList
                vc.VCIntent["clickCount"] = "\(clickCount)"
                vc.VCIntent["rpt_typ"] = "P"
                context.present(vc, animated: true, completion: nil)
                
                // vc.customVariablesAndMethod1.msgBox(vc: vc,msg: "\(SpoRptAdapter.clickCount)");
            }
            else {
                context.customVariablesAndMethod1.msgBox(vc: context,msg: dataList[position].getConsignee());
            }
            
        }else if (clickCount == 3){
            if (spoIdFromList != ("0")) {
                
                
                let vc = context.storyboard?.instantiateViewController(withIdentifier: "SpoRptGrid" ) as! SpoRptGrid
                vc.VCIntent["title"] = "SPO Bill Wise Report"
                vc.VCIntent["uid"] = ""
                vc.VCIntent["mIdFrom"] = context.VCIntent["mIdFrom"]
                vc.VCIntent["mIdTo"] = context.VCIntent["mIdTo"]
                vc.VCIntent["spoId"] = spoIdFromList
                vc.VCIntent["clickCount"] = "\(clickCount)"
                vc.VCIntent["rpt_typ"] = "B"
                context.present(vc, animated: true, completion: nil)
                
                // vc.customVariablesAndMethod1.msgBox(vc: vc,msg: "\(SpoRptAdapter.clickCount)");
            }
            else {
                context.customVariablesAndMethod1.msgBox(vc: context,msg: dataList[position].getConsignee());
            }
            
        }
        else{
            if (spoIdFromList != ("0")) {
//                Intent spoDistributorsWise = new Intent(context, SpoDistributorsWise.class);
//                spoDistributorsWise.putExtra("spoId", spoIdFromList);
//
//                v.getContext().startActivity(spoDistributorsWise);
                context.customVariablesAndMethod1.msgBox(vc: context,msg: "\(clickCount)");
            }
            else {
                context.customVariablesAndMethod1.msgBox(vc: context,msg: dataList[position].getConsignee());
            }

        }
    }
    
    @objc func OnstkAmtClick(sender : CustomeUIButton){
        
//        if rptData[sender.tag].getTtldr() == "0"{
//            customVariablesAndMethod.getAlert(vc: vc, title: "", msg: "No Doctor in the list")
//        }else {
//            // let tables = [0]
//
//
//            let drCallVC = storyBoard.instantiateViewController(withIdentifier: "DoctorView") as! DoctorView
//
//            drCallVC.VCIntent["date"] =  rptData[sender.tag].getDate()
//            drCallVC.VCIntent["call_type"] =  "D"
//            drCallVC.VCIntent["Title"] =  cbohelp.getMenu(menu: "DCR", code: "D_DRCALL")[0]["menu_name"]
//
//            vc.present(drCallVC, animated: true, completion: nil)
//        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SPO_ReportHeader") as! SPO_ReportHeader
        
        headerView.headerView.backgroundColor = .white
        return headerView
    }
    
    
}
