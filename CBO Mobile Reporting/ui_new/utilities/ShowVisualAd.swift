//
//  ShowVisualAd.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 24/02/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class ShowVisualAd: CustomUIViewController  {
    var myImagesDic = [[String : [String]]]()
    var indexId = 0
   
     var who = 1

     var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var sample_id = [String]()
    var sample_name = [String]()
    
    private var sample_name_Stored = "" , sample_pob = "" , sample_sample = ""
    
    
    var presenter  : VisualAdAdaptor!
    @IBOutlet weak var mytopView: TopViewOfApplication!
    
    @IBOutlet weak var showAdTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !((VCIntent["who"]?.isEmpty)!){
            who = Int(VCIntent["who"]!)!
        }
        
        
        if (who==0){
            
            if !((VCIntent["sample_name"]?.isEmpty)!){
                sample_name_Stored = VCIntent["sample_name"]!
            }
            if !((VCIntent["sample_pob"]?.isEmpty)!){
                sample_pob = VCIntent["sample_pob"]!
            }
            if !((VCIntent["sample_sample"]?.isEmpty)!){
               sample_sample = VCIntent["sample_sample"]!
            }
        }
        
        var splcode = ""
        
        do {
            let  statement  =  try  cbohelp.getSelectedFromDr(dr_id: Custom_Variables_And_Method.DR_ID);

            while let c1 = statement.next(){
                splcode = (try c1[cbohelp.getColumnIndex(statement: statement, Coloumn_Name: "remark")] as! String)
                
            }
            
            Custom_Variables_And_Method.pub_doctor_spl_code = splcode
        }catch{
            print(error)
        }
        
        
        if !(VCIntent["title"]?.isEmpty)!{
            mytopView.setText(title: VCIntent["title"]!)
        }
          mytopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        presenter = VisualAdAdaptor(tableView: showAdTableView , vc : self, dataList: getAllVisualAdd(), sample_id: sample_id, sample_name: sample_name)

        showAdTableView.delegate = presenter
        showAdTableView.dataSource = presenter
        showAdTableView.reloadData()


    }
    
    
    
    
    
    
    func getAllVisualAdd() -> [DocSampleModel]{
        var list = [DocSampleModel]()
        var ItemIdNotIn = "0"
        
        do {
           let db = cbohelp
            var cnt = 0;
            var  statement3 = try cbohelp.getAllVisualAdd(itemidnotin: ItemIdNotIn, SHOW_ON_TOP: "Y");
            //Cursor c=myitem.getSelected();
            //rs=stmt.getResultSet();
            
            if  statement3.next() != nil {
                statement3 = try cbohelp.getAllVisualAdd(itemidnotin: ItemIdNotIn, SHOW_ON_TOP: "Y");
                while let c = statement3.next() {
                    
                    
                    sample_id.append(try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_id")] as! String);
                    
                    sample_name.append(try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_name")] as! String);
                    
                    list.append( DocSampleModel(name: (try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_name")] as! String), id: (try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_id")] as! String), rowid: "\(cnt)") )
                    
                    cnt += 1
                }
            }
    
            
            var cnt3 = 0;
           Custom_Variables_And_Method.DOCTOR_SPL_ID = 1
             var statement4 = try cbohelp.getphitemSpl();
            var cnt2 = 0
 
            var  statement2  = try  cbohelp.getSelectedFromDr(dr_id: Custom_Variables_And_Method.DR_ID);

            while let c1 = statement2.next(){
                
                
                list.append(DocSampleModel(name: (try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_name")] as! String), id: "\(try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_id")]!)", rowid: "\(cnt2)"))
                
                
                sample_id.append("\(try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_id")]!)");
                sample_name.append(try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_name")] as! String);
                
                
                ItemIdNotIn = "\(ItemIdNotIn),\(String(describing: try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_id")])))"
                //print(ItemIdNotIn)
                
                cnt2 = cnt2+1;
                
            }
            
            statement2  = try  cbohelp.getSelectedFromDr(dr_id: Custom_Variables_And_Method.DR_ID);

            if (statement2.next() != nil &&  who == 0 && customVariablesAndMethod1.getDataFrom_FMCG_PREFRENCE(vc: self, key: "VISUALAID_DRSELITEMYN", defaultValue: "N") == "Y") {
                
//                statement2  = try  cbohelp.getSelectedFromDr(dr_id: Custom_Variables_And_Method.DR_ID);
//                while let c1 = statement2.next(){
//
//
//                    list.append(DocSampleModel(name: (try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_name")] as! String), id: (try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_id")] as! String), rowid: "\(cnt2)"))
//
//
//                    sample_id.append(try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_id")] as! String);
//                    sample_name.append(try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_name")] as! String);
//
//
//                    ItemIdNotIn = "\(ItemIdNotIn),\(String(describing: try c1[db.getColumnIndex(statement: statement2, Coloumn_Name: "item_id")])))"
//                print(ItemIdNotIn)
//
//                    cnt2 = cnt2+1;
//
//                 }
            }else if  statement4.next() != nil {
                statement4 = try cbohelp.getphitemSpl();
                while let c2 = statement4.next(){

                    list.append(DocSampleModel(name: (try c2[db.getColumnIndex(statement: statement4, Coloumn_Name: "item_name")] as! String), id: (try c2[db.getColumnIndex(statement: statement4, Coloumn_Name: "item_id")] as! String), rowid: "\(cnt3)"))

                    sample_id.append(try c2[db.getColumnIndex(statement: statement4, Coloumn_Name: "item_id")] as! String);

                    sample_name.append(try c2[db.getColumnIndex(statement: statement4, Coloumn_Name: "item_name")] as! String);

                    ItemIdNotIn = "\(ItemIdNotIn),\(try c2[db.getColumnIndex(statement: statement4, Coloumn_Name: "item_id")] ?? "0")"
                }
            }
            else {
           
                 cnt = 0;
                var  statement3 = try cbohelp.getAllVisualAdd(itemidnotin: ItemIdNotIn, SHOW_ON_TOP: "N");
                //Cursor c=myitem.getSelected();
                //rs=stmt.getResultSet();
                
                if  statement3.next() != nil {
                    statement3 = try cbohelp.getAllVisualAdd(itemidnotin: ItemIdNotIn, SHOW_ON_TOP: "N");
                    while let c = statement3.next() {
                        
                        
                        sample_id.append(try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_id")] as! String);
                        
                        sample_name.append(try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_name")] as! String);
                        
                        list.append( DocSampleModel(name: (try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_name")] as! String), id: (try c[db.getColumnIndex(statement: statement3, Coloumn_Name: "item_id")] as! String), rowid: "\(cnt)") )
                        
                        cnt += 1
                    }
                }
            }
            
            // get the list of files in mobile
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let myFilesPath = documentDirectoryPath.appending("/Cbo/Product/")
            let fileManager = FileManager.default
            
            
            let files = fileManager.enumerator(atPath: myFilesPath)


            while let file  = files?.nextObject()  {

                
                let file1 = file as! String
                print(file1)
                if (file1.contains(".")){
                    let file_Name = file1.subString(offsetFrom:0, offSetTo: file1.lastIndexOf(char: ".") - 1 )
                    if (file1.contains(".") && sample_id.contains(file_Name) ){

                        for j in  0 ..< sample_id.count {
                            if (sample_id[j] == (file_Name)) {
                                list[j].set_file_ext(file_ext:getFileExtension(fileName: file1) )
                                break;
                            }
                        }
                    }
                    
                  
                }else{
                    if (sample_name.contains("CATALOG")) {
                        for j in 0 ..< sample_name.count {
                            if (sample_name[j] == "CATALOG") {
                                list[j].set_file_ext(file_ext: ".html");
                                    break;
                                }
                            }
                        }
                    }

                print(sample_id)
            }

            
        }catch{
            print(error)
        }
        
        
        if (who==0) {
            var sample_name1  =  sample_name_Stored.split(separator: ",")
            /*String[] sample_qty1 = sample_sample.split(",");
             String[] sample_pob1 = sample_pob.split(",");*/
            print(sample_name1)
            for  i in  0 ..< sample_name1.count {
                for j in 0 ..< list.count  {
                    if (sample_name1[i] == (list[j].getName())) {
                        list[j].set_Checked(checked: true);
                    }
                }
            }
        }

        
        
        return list
    }
    
    func getFileExtension(fileName : String) -> String {
        let  exte = NSURL ( fileURLWithPath: fileName).pathExtension ?? ""
        return ".\(exte)"
    }
    
    
    
    func convertingArrayToDictionary(listName : [String]){
        myImagesDic.removeAll()
        var tempArray = [String]()
        var l = 0
        for i in 0 ..< listName.count{
            if (listName[i] as NSString).pathExtension ==  "jpg" || (listName[i] as NSString).pathExtension ==  "png"   {
                
                tempArray.removeAll()
                
                for j in 0 ..< listName.count{
                    // print(listName[j].first! , i)
                    
                    var k = 0
                    let var1  : String = listName[j].subString(offsetFrom: 0, offSetTo: 0)  , var2 = "\(i)"
                    
                    if var1 == var2 {
                        //                    print("\(i)=\(listName[j])")
                        tempArray.insert(listName[j], at: k)
                        k += 1
                    }
                }
                if !( tempArray.isEmpty){
                    //                    print(tempArray)
                    myImagesDic.insert([tempArray[0] : tempArray], at: l)
                    l += 1
                }
            }
        }
    }


    @objc func closeVC(){
        mytopView.CloseCurruntVC(vc: self)
    }
 
}
