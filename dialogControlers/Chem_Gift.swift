//
//  Chem_Gift.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 25/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Chem_Gift: CustomUIViewController , UITableViewDataSource,CustomTextViewDelegate {
    func onTextChangeListner(sender: CustomTextView, text: String) {
        let tag = sender.getTag() as! Int
        switch tag {
        case Search_tag:
            searchInList(search: text)
            break
            
        default:
            print ("no tag assigned")
        }
    }
    @IBAction func pressedDoneButton(_ sender: CustomeUIButton) {
       
        let POB="0";
        let Rate="x";
        if( gift_typ == "dr"){
            cbohelp.deletedata(drid: Custom_Variables_And_Method.DR_ID, Rate: Rate)
        }
            for i in 0 ..< list.count {
                let check = list[i].isSelected();
                if (check) {
                    
                    id.append(list[i].getId());
                    item_list.append(list[i].getName());
                    
                    if (list[i].getScore() == nil || list[i].getScore() == ""){
                        score.append("0");
                    }else {
                        score.append(list[i].getScore());
                    }
                    if(list[i].getScore() != ("") && gift_typ == "dr"){
                        cbohelp.insertdata(drid: Custom_Variables_And_Method.DR_ID, item: list[i].getId(), item_name: list[i].getName(), qty: list[i].getScore(), pob: POB, stk_rate: Rate,visual: "0",noc: "0");
                    }
                }
            }
            
            
            for i in 0 ..< id.count {
                sb3 = "\(sb3)\(id[i]),"   // id
                item_list_string = "\(item_list_string)\(item_list[i]),"  //name
                sb2 = "\(sb2)\(score[i]),"    //pob
//                sb4 = "\(sb4)\(rate[i]),"    // rate
//                sb5 = "\(sb5)\(sample[i]),"    //sample
            }
        
            var ReplyMsg = [String : String]()
            ReplyMsg["val"]  = String(sb3.dropLast())
            ReplyMsg["val2"] = String(sb2.dropLast())
            ReplyMsg["resultList"] = String(item_list_string.dropLast())
            
            self.dismiss(animated: true, completion: nil)
            vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
    }
    
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var mySearchBar: CustomTextView!
    @IBOutlet weak var myTableView: UITableView!
    var objMyAdaptor : MyAdapter!
    
    
    var vc : CustomUIViewController!
    var responseCode : Int!
    
    
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var Search_tag = 1;
    var PA_ID = 0;
    
    var list = [GiftModel]();
    var id = [String](),score = [String](),sample = [String](),rate = [String](),item_list = [String]();    //data1, data2, data3, data5;
    var sb3 = "", sb2 = "", sb4 = "", sb5 = "",item_list_string = "";
    var mainval = 0.0;
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var callFromRcpa = "", drId = "", chemId = "", rcpaDate = "" ;
    var context : CustomUIViewController!;
    var gift_name="",gift_qty="",gift_typ = "chem"
    var gift_name_previous = "",gift_qty_previous = ""
    
    
    var MESSAGE_INTERNET=1;
    let MESSAGE_INTERNET_UTILITES=2
    var multiCallService : Multi_Class_Service_call!
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTopView.setText(title: "Gift...")
        
        progressHUD = ProgressHUD(vc : self)
        multiCallService = Multi_Class_Service_call()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myTableView.dataSource = self
        
        myTableView.separatorStyle = .none
        self.mySearchBar.delegate = self
        mySearchBar.setHint(placeholder: "Enter Name to Search..")
        mySearchBar.setTag(tag: Search_tag)
        self.myTableView.register(SamplePOBTableViewCell.self, forCellReuseIdentifier: "cell")
        
        gift_name  = VCIntent["gift_name"]!
        gift_qty  = VCIntent["gift_qty"]!
        gift_typ  = VCIntent["gift_typ"]!

        gift_name_previous  = VCIntent["gift_name_previous"]!
        gift_qty_previous  = VCIntent["gift_qty_previous"]!
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (list.count == 0) {
         
            customVariablesAndMethod.getAlert(vc: self,title: "No data found !!!",msg: "No product in the list\nUpload Download now..." , completion :  {_ in
                self.multiCallService.UploadDownLoad(vc: self, response_code: self.MESSAGE_INTERNET_UTILITES,progressHUD: self.progressHUD)
            });
            
        }
    }
    
    @objc func closeCurrentView()
    {
        myTopView.CloseCurruntVC(vc: self)
    }
    
    func getData(){
        
        do{
            list.removeAll()
            let ItemIdNotIn = "0";
            let statement = try cbohelp.getAllGifts(ItemIdNotIn: ItemIdNotIn);
            let db = cbohelp
            while let c = statement.next() {
                
                    list.append(
                        try GiftModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_name")] as! String, id: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_id")] as! String, rate: "",Stock: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "STOCK_QTY")]!))")!,Balance: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "BALANCE")]!))")!));
    
                
            }
            
            if (list.count != 0) {
                
                var gift_name1 = gift_name.components(separatedBy: ",")
                var gift_qty1 = gift_qty.components(separatedBy: ",")
                
                for i in 0 ..< gift_name1.count {
                    for j in 0 ..< list.count{
                        if (gift_name1[i] == list[j].getName()) {
                            list[j].setScore(score: gift_qty1[i]);
                            list[j].setSelected(selected: true)
                        }
                    }
                }
                
                
                var gift_name1_previous = gift_name_previous.components(separatedBy: ",")
                var gift_qty1_previous = gift_qty_previous.components(separatedBy: ",")
                
                for i in 0 ..< gift_name1_previous.count {
                    for j in 0 ..< list.count{
                        if (gift_name1_previous[i] == list[j].getName()) {
                            list[j].setBalance( Balance: list[j].getBalance() + Int(gift_qty1_previous[i])!);
                        }
                    }
                }
                
               
            }
            
            objMyAdaptor = MyAdapter(vc: self ,tableView : myTableView,  list : list, AdaptorType: "GIFT")
            
        }catch {
            print(error)
        }
        
        
    }
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
            
        case MESSAGE_INTERNET_UTILITES:
            multiCallService.parser_utilites( dataFromAPI  : dataFromAPI)
            myTopView.CloseAllVC(vc: self)
            break
        case 99:
            progressHUD.dismiss()
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            progressHUD.dismiss()
            print("Error")
        }
    }
    
   
    func searchInList(search : String){
        
        for l in 0 ..< list.count {
            if (search != "" && search.count <= list[l].getName().count) {
                if (list[l].getName().lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                    //mylist.smoothScrollToPosition(l);
                    let indexPath = IndexPath(row: l, section: 0)
                    myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    for j in l ..< list.count {
                        if (search.count <= list[j].getName().count) {
                            if (list[j].getName().lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                                list[j].setHighlight(highlight: true);
                            }else{
                                list[j].setHighlight(highlight: false);
                            }
                        }else{
                            list[j].setHighlight(highlight: false);
                        }
                    }
                    break;
                }else{
                    list[l].setHighlight(highlight: false);
                }
            }else{
                list[l].setHighlight(highlight: false);
            }
        }
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return objMyAdaptor.getView( index: indexPath.row)
    }
    
}

