
//
//  TestTableViewVC.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 12/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class TestTableViewVC: CustomUIViewController , UITableViewDataSource{

    @IBAction func pressedDoneButton(_ sender: CustomeUIButton) {
        
    }
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var mySearchBar: CustomTextView!
    let data = ["adnfeqkbfaewfbfb","cbnqefwefbfwbkf", "b" ,"e","q" ]
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTopView.setText(title: "Sample/POB")
        myTopView.backButton.addTarget(self, action: #selector(closeCurrentView), for: .touchUpInside)
        

        self.myTableView.dataSource = self
        
      self.myTableView.register(SamplePOBTableViewCell.self, forCellReuseIdentifier: "cell")
        

    }
    @objc func closeCurrentView()
    {
            myTopView.CloseCurruntVC(vc: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SamplePOBTableViewCell", owner: self, options: nil)?.first as! SamplePOBTableViewCell
        cell.selectionStyle = .none
//        cell.textViewLeft.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
//        cell.textViewLeft.setHint(placeholder: "Sample")
//        cell.textViewLeft.setSecureTextEnable(enable: true)
//        cell.textViewMid.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
//        cell.textViewMid.setHint(placeholder: "POB")
//        
//       
//        cell.textViewRight.setKeyBoardType(keyBoardType: UIKeyboardType.numberPad)
//        cell.textViewRight.setHint(placeholder: "NOC")
//        cell.lblSamplePOB?.text = data[indexPath.row]
            return cell
         }


}
