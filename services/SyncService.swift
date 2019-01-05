//
//  SyncService.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 12/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
import UIKit
class SyncService {
    
    let cbohelp : CBO_DB_Helper = CBO_DB_Helper.shared
    let customVariablesAndMethod : Custom_Variables_And_Method!
    var context : CustomUIViewController!
    
    init(context : CustomUIViewController) {
        self.context = context
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance();
        //cboFinalTask_new = new CBOFinalTask_New(context);
        cboFinalTask_new = CBOFinalTask_New(context: context)
    }

    
    private static  var MESSAGE_INTERNET_SYNC=1
    public  var ReplyYN="N"
    
    var cboFinalTask_new : CBOFinalTask_New!
    
    var dcr_latCommit = [String : String]()
    
    var  dcr_Commititem = [String : String]()
    var  dcr_Commit_rx = [String : String]()
    var  dcr_CommitDr = [String : String]()
    var  dcr_ChemistCommit = [String : String]()
    var  dcr_StkCommit = [String : String]()
    var  dcr_CommitDr_Reminder = [String : String]()
    var  Lat_Long_Reg = [String : String]()
    var  dcr_Dairy = [String : String]()
    
    
    
    var sb_DCRLATCOMMIT_KM = "", sb_DCRLATCOMMIT_LOC_LAT  = "", sb_sDCRLATCOMMIT_IN_TIME  = "", sDCRLATCOMMIT_ID  = "", sDCRLATCOMMIT_LOC  = ""
    var sDCRITEM_DR_ID  = "", sDCRITEM_ITEMIDIN = "", sDCRITEM_ITEM_ID_ARR = "", sDCRITEM_QTY_ARR = "", sDCRITEM_ITEM_ID_GIFT_ARR  = "",
    sDCRITEM_QTY_GIFT_ARR = "", sDCRITEM_POB_QTY = "",  sDCRITEM_POB_VALUE = "",  sDCRITEM_VISUAL_ARR = "",  sDCRITEM_NOC_ARR  = ""
    
    var sDCRDR_DR_ID = "",  sDCRDR_WW1 = "",  sDCRDR_WW2 = "",  sDCRDR_WW3 = "",  sDCRDR_LOC = "",  sDCRDR_IN_TIME = "",  sDCRDR_BATTERY_PERCENT = "",  sDCRDR_REMARK = "",  sDCRDR_KM = "",  sDCRDR_SRNO = "", sDCRDR_FILE = "", sDCRDR_CALLTYPE  = ""
    
    var sDCRCHEM_CHEM_ID = "",  sDCRCHEM_POB_QTY = "",  sDCRCHEM_POB_AMT = "",  sDCRCHEM_ITEM_ID_ARR = "",  sDCRCHEM_QTY_ARR = "",  sDCRCHEM_LOC = "",  sDCRCHEM_IN_TIME = "",  sDCRCHEM_SQTY_ARR = "",  sDCRCHEM_ITEM_ID_GIFT_ARR = "",  sDCRCHEM_QTY_GIFT_ARR = "",  sDCRCHEM_BATTERY_PERCENT = "",  sDCRCHEM_KM = "",  sDCRCHEM_SRNO = "", sDCRCHEM_REMARK = "", sDCRCHEM_FILE  = ""
    
    var sDCRSTK_STK_ID = "",  sDCRSTK_POB_QTY = "",  sDCRSTK_POB_AMT = "",  sDCRSTK_ITEM_ID_ARR = "",  sDCRSTK_QTY_ARR = "",  sDCRSTK_LOC = "",  sDCRSTK_IN_TIME = "",  sDCRSTK_SQTY_ARR = "",  sDCRSTK_ITEM_ID_GIFT_ARR = "",  sDCRSTK_QTY_GIFT_ARR = "",  sDCRSTK_BATTERY_PERCENT = "",  sDCRSTK_KM = "",  sDCRSTK_SRNO = "", sDCRSTK_REMARK = "", sDCRSTK_FILE  = ""
    
    var sDCRRC_IN_TIME = "",  sDCRRC_LOC = "",  sDCRRC_DR_ID = "",  sDCRRC_KM = "",  sDCRRC_SRNO = "", sDCRRC_BATTERY_PERCENT = "", sDCRRC_REMARK = "", sDCRRC_FILE  = ""
    
    var sDCR_DR_RX = "",  sDCR_ITM_RX  = "",  sFinalKm  = "",   DCS_ID_ARR = "",  LAT_LONG_ARR = "",  DCS_TYPE_ARR = "",  DCS_ADD_ARR = "",  DCS_INDES_ARR  = ""
    
    
    var sDAIRY_ID = "", sSTRDAIRY_CPID = "",sDCRDAIRY_LOC = "",sDCRDAIRY_IN_TIME = "",sDCRDAIRY_BATTERY_PERCENT = "",sDCRDAIRY_REMARK = "",sDCRDAIRY_KM = "",sDCRDAIRY_SRNO = "";
    var sDCRDAIRYITEM_DAIRY_ID = "",sDCRDAIRYITEM_ITEM_ID_ARR = "",sDCRDAIRYITEM_QTY_ARR = "",sDCRDAIRYITEM_ITEM_ID_GIFT_ARR = "",sDCRDAIRYITEM_QTY_GIFT_ARR = "";
    var sDCRDAIRYITEM_POB_QTY = "",sDAIRY_FILE = "",sDCRDAIRY_INTERSETEDYN = "";
    
