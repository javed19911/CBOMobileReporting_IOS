//
//  FilterView.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 26/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//
import UIKit

class FilterView: CustomUIViewController , UITableViewDataSource , UITableViewDelegate,CustomTextViewDelegate {
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
    var multiCallService : Multi_Class_Service_call!
    var progressHUD : ProgressHUD!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var mySearchBar: CustomTextView!
    
    
    
    //let data = [1,2,3,4,5,6,7,8,9,10]
    @IBOutlet weak var cancleBtn: CustomeUIButton!
    var customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
    var cbohelp = CBO_DB_Helper.shared
    var syncServices: SyncService!
    var progess : ProgressHUD!
    var vc : CustomUIViewController!
    var dr_List = [SpinnerModel]()
    var items = [DPItem]()
    var responseCode : Int!
    var showGeoFencing : Int = 0
    var callTyp = "D"
    var Search_tag = 1;
    let MESSAGE_INTERNET_SYNC=1,MESSAGE_INTERNET_DOWNLOADALL = 2
    var ReplyMsg = [String : String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progess = ProgressHUD(vc: self)
        multiCallService = Multi_Class_Service_call()
        myTableView.delegate = self
        self.mySearchBar.delegate = self
        mySearchBar.setTag(tag: Search_tag)
        mySearchBar.setHint(placeholder: "Enter Name to Search..")
        
        showGeoFencing = Int(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: self, key: "IsBackDate", defaultValue: "0"))!
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        myTopView.setText(title: VCIntent["title"]!)
        
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
       
        cancleBtn.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        
        
        self.myTableView.dataSource = self
        self.myTableView.register(CallRowCellTableViewCell.self, forCellReuseIdentifier: "cell")
        
        if items.count == 0{
            var title = "Doctor"
            switch callTyp{
            case "C":
                title = "Chemist"
                break
            case "S" :
                title = "Stockist"
                break
            case "D" :
                title = "Doctor"
                break
            default:
                title = "Data"
            }
            
            customVariablesAndMethod.msgBox(vc: vc, msg: "No \(title) in List")
        }
        
    }
    
   
    
    @objc func closeCurrentView()
    {
        myTopView.CloseCurruntVC(vc: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FilterViewRow", owner: self, options: nil)?.first as! FilterViewRow
        
        cell.selectionStyle = .none
        
        let tempValues = items[indexPath.row]
        
        cell.myLabel.text = tempValues.title
        
        if (tempValues.isHighlighted()){
           
            cell.myLabel.textColor = UIColor(hex: "FF8333");
        }
        return cell
    }
    
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ReplyMsg.removeAll()
        ReplyMsg["Selected_Index"]  = "\(indexPath.row)"
      
            self.dismiss(animated: true, completion: nil)
            vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
        
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case MESSAGE_INTERNET_SYNC:
            syncServices.parser_sync(result: dataFromAPI)
            self.dismiss(animated: true, completion: nil)
            self.vc.getDataFromApi(response_code: self.responseCode, dataFromAPI: ["data" : [ReplyMsg]])
            
            
        case MESSAGE_INTERNET_DOWNLOADALL:
            multiCallService.parser_DCRCOMMIT_DOWNLOADALL(dataFromAPI : dataFromAPI)
            
            customVariablesAndMethod.getAlert(vc: self, title: "Refreshed...", msg: "DCR Sucessfully Refreshed...")
            break;
        case 99:
            progess.dismiss()
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            self.dismiss(animated: true, completion: nil)
            print("Error")
        }
        progess.dismiss()
    }
    
    func searchInList(search : String){
        
        for l in 0 ..< items.count {
            if (search != "" && search.count <= items[l].title.count) {
                if (items[l].title.lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                    //mydr_List.smoothScrollToPosition(l);
                    let indexPath = IndexPath(row: l, section: 0)
                    myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    for j in l ..< items.count {
                        if (search.count <= items[j].title.count) {
                            if (items[j].title.lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                                items[j].setHighlight(highlight: true);
                            }else{
                                items[j].setHighlight(highlight: false);
                            }
                        }else{
                            items[j].setHighlight(highlight: false);
                        }
                    }
                    break;
                }else{
                    items[l].setHighlight(highlight: false);
                }
            }else{
                items[l].setHighlight(highlight: false);
            }
        }
        myTableView.reloadData()
    }
    
}

