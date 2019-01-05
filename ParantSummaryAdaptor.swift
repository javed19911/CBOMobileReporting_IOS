//
//  ParantSummaryAdaptor.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 03/04/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit



protocol ParantSummaryAdaptorDalegate  {
    func onEdit(id : String , name : String)
    func onDelete(id : String , name: String)
}


class ParantSummaryAdaptor: NSObject , UITableViewDelegate , UITableViewDataSource{
        
    var delegate : ParantSummaryAdaptorDalegate?
    var isCollaps = [Bool]()
    var tableView : UITableView!
    var headers = [String]()
    var i = 0
    var isCellCollaps = [[Bool]]()
    
    private var total_Exps_height : CGFloat = 165.0
    
    var chemist_list = [String : [String]]()
    var doctor_list = [String : [String]]()
    var stockist_list = [String : [String]]()
    
    var gift_name="",gift_qty="";
    var sample = "0.0";
    var sample_name="",sample_pob="",sample_sample="" , sample_noc = "";
    var name2 = "", name3 = "", name4 = "";
    var name = "", chm_id = "", chm_name = "",resultList="",dr_name_reg="",dr_id_reg = "",dr_id_index = "";
    

    var  summaryData = [[String : [String : [String]]]]()
    let cbohelp = CBO_DB_Helper.shared
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var context : CustomUIViewController!
    init(tableView : UITableView , vc : CustomUIViewController , summaryData : [[String : [String : [String]]]] , headers :[String] , isCollaps : [Bool] ) {
        super.init()

        context = vc
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        self.summaryData = summaryData
        self.tableView = tableView
        self.isCollaps = isCollaps
        self.headers = headers
        
        let headerNib = UINib.init(nibName: "ExpandableTableViewHeader", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ExpandableTableViewHeader")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
   
    
    @objc func pressedEditButton(sender : UIButton){
  
        print(sender.tag , sender.descriptiveName!)

        delegate?.onEdit(id: "\(sender.tag)", name:sender.descriptiveName!)
        
       
        
    }
    
    
//    func getItemName(id : Int) -> String{
//        var j = 0
//        var name = ""
//        for i in 0 ..< headers.count{
//            let child_List  = getChild(groupPosition: i, childname:  headers[i])
//            print(child_List["id"]!)
//            for id in child_List["id"]!{
//                if "\(id)" == id {
//                    print(child_List["name"]![j])
//                    name = (child_List["name"]![j])
//                }
//                j += 1
//            }
//        }
//        return name
//    }
    
    
    @objc func pressedDeleteButton(sender : UIButton){
        
        delegate?.onDelete(id: "\(sender.tag)", name:sender.descriptiveName!)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCollaps[indexPath.section] == true {
            return 0
        }else {
            return  UITableViewAutomaticDimension
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
         return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  getChildCount(groupPosition: section, childname: headers[section])
    }
   
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let child_List  = getChild(groupPosition: indexPath.section, childname:  headers[indexPath.section])
        
        let cell = Bundle.main.loadNibNamed("ExpandableInnerCell", owner: self, options: nil)?.first as! ExpandableInnerCell
         cell.selectionStyle = .none
        do{
            
                if ( child_List["name"]!.count == 1 && "\(String(describing: child_List["name"]![0]))" == "Yet to make your first Call"){
                    cell.name?.textColor = UIColor.red
                    cell.calltime.isHidden = true
                    cell.watch.isHidden = true
                    cell.signLabel.isHidden = true
                    cell.deleteButton.isHidden = true
                    cell.editButton.isHidden = true
                    cell.remarkContraint.isActive = false
                    
                }else if ("\(try cbohelp.getMenuNew(menu: "DCR", code: "D_EXP").getString(key: "D_EXP"))" == "\(headers[indexPath.section])") {
//                    cell.watch.isHidden = true
//                    cell.calltime.isHidden = false
//                    cell.signLabel.isHidden = true
//                    cell.signLabel?.textColor = AppColorClass.colorPrimaryDark
//                    cell.name?.textColor = AppColorClass.colorPrimaryDark
//                    cell.calltime.font = UIFont.boldSystemFont(ofSize: 13.0)
//
                        return UITableViewCell()
                    
                }else {
                   
                    cell.signLabel?.textColor = AppColorClass.colorPrimaryDark
                    cell.name?.textColor = AppColorClass.colorPrimaryDark
                    
                    cell.signLabel.text = (child_List["visible_status"]![indexPath.row] == "0" ? "+" : "-" )
                    cell.calltime.text = "\(String(describing: child_List["time"]![indexPath.row]))"
                   
                    

                    cell.watch.isHidden =  isCollaps[indexPath.section]
                    cell.calltime.isHidden = isCollaps[indexPath.section]
                    cell.signLabel.isHidden =  isCollaps[indexPath.section]
                    cell.remarkLabel.isHidden =  isCollaps[indexPath.section]
                    
                    
                    cell.deleteButton.isHidden = (child_List["show_edit_delete"]![indexPath.row] == "0" ? true : false )
                    
                    cell.editButton.isHidden = (child_List["show_edit_delete"]![indexPath.row] == "0" ? true : false  )
                    
                    cell.remarkContraint.isActive = (child_List["show_edit_delete"]![indexPath.row] == "0" ? false : true )
                    cell.remarkLabel.text =  child_List["remark"]![indexPath.row]
                    
                    
                    
                   
                    
                }
            
            cell.editButton.descriptiveName =  child_List["name"]![indexPath.row]
            
            cell.deleteButton.descriptiveName = child_List["name"]![indexPath.row]
            
            if cell.editButton.isHidden == false {
                cell.editButton.tag = Int(child_List["id"]![indexPath.row])!
                cell.deleteButton.tag = Int(child_List["id"]![indexPath.row])!
            }
            
            
            
                cell.editButton.addTarget(self, action: #selector(pressedEditButton(sender:)), for: .touchUpInside)
                cell.deleteButton.addTarget(self, action: #selector(pressedDeleteButton(sender:)), for: .touchUpInside)
            
                 cell.name?.text = "\(String(describing: child_List["name"]![indexPath.row]))"
            
            
            if (try  (child_List["visible_status"]![indexPath.row] == "1" &&
                "\(String(describing: child_List["name"]![0]))" != "Yet to make your first Call" &&
                "\(  try cbohelp.getMenuNew(menu: "DCR", code: "D_NLC_CALL").getString(key: "D_NLC_CALL"))" != "\(headers[indexPath.section])" &&
                "\( try cbohelp.getMenuNew(menu: "DCR", code: "D_AP").getString(key: "D_AP"))" != "\(headers[indexPath.section])"
                   )){
                   

                        if (child_List["sample_name"]![indexPath.row] != "") {
       
                            sample_name = child_List["sample_name"]![indexPath.row]
                            sample_sample = child_List["sample_qty"]![indexPath.row]
                            sample_pob = child_List["sample_pob"]![indexPath.row]
                            sample_noc = child_List["sample_noc"]![indexPath.row]

                            let sample_name1 = sample_name.components(separatedBy: ",");
                            let sample_qty1 = sample_sample.components(separatedBy: ",");
                            let sample_pob1 = sample_pob.components(separatedBy: ",");

                       
                            ShowDrSampleProduct(sample_name: sample_name1, sample_qty: sample_qty1, sample_pob: sample_pob1, myStackView: cell.myStackView);

                        }else{
                            RemoveAllviewsinProduct(myStackView: cell.myStackView)
                        }
                    
                    
                    
                    let titleNAme = ["Area","Class","Potential","Last Visited"]
                    
                    let itemName = [child_List["area"]![indexPath.row] , child_List["class"]![indexPath.row],child_List["potential"]![indexPath.row] , ""  ]
                    
                    Doc_Detail(titleName: titleNAme, itemName: itemName, myStackView: cell.detailsView)
                    
                    if child_List["workwith"]![indexPath.row] != ""{
                             workWithDetails(workWith: child_List["workwith"]![indexPath.row].components(separatedBy: ","), myStackView: cell.workWithDetailsView)
                            
                        }else {
                            RemoveAllviewsinProduct(myStackView: cell.workWithDetailsView)
                        }
                    
                        if (child_List["gift_name"]![indexPath.row] != "") {

                            gift_name = child_List["gift_name"]![indexPath.row]
                            gift_qty = child_List["gift_qty"]![indexPath.row]

                            name4 = gift_qty

                            let gift_name1 = gift_name.components(separatedBy: ",");
                            let gift_qty1 = gift_qty.components(separatedBy: ",");
                            ShowDrSampleGift(gift_name: gift_name1, gift_qty: gift_qty1, myStackView: cell.giftView);
                        }else{
                            RemoveAllviewsinProduct(myStackView: cell.giftView)
                        }
            }else if (try  (child_List["visible_status"]![indexPath.row] == "1" &&
                "\(String(describing: child_List["name"]![0]))" != "Yet to make your first Call" &&
                "\(  try cbohelp.getMenuNew(menu: "DCR", code: "D_NLC_CALL").getString(key: "D_NLC_CALL"))" == "\(headers[indexPath.section])"
                )){
              
                RemoveAllviewsinProduct(myStackView: cell.giftView)
                RemoveAllviewsinProduct(myStackView: cell.workWithDetailsView)
                
                if (child_List["sample_name"]![indexPath.row].contains("(c&f)")) {
                    
                    let titleNAme = ["Contact Person","Address","Mob.","DL No.","TIN No.","Business Start Date"]
                    let itemName = [child_List["sample_name"]![indexPath.row].subString(offsetFrom: 0, offSetTo: child_List["sample_name"]![indexPath.row].lastIndexOf(char: "(") - 1),
                                     child_List["sample_qty"]![indexPath.row],
                                     child_List["sample_pob"]![indexPath.row],
                                     child_List["class"]![indexPath.row],
                                     child_List["potential"]![indexPath.row],
                                     child_List["area"]![indexPath.row]]
                    Doc_Detail(titleName: titleNAme, itemName: itemName, myStackView: cell.myStackView)
                    
                }else{
                    
                    let titleNAme = ["Qlf. (Spl.) ","Address","Mob.","Class","Potential","Area"]
                    let itemName = [child_List["sample_name"]![indexPath.row],
                                    child_List["sample_qty"]![indexPath.row],
                                    child_List["sample_pob"]![indexPath.row],
                                    child_List["class"]![indexPath.row],
                                    child_List["potential"]![indexPath.row],
                                    child_List["area"]![indexPath.row]]
                    Doc_Detail(titleName: titleNAme, itemName: itemName, myStackView: cell.myStackView)
                    
                    
                    
                }
                

            }else{
                    cell.remarkLabel.isHidden = true
            }
        }
        catch{
            print(error)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpandableTableViewHeader") as! ExpandableTableViewHeader
        do{
            if (summaryData[section][headers[section]]!["name"]!.count == 1 && "\(String(describing: summaryData[section][headers[section]]!["name"]![0]))" == "Yet to make your first Call"){
                 headerView.itemCount.isHidden = true
            }else  if ("\(try cbohelp.getMenuNew(menu: "DCR", code: "D_EXP").getString(key: "D_EXP"))" == "\(headers[section])") && summaryData[section][headers[section]]!["name"]!.count == 0 {
                  headerView.itemCount.isHidden = false
            } else {
                 headerView.itemCount.isHidden = false
            }
        }catch{
            print(error)
        }
        
        headerView.mylabel.text = headers[section]
        headerView.itemCount.text =  "\(getChildCount(groupPosition: section, childname: headers[section]))"
    
        
        headerView.itemCount.backgroundColor = AppColorClass.colorPrimary
        headerView.itemCount.layer.masksToBounds = true
        headerView.itemCount.layer.cornerRadius = CGFloat(5)
        
        headerView.mylabel.textColor = AppColorClass.colorPrimaryDark
        headerView.headerButton.textColor = AppColorClass.colorPrimaryDark
        headerView.headerTapButton.addTarget(self, action: #selector(headerButtonPressed), for: .touchUpInside)
        
        
        headerView.headerTapButton.tag = section

        if isCollaps[section] == true{
            headerView.headerButton.text = "+"
        }else{
             headerView.headerButton.text = "-"
        }
        do {
            let a = getChildCount(groupPosition: section, childname: headers[section])
        
            if(headers[section] != ( try cbohelp.getMenuNew(menu: "DCR", code: "D_EXP").getString(key: "D_EXP"))) {
            
                
                headerView.myview.layer.shadowRadius = 3.0
                headerView.myview.layer.masksToBounds = false
                headerView.myview.layer.shadowOffset = CGSize(width: 0, height: 0)
                headerView.myview.layer.shadowOpacity = 0.5
                
                headerView.shadowView.layer.shadowRadius = 0.0
                headerView.shadowView.layer.masksToBounds = false
                headerView.shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
                headerView.shadowView.layer.shadowOpacity = 0.0
                

//               headerView.shadowView.isHidden = true
                
                if (a > 0 && getChild(groupPosition: section, childname: headers[section])["name"]![0] != ("Yet to make your first Call")) {
                    headerView.itemCount.isHidden = false
                } else {
                    headerView.itemCount.isHidden = true
                }
                RemoveAllviewsinProduct(myStackView:  headerView.DA_layout)
            
                //DA_layout.setBackgroundColor(Color.TRANSPARENT);
            }else{
                if (a > 0 && getChild(groupPosition: section, childname: headers[section])["name"]![0] != ("No extra expenses")){
                     headerView.itemCount.isHidden = false
//
                    
                    headerView.shadowView.layer.shadowRadius = 3.0
                    headerView.shadowView.layer.masksToBounds = false
                    headerView.shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    headerView.shadowView.layer.shadowOpacity = 0.5
                    
                    headerView.myview.layer.shadowRadius = 0.0
                    headerView.myview.layer.masksToBounds = false
                    headerView.myview.layer.shadowOffset = CGSize(width: 0, height: 0)
                    headerView.myview.layer.shadowOpacity = 0.0
                    
                    if (isCollaps[section]){
                        headerView.itemCount.text = String(a - 1)
                    }
                } else {
                      headerView.itemCount.isHidden = false
                }
                init_DA_type(DALayout: headerView.DA_layout , isCollaps :isCollaps[section])
                
    //            /* if (clicked){
    //             expence(groupPosition,false);
    //             init_DA_type(DA_layout,groupPosition);
    //             }else{
    //             init_DA_type(DA_layout,groupPosition);
    //             clicked=true;
    //             }*/
                
//                init_DA_type(DA_layout,groupPosition);
    
//                DA_layout.setBackgroundResource(R.drawable.custom_square_transparent_bg);
//                DA_layout.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View view) {
//                expence(groupPosition,true);
//                init_DA_type(DA_layout,groupPosition);
//                }
//                });
            
            }
        }
        catch{
            print(error)
        }
        

        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        do {
         
            if (headers[section] == ( try cbohelp.getMenuNew(menu: "DCR", code: "D_EXP").getString(key: "D_EXP"))){
                print(total_Exps_height)
                return 155.0
            }
        }
        catch {
            print(error)
        }
        return 40
    }
    
    
    
    func init_DA_type(DALayout : UIView , isCollaps : Bool ){
        
        RemoveAllviewsinProduct(myStackView: DALayout)
        var i = 0
        var heightConstraint : NSLayoutConstraint!
        // var stackViewHeightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        var data = [[String : String]]();
        var exp_data = [[String : String]]()
        exp_data.append(["DA. Type" : customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "DA_TYPE",defaultValue: "") ])
        exp_data.append(["DA. Value" :  "₹" + customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "da_val",defaultValue: "0.0")])
        
        var Dis_val = 0.0;
        if (customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "ACTUALFAREYN",defaultValue: "").uppercased() != ("Y")) {
            Dis_val = Double(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "distance_val",defaultValue: "0.0"))!
            exp_data.append(["TA. Value" : "₹\( Dis_val)"])
        }
        
        
        data = cbohelp.get_Expense()
        
        var other = 0.0;
        for  i in  0 ..< data.count {
            other += Double(data[i]["amount"]!)!;
        }
        
        let net_value = Double(customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context, key: "da_val",defaultValue: "0.0"))!
            + Dis_val
            + other;
        
        exp_data.append(["Other Value" :  "₹" + "\(other)"])
        exp_data.append(["Total Expenses" : "₹" + "\(net_value)"])
        
    
        
        for x1 in exp_data{
            for x in x1 {

                
               
                
                
                let myinnerStackView = UIStackView()
                myinnerStackView.axis =  .horizontal
                myinnerStackView.distribution = .fillProportionally
                DALayout.addSubview(myinnerStackView)
                
                
                let lineView = UIView()
                myinnerStackView.addSubview(lineView)
                lineView.backgroundColor = AppColorClass.colorPrimaryDark
                lineView.isHidden = true
                lineView.translatesAutoresizingMaskIntoConstraints =  false
                
                let myLabel = UILabel()
                myLabel.translatesAutoresizingMaskIntoConstraints = false
                myinnerStackView.addSubview(myLabel)
                myLabel.text = x.key
                myLabel.textColor = .black //AppColorClass.colorPrimaryDark
                //                if x.key == "Other Value" {
                //                     myLabel.textColor = AppColorClass.colorPrimaryDark
                //                }
                myLabel.font = myLabel.font.bold()
                myLabel.numberOfLines = 0
                
                
                let myLabel2 = UILabel()
                myinnerStackView.addSubview(myLabel2)
                myLabel2.translatesAutoresizingMaskIntoConstraints = false
                myLabel2.numberOfLines = 0
                myLabel2.textColor = .black
                myLabel2.textAlignment = .right
                myLabel2.font = myLabel2.font.bold()
                myLabel2.text = x.value
                
                myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
                
                let myinnerStackView1 = UIStackView()
                myinnerStackView1.axis =  .horizontal
                
                myinnerStackView1.translatesAutoresizingMaskIntoConstraints =  false
                
                

                if x.key == "Other Value" {

                    myLabel.textColor = AppColorClass.colorPrimaryDark
                     lineView.isHidden = isCollaps ? false : true
                    myLabel2.isHidden = isCollaps ? false : true
                    myLabel.isHidden = isCollaps ? false : true
//                 myinnerStackView.isHidden = isCollaps ? false : true
//
//
//                   myinnerStackView.addSubview(myinnerStackView1)
//
//                    myinnerStackView1.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
//                    myinnerStackView1.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
//                    myinnerStackView1.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
//                    myinnerStackView1.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
////
//                    myinnerStackView1.isHidden =  isCollaps ? true : false
//
//
//
//
//                    for i in  0 ..< data.count {
//                        let otherExpnView = OtherExpenseView()
//                        otherExpnView.translatesAutoresizingMaskIntoConstraints =  false
//                        otherExpnView.amount.text = (data[i]["amount"]!)
//                        otherExpnView.remark.text = (data[i]["exp_head"]!)
//                        otherExpnView.expHead.text = (data[i]["remark"]!)
//                        myinnerStackView1.addSubview(otherExpnView)
//
//
//
//                        otherExpnView.topAnchor.constraint(equalTo: myinnerStackView1.topAnchor).isActive =  true
//                        otherExpnView.rightAnchor.constraint(equalTo: myinnerStackView1.rightAnchor ).isActive =  true
//                        otherExpnView.leftAnchor.constraint(equalTo: myinnerStackView1.leftAnchor).isActive =  true
//                        otherExpnView.bottomAnchor.constraint(equalTo: myinnerStackView1.bottomAnchor).isActive = true
//
//                        heightConstraint = NSLayoutConstraint(item: otherExpnView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
//                        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
//                        heightConstraint.isActive =  true
//
//
//                        total_Exps_height += otherExpnView.buttomLine.frame.height
//
//                    }
//                    total_Exps_height = 165.0
                }
                
                
                
                myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
                myLabel2.bottomAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
                
                
                
                myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
                myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
                myLabel.bottomAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
                
                
                lineView.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 2).isActive = true
                lineView.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor, constant: 2).isActive = true
                lineView.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor, constant: -2).isActive = true
                lineView.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ,constant : 0).isActive = true
                
