//
//  RptModel.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 19/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
public class RptModel {
    private var date : String!
    private var  with : String!
    private var  ttldr :  String!
    private var  ttlchm :  String!
    private var  ttlstk :  String!
    private var  ttlexp :  String!
    private var  ttlMissedCall :  String!
    private var  ttlDrRiminder ,ttlNonDoctor,ttlTenivia : String!
    private var  remark: String!
    
    public init( mdate :String , mwith :String, mdr :String , mchm :String,  mstk :String , mexp:String , ttlNonDistributor :String , ttlNonRetailer : String){
        self.date =  mdate;
        self.with=mwith;
        self.ttldr=mdr;
        self.ttlchm=mchm;
        self.ttlstk=mstk;
        self.ttlexp=mexp;
        self.ttlMissedCall = ttlNonRetailer;
        self.ttlDrRiminder = ttlNonDistributor;
    }
    init (){
        
    }

    
    func  getDate() -> String{
        return date;
    }
    
    func  setDate( date : String){
        self.date=date;
    }
    
    func getWith() -> String{
        return  with
    }
    
    func setWith(with : String){
        self.with=with;
    }
    
    func getTtldr() -> String{
        return ttldr;
    }
   
    func setTtldr(dr : String){
        self.ttldr=dr;
    }
    func getTtlchm() -> String{
        return ttlchm;
    }
    
    func setTtlchm( chm : String){
        self.ttlchm=chm;
    }
    
    func  getTtlstk() -> String{
    return ttlstk;
    }
    
    func  setTtlstk( stk : String){
        self.ttlstk=stk;
    }
    
    func  getTtlexp() -> String{
        return ttlexp;
    }
    
    func setTtlexp( exp : String){
        self.ttlexp=exp;
    }
    
    func getTtlMissedCall() -> String {
        return ttlMissedCall;
    }
    
    func  getTtlDrRiminder() -> String {
        return ttlDrRiminder;
    }
    
    func  getTtlTenivia()-> String{
        return ttlTenivia;
    }
    func  getTtlNonDoctor() -> String {
     return ttlNonDoctor;
    }
    
    func  setTtlMissedCall( ttlMissedCall :String) {
        self.ttlMissedCall = ttlMissedCall;
    }
    
    func  setTtlDrRiminder( ttlDrRiminder : String) {
        self.ttlDrRiminder = ttlDrRiminder;
    }
   
    func  setTtlTenivia( ttlTenivia : String) {
        self.ttlTenivia = ttlTenivia;
    }
    
    func setTtlNonDoctor( ttlNonDoctor : String) {
        self.ttlNonDoctor = ttlNonDoctor;
    }
    
    func  setRemark( remark : String) {
        self.remark = remark;
    }
    func  getRemark() -> String {
        return self.remark ;
    }
}

