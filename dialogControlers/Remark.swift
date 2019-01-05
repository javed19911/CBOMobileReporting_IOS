//
//  Remark.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 22/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class Remark : CustomUIViewController , UITableViewDataSource , UITableViewDelegate,CustomTextViewDelegate {
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
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var mySearchBar: CustomTextView!
    @IBOutlet weak var cancleBtn: CustomeUIButton!
    
    var vc : CustomUIViewController!
    var List = [String]()
    var IsHighlighted = [Bool]()
    var responseCode : Int!
    var Search_tag = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        self.mySearchBar.delegate = self
        mySearchBar.setTag(tag: Search_tag)
        mySearchBar.setHint(placeholder: "Enter Name to Search..")
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        myTopView.setText(title: VCIntent["title"]!)
        
        for _ in 0 ..< List.count{
            IsHighlighted.append(false)
        }
        
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        
        self.myTableView.dataSource = self
        self.myTableView.register(CallRowCellTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    @objc func closeCurrentView()
    {
        myTopView.CloseCurruntVC(vc: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CallRowCellTableViewCell", owner: self, options: nil)?.first as! CallRowCellTableViewCell
        cell.selectionStyle = .none
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        
        cell.lblName.text = List[indexPath.row]
       
         cell.rightView.isHidden = true
        if (IsHighlighted[indexPath.row]){
            cell.lblName.textColor = UIColor(hex: "FF8333");
        }else {
            cell.lblName.textColor = UIColor(hex: "000000");
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ReplyMsg = [String : String]()
        ReplyMsg["Selected_Index"]  = "\(indexPath.row)"
        self.dismiss(animated: true, completion: nil)
        vc.getDataFromApi(response_code: responseCode, dataFromAPI: ["data" : [ReplyMsg]])
    }
    
    func searchInList(search : String){
        
        for l in 0 ..< List.count {
            if (search != "" && search.count <= List[l].count) {
                if (List[l].lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                    //mydr_List.smoothScrollToPosition(l);
                    let indexPath = IndexPath(row: l, section: 0)
                    myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    for j in l ..< List.count {
                        if (search.count <= List[j].count) {
                            if (List[j].lowercased().contains(search.lowercased().trimmingCharacters(in: .whitespaces))) {
                                IsHighlighted[j] =  true
                            }else{
                                 IsHighlighted[j] =  false                            }
                        }else{
                            IsHighlighted[j] =  false
                        }
                    }
                    break;
                }else{
                   IsHighlighted[l] =  false
                }
            }else{
                IsHighlighted[l] =  false
            }
        }
        myTableView.reloadData()
    }
    
}

