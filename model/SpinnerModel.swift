//
//  SpinnerModel.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 11/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class SpinnerModel {

    private var name="";
    
    private var id="";
    private  var LAST_VISIT_DATE="";
    
    private var CLASS="";
    private var POTENCY_AMT="";
    private  var ITEM_NAME="";
    private  var ITEM_POB="";
    private var ITEM_SALE="";
    private var AREA="";
    private var FREQ="0";
    private var DR_LAT_LONG="";
    private var DR_LAT_LONG2="";
    private  var DR_LAT_LONG3="";
    private  var PANE_TYPE="";
    private  var NO_VISITED="0";
    private   var COLORYN="0";
    private  var CALLYN="0";
    private   var CRM_COUNT="";
    private  var DRCAPM_GROUP="";
    private var highlight = false
    private  var REF_LAT_LONG = "";
    
    
    public init(name : String,id : String){
        self.name=name;
        self.id=id;
    }
    
    public init(name : String,id : String, last_visited : String,  DR_LAT_LONG : String, DR_LAT_LONG2 : String, DR_LAT_LONG3 : String, CALLYN : String){
        self.name=name;
        self.id=id;
        LAST_VISIT_DATE=last_visited;
        self.DR_LAT_LONG=DR_LAT_LONG;
        self.DR_LAT_LONG2=DR_LAT_LONG2;
        self.DR_LAT_LONG3=DR_LAT_LONG3;
        self.PANE_TYPE="1";
        self.CALLYN=CALLYN;
    }
    
    public init(name : String,id : String, last_visited : String, CLASS : String, POTENCY_AMT : String, ITEM_NAME : String
    , ITEM_POB : String, ITEM_SALE : String, AREA : String, PANE_TYPE : String,  DR_LAT_LONG : String, FREQ : String,  NO_VISITED : String, DR_LAT_LONG2 : String,  DR_LAT_LONG3 : String, COLORYN : String, CALLYN : String, CRM_COUNT : String, DRCAPM_GROUP : String){
        
        self.name=name;
        self.id=id;
        LAST_VISIT_DATE=last_visited;
        self.CLASS=CLASS;
        self.POTENCY_AMT=POTENCY_AMT;
        self.ITEM_NAME=ITEM_NAME;
        self.ITEM_POB=ITEM_POB;
        self.ITEM_SALE=ITEM_SALE;
        self.AREA=AREA;
        self.PANE_TYPE=PANE_TYPE;
        self.DR_LAT_LONG=DR_LAT_LONG;
        self.DR_LAT_LONG2=DR_LAT_LONG2;
        self.DR_LAT_LONG3=DR_LAT_LONG3;
        self.FREQ=FREQ;
        self.NO_VISITED=NO_VISITED;
        self.COLORYN=COLORYN;
        self.CALLYN=CALLYN;
        self.CRM_COUNT = CRM_COUNT;
        self.DRCAPM_GROUP = DRCAPM_GROUP;
    }
    
   public init(name : String){
        self.name=name;
    }
    
    
    func setName( name : String)
{
    self.name = name;
    }
    
    func getLastVisited() -> String
{
    return LAST_VISIT_DATE;
    }
    func getCLASS() -> String
{
    return CLASS;
    }
    func getPOTENCY_AMT() -> String
{
    return POTENCY_AMT;
    }
    func getITEM_NAME() -> String
{
    return ITEM_NAME;
    }
    func getITEM_POB() -> String
{
    return ITEM_POB;
    }
    func getITEM_SALE() -> String
{
    return ITEM_SALE;
    }
    func getAREA() -> String
{
    return AREA;
    }
    func getPANE_TYPE() -> String
{
    return PANE_TYPE;
    }
    
    func isHighlighted() -> Bool {
        return highlight;
    }
    
    func setHighlight( highlight : Bool) {
        self.highlight = highlight;
    }
    
    
    
    func  setId( id : String)
{
    self.id = id;
    }
    
    /*********** Get Methods ****************/
    func getName() -> String
{
    return self.name;
    }
   func getId() -> String
{
    return self.id;
    }
    
    func getLoc() -> String
{
    return self.DR_LAT_LONG;
    }
    func setLoc( DR_LAT_LONG : String) {
        self.DR_LAT_LONG=DR_LAT_LONG;
    }
    
   func getLoc2() -> String
{
    if    (DR_LAT_LONG2 == nil) {
    return "";
    }
    return DR_LAT_LONG2;
    }
   func setLoc2( DR_LAT_LONG2 : String)  {
    self.DR_LAT_LONG2=DR_LAT_LONG2;
    }
    
    func getLoc3() -> String{
        if(DR_LAT_LONG3 == nil) {
        return "";
        }
        
        return DR_LAT_LONG3;
    }
    func setLoc3( DR_LAT_LONG3 : String) {
    self.DR_LAT_LONG3=DR_LAT_LONG3;
    }
    
    func getFREQ() -> String{
        return self.FREQ;
    }
    func setFREQ(FREQ : String)  {
    self.FREQ=FREQ;
    }
    
    func getNO_VISITED() -> String
{
    return self.NO_VISITED;
    }
    func setNO_VISITED(NO_VISITED : String)  {
    self.NO_VISITED=NO_VISITED;
    }
    
    func getCOLORYN() -> String
{
    return self.COLORYN;
    }
    func setCOLORYN( COLORYN  : String) {
        self.COLORYN = COLORYN;
    }
    
    func getCALLYN() -> String
{
    return self.CALLYN;
    }
    func setCALLYN( CALLYN : String) {
        self.CALLYN = CALLYN;
    }
    
    
    func getCRM_COUNT() -> String
    {
        return self.CRM_COUNT;
    }
    func setCRM_COUNT( CRM_COUNT  : String) {
        self.CRM_COUNT = CRM_COUNT;
    }
    
    func getDRCAPM_GROUP() -> String
    {
        return self.DRCAPM_GROUP;
    }
    func setDRCAPM_GROUP( DRCAPM_GROUP : String) {
        self.DRCAPM_GROUP = DRCAPM_GROUP;
    }
    
    func getREF_LAT_LONG() -> String{
        return REF_LAT_LONG;
    }
    
    func setREF_LAT_LONG( REF_LAT_LONG : String) {
        self.REF_LAT_LONG = REF_LAT_LONG;
    }

}
