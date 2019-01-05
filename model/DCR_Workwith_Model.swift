//
//  DCR_Workwith_Model.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
class DCR_Workwith_Model{
    var name : String = ""
    var id : String = ""
    var  ResigYN  : String = "0";
    var  LeaveYN  : String = "1";
    var selected = false
    var independent_list = false;
    
 
    
    init ( name :  String , id :  String){
        self.name=name;
        self.id=id;
        selected=false;
        independent_list=false;
        ResigYN="0";
        LeaveYN  = "1";
    }
    
    
    init (name : String, id : String ,ResigYN : String, LeaveYN : String, WorkWithYN : String){
        self.name=name;
        self.id=id;
        selected=false;
        independent_list=false;
        self.ResigYN=ResigYN;
        self.LeaveYN  = LeaveYN;
        selected = WorkWithYN == ("1");
    }
    
    
    func getName() -> String {
        return self.name
    }
    func setName(name : String)  {
        self.name = name
    }
    

    
    func getId() -> String{
    return id;
    }
    
    func setId( id : String){
    self.id=id;
    }
    
    func  getResigYN() -> String{
    return ResigYN;
    }
    
    func setResigYN( ResigYN : String){
    self.ResigYN=ResigYN;
    }
    
    func  getLeaveYN() -> String{
        return LeaveYN;
    }
    
    func setLeaveYN( LeaveYN : String){
        self.LeaveYN=LeaveYN;
    }
    
    
    func isSelected() -> Bool {
    return selected;
    }
    
    func setSelected(selected : Bool){
    self.selected=selected;
    }
    
    func isindependentSelected() -> Bool{
    return independent_list;
    }
    
    func setindependentSelected( independent_list : Bool){
    self.independent_list=independent_list;
    }
    
}


