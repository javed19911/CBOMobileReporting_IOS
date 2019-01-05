//
//  SPO_ReportSubView.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 09/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

class SpoProductWiseStock: UIViewController {

    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    }
    
    
    
    override var shouldAutorotate: Bool{
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
}
