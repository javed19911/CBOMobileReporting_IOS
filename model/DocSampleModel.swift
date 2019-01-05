//
//  DocSampleModel.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 15/03/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

public class DocSampleModel {
    var  name="";
    var  id="";
    var  rowid="";
    var  file_ext="";
    var  checked=false;
    
    init ( name : String, id :String , rowid : String){
    self.name=name;
    self.id=id;
    self.rowid=rowid;
    }
    
    func  getName() -> String{
    return name;
    }
    func setName(name : String){
    self.name=name;
    }
    
    func  getId() -> String{
    return id;
    }
    func  setid( id : String){
    self.id=id;
    }
    
    func getRowId() -> String{
    return rowid;
    }
    func setRowId( rowid : String){
    self.rowid=rowid;
    
    }
    func  get_file_ext() -> String{
    return file_ext;
    }
    func set_file_ext( file_ext :String){
    self.file_ext=file_ext;
    
    }
    func get_Checked() -> Bool{
    return checked;
    }
    func set_Checked( checked  : Bool){
    self.checked=checked;
    
    }
}
