//
//  stk_sample.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 18/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class stk_sample: CustomUIViewController, UITableViewDataSource,CustomTextViewDelegate {
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
        var total_pob = "";
        var count = false,check : Bool;
        
        for i in 0 ..< Mainlist.count{
            check = Mainlist[i].isSelected();
            if (check ) {
                count = true;
                break;
            }
        }
        
        if (count) {
            item_list.removeAll()
            data1.removeAll()
            data2.removeAll()
            data3.removeAll()
            data5.removeAll()
            for i in 0 ..< Mainlist.count{
                check = Mainlist[i].isSelected();
                
                if (check && Mainlist[i].getScore()  != "") {
                    total_pob = Mainlist[i].getScore()
                    break;
                }
            }
            do {
            
               for i in 0 ..< Mainlist.count{
                    check = Mainlist[i].isSelected();
                    if (check) {
                        data1.append(Mainlist[i].getId());
                        item_list.append(Mainlist[i].getName());
                        //pob
                        if (Mainlist[i].getScore() == nil || Mainlist[i].getScore() == "") {
                            data2.append("0");
                        } else {
                            data2.append(Mainlist[i].getScore());
                        }
            
                        data3.append(Mainlist[i].getRate());
                        //sample
                        if (Mainlist[i].getSample() == nil || Mainlist[i].getSample() == "") {
                            data5.append("0");
                        } else {
                            data5.append(Mainlist[i].getSample());
                        }
                    }
            
                }
            
            
                for i in 0 ..< data1.count{
            
                    sb3 = "\(sb3)\(data1[i]),"   // id
                    item_list_string = "\(item_list_string)\(item_list[i]),"  //name
                    sb2 = "\(sb2)\(data2[i]),"    //pob
                    sb4 = "\(sb4)\(data3[i]),"    // rate
                    sb5 = "\(sb5)\(data5[i]),"    //sample
                }
            
                var rateval =  sb4
                if (data3.isEmpty || data1.isEmpty) {
                    mainval = 0.0;
                    rateval += "0.0,";
                }
                //rateval = String(rateval.dropLast())
                var rateval1 = rateval.components(separatedBy: ",")
                var intarray = [String]()
                 for i in 0 ..< rateval1.count - 1{
                    intarray.append(rateval1[i]);
                }
            
                var pobval = sb2
                if (data3.isEmpty || data1.isEmpty) {
                    mainval = 0.0;
                    pobval += "0.0,";
                }
                
                //pobval = String(pobval.dropLast())
                var pobval1 = pobval.components(separatedBy: ",")
                var pobarray =  [String]();
                 for i in 0 ..< pobval1.count - 1{
                    pobarray.append(pobval1[i]);
                }
                
                for i in 0 ..< intarray.count{
                    if (data3.isEmpty || data1.isEmpty) {
                        pobval += " 0.0,";
                        rateval += "0.0,";
                        pobarray[i] = "0.0";
                        intarray[i] = "0.0";
                        mainval += 0.0;
                    }
                    
                    do {
                        mainval += (Double(pobarray[i])! * Double(intarray[i])!);
                    } catch {
                       print(error);
                    }
                }
            } catch {
                customVariablesAndMethod.getAlert(vc: vc, title: "Invalid Entry", msg: "Wrong Input Please Try Again..");
            }
        }
        if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "SAMPLE_POB_MANDATORY",defaultValue: "N") == "Y" && total_pob == "") {
            customVariablesAndMethod.getAlert(vc: vc, title: "Alert !!!", msg: "POB can't be blank");
            sb2 = ""
            sb3 = ""
            sb4 = ""
            sb5 = ""
            item_list_string = ""
        }else {
            var ReplyMsg = [String : String]()
            ReplyMsg["val"]  = String(sb3.dropLast())
            ReplyMsg["val2"] = String(sb2.dropLast())
            ReplyMsg["sampleQty"] = String(sb5.dropLast())
            ReplyMsg["resultpob"] = "\(mainval)"
            ReplyMsg["resultList"] = String(item_list_string.dropLast())
            
            self.dismiss(animated: true, completion: nil)
            vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
        }
    }
    
    
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var mySearchBar: CustomTextView!
    //let data = ["adnfeqkbfaewfbfb","cbnqefwefbfwbkf", "b" ,"e","q" ]
    @IBOutlet weak var myTableView: UITableView!
    var objMyAdaptor : MyAdapter!
    
    var vc : CustomUIViewController!
    var responseCode : Int!
    
    var Search_tag = 1;
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var PA_ID = 0;
    
    var Mainlist = [GiftModel]();
    var id = [String](),score = [String](),sample = [String](),rate = [String](),item_list = [String](), data1 = [String](), data2 = [String](), data3 = [String](), data5 = [String]();
    var sb3 = "", sb2 = "", sb4 = "", sb5 = "",item_list_string = "";
    var mainval = 0.0;
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var callFromRcpa = "", drId = "", chemId = "", rcpaDate = "" ;
    var context : CustomUIViewController!;
    var sample_name="",sample_pob="",sample_sample="";
    var sample_name_previous="",sample_pob_previous="",sample_sample_previous="";
    
    
    
    var MESSAGE_INTERNET=1;
    let MESSAGE_INTERNET_UTILITES=2
    var multiCallService : Multi_Class_Service_call!
    var progressHUD : ProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTopView.setText(title: "Sample/POB")
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        context = self
        progressHUD = ProgressHUD(vc : self)
        multiCallService = Multi_Class_Service_call()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myTableView.dataSource = self
        self.mySearchBar.delegate = self
        mySearchBar.setTag(tag: Search_tag)
        mySearchBar.setHint(placeholder: "Enter Name to Search..")
        self.myTableView.register(SamplePOBTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        callFromRcpa = VCIntent["intent_fromRcpaCAll"]!;
        
        if (callFromRcpa == "intent_fromRcpaCAll") {
            drId = VCIntent["dr_id"]!
            chemId = VCIntent["chm_id"]!
            rcpaDate = VCIntent["dateMMDDYY"]!
            myTopView.setText(title: "Prescribe");
            
        }else{
            
            sample_name = VCIntent["sample_name"]!
            sample_pob = VCIntent["sample_pob"]!
            sample_sample = VCIntent["sample_sample"]!
            
            sample_name_previous = VCIntent["sample_name_previous"]!
            sample_pob_previous = VCIntent["sample_pob_previous"]!
            sample_sample_previous = VCIntent["sample_sample_previous"]!

        }
        
        getData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (Mainlist.count == 0) {
            
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
            Mainlist.removeAll()
            let ItemIdNotIn = "0";
            let statement = try cbohelp.getAllProducts(itemidnotin: ItemIdNotIn);
            let db = cbohelp
            while let c = statement.next() {
                if (callFromRcpa == "intent_fromRcpaCAll") {
                    Mainlist.append(
                        try GiftModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_name")]! as! String, id: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_id")]! as! String, rate: ""));
                }else {
            
                    try Mainlist.append( GiftModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_name")]! as! String, id: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_id")]! as! String, rate: "\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "stk_rate")]!))",Stock: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "STOCK_QTY")]!))")!,Balance: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "BALANCE")]!))")!))
                }
                
            }
           
            if (Mainlist.count != 0) {
                let sample_name1 = sample_name.components(separatedBy: ",")
                let sample_qty1 = sample_sample.components(separatedBy: ",")
                let sample_pob1 = sample_pob.components(separatedBy: ",")
                
                for i in 0 ..< sample_name1.count {
                    for j in 0 ..< Mainlist.count{
                        if (sample_name1[i] == Mainlist[j].getName()) {
                            Mainlist[j].setScore(score: sample_pob1[i]);
                            Mainlist[j].setSample(sample: sample_qty1[i]);
                            Mainlist[j].setSelected(selected: true)
                        }
                    }
                }
                
                let sample_name1_previous = sample_name_previous.components(separatedBy: ",")
                let sample_qty1_previous = sample_sample_previous.components(separatedBy: ",")
               // let sample_pob1_previous = sample_pob_previous.components(separatedBy: ",")
                
                for i in 0 ..< sample_name1_previous.count {
                    for j in 0 ..< Mainlist.count{
                        if (sample_name1_previous[i] == Mainlist[j].getName()) {
                            Mainlist[j].setBalance(Balance: Mainlist[j].getBalance() + Int(sample_qty1_previous[i])!);
                        }
                    }
                }
                
            }
            
            objMyAdaptor = MyAdapter(vc: self ,tableView : myTableView,  list : Mainlist)
            
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
        
        for l in 0 ..< Mainlist.count {
            if (search != "" && search.count <= Mainlist[l].getName().count) {
                if (Mainlist[l].getName().lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                    //mylist.smoothScrollToPosition(l);
                    let indexPath = IndexPath(row: l, section: 0)
                    myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    for j in l ..< Mainlist.count {
                        if (search.count <= Mainlist[j].getName().count) {
                            if (Mainlist[j].getName().lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                                Mainlist[j].setHighlight(highlight: true);
                            }else{
                                Mainlist[j].setHighlight(highlight: false);
                            }
                        }else{
                            Mainlist[j].setHighlight(highlight: false);
                        }
                    }
                    break;
                }else{
                    Mainlist[l].setHighlight(highlight: false);
                }
            }else{
                Mainlist[l].setHighlight(highlight: false);
            }
        }
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Mainlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return objMyAdaptor.getView( index: indexPath.row)
    }

}