    func  DCR_sync_all(responseCode : Int, ReplyYN : String? = "N"){
        
        do {
            self.ReplyYN = ReplyYN!
            let  IsGPRS_ON : Bool  = customVariablesAndMethod.internetConneted(context: context,ShowAlert: false )
            let fmcg_Live_Km : String = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "live_km" , defaultValue: "")
            
            
            
            if ((fmcg_Live_Km.uppercased() == ("5") || fmcg_Live_Km.uppercased() == ("Y5")) && IsGPRS_ON ){
                //MARK:- need
                //    customMethod.backgroundData();
                //    dcr_latCommit = customMethod.dataToServer("0");
                
            }
            
            
            if ((dcr_latCommit.isEmpty) || (dcr_latCommit.count == 0)) {
                
                sb_DCRLATCOMMIT_KM = "";
                sb_DCRLATCOMMIT_LOC_LAT = "";
                sb_sDCRLATCOMMIT_IN_TIME = "";
                sDCRLATCOMMIT_ID = "";
                sDCRLATCOMMIT_LOC = "";
            } else {
                
                sb_DCRLATCOMMIT_KM = dcr_latCommit["sb_DCRLATCOMMIT_KM"]!
                sb_DCRLATCOMMIT_LOC_LAT = dcr_latCommit["sb_DCRLATCOMMIT_LOC_LAT"]!
                sb_sDCRLATCOMMIT_IN_TIME = dcr_latCommit["sb_sDCRLATCOMMIT_IN_TIME"]!
                sDCRLATCOMMIT_ID = dcr_latCommit["sDCRLATCOMMIT_ID"]!
                sDCRLATCOMMIT_LOC = dcr_latCommit["sDCRLATCOMMIT_LOC"]!
            }
            
            if (  IsGPRS_ON ) {
                dcr_Commit_rx = cboFinalTask_new.drRx_Save(updated: "0");
            }
            if ((dcr_Commit_rx.isEmpty) || (dcr_Commit_rx.count == 0)) {
                
                sDCR_DR_RX = "";
                sDCR_ITM_RX = "";
                
                
            } else {
                
                sDCR_DR_RX = dcr_Commit_rx["sDCRRX_DR_ARR"]!
                sDCR_ITM_RX = dcr_Commit_rx["sDCRRX_ITEMID_ARR"]!
                
                
            }
            
            if (  IsGPRS_ON ) {
                dcr_Commititem = cboFinalTask_new.drItemSave(updated: "0");
            }
            
            if ((dcr_Commititem.isEmpty) || (dcr_Commititem.count == 0)){
                
                sDCRITEM_DR_ID = "";
                sDCRITEM_ITEMIDIN = "";
                sDCRITEM_ITEM_ID_ARR = "";
                sDCRITEM_QTY_ARR = "";
                sDCRITEM_ITEM_ID_GIFT_ARR = "";
                sDCRITEM_QTY_GIFT_ARR = "";
                sDCRITEM_POB_QTY = "";
                sDCRITEM_POB_VALUE = "";
                sDCRITEM_VISUAL_ARR = "";
                sDCRITEM_NOC_ARR="";
                
            } else {
                sDCRITEM_DR_ID = dcr_Commititem["sb_sDCRITEM_DR_ID"]!
                sDCRITEM_ITEMIDIN = dcr_Commititem["sb_sDCRITEM_ITEMIDIN"]!
                sDCRITEM_ITEM_ID_ARR = dcr_Commititem["sb_sDCRITEM_ITEM_ID_ARR"]!
                sDCRITEM_QTY_ARR = dcr_Commititem["sb_sDCRITEM_QTY_ARR"]!
                sDCRITEM_ITEM_ID_GIFT_ARR = dcr_Commititem["sb_sDCRITEM_ITEM_ID_GIFT_ARR"]!
                sDCRITEM_QTY_GIFT_ARR = dcr_Commititem["sb_sDCRITEM_QTY_GIFT_ARR"]!
                sDCRITEM_POB_QTY = dcr_Commititem["sb_sDCRITEM_POB_QTY"]!
                sDCRITEM_POB_VALUE = dcr_Commititem["sb_sDCRITEM_POB_VALUE"]!
                sDCRITEM_VISUAL_ARR = dcr_Commititem["sb_sDCRITEM_VISUAL_ARR"]!
                sDCRITEM_NOC_ARR = dcr_Commititem["sb_sDCRITEM_NOC_ARR"]!
                
            }
            
            if (  IsGPRS_ON ) {
                dcr_CommitDr = cboFinalTask_new.dcr_doctorSave(updated: "0");
            }
            
            if ((dcr_CommitDr.isEmpty) || (dcr_CommitDr.count == 0)) {
                sDCRDR_DR_ID = "";
                sDCRDR_WW1 = "";
                sDCRDR_WW2 = "";
                sDCRDR_WW3 = "";
                sDCRDR_LOC = "";
                sDCRDR_IN_TIME = "";
                sDCRDR_BATTERY_PERCENT = "";
                sDCRDR_REMARK = "";
                sDCRDR_KM = "";
                sDCRDR_SRNO="";
                sDCRDR_FILE="";
                sDCRDR_CALLTYPE="";
            } else {
                sDCRDR_DR_ID = dcr_CommitDr["sb_sDCRDR_DR_ID"]!
                sDCRDR_WW1 = dcr_CommitDr["sb_sDCRDR_WW1"]!
                sDCRDR_WW2 = dcr_CommitDr["sb_sDCRDR_WW2"]!
                sDCRDR_WW3 = dcr_CommitDr["sb_sDCRDR_WW3"]!
                sDCRDR_LOC = dcr_CommitDr["sb_sDCRDR_LOC"]!
                sDCRDR_IN_TIME = dcr_CommitDr["sb_sDCRDR_IN_TIME"]!
                sDCRDR_BATTERY_PERCENT = dcr_CommitDr["sb_sDCRDR_BATTERY_PERCENT"]!
                sDCRDR_REMARK = dcr_CommitDr["sb_sDCRDR_Remark"]!
                sDCRDR_KM = dcr_CommitDr["sb_sDCRDR_KM"]!
                sDCRDR_SRNO=dcr_CommitDr["sb_sDCRDR_SRNO"]!
                sDCRDR_FILE=dcr_CommitDr["sb_sDCRDR_FILE"]!
                sDCRDR_CALLTYPE=dcr_CommitDr["sb_sDCRDR_CALLTYPE"]!
            }
            
            if (  IsGPRS_ON ) {
                dcr_ChemistCommit = cboFinalTask_new.dcr_chemSave(updated: "0")
            }
            
            if ((dcr_ChemistCommit.isEmpty) || (dcr_ChemistCommit.count == 0)) {
                sDCRCHEM_CHEM_ID = "";
                sDCRCHEM_POB_QTY = "";
                sDCRCHEM_POB_AMT = "";
                sDCRCHEM_ITEM_ID_ARR = "";
                sDCRCHEM_QTY_ARR = "";
                sDCRCHEM_LOC = "";
                sDCRCHEM_IN_TIME = "";
                sDCRCHEM_SQTY_ARR = "";
                sDCRCHEM_ITEM_ID_GIFT_ARR = "";
                sDCRCHEM_QTY_GIFT_ARR = "";
                sDCRCHEM_BATTERY_PERCENT = "";
                sDCRCHEM_KM = "";
                sDCRCHEM_SRNO="";
                sDCRCHEM_REMARK="";
                sDCRCHEM_FILE="";
                
            } else {
                sDCRCHEM_CHEM_ID = dcr_ChemistCommit["sb_sDCRCHEM_CHEM_ID"]!
                sDCRCHEM_POB_QTY = dcr_ChemistCommit["sb_sDCRCHEM_POB_QTY"]!
                sDCRCHEM_POB_AMT = dcr_ChemistCommit["sb_sDCRCHEM_POB_AMT"]!
                sDCRCHEM_ITEM_ID_ARR = dcr_ChemistCommit["sb_sDCRCHEM_ITEM_ID_ARR"]!
                sDCRCHEM_QTY_ARR = dcr_ChemistCommit["sb_sDCRCHEM_QTY_ARR"]!
                sDCRCHEM_LOC = dcr_ChemistCommit["sb_sDCRCHEM_LOC"]!
                sDCRCHEM_IN_TIME = dcr_ChemistCommit["sb_sDCRCHEM_IN_TIME"]!
                sDCRCHEM_SQTY_ARR = dcr_ChemistCommit["sb_sDCRCHEM_SQTY_ARR"]!
                sDCRCHEM_ITEM_ID_GIFT_ARR = dcr_ChemistCommit["sb_sDCRCHEM_ITEM_ID_GIFT_ARR"]!
                sDCRCHEM_QTY_GIFT_ARR = dcr_ChemistCommit["sb_sDCRCHEM_QTY_GIFT_ARR"]!
                sDCRCHEM_BATTERY_PERCENT = dcr_ChemistCommit["sb_sDCRCHEM_BATTERY_PERCENT"]!
                sDCRCHEM_KM = dcr_ChemistCommit["sb_sDCRCHEM_KM"]!
                sDCRCHEM_SRNO=dcr_ChemistCommit["sb_sDCRCHEM_SRNO"]!
                sDCRCHEM_REMARK = dcr_ChemistCommit["sb_sDCRCHEM_REMARK"]!
                sDCRCHEM_FILE = dcr_ChemistCommit["sb_sDCRCHEM_FILE"]!
            }
            
            
            if (  IsGPRS_ON ) {
                dcr_StkCommit = cboFinalTask_new.dcr_stkSave(updated: "0")
            }
            
            if ((dcr_StkCommit.isEmpty) || (dcr_StkCommit.count == 0)) {
                
                sDCRSTK_STK_ID = "";
                
                sDCRSTK_POB_QTY = "";
                sDCRSTK_POB_AMT = "";
                sDCRSTK_ITEM_ID_ARR = "";
                sDCRSTK_QTY_ARR = "";
                sDCRSTK_LOC = "";
                sDCRSTK_IN_TIME = "";
                sDCRSTK_SQTY_ARR = "";
                sDCRSTK_ITEM_ID_GIFT_ARR = "";
                sDCRSTK_QTY_GIFT_ARR = "";
                sDCRSTK_BATTERY_PERCENT = "";
                sDCRSTK_KM = "";
                sDCRSTK_SRNO = "";
                sDCRSTK_REMARK="";
                sDCRSTK_FILE="";
                
            } else {
                sDCRSTK_STK_ID = dcr_StkCommit["sb_sDCRSTK_STK_ID"]!
                sDCRSTK_POB_QTY = dcr_StkCommit["sb_sDCRSTK_POB_QTY"]!
                sDCRSTK_POB_AMT = dcr_StkCommit["sb_sDCRSTK_POB_AMT"]!
                sDCRSTK_ITEM_ID_ARR = dcr_StkCommit["sb_sDCRSTK_ITEM_ID_ARR"]!
                sDCRSTK_QTY_ARR = dcr_StkCommit["sb_sDCRSTK_QTY_ARR"]!
                sDCRSTK_LOC = dcr_StkCommit["sb_sDCRSTK_LOC"]!
                sDCRSTK_IN_TIME = dcr_StkCommit["sb_sDCRSTK_IN_TIME"]!
                sDCRSTK_SQTY_ARR = dcr_StkCommit["sb_sDCRSTK_SQTY_ARR"]!
                sDCRSTK_ITEM_ID_GIFT_ARR = dcr_StkCommit["sb_sDCRSTK_ITEM_ID_GIFT_ARR"]!
                sDCRSTK_QTY_GIFT_ARR = dcr_StkCommit["sb_sDCRSTK_QTY_GIFT_ARR"]!
                sDCRSTK_BATTERY_PERCENT = dcr_StkCommit["sb_sDCRSTK_BATTERY_PERCENT"]!
                sDCRSTK_KM = dcr_StkCommit["sb_sDCRSTK_KM"]!
                sDCRSTK_SRNO = dcr_StkCommit["sb_sDCRSTK_SRNO"]!
                sDCRSTK_REMARK = dcr_StkCommit["sb_sDCRSTK_REMARK"]!
                sDCRSTK_FILE = dcr_StkCommit["sb_sDCRSTK_FILE"]!
            }
            
            
            if (  IsGPRS_ON ) {
                dcr_CommitDr_Reminder = cboFinalTask_new.dcr_DrReminder(updated: "0")
            }
            
            if ((dcr_CommitDr_Reminder.isEmpty) || (dcr_CommitDr_Reminder.count == 0)) {
                
                sDCRRC_IN_TIME = "";
                sDCRRC_LOC = "";
                sDCRRC_DR_ID = "";
                sDCRRC_KM = "";
                sDCRRC_SRNO = "";
                sDCRRC_BATTERY_PERCENT="";
                sDCRRC_REMARK="";
                sDCRRC_FILE="";
            } else {
                
                sDCRRC_DR_ID = dcr_CommitDr_Reminder["sb_sDCRRC_DR_ID"]!
                sDCRRC_LOC = dcr_CommitDr_Reminder["sb_sDCRRC_LOC"]!
                sDCRRC_IN_TIME = dcr_CommitDr_Reminder["sb_sDCRRC_IN_TIME"]!
                sDCRRC_KM = dcr_CommitDr_Reminder["sb_sDCRRC_KM"]!
                sDCRRC_SRNO = dcr_CommitDr_Reminder["sb_sDCRRC_SRNO"]!
                sDCRRC_BATTERY_PERCENT = dcr_CommitDr_Reminder["sb_sDCRRC_BATTERY_PERCENT"]!
                sDCRRC_REMARK=dcr_CommitDr_Reminder["sb_sDCRRC_REMARK"]!
                sDCRRC_FILE=dcr_CommitDr_Reminder["sb_sDCRRC_FILE"]!
            }
            
            
            if (  IsGPRS_ON ) {
                Lat_Long_Reg = cboFinalTask_new.get_Lat_Long_Reg(updated: "0")
            }
            
            if ((Lat_Long_Reg.isEmpty) || (Lat_Long_Reg.count == 0)) {
                
                DCS_ID_ARR = "";
                LAT_LONG_ARR = "";
                DCS_TYPE_ARR = "";
                DCS_ADD_ARR = "";
                DCS_INDES_ARR = "";
            } else {
                
                DCS_ID_ARR = Lat_Long_Reg["DCS_ID_ARR"]!
                LAT_LONG_ARR = Lat_Long_Reg["LAT_LONG_ARR"]!
                DCS_TYPE_ARR = Lat_Long_Reg["DCS_TYPE_ARR"]!
                DCS_ADD_ARR = Lat_Long_Reg["DCS_ADD_ARR"]!
                DCS_INDES_ARR = Lat_Long_Reg["DCS_INDES_ARR"]!
            }
            
            
            if (  IsGPRS_ON ) {
                dcr_Dairy = cboFinalTask_new.get_phdairy_dcr(updated: "0");
            }
            
            if ((dcr_Dairy.isEmpty) || (dcr_Dairy.count == 0)) {
                
                sDAIRY_ID = "";
                sSTRDAIRY_CPID = "";
                sDCRDAIRY_LOC = "";
                sDCRDAIRY_IN_TIME = "";
                sDCRDAIRY_BATTERY_PERCENT = "";
                sDCRDAIRY_REMARK = "";
                sDCRDAIRY_KM = "";
                sDCRDAIRY_SRNO = "";
                sDCRDAIRYITEM_DAIRY_ID = "";
                sDCRDAIRYITEM_ITEM_ID_ARR = "";
                sDCRDAIRYITEM_QTY_ARR = "";
                sDCRDAIRYITEM_ITEM_ID_GIFT_ARR = "";
                sDCRDAIRYITEM_QTY_GIFT_ARR = "";
                sDCRDAIRYITEM_POB_QTY = "";
                sDAIRY_FILE = "";
                sDCRDAIRY_INTERSETEDYN = "";
            } else {
                
                sDAIRY_ID = dcr_Dairy["sDAIRY_ID"]!
                sSTRDAIRY_CPID  = dcr_Dairy["sSTRDAIRY_CPID"]!
                sDCRDAIRY_LOC  = dcr_Dairy["sDCRDAIRY_LOC"]!
                sDCRDAIRY_IN_TIME = dcr_Dairy["sDCRDAIRY_IN_TIME"]!
                sDCRDAIRY_BATTERY_PERCENT = dcr_Dairy["sDCRDAIRY_BATTERY_PERCENT"]!
                sDCRDAIRY_REMARK = dcr_Dairy["sDCRDAIRY_REMARK"]!
                sDCRDAIRY_KM = dcr_Dairy["sDCRDAIRY_KM"]!
                sDCRDAIRY_SRNO = dcr_Dairy["sDCRDAIRY_SRNO"]!
                sDCRDAIRYITEM_DAIRY_ID = dcr_Dairy["sDAIRY_ID"]!
                sDCRDAIRYITEM_ITEM_ID_ARR = dcr_Dairy["sDCRDAIRYITEM_ITEM_ID_ARR"]!
                sDCRDAIRYITEM_QTY_ARR = dcr_Dairy["sDCRDAIRYITEM_QTY_ARR"]!
                sDCRDAIRYITEM_ITEM_ID_GIFT_ARR = dcr_Dairy["sDCRDAIRYITEM_ITEM_ID_GIFT_ARR"]!
                sDCRDAIRYITEM_QTY_GIFT_ARR = dcr_Dairy["sDCRDAIRYITEM_QTY_GIFT_ARR"]!
                sDCRDAIRYITEM_POB_QTY = dcr_Dairy["sDCRDAIRYITEM_POB_QTY"]!
                sDAIRY_FILE = dcr_Dairy["sDAIRY_FILE"]!
                sDCRDAIRY_INTERSETEDYN = dcr_Dairy["sDCRDAIRY_INTERSETEDYN"]!
            }
            
            if (IsGPRS_ON && (!dcr_Commit_rx.isEmpty || dcr_Commit_rx.count > 0 ||
                !dcr_CommitDr_Reminder.isEmpty || dcr_CommitDr_Reminder.count > 0  ||
                !dcr_StkCommit.isEmpty || dcr_StkCommit.count > 0 ||
                !dcr_ChemistCommit.isEmpty || dcr_ChemistCommit.count > 0 ||
                !dcr_CommitDr.isEmpty || dcr_CommitDr.count > 0 ||
                !dcr_Commititem.isEmpty || dcr_Commititem.count > 0 ||
                !dcr_latCommit.isEmpty || dcr_latCommit.count > 0 ||
                !Lat_Long_Reg.isEmpty || Lat_Long_Reg.count > 0)){
                
                //Start of call to service
                
                var request = [String : String]()
                request["sCompanyFolder"] =  cbohelp.getCompanyCode()
                request["iDcrId"] =  "" + Custom_Variables_And_Method.DCR_ID
                request["iPA_ID"] =  "\( Custom_Variables_And_Method.PA_ID)"
                
                request["sDCRDR_DR_ID"] =  sDCRDR_DR_ID
                request["sDCRDR_WW1"] =  sDCRDR_WW1
                request["sDCRDR_WW2"] =  sDCRDR_WW2
                request["sDCRDR_WW3"] =  sDCRDR_WW3
                request["sDCRDR_LOC"] =  sDCRDR_LOC
                request["sDCRDR_IN_TIME"] =  sDCRDR_IN_TIME
                request["sDCRDR_BATTERY_PERCENT"] =  sDCRDR_BATTERY_PERCENT
                request["sDCRDR_REMARK"] =  sDCRDR_REMARK
                request["sDCRDR_KM"] =  sDCRDR_KM
                request["sDCRDR_SRNO"] =  sDCRDR_SRNO
                request["sDCRDR_CALLTYPE"] =  sDCRDR_CALLTYPE
                request["sDCRDR_FILE"] =  sDCRDR_FILE
                
                request["sDCRITEM_DR_ID"] =  sDCRITEM_DR_ID
                request["sDCRITEM_ITEMIDIN"] =  sDCRITEM_ITEMIDIN
                request["sDCRITEM_ITEM_ID_ARR"] =  sDCRITEM_ITEM_ID_ARR
                request["sDCRITEM_QTY_ARR"] =  sDCRITEM_QTY_ARR
                request["sDCRITEM_ITEM_ID_GIFT_ARR"] =  sDCRITEM_ITEM_ID_GIFT_ARR
                request["sDCRITEM_QTY_GIFT_ARR"] =  sDCRITEM_QTY_GIFT_ARR
                request["sDCRITEM_POB_QTY"] =  sDCRITEM_POB_QTY
                request["sDCRITEM_POB_VALUE"] =  sDCRITEM_POB_VALUE
                request["sDCRITEM_VISUAL_ARR"] =  sDCRITEM_VISUAL_ARR
                request["sDCRITEM_NOC_ARR"] =  sDCRITEM_NOC_ARR
                
                request["sDCRRX_DR_ARR"] =  sDCR_DR_RX
                request["sDCRRX_ITEMID_ARR"] =  sDCR_ITM_RX
                
                request["sDCRCHEM_CHEM_ID"] =  sDCRCHEM_CHEM_ID
                request["sDCRCHEM_POB_QTY"] =  sDCRCHEM_POB_QTY
                request["sDCRCHEM_POB_AMT"] =  sDCRCHEM_POB_AMT
                request["sDCRCHEM_ITEM_ID_ARR"] =  sDCRCHEM_ITEM_ID_ARR
                request["sDCRCHEM_QTY_ARR"] =  sDCRCHEM_QTY_ARR
                request["sDCRCHEM_LOC"] =  sDCRCHEM_LOC
                request["sDCRCHEM_IN_TIME"] =  sDCRCHEM_IN_TIME
                request["sDCRCHEM_SQTY_ARR"] =  sDCRCHEM_SQTY_ARR
                request["sDCRCHEM_ITEM_ID_GIFT_ARR"] =  sDCRCHEM_ITEM_ID_GIFT_ARR
                request["sDCRCHEM_QTY_GIFT_ARR"] =  sDCRCHEM_QTY_GIFT_ARR
                request["sDCRCHEM_BATTERY_PERCENT"] =  sDCRCHEM_BATTERY_PERCENT
                request["sDCRCHEM_KM"] =  sDCRCHEM_KM
                request["sDCRCHEM_SRNO"] =  sDCRCHEM_SRNO
                request["sDCRCHEM_REMARK"] =  sDCRCHEM_REMARK
                request["sDCRCHEM_FILE"] =  sDCRCHEM_FILE
                
                request["sDCRSTK_STK_ID"] =  sDCRSTK_STK_ID
                request["sDCRSTK_POB_QTY"] =  sDCRSTK_POB_QTY
                request["sDCRSTK_POB_AMT"] =  sDCRSTK_POB_AMT
                request["sDCRSTK_ITEM_ID_ARR"] =  sDCRSTK_ITEM_ID_ARR
                request["sDCRSTK_QTY_ARR"] =  sDCRSTK_QTY_ARR
                request["sDCRSTK_LOC"] =  sDCRSTK_LOC
                request["sDCRSTK_IN_TIME"] =  sDCRSTK_IN_TIME
                request["sDCRSTK_SQTY_ARR"] =  sDCRSTK_SQTY_ARR
                request["sDCRSTK_ITEM_ID_GIFT_ARR"] =  sDCRSTK_ITEM_ID_GIFT_ARR
                request["sDCRSTK_QTY_GIFT_ARR"] =  sDCRSTK_QTY_GIFT_ARR
                request["sDCRSTK_BATTERY_PERCENT"] =  sDCRSTK_BATTERY_PERCENT
                request["sDCRSTK_KM"] =  sDCRSTK_KM
                request["sDCRSTK_SRNO"] =  sDCRSTK_SRNO
                request["sDCRSTK_REMARK"] =  sDCRSTK_REMARK
                request["sDCRSTK_FILE"] =  sDCRSTK_FILE
                
                request["sDCRRC_DR_ID"] =  sDCRRC_DR_ID
                request["sDCRRC_LOC"] =  sDCRRC_LOC
                request["sDCRRC_IN_TIME"] =  sDCRRC_IN_TIME
                request["sDCRRC_KM"] =  sDCRRC_KM
                request["sDCRRC_SRNO"] =  sDCRRC_SRNO
                request["sDCRRC_BATTERY_PERCENT"] =  sDCRRC_BATTERY_PERCENT
                request["sDCRRC_REMARK"] =  sDCRRC_REMARK
                request["sDCRRC_FILE"] =  sDCRRC_FILE
                
                request["sDCRLATCOMMIT_ID"] =  sDCRLATCOMMIT_ID
                request["sDCRLATCOMMIT_IN_TIME"] =  sb_sDCRLATCOMMIT_IN_TIME
                request["sDCRLATCOMMIT_LOC_LAT"] =  sb_DCRLATCOMMIT_LOC_LAT
                request["sDCRLATCOMMIT_LOC"] =  sDCRLATCOMMIT_LOC
                request["sDCRLATCOMMIT_KM"] =  sb_DCRLATCOMMIT_KM
                
                
                
                request["DCS_ID_ARR"] =  DCS_ID_ARR
                request["LAT_LONG_ARR"] =  LAT_LONG_ARR
                request["DCS_TYPE_ARR"] =  DCS_TYPE_ARR
                request["DCS_ADD_ARR"] =  DCS_ADD_ARR
                request["DCS_INDES_ARR"] =  DCS_INDES_ARR
                
                
                
                request["sDAIRY_ID"] = sDAIRY_ID
                request["sSTRDAIRY_CPID"] = sSTRDAIRY_CPID
                request["sDCRDAIRY_LOC"] = sDCRDAIRY_LOC
                request["sDCRDAIRY_IN_TIME"] = sDCRDAIRY_IN_TIME
                request["sDCRDAIRY_BATTERY_PERCENT"] = sDCRDAIRY_BATTERY_PERCENT
                
                
                request["sDCRDAIRY_REMARK"] = sDCRDAIRY_REMARK
                request["sDCRDAIRY_KM"] =  sDCRDAIRY_KM
                
                request["sDCRDAIRY_SRNO"] = sDCRDAIRY_SRNO
                request["sDCRDAIRYITEM_DAIRY_ID"] = sDCRDAIRYITEM_DAIRY_ID
                request["sDCRDAIRYITEM_ITEM_ID_ARR"] = sDCRDAIRYITEM_ITEM_ID_ARR
                request["sDCRDAIRYITEM_QTY_ARR"] = sDCRDAIRYITEM_QTY_ARR
                request["sDCRDAIRYITEM_ITEM_ID_GIFT_ARR"] = sDCRDAIRYITEM_ITEM_ID_GIFT_ARR
                request["sDCRDAIRYITEM_QTY_GIFT_ARR"] = sDCRDAIRYITEM_QTY_GIFT_ARR
                request["sDCRDAIRYITEM_POB_QTY"] =  sDCRDAIRYITEM_POB_QTY
                request["sDAIRY_FILE"] = sDAIRY_FILE
                request["sDCRDAIRY_INTERSETEDYN"] = sDCRDAIRY_INTERSETEDYN
                
                
                var tables = [Int]()
                if (self.ReplyYN == "N"){
                    tables.append(-2);
                }else {
                    tables.append(-1);
                }
                
                CboServices().customMethodForAllServices(params: request , methodName: "DCR_SYNC_MOBILE_ALL_4", tables: tables, response_code: responseCode, vc: context)
                //        CboServices().customMethodForAllServices(request, "DCR_SYNC_MOBILE_ALL_2", SyncService.MESSAGE_INTERNET_SYNC, tables);
                
                //End of call to service
            }else if (self.ReplyYN != "N"){
                var ReplyMsg = [String : NSArray]()
                ReplyMsg["Error"] = ["No Data to update..."]
                context.getDataFromApi(response_code: 99, dataFromAPI: ReplyMsg)
                
            }
            
            
        } catch  {
            print(error)
        }
    }
    
    
    
    
    
    //    private final Handler mHandler = new Handler() {
    //    @Override
    //    public void handleMessage(Message msg) {
    //    ReplyYN="N";
    //    String DoneYN="N";
    //    switch (msg.what) {
    //    case MESSAGE_INTERNET_SYNC:
    //    DoneYN="Y";
    //    if ((null != msg.getData())) {
    //
    //    parser_sync(msg.getData());
    //
    //    }
    //    break;
    //    case 99:
    //    if ((null != msg.getData())) {
    //    customVariablesAndMethod.msgBox(context,msg.getData().getString("Error"));
    //
    //    }
    //    break;
    //    default:
    //
    //    }
    //    sendMessagetoUI(DoneYN);
    //    }
    //    };
    
    public func parser_sync( result : [String : NSArray]) {
        if !(result.isEmpty  ) {
            
            do {
                
                let table0 = result["Tables0"]
                
                let jsonArray1 = table0
                for i in 0 ..< jsonArray1!.count {
                    let c = jsonArray1![i] as! [String : AnyObject]
                    if(c["STATUS"] as! String == ("OK")){
                        
                        if(!dcr_CommitDr.isEmpty || dcr_CommitDr.count > 0) {
                            let dr_id_array = try dcr_CommitDr.getString(key: "sb_sDCRDR_DR_ID").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            
                            
                            for j in 0 ..< dr_id_array.count  {
                                cbohelp.updateDrKilo(km: "0", id: dr_id_array[j]);
                            }
                        }
                        
                        
                        if(!dcr_Commititem.isEmpty || dcr_Commititem.count > 0) {
                            let dr_id_array = try dcr_Commititem.getString(key: "sb_sDCRITEM_DR_ID").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            
                            for j in 0 ..< dr_id_array.count {
                                cbohelp.updateDr_item(id: dr_id_array[j]);
                            }
                        }
                        
                        if(!dcr_CommitDr_Reminder.isEmpty || dcr_CommitDr_Reminder.count > 0) {
                            let dr_id_array = try dcr_CommitDr_Reminder.getString(key: "sb_sDCRRC_DR_ID").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            
                            
                            for j in 0 ..< dr_id_array.count{
                                cbohelp.updateKm_RC(km: "0", id: dr_id_array[j]);
                            }
                        }
                        
                        
                        if(!dcr_ChemistCommit.isEmpty || dcr_ChemistCommit.count > 0) {
                            let dr_id_array = try dcr_ChemistCommit.getString(key: "sb_sDCRCHEM_CHEM_ID").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            
                            for j in 0 ..< dr_id_array.count{
                                cbohelp.updateChemistKilo(km: "0", id: dr_id_array[j]);
                            }
                        }
                        
                        if(!dcr_StkCommit.isEmpty || dcr_StkCommit.count > 0) {
                            let dr_id_array = try dcr_StkCommit.getString(key: "sb_sDCRSTK_STK_ID").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            for j in 0 ..< dr_id_array.count{
                                cbohelp.updateStk_Km(km: "0", id: dr_id_array[j]);
                            }
                        }
                        
                        if(!dcr_latCommit.isEmpty || dcr_latCommit.count > 0) {
                            let dr_id_array = try  dcr_latCommit.getString(key: "sDCRLATCOMMIT_ID").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            for j in 0 ..< dr_id_array.count{
                                cbohelp.latLon10_updated(id: dr_id_array[j]);
                            }
                        }
                        
                        if(!Lat_Long_Reg.isEmpty || Lat_Long_Reg.count > 0) {
                            let dr_id_array = try  Lat_Long_Reg.getString(key: "DCS_ID_ARR").replacingOccurrences(of: "^", with: "@").components(separatedBy: "@")
                            for j in 0 ..< dr_id_array.count{
                                cbohelp.updatedLat_Long_Reg(DCS_ID: dr_id_array[j]);
                            }
                        }
                        
                    }
                }
                
            } catch  {
                print(error)
                
                
                
                customVariablesAndMethod.getAlert(vc: context, title: "Missing field error", msg: error.localizedDescription )
                
                
                let dataDict = ["Error Alert : ":"Missing field error \n \(error.localizedDescription )"]
                
                let objBroadcastErrorMail = BroadcastErrorMail(dataDict: dataDict, mailSubject: "\(error.localizedDescription )" , vc: context)
                
                objBroadcastErrorMail.requestAuthorization()
                
            }
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    //
    //    private func sendMessagetoUI(DoneYN : String) {
    //    //Log.d("sender", "Broadcasting message");
    //
    //    Intent intent = new Intent("SyncComplete");
    //    // You can also include some extra data.
    //    intent.putExtra("message", DoneYN );
    //    LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    //    }
    //    @Override
    //
    //    public IBinder onBind(Intent intent) {
    //    // TODO Auto-generated method stub
    //    Log.e("servic binded", "service binded");
    //    return null;
    //    }
    
    //    public init() {
    //
    ////        context = context
    //        customVariablesAndMethod=Custom_Variables_And_Method.getInstance();
    ////        cbohelp = new CBO_DB_Helper(getApplicationContext());
    ////        cboFinalTask_new = new CBOFinalTask_New(context);
    ////        customMethod=new MyCustomMethod(context);
    //    }
    
    
    
    
    //    public func onStartCommand(Intent intent, int flags, int startId) -> Int {
    //
    //    cbohelp = new CBO_DB_Helper(getApplicationContext());
    //
    //
    //
    //    Runnable r7 = new Runnable() {
    //    @Override
    //    public void run() {
    //    synchronized (this) {
    //    DCR_sync_all();
    //    }
    //
    //    }
    //    };
    //
    //
    //    new Thread(r7).start();
    //    stopSelf();
    //    return Service.START_STICKY;
    //    }
    
    
}