                if i == 0{
                    myinnerStackView.topAnchor.constraint(equalTo: DALayout.topAnchor).isActive = true
                    myinnerStackView.leftAnchor.constraint(equalTo: DALayout.leftAnchor , constant : 5).isActive = true
                    myinnerStackView .rightAnchor.constraint(equalTo: DALayout.rightAnchor , constant : -5).isActive =  true
                    i = 1
                }else{
                    myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
                    myinnerStackView.leftAnchor.constraint(equalTo: DALayout.leftAnchor , constant : 5).isActive = true
                    myinnerStackView .rightAnchor.constraint(equalTo: DALayout.rightAnchor, constant : -5).isActive =  true
                }
                
                
                heightConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
                heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
                heightConstraint.isActive =  true
                
                
                
                heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
                heightConstraint.isActive =  true
                
                widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 90)
                widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
                widthConstraint.isActive =  true
                
                previousStackView = myinnerStackView
            }
            
        }
//
//                    let a = UIStackView()
//                    DALayout.addSubview(a)
//                    a.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive =  true
//                    a.rightAnchor.constraint(equalTo: DALayout.rightAnchor ).isActive =  true
//                    a.leftAnchor.constraint(equalTo: DALayout.leftAnchor).isActive =  true
//
//                    heightConstraint = NSLayoutConstraint(item: a, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
//                    heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
//                    heightConstraint.isActive =  true
//
//        previousStackView = a
        previousStackView.bottomAnchor.constraint(equalTo: DALayout.bottomAnchor).isActive =  true
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     let child = getChild(groupPosition: indexPath.section, childname: headers[indexPath.section] )
        if child["visible_status"]![indexPath.row] == "0"  {
            summaryData[indexPath.section][headers[indexPath.section]]!["visible_status"]![indexPath.row] = "1"
           
        }else {

            summaryData[indexPath.section][headers[indexPath.section]]!["visible_status"]![indexPath.row] = "0"
        }
        
        tableView.reloadData()
    }
   

    
    @objc func headerButtonPressed(sender : UIButton){
        isCollaps[sender.tag] = !isCollaps[sender.tag]
        tableView.reloadData()
    }
    
    

    
    func getChild(groupPosition : Int , childname : String) -> [String : [String]]{
        
        return summaryData[groupPosition][childname]!
    }
    
    func getChildCount(groupPosition : Int , childname : String) -> Int{
        return getChild(groupPosition: groupPosition, childname: headers[groupPosition])["name"]!.count
    }
    func ShowDrSampleProduct( sample_name : [String],  sample_qty : [String], sample_pob : [String] , myStackView : UIView ){
        
        
        print(sample_pob , sample_qty , sample_name)
        
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        var previousStackView : UIStackView!
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Product"
        myLabel.numberOfLines = 0
        myLabel.font = myLabel.font.withSize(13)
        myLabel.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel.textColor = .white
        
        
        let myLabel2 = UILabel()
        myStackView.addSubview(myLabel2)
        myLabel2.translatesAutoresizingMaskIntoConstraints = false
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel2.font = myLabel2.font.withSize(13)
        myLabel2.textAlignment = .center
        myLabel2.textColor = .white
        myLabel2.text =  "Sample"
        
        let myLabel3 = UILabel()
        myStackView.addSubview(myLabel3)
        myLabel3.translatesAutoresizingMaskIntoConstraints = false
        myLabel3.numberOfLines = 0
        myLabel3.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel3.font = myLabel3.font.withSize(13)
        
        myLabel3.textAlignment = .center
        myLabel3.textColor = .white
        myLabel3.text =  "POB"
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        
        myLabel3.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel3.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
        myLabel3.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel2.rightAnchor.constraint(equalTo: myLabel3.leftAnchor ).isActive =  true
        myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        
        
        //if i == 0{
        
        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        
        //        }else{
        //
        //            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
        //            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        //            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        //
        //        }
        
        
        heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        heightConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< sample_name.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  sample_name[i]
            myLabel.numberOfLines = 0
            myLabel.textColor = AppColorClass.colorPrimaryDark
            //myLabel.backgroundColor = .gray
            
            
            let myLabel2 = UILabel()
            myStackView.addSubview(myLabel2)
            myLabel2.translatesAutoresizingMaskIntoConstraints = false
            myLabel2.numberOfLines = 0
            //myLabel2.backgroundColor = .lightGray
            myLabel2.textAlignment = .center
            myLabel2.textColor = AppColorClass.colorPrimaryDark
            myLabel2.text =  sample_qty[i]
            
            let myLabel3 = UILabel()
            myStackView.addSubview(myLabel3)
            myLabel3.translatesAutoresizingMaskIntoConstraints = false
            myLabel3.numberOfLines = 0
            //myLabel3.backgroundColor = .red
            myLabel3.textAlignment = .center
            myLabel3.textColor = AppColorClass.colorPrimaryDark
            myLabel3.text =  sample_pob[i]
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            
            
            myLabel3.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel3.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor).isActive =  true
            myLabel3.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel2.rightAnchor.constraint(equalTo: myLabel3.leftAnchor ).isActive =  true
            myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            
            //            if i == 0{
            //
            //                myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
            //                myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            //                myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            //
            //            }else{
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            
            //}
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            heightConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            previousStackView = myinnerStackView
            
            
        }
        
        
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
        
        
        
    }
    
    
    func RemoveAllviewsinProduct(myStackView : UIView){
        while( myStackView.subviews.count > 0 ) {
            myStackView.subviews[0].removeFromSuperview()
        }
    }
    
    func ShowDrSampleGift( gift_name : [String],  gift_qty : [String]  , myStackView : UIView){
       
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        // var stackViewHeightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Gift"
        myLabel.numberOfLines = 0
        myLabel.font = myLabel.font.withSize(13)
        myLabel.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel.textColor = .white
        
        
        let myLabel2 = UILabel()
        myStackView.addSubview(myLabel2)
        myLabel2.translatesAutoresizingMaskIntoConstraints = false
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = AppColorClass.colorPrimaryDark
        myLabel2.font = myLabel2.font.withSize(13)
        myLabel2.textAlignment = .center
        myLabel2.textColor = .white
        myLabel2.text =  "Qty."
        
        
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
        myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        

        
        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
        
      
        
        heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        
        widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        previousStackView = myinnerStackView
        
        for i in 0 ..< gift_name.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  gift_name[i]
            myLabel.numberOfLines = 0
            myLabel.textColor = AppColorClass.colorPrimaryDark
            //myLabel.backgroundColor = .gray
            
            
            let myLabel2 = UILabel()
            myStackView.addSubview(myLabel2)
            myLabel2.translatesAutoresizingMaskIntoConstraints = false
            myLabel2.numberOfLines = 0
            //myLabel2.backgroundColor = .lightGray
            myLabel2.textAlignment = .center
            myLabel2.textColor = AppColorClass.colorPrimaryDark
            myLabel2.text =  gift_qty[i]
            
            
            
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
            myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor ).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            
        
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
   
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 70)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            
            widthConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            widthConstraint.isActive =  true
            
            
            previousStackView = myinnerStackView
            
        }
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
    }
    
    
    func Doc_Detail( titleName : [String],  itemName : [String]  , myStackView : UIView){
        myStackView.backgroundColor = UIColor.white
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        
        var previousStackView : UIStackView!
        
       
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
      
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        
        
        let lineView = UIView()
        
        if itemName.count == 0{
            myStackView.superview?.isHidden = true
        }else {
            
            
            myinnerStackView.addSubview(lineView)
            lineView.backgroundColor = AppColorClass.colorPrimaryDark
            lineView.isHidden = false
            lineView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            lineView.topAnchor.constraint(equalTo: myStackView.topAnchor , constant : 0).isActive = true
            lineView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true


            myinnerStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor , constant : 5).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            heightConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            heightConstraint.isActive =  true
            

            myStackView.superview?.isHidden = false
        }
        
        
      
        previousStackView = myinnerStackView
        
        for i in 0 ..< titleName.count{
            
            if itemName[i] != ""{
                
                
                let myLabel = UILabel()
                myLabel.translatesAutoresizingMaskIntoConstraints = false
                myStackView.addSubview(myLabel)
                myLabel.text =  titleName[i]
                myLabel.numberOfLines = 0
                myLabel.textColor = UIColor.black
                myLabel.font =  UIFont.boldSystemFont(ofSize: 14.0)
                //myLabel.backgroundColor = .gray
                
                
                let myLabel2 = UILabel()
                myStackView.addSubview(myLabel2)
                myLabel2.translatesAutoresizingMaskIntoConstraints = false
                myLabel2.numberOfLines = 0
                //myLabel2.backgroundColor = .lightGray
                myLabel2.textAlignment = .right
                myLabel2.textColor = UIColor.black
                myLabel2.font = UIFont(name:"HelveticaNeue", size: 14.0)
                myLabel2.text =  itemName[i]
                
                
                let myinnerStackView = UIStackView()
                myinnerStackView.axis =  .horizontal
                myStackView.addSubview(myinnerStackView)
                myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
                
                
                myLabel2.topAnchor.constraint(equalTo: myinnerStackView.topAnchor ).isActive =  true
                myLabel2.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor , constant : -5).isActive =  true
                myLabel2.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ).isActive = true
                
                
                myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
                myLabel.rightAnchor.constraint(equalTo: myLabel2.leftAnchor , constant : -50 ).isActive =  true
                myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor ).isActive =  true
                myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor ).isActive = true
                
                
                myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
                myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
                myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
                
                
                heightConstraint = NSLayoutConstraint(item: myLabel2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
                heightConstraint.isActive =  true
                
                
                previousStackView = myinnerStackView
            }
        }
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor , constant : -5).isActive =  true
    }
    
    
    
    private func workWithDetails(workWith: [String], myStackView : UIView ){
        
        RemoveAllviewsinProduct(myStackView: myStackView)
        
        var heightConstraint : NSLayoutConstraint!
        var widthConstraint : NSLayoutConstraint!
        var previousStackView : UIStackView!
        
        
        let myinnerStackView = UIStackView()
        myinnerStackView.axis =  .horizontal
        myStackView.addSubview(myinnerStackView)
        myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
        

        if workWith[0] == ""{
            myStackView.superview?.isHidden = true
        }else {
            let lineView = UIView()
            myinnerStackView.addSubview(lineView)
            lineView.backgroundColor = AppColorClass.colorPrimaryDark
            lineView.isHidden = false
            lineView.translatesAutoresizingMaskIntoConstraints =  false
            
            
            lineView.topAnchor.constraint(equalTo: myStackView.topAnchor , constant : 0).isActive = true
            lineView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            myinnerStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor , constant : 5).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
            myinnerStackView.rightAnchor.constraint(equalTo: myStackView.rightAnchor ).isActive =  true
            
            
            heightConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
            heightConstraint.isActive =  true
            
            myStackView.superview?.isHidden = false
        }
        
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myStackView.addSubview(myLabel)
        myLabel.text =  "Work-with"
        myLabel.numberOfLines = 0
        myLabel.font = UIFont.boldSystemFont(ofSize: 13)
        myLabel.textColor = .black
        
       
        
        myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
        myLabel.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor ).isActive =  true
        myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor).isActive =  true
        myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
        
        
        
