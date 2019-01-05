//
//  Chm_sample.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 17/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Chm_sample: CustomUIViewController , UITableViewDataSource,CustomTextViewDelegate {
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
        if (callFromRcpa == "intent_fromRcpaCAll") {
//            StringBuilder sbItemId = new StringBuilder();
//            StringBuilder sbQty = new StringBuilder();
//            StringBuilder sbProduct = new StringBuilder();
//            StringBuilder sbRemark = new StringBuilder();
//
//            int j = 0;
//            for (int i = 0; i < list.size(); i++) {
//                boolean check = list.get(i).isSelected();
//                if (check) {
//                    if (j == 0) {
//                        if (list.get(i).getScore()!=null && !list.get(i).getScore().equals("")){
//                            sbItemId.append(list.get(i).getId());
//                            sbQty.append(list.get(i).getScore());
//                            sbProduct.append(list.get(i).getSample());
//                            sbRemark.append(list.get(i).getRate());
//                        }
//                    } else {
//                        if (list.get(i).getScore()!=null && !list.get(i).getScore().equals("")){
//                            sbItemId.append("^").append(list.get(i).getId());
//                            sbQty.append("^").append(list.get(i).getScore());
//                            sbProduct.append("^").append(list.get(i).getSample());
//                            sbRemark.append("^").append(list.get(i).getRate());
//                        }
//                    }
//
//                    j = j + 1;
//                } else {
//
//                    id.remove(check);
//                    score.remove(check);
//                    rate.remove(check);
//                    mainval = 0.0;
//                }
//
//
//            }
//            if (sbItemId.length() > 0) {
//
//                //Start of call to service
//
//                HashMap<String,String> request=new HashMap<>();
//                request.put("sCompanyFolder",cbohelp.getCompanyCode());
//                request.put("iPA_ID", ""+Custom_Variables_And_Method.PA_ID);
//                request.put("iDCR_ID",Custom_Variables_And_Method.DCR_ID);
//                request.put("iDR_ID", drId);
//                request.put("iCHEM_ID",chemId);
//
//                request.put("sMONTH","");
//                request.put("iITEM_ID", sbItemId.toString());
//                request.put("sITEM_NAME",sbProduct.toString());
//                request.put("sQTY", sbQty.toString());
//                request.put("sREMARK",sbRemark.toString());
//
//                ArrayList<Integer> tables=new ArrayList<>();
//                tables.add(0);
//
//                progress1.setMessage("Please Wait..\n" +
//                " Fetching data");
//                progress1.setCancelable(false);
//                progress1.show();
//
//                new CboServices(context,mHandler).customMethodForAllServices(request,"RCPA_COMMIT",MESSAGE_INTERNET,tables);
//
//                //End of call to service
//
//                //String myDcrId = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(context,"DCR_ID");
//                //cbohelp.insertDataRcpa("" + myDcrId, "" + Custom_Variables_And_Method.PA_ID, drId, chemId, rcpaDate, sbItemId.toString(), sbQty.toString());
//
//                //startActivity(new Intent(getApplicationContext(), ViewPager_2016.class));
//            }
//
            
            //customVariablesAndMethod.msgBox(context,"Successfully Submitted....");
        } else {
            
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
                    
                    if (list[i].getSample() == nil || list[i].getSample() == ""){
                        sample.append("0");
                    }else {
                        sample.append(list[i].getSample());
                    }
                    
                    // data2.add(list.get(i).getSample());
                    rate.append(list[i].getRate());
                 
                }
                
            }
            
            
            for i in 0 ..< id.count {
                sb3 = "\(sb3)\(id[i]),"   // id
                item_list_string = "\(item_list_string)\(item_list[i]),"  //name
                sb2 = "\(sb2)\(score[i]),"    //pob
                sb4 = "\(sb4)\(rate[i]),"    // rate
                sb5 = "\(sb5)\(sample[i]),"    //sample
                
              
            }
            
            
            var rateval = sb4
            
            if (rate.isEmpty || id.isEmpty) {
                mainval = 0.0;
                rateval += "0.0,"
            }
            
            var rateval1 = rateval.components(separatedBy: ",")
            var intarray = [String]()
            for i in 0 ..< rateval1.count - 1{
                intarray.append(rateval1[i]);
            }
           
            
            
            var pobval = sb2
            if (rate.isEmpty || id.isEmpty) {
                mainval = 0.0;
                pobval += "0.0,"
            }
            var sampleQty = sb5
            if (sample.isEmpty || id.isEmpty) {
                mainval = 0.0;
                pobval += "0.0,"
            }
            
            var pobval1 = pobval.components(separatedBy: ",")
            var pobarray = [String]()
            for i in 0 ..< pobval1.count - 1{
                pobarray.append(pobval1[i]);
            }
            
          
            if (rate.isEmpty || id.isEmpty) {
                mainval += 0.0;
            }
            
            
            for i in 0 ..< intarray.count {
                if (self.rate.isEmpty || self.id.isEmpty) {
                    pobval += "0.0,"
                    rateval += "0.0,"
                    pobarray[i] = "0.0";
                    intarray[i] = "0.0";
                    self.mainval += 0.0;
                }
            
             mainval += (Double(pobarray[i])! * Double(intarray[i])!);
           
            
            }
           
            var ReplyMsg = [String : String]()
            ReplyMsg["val"]  = sb3
            ReplyMsg["val2"] = sb2
            ReplyMsg["sampleQty"] = sb5
            ReplyMsg["resultpob"] = "\(mainval)"
            ReplyMsg["resultList"] = item_list_string
            
            self.dismiss(animated: true, completion: nil)
            vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
            
            
        }
    
    }


    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var mySearchBar: CustomTextView!
    @IBOutlet weak var myTableView: UITableView!
    var objMyAdaptor : MyAdapter!
    
    
    var vc : CustomUIViewController!
    var dr_List = [SpinnerModel]()
    var responseCode : Int!
    var showGeoFencing : Int = 0
    
   
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
    var sample_name="",sample_pob="",sample_sample="";
    var sample_name_previous="",sample_pob_previous="",sample_sample_previous="";
    
    
    var MESSAGE_INTERNET=1;
    let MESSAGE_INTERNET_UTILITES=2
    var multiCallService : Multi_Class_Service_call!
    var progressHUD : ProgressHUD!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTopView.setText(title: "Sample/POB")
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        
        progressHUD = ProgressHUD(vc : self)
        multiCallService = Multi_Class_Service_call()
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myTableView.dataSource = self
        self.mySearchBar.delegate = self
        mySearchBar.setHint(placeholder: "Enter Name to Search..")
        mySearchBar.setTag(tag: Search_tag)
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
            let statement = try cbohelp.getAllProducts(itemidnotin: ItemIdNotIn);
            let db = cbohelp
            while let c = statement.next() {
                    if (callFromRcpa == "intent_fromRcpaCAll") {
                        list.append(
                            try GiftModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_name")] as! String, id: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_id")] as! String, rate: ""));
                    }else {
                        try list.append( GiftModel(name: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_name")] as! String, id: c[db.getColumnIndex(statement: statement, Coloumn_Name: "item_id")] as! String, rate: "\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "stk_rate")]!))",Stock: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "STOCK_QTY")]!))")!,Balance: Int("\(String(describing: c[db.getColumnIndex(statement: statement, Coloumn_Name: "BALANCE")]!))")!))
                    }
                }
            
            if (list.count != 0) {
                
                var sample_name1 = sample_name.components(separatedBy: ",")
                var sample_qty1 = sample_sample.components(separatedBy: ",")
                var sample_pob1 = sample_pob.components(separatedBy: ",")
                
                for i in 0 ..< sample_name1.count {
                    for j in 0 ..< list.count{
                        if (sample_name1[i] == list[j].getName()) {
                            list[j].setScore(score: sample_pob1[i]);
                            list[j].setSample(sample: sample_qty1[i]);
                            list[j].setSelected(selected: true)
                        }
                    }
                }
                
                let sample_name1_previous = sample_name_previous.components(separatedBy: ",")
                let sample_qty1_previous = sample_sample_previous.components(separatedBy: ",")
                // let sample_pob1_previous = sample_pob_previous.components(separatedBy: ",")
                
                for i in 0 ..< sample_name1_previous.count {
                    for j in 0 ..< list.count{
                        if (sample_name1_previous[i] == list[j].getName()) {
                           list[j].setBalance(Balance: list[j].getBalance() + Int(sample_qty1_previous[i])!);
                        }
                    }
                }
            }
            objMyAdaptor = MyAdapter(vc: self ,tableView : myTableView,  list : list)
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
