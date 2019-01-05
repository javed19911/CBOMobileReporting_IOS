//
//  RptAdaptor.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 20/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class RptAdaptor : NSObject, UITableViewDataSource , UITableViewDelegate {
    

    var fmcgYn = ""
    
    private  var rptData = [RptModel]()
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var cbohelp = CBO_DB_Helper.shared
    
    var tableView : UITableView!
    var vc : CustomUIViewController!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    init(tableView : UITableView , vc : CustomUIViewController  , rptData : [RptModel]) {
        super.init()
    
        self.rptData = rptData
        self.vc = vc
        self.tableView = tableView
        tableView.rowHeight = UITableViewAutomaticDimension

        
        let headerNib = UINib.init(nibName: "DCR_Report_Row", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "DCR_Report_Row")
        
        tableView.separatorStyle = .none
        
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        fmcgYn = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: vc, key: "fmcg_value", defaultValue: "N")
            

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rptData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DCR_Report_Row", owner: self, options: nil)?.first as! DCR_Report_Row
        
        
        cell.selectionStyle = .none
        
        cell.date.text = rptData[indexPath.row].getDate()
        cell.workStation.text = rptData[indexPath.row].getWith()
        
        
        cell.totalDR.setText(text: rptData[indexPath.row].getTtldr())
        cell.totalDR.tag = indexPath.row
        cell.totalDR.addTarget(self, action: #selector(totalDR), for: .touchUpInside)
        
        
        cell.Dr_Reminder.setText(text: rptData[indexPath.row].getTtlDrRiminder())
        cell.Dr_Reminder.tag = indexPath.row
        cell.Dr_Reminder.addTarget(self, action: #selector(Dr_Reminder), for: .touchUpInside)
        
        
        cell.totalChemist.setText(text: rptData[indexPath.row].getTtlchm())
        cell.totalChemist.tag = indexPath.row
        cell.totalChemist.addTarget(self, action: #selector(totalChemist), for: .touchUpInside)
        
        
        cell.totalStockist.setText(text: rptData[indexPath.row].getTtlstk())
        cell.totalStockist.tag = indexPath.row
        cell.totalStockist.addTarget(self, action: #selector(totalStockist), for: .touchUpInside)
        
        
        cell.nonListedCall.setText(text: rptData[indexPath.row].getTtlNonDoctor())
        cell.nonListedCall.tag = indexPath.row
        cell.nonListedCall.addTarget(self, action: #selector(nonListedCall), for: .touchUpInside)
        
        
        cell.DAType.setText(text: rptData[indexPath.row].getTtlexp())
        cell.DAType.tag = indexPath.row
        cell.DAType.addTarget(self, action: #selector(DAType), for: .touchUpInside)
        
        
        cell.remark.text = rptData[indexPath.row].getRemark()
        
        if (fmcgYn == "Y"){
          //  holder.lLayoutDr.setVisibility(View.GONE);
            // holder.totalDr_text.setText("Total Retailer :");
        }
        
        if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: vc, key: "CHEMIST_NOT_REQUIRED", defaultValue: "Y") == "N") {

   
//            holder.totalDr_text.setText("Total " + cbohelp.getMenu("DCR", "D_CHEMCALL").get("D_CHEMCALL").split(" ")[0] + " :");
        }
        if(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc : vc , key :"Doctor_RC_NOT_REQUIRED" , defaultValue: "Y") == "N") {
//            holder.totalTenivia_text.setText(cbohelp.getMenu("DCR", "D_DR_RX").get("D_DR_RX"));
        }
        
        if (rptData[indexPath.row].getTtldr() == ""){
            cell.totalDRStackView.isHidden = true
           // holder.lLayoutDr.setVisibility(View.GONE);
        }else{
            cell.totalDRStackView.isHidden = false
            //holder.lLayoutDr.setVisibility(View.VISIBLE);
        }
        
        if (rptData[indexPath.row].getTtlstk() == ""){
            cell.totalStockistStackView.isHidden = true
            //holder.lLayoutSTK.setVisibility(View.GONE);
        }else{
              cell.totalStockistStackView.isHidden = false
           // holder.lLayoutSTK.setVisibility(View.VISIBLE);
        }
        
        if (rptData[indexPath.row].getTtlchm() == ""){
            cell.totalChemistStackView.isHidden = true
//            holder.chem.setVisibility(View.GONE);
        }else{
            cell.totalChemistStackView.isHidden = false
//            holder.chem.setVisibility(View.VISIBLE);
        }
        
        if ( rptData[indexPath.row].getTtlNonDoctor() == "0"){
            cell.nonListedCallStackView.isHidden = true
           // holder.lLayoutMissed_call.setVisibility(View.GONE);
        }else{
             cell.nonListedCallStackView.isHidden = false
         //   holder.lLayoutMissed_call.setVisibility(View.VISIBLE);
        }
        
        if (rptData[indexPath.row].getTtlDrRiminder() == "0"){
            cell.dr_ReminderStackView.isHidden = true
           // holder.lLayoutDeRiminder.setVisibility(View.GONE);
        }else{
            cell.dr_ReminderStackView.isHidden = false
            //holder.lLayoutDeRiminder.setVisibility(View.VISIBLE);
        }
        
//        if (rptData[indexPath.row].getTtlNonDoctor() == "0"){
//            holder.lLayoutDoctor.setVisibility(View.GONE);
//        }else{
//            holder.lLayoutDoctor.setVisibility(View.VISIBLE);
//        }

        return cell
        
    }
    func getParams(indexId : Int) -> [String : String]{

        var params = [String : String]()
        params["sCompanyFolder"] = cbohelp.getCompanyCode()
        params["iPaId"] = "\(Custom_Variables_And_Method.PA_ID)"
        params["sDCR_DATE"] = rptData[indexId].getDate()
       // params["sCALL_TYPE"] = "0"
    
        return params
        
    }
    
    
    @objc func totalDR(sender : CustomeUIButton){
        
        if rptData[sender.tag].getTtldr() == "0"{
            customVariablesAndMethod.getAlert(vc: vc, title: "", msg: "No Doctor in the list")
        }else {
          
            let drCallVC = storyBoard.instantiateViewController(withIdentifier: "DoctorView") as! DoctorView
           
            drCallVC.VCIntent["date"] =  rptData[sender.tag].getDate()
            drCallVC.VCIntent["call_type"] =  "D"
            drCallVC.VCIntent["pa_id"] =  vc.VCIntent["nameId"]!
            drCallVC.VCIntent["Title"] =  cbohelp.getMenu(menu: "DCR", code: "D_DRCALL")[0]["menu_name"]
      
            vc.present(drCallVC, animated: true, completion: nil)
        }

    }
    
    
    @objc func Dr_Reminder(sender : CustomeUIButton){
        
        if rptData[sender.tag].getTtlDrRiminder() == "0"{
             customVariablesAndMethod.getAlert(vc: vc, title: "", msg: "No Doctor in the lis")
        }else{
            let drCallVC = storyBoard.instantiateViewController(withIdentifier: "DoctorView") as! DoctorView
            
            drCallVC.VCIntent["date"] =  rptData[sender.tag].getDate()
            drCallVC.VCIntent["call_type"] =  "R"
            drCallVC.VCIntent["pa_id"] =  vc.VCIntent["nameId"]!
            drCallVC.VCIntent["Title"] =  cbohelp.getMenu(menu: "DCR", code: "D_RCCALL")[0]["menu_name"]
            
            vc.present(drCallVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func totalChemist(sender : CustomeUIButton){
      
        if rptData[sender.tag].getTtlchm() == "0"{
            customVariablesAndMethod.getAlert(vc: vc, title: "", msg: "No Chemist in the list")
        }else{
            let drCallVC = storyBoard.instantiateViewController(withIdentifier: "DoctorView") as! DoctorView
            
            drCallVC.VCIntent["date"] =  rptData[sender.tag].getDate()
            drCallVC.VCIntent["call_type"] =  "C"
            drCallVC.VCIntent["pa_id"] =  vc.VCIntent["nameId"]!
            drCallVC.VCIntent["Title"] =  cbohelp.getMenu(menu: "DCR", code: "D_CHEMCALL")[0]["menu_name"]
            
            vc.present(drCallVC, animated: true, completion: nil)
         
        }
//        print( rptData[sender.tag].getTtlchm() )
    }
    
    @objc func totalStockist(sender : CustomeUIButton){
        let tables = [0]
        if rptData[sender.tag].getTtlstk() == "0"{
             customVariablesAndMethod.getAlert(vc: vc, title: "", msg: "No Stokist in the list")
        }else{
            
            let drCallVC = storyBoard.instantiateViewController(withIdentifier: "DoctorView") as! DoctorView
            
            drCallVC.VCIntent["date"] =  rptData[sender.tag].getDate()
            drCallVC.VCIntent["call_type"] =  "S"
            drCallVC.VCIntent["pa_id"] =  vc.VCIntent["nameId"]!
            drCallVC.VCIntent["Title"] =  cbohelp.getMenu(menu: "DCR", code: "D_STK_CALL")[0]["menu_name"]
            
            vc.present(drCallVC, animated: true, completion: nil)
           
        }
    }
    
    @objc func nonListedCall(sender : CustomeUIButton){
        if rptData[sender.tag].getTtlNonDoctor() == "0"{
            customVariablesAndMethod.getAlert(vc: vc, title: "", msg: "No NonListed Call in the list")
        }else{
            
            let drCallVC = storyBoard.instantiateViewController(withIdentifier: "DoctorView") as! DoctorView
            
            drCallVC.VCIntent["date"] =  rptData[sender.tag].getDate()
            drCallVC.VCIntent["call_type"] =  "NLC"
            drCallVC.VCIntent["pa_id"] =  vc.VCIntent["nameId"]!
            drCallVC.VCIntent["Title"] =  cbohelp.getMenu(menu: "DCR", code: "D_NLC_CALL")[0]["menu_name"]
            
            vc.present(drCallVC, animated: true, completion: nil)
            
        }
    }
    
    @objc func DAType(sender : CustomeUIButton){
        print( rptData[sender.tag].getTtlexp() )
    }
    
}