//        myinnerStackView.topAnchor.constraint(equalTo: myStackView.topAnchor).isActive = true
//        myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor).isActive = true
//        myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
         previousStackView = myinnerStackView
        
        heightConstraint = NSLayoutConstraint(item: myLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        widthConstraint = NSLayoutConstraint(item: myLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(1000)))
        widthConstraint.isActive =  true
        
        
        
        
        for i in 0 ..< workWith.count{
            
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myStackView.addSubview(myLabel)
            myLabel.text =  workWith[i]
            myLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
            myLabel.numberOfLines = 0
            myLabel.textColor = .black
            //myLabel.backgroundColor = .gray
        
            let myinnerStackView = UIStackView()
            myinnerStackView.axis =  .horizontal
            myStackView.addSubview(myinnerStackView)
            myinnerStackView.translatesAutoresizingMaskIntoConstraints =  false
            
            
           
            
            myLabel.topAnchor.constraint(equalTo: myinnerStackView.topAnchor).isActive =  true
            myLabel.rightAnchor.constraint(equalTo: myinnerStackView.rightAnchor , constant : -5).isActive =  true
            myLabel.leftAnchor.constraint(equalTo: myinnerStackView.leftAnchor , constant : 5).isActive =  true
            myLabel.bottomAnchor.constraint(equalTo: myinnerStackView.bottomAnchor).isActive = true
            
            
            myinnerStackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            myinnerStackView.leftAnchor.constraint(equalTo: myStackView.leftAnchor ).isActive = true
            myinnerStackView .rightAnchor.constraint(equalTo: myStackView.rightAnchor).isActive =  true
            
            
            
            heightConstraint = NSLayoutConstraint(item: myLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
            heightConstraint.isActive =  true
            
            previousStackView = myinnerStackView
            
        }
        previousStackView.bottomAnchor.constraint(equalTo: myStackView.bottomAnchor).isActive =  true
        
    }
    
    
    
    
    

