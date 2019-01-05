//
//  dr_Sample.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 24/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//


import UIKit

class dr_Sample: CustomUIViewController, UITableViewDataSource,CustomTextViewDelegate {
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
                
                if (check && Mainlist[i].getPob()  != "") {
                    total_pob = Mainlist[i].getPob()
                    break;
                }
            }
        }
            
        if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context,key: "SAMPLE_POB_MANDATORY",defaultValue: "") == "Y" && total_pob == "") {
            customVariablesAndMethod.msgBox(vc: context,msg: "POB can't be blank");
        }else {
            saveDoctorSample_CheckPob();
        }
    }
    
    
    func saveDoctorSample_CheckPob() {
    
        var checkIfPOB_Entered = false;
        var Qty = "";
        var POB = "";
        var Rate = "";
        var NOC = "";
        data1.removeAll()
        data2.removeAll()
        data3.removeAll()
        data4.removeAll()
        data5.removeAll()
        var check_Rx : Bool ,check : Bool;
        
        var getPrescribeRx_Dr = [String]();
        var sb_rx = String();
        var j = 0;
        var seprator = "";
        cbohelp.deletedata(drid: dr_id,Rate: "")
    
        for i in 0 ..< Mainlist.count{
        
            check = Mainlist[i].isSelected();
            check_Rx = Mainlist[i].isSelected_Rx();
            if (check_Rx) {
            
                if (j==0){
                    seprator = "";
                }else {
                    seprator = ",";
                }
            
                sb_rx = sb_rx + seprator + Mainlist[i].getId()  + ","
                
            
            }
    
            if (check) {
                checkIfPOB_Entered=true;
                data1.append(Mainlist[i].getId());
                data2.append(Mainlist[i].getScore());
                data5.append(Mainlist[i].getName());
                data3.append(Mainlist[i].getPob());
                data4.append(Mainlist[i].getRate());
                Qty = Mainlist[i].getScore();
                POB = Mainlist[i].getPob();
                Rate = Mainlist[i].getRate();
                NOC = Mainlist[i].getNOC();
                if (Qty == "") {
                    Qty = "0";
                }
                if (POB == "") {
                    POB = "0";
                }
                if (Rate == "") {
                    Rate = "0";
                }
                if (NOC == "") {
                    NOC = "0";
                }
                var doclist = cbohelp.getDoctorList();
                var docitems = cbohelp.getDoctorAllItems();
                var visual_id = cbohelp.getDoctorVisualId();
                var actlist = getdoclist();
                if (actlist.contains(Int(dr_id)!)) {
                    if (visual_id.contains("1")) {
                    //cbohelp.deletedata(Custom_Variables_And_Method.DR_ID, list.get(i).getId());
                        cbohelp.insertdata(drid: dr_id, item: Mainlist[i].getId(), item_name: Mainlist[i].getName(), qty: Qty, pob: POB, stk_rate: Rate, visual: "1",noc: NOC);
                    } else {
                    
                    print("no updation in sample", "no update");
                    //cbohelp.deletedata(Custom_Variables_And_Method.DR_ID, list.get(i).getId());
                        cbohelp.insertdata(drid: dr_id, item: Mainlist[i].getId(), item_name: Mainlist[i].getName(), qty: Qty, pob: POB, stk_rate: Rate, visual: "0",noc: NOC);
                    }
                
                } else {
                
                    cbohelp.insertdata(drid: dr_id, item: Mainlist[i].getId(), item_name: Mainlist[i].getName(), qty: Qty, pob: POB, stk_rate: Rate, visual: "0",noc: NOC);
                }
    
    
            }
    
        }
    
//        for k in  0 ..< data1.count {
//            itemid.append(data1.get(k)).append(",");
//            itemname.append(data5.get(k)).append(",");
//            itemqty.append(data2.get(k)).append(",");
//            itempob.append(data3.get(k)).append(",");
//        }
    
        if (sb_rx != "") {
            getPrescribeRx_Dr = cbohelp.getDr_Rx_id();
            if (getPrescribeRx_Dr.contains(dr_id)) {
                cbohelp.updateDr_Rx_Data(dr_id: dr_id,  item_id: sb_rx);
            } else if (getPrescribeRx_Dr.count >= 0) {
                cbohelp.insert_drRx_Data(drid: dr_id,  item: sb_rx);
            }
        }
        
//        item_id = itemid.toString();
//        item_name = itemname.toString();
//        item_qty = itemqty.toString();
//        item_pob = itempob.toString();
        
//        Intent i = new Intent();
//        if (checkIfPOB_Entered) {
//        i.putExtra("val", "");
//        i.putExtra("val2", "");
//        i.putExtra("val3", "");
//        i.putExtra("resultpob", mainval);
//        setResult(RESULT_OK, i);
//        }else{
//        setResult(RESULT_CANCELED, i);
//        }
       
        if (checkIfPOB_Entered) {
            var ReplyMsg = [String : String]()
            ReplyMsg["val"]  = ""
            ReplyMsg["val2"] = ""
            ReplyMsg["sampleQty"] = ""
            ReplyMsg["resultpob"] = "\(mainval)"
            ReplyMsg["resultList"] = item_list_string
            
            self.dismiss(animated: true, completion: nil)
            vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
        }else{
            
        }
    
    }
    
    
    func getdoclist() -> [Int] {
        var myno = [Int]();
        var doclist = cbohelp.getDoctorList();
        for i in 0 ..< doclist.count {
            myno.append(Int(doclist[i])!);
        }
    return myno;
    }
    
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var mySearchBar: CustomTextView!
    //let data = ["adnfeqkbfaewfbfb","cbnqefwefbfwbkf", "b" ,"e","q" ]
    @IBOutlet weak var myTableView: UITableView!
    var objMyAdaptor : PobAdapter!
    
    var vc : CustomUIViewController!
    var responseCode : Int!
    
    var Search_tag = 1;
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var PA_ID = 0;
    var dr_id = "0"
    var Mainlist = [PobModel]();
    var id = [String](),score = [String](),sample = [String](),rate = [String](),item_list = [String](), data1 = [String](), data2 = [String](), data3 = [String](), data5 = [String](),data4 = [String]();
    var sb3 = "", sb2 = "", sb4 = "", sb5 = "",item_list_string = "";
    var mainval = 0.0;
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
    var callFromRcpa = "", drId = "", chemId = "", rcpaDate = "" ;
    var context : CustomUIViewController!;
    var sample_name="",sample_pob="",sample_sample="",sample_noc="";
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
        
        sample_name = VCIntent["sample_name"]!
        sample_pob = VCIntent["sample_pob"]!
        sample_sample = VCIntent["sample_sample"]!
        sample_noc = VCIntent["sample_noc"]!
        
        sample_name_previous = VCIntent["sample_name_previous"]!
        sample_pob_previous = VCIntent["sample_pob_previous"]!
        sample_sample_previous = VCIntent["sample_sample_previous"]!
        
        PA_ID = Custom_Variables_And_Method.PA_ID;
        dr_id=Custom_Variables_And_Method.DR_ID;
        
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
          
            let statement = try cbohelp.getAllProducts(itemidnotin: dr_id);
            let db = cbohelp
            while let c = statement.next() {
                
                    Mainlist.append(
                        try PobModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_name")]! as! String, id: "\(c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_id")]!)", rate:  "\(c[db.getColumnIndex(statement: statement, Coloumn_Name: "stk_rate")]!)", dr_item: c[db.getColumnIndex(statement: statement, Coloumn_Name: "sn")]! as! String,Stock: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "STOCK_QTY")]!))")!,Balance: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "BALANCE")]!))")!))
                
            }
            
            if (Mainlist.count != 0) {
                var sample_name1 = sample_name.components(separatedBy: ",")
                var sample_qty1 = sample_sample.components(separatedBy: ",")
                var sample_pob1 = sample_pob.components(separatedBy: ",")
                var sample_noc1 = sample_noc.components(separatedBy: ",")
                for i in 0 ..< sample_name1.count {
                    for j in 0 ..< Mainlist.count{
                        if (sample_name1[i] == Mainlist[j].getName()) {
                            Mainlist[j].setPob(pob: sample_pob1[i]);
                            Mainlist[j].setScore(score: sample_qty1[i]);
                            Mainlist[j].setNOC(noc: sample_noc1[i]);
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
            
            objMyAdaptor = PobAdapter(vc: self ,tableView : myTableView,  list : Mainlist)
            
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