//    
//    private func Doc_Detail( doc_class : String, doc_potential : String , doc_last_visited :String , area :String , class_title :String , potential_title :String,  area_title : String, top_line : Int , bottom_line : Int , stk : UIView ) {
//   
//        RemoveAllviewsinProduct(myStackView: stk)
//    //tbrow0.setBackgroundColor(0xff125688);
////    TableRow.LayoutParams params = new TableRow.LayoutParams(0, TableLayout.LayoutParams.WRAP_CONTENT, 1f);
//    if (top_line==1) {
//    TableRow tbrow5 = new TableRow(_context);
//    tbrow5.setPadding(2, 2, 2, 2);
//    tbrow5.setBackgroundColor(0xff125688);
//    stk.addView(tbrow5);
//    }
//    
//    if (!area.equals("")) {
//    TableRow tbrow00 = new TableRow(_context);
//    TextView tv00 = new TextView(_context);
//    tv00.setText(area_title);
//    tv00.setTextSize(11);
//    tv00.setPadding(5, 5, 5, 0);
//    tv00.setTextColor(Color.BLACK);
//    tv00.setTypeface(null, Typeface.BOLD);
//    
//    tbrow00.addView(tv00);
//    TextView tv01 = new TextView(_context);
//    tv01.setText(area);
//    tv01.setTextSize(11);
//    tv01.setPadding(5, 5, 5, 0);
//    tv01.setTextColor(Color.BLACK);
//    tv01.setGravity(Gravity.RIGHT);
//    tv01.setTypeface(null, Typeface.NORMAL);
//    tv00.setLayoutParams(params);
//    tbrow00.addView(tv01);
//    stk.addView(tbrow00);
//    }
//    
//    if (!doc_class.equals("") ) {
//    TableRow tbrow0 = new TableRow(_context);
//    TextView tv0 = new TextView(_context);
//    tv0.setText(class_title);
//    tv0.setTextSize(11);
//    tv0.setPadding(5, 5, 5, 0);
//    tv0.setTextColor(Color.BLACK);
//    tv0.setTypeface(null, Typeface.BOLD);
//    tv0.setLayoutParams(params);
//    tbrow0.addView(tv0);
//    TextView tv1 = new TextView(_context);
//    tv1.setText(doc_class);
//    tv1.setTextSize(11);
//    tv1.setPadding(5, 5, 5, 0);
//    tv1.setTextColor(Color.BLACK);
//    tv1.setGravity(Gravity.RIGHT);
//    tv1.setTypeface(null, Typeface.NORMAL);
//    tbrow0.addView(tv1);
//    stk.addView(tbrow0);
//    }
//    
//    if (!doc_potential.equals("")) {
//    TableRow tbrow01 = new TableRow(_context);
//    TextView tv01 = new TextView(_context);
//    tv01.setText(potential_title);
//    tv01.setTextSize(11);
//    tv01.setPadding(5, 5, 5, 0);
//    tv01.setTextColor(Color.BLACK);
//    tv01.setTypeface(null, Typeface.BOLD);
//    tv01.setLayoutParams(params);
//    tbrow01.addView(tv01);
//    TextView tv11 = new TextView(_context);
//    tv11.setText(doc_potential);
//    tv11.setTextSize(11);
//    tv11.setPadding(5, 5, 5, 0);
//    tv11.setTextColor(Color.BLACK);
//    tv11.setGravity(Gravity.RIGHT);
//    tv11.setTypeface(null, Typeface.NORMAL);
//    tbrow01.addView(tv11);
//    stk.addView(tbrow01);
//    }
//    
//    if (!doc_last_visited.equals("")) {
//    
//    TableRow tbrow02 = new TableRow(_context);
//    TextView tv02 = new TextView(_context);
//    tv02.setText("Last Visited");
//    tv02.setTextSize(11);
//    tv02.setPadding(5, 5, 5, 0);
//    tv02.setTextColor(Color.BLACK);
//    tv02.setTypeface(null, Typeface.BOLD);
//    tv02.setLayoutParams(params);
//    tbrow02.addView(tv02);
//    TextView tv12 = new TextView(_context);
//    tv12.setText(doc_last_visited);
//    tv12.setPadding(5, 5, 5, 0);
//    tv12.setTextSize(11);
//    tv12.setTextColor(Color.BLACK);
//    tv12.setGravity(Gravity.RIGHT);
//    tv12.setTypeface(null, Typeface.NORMAL);
//    tbrow02.addView(tv12);
//    stk.addView(tbrow02);
//    }
//    
//    if (bottom_line==1) {
//    TableRow tbrow6 = new TableRow(_context);
//    tbrow6.setPadding(2, 2, 2, 2);
//    tbrow6.setBackgroundColor(0xff125688);
//    stk.addView(tbrow6);
//    }
    
    
    
//    }
    
    
    
    
    

}
