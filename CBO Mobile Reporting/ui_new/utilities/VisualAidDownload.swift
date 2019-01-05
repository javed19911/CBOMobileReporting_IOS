//
//  VisualAidDownload.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 24/02/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
//import GoldRaccoon
class VisualAidDownload: CustomUIViewController , Up_Down_Output {
   

    
    @IBOutlet weak var contentView: UIView!
    
    let cbohelp: CBO_DB_Helper = CBO_DB_Helper.shared
    var pa_name = "" , PA_ID = ""
    
    static var alert : UIAlertController!
    
    var localpath : String = ""
    var arrayString =  [String]()
    var myImages = [UIImage]()
    var customVariablesAndMethod :      Custom_Variables_And_Method!
    
    let INTERNET_MSG_VISUALAID_DOWNLAOD = 0
    @IBOutlet weak var myTopView: TopViewOfApplication!
    @IBOutlet weak var tname: UILabel!
    @IBOutlet weak var comp_name: UILabel!
    @IBOutlet weak var downloadPercent: UILabel!
    @IBOutlet weak var fileName: UILabel!
  //  var requestsManager : GRRequestsManager!
    @IBOutlet weak var progressBar: UIProgressView!
    var upDownFTP : Up_Down_Ftp!
    @IBOutlet weak var downloadButton: CustomeUIButton!
    override func viewDidLoad() {
         progressBar.progress = 0.0
        super.viewDidLoad()
        myTopView.setText(title: VCIntent["title"]!)
        progressBar.layer.cornerRadius = 6
        progressBar.clipsToBounds = true
        contentView.isHidden = true
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
       
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
            PA_ID = "\(Custom_Variables_And_Method.PA_ID)"
    
            pa_name = Custom_Variables_And_Method.PA_NAME
        customVariablesAndMethod=Custom_Variables_And_Method.getInstance()
        
        if(pa_name != (Custom_Variables_And_Method.PA_NAME))
        {
             tname.text = ("       user Logged-Out");
            
            comp_name.text = ("");
            customVariablesAndMethod.msgBox(vc: self, msg: "Connection Reset...\nplease login again from login screen")
        }
        else
        {
            tname.text = "Welcome \( pa_name)";
            comp_name.text = (Custom_Variables_And_Method.COMPANY_NAME);
        }
    }
    
   @objc func closeVC()
    {
        myTopView.CloseCurruntVC(vc: self)
    }
    
    
    
    
    @objc func downloadButtonPressed(){
        
  
        upDownFTP = Up_Down_Ftp()
        upDownFTP.delegate = self
        downloadButton.isHidden = true
        contentView.isHidden = false
        downloadPercent.text = "Downloading will be start shortly...."
        fileName.text = "Please don't use Back Button while\n Downloading Visual Ads...."
        
        
        // display list of all file in folder and download autometic

//        self.upDownFTP.displayFilesList()
        
//       requestsManager = GRRequestsManager(hostname: "220.158.164.114/CBO_IOS", user: "cbo_ios", password: "ioscbo"  )
      
        var params = [String:String]()
        params["sCompanyFolder"]  = cbohelp.getCompanyCode()
        params["iPA_ID"] = "\(Custom_Variables_And_Method.PA_ID)"

          let tables = [0]
        CboServices().customMethodForAllServices(params: params, methodName: "VISUALAID_DOWNLOAD", tables: tables, response_code: INTERNET_MSG_VISUALAID_DOWNLAOD, vc : self , multiTableResponse: false)
    }
    
    
    override func getDataFromApi(response_code: Int, dataFromAPI: [String : NSArray]) {
        switch response_code {
        case INTERNET_MSG_VISUALAID_DOWNLAOD:
            parser_utilities(dataFromAPI : dataFromAPI)
        case 99:
            customVariablesAndMethod.getAlert(vc: self, title: "Error", msg: (dataFromAPI["Error"]![0] as! String))
            break
        default:
            print("Error")
        }
    }
    
    
    private func parser_utilities(dataFromAPI : [String : NSArray])
    {
        var list = [String]()
        list.removeAll()
        if(!dataFromAPI.isEmpty){
            var FILE_NAME = [String]()
            var ITEM_NAME = [String]()
            
            let jsonArray =   dataFromAPI["Tables0"]!
                for i in 0 ..< jsonArray.count{
             let innerJson = jsonArray[i] as! [String : AnyObject]

                    ITEM_NAME.append(innerJson["ITEM_NAME"]! as! String)
                    FILE_NAME.append(innerJson["FILE_NAME"]! as! String)
       
            }
            
            if FILE_NAME.count > 0 {
                self.upDownFTP.clearDiskCache()
             
                
                self.upDownFTP.downloadSingleFile(file_Name :FILE_NAME , item_Name: ITEM_NAME )
            }else {
                customVariablesAndMethod.msgBox(vc: self, msg: "No File To Download")
            }
        }
    }
    
    
    
    func getPercant(precent: Int , fileName : String) {
        VisualAidDownload.alert = nil
        downloadPercent.text = "\(precent)% Downloaded"
        progressBar.progress = Float(precent) * 0.01
        self.fileName.text = fileName
        if (Float(precent) * 0.01) == 1.0 {
            VisualAidDownload.alert = showAlertView()
           self.present( VisualAidDownload.alert, animated: true, completion: nil)
            downloadButton.isHidden = false
        }
    }
    
    func showAlertView() -> UIAlertController {

        let alertViewController = UIAlertController(title: "Download Complete" , message: "Press Ok"
        , preferredStyle: .alert)
        
        let okbutton = UIAlertAction(title: "ok", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
                    
            alertViewController.addAction(okbutton)
            return alertViewController
    }
    
    
    
    
    
    
    
    
    
    
    // display all file
//    func displayAllFile(){
//           let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//
//        let myFilesPath = documentDirectoryPath.appending("/")
//        let files = FileManager.default.enumerator(atPath: myFilesPath)
//        while let file = files?.nextObject() {
//            print(file)
//        }
//
//    }
    
    
    // function to download images
//    func startDownloadImages( indexValue : Int){
//        fileName.text = arrayString[index]
        
//        if( index == 0){
//            downloadPercent.text = "0 % download"
//        }else if (index == arrayString.count - 1){
//            progressBar.progress = 1.0
//              downloadPercent.text = "100 % download"
//        }else{
//
//            let per : Float = (Float((index * 100) / 15))
//            print(per)
//            progressBar.progress = Float(per/100)
//
//            downloadPercent.text = "\(per) % download"
//        }
    
        
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

//        localpath = (documentDirectory as NSString).appendingPathComponent(arrayString[indexValue])
//
//        print("\(arrayString[indexValue]) is downloading")
//
//        print(localpath)
////        self.upDownFTP.addRequestForDownloadFile(atRemotePath: arrayString[indexValue], toLocalPath: localpath)
//        self.upDownFTP.startProcessingRequests()
        
//    }

    
    
//    func removeOldFileIfExist( indexValue : Int) {
//        var indValue = indexValue
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        if paths.count > 0 {
//            let dirPath = paths[0]
//
//            let filePath = NSString(format:"%@/%@", dirPath, arrayString[indValue]) as String
//            if FileManager.default.fileExists(atPath: filePath) {
//                do {
//                    try FileManager.default.removeItem(atPath: filePath)
//                    indValue += 1
//                    removeOldFileIfExist(indexValue: indexValue)
//                    print("User photo has been removed")
//                } catch {
//                    print("an error during a removing")
//                }
//            }
//        }
//    }

    
    
    //////////////////////// upload download delegate function /////////////
//    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didScheduleRequest request: GRRequestProtocol!){
//        print("Start")
//
//    }
//    var index = 0
//    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompleteListingRequest request: GRRequestProtocol!, listing: [Any]!) {
//        arrayString = listing as! [String]
//
//
//        for i in 0 ..< arrayString.count - 1{
//         print(arrayString[i].substringFrom(offSetTo: 0))
//
//        }
//
//        print("List Of files visual add :\n" , listing )
//       // startDownloadImages(indexValue: index)
//    }

//    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompletePercent percent: Float, forRequest request: GRRequestProtocol!) {
//
//        print("request compeleted" , percent)
//    }
//
//
//    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompleteDownloadRequest request: GRDataExchangeRequestProtocol!) {
//
//        print(localpath)
//        if index < arrayString.count {
//
//            myImages.insert((UIImage(contentsOfFile: localpath))!, at: index)
//        }
//        index += 1
//
//
//        if myImages.count - 1   == arrayString.count - 1{
//            downloadButton.isHidden  = false
//            showAlertView()
//        }else {
//
//            startDownloadImages(indexValue: index)
//        }
//    }
//
//
//    func showAlertView(){
//        let alertViewController = UIAlertController(title: "Download Complete" , message: "Press Ok to cloase this massege or Press open to display visual Ad", preferredStyle: .alert)
//
//        let okbutton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//        alertViewController.addAction(okbutton)
//        self.present(alertViewController, animated: true, completion: nil)
//    }
//
//
//
//    func redirectToVisualAdPage(){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//
////        vc.arrayString = arrayString
////        vc.myImages = myImages
//
//        self.present(vc, animated: true, completion: nil)
//    }
//
//
//    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didFailRequest request: GRRequestProtocol!, withError error: Error!) {
//        startDownloadImages( indexValue : index)
//
//        print(error)
//    }
//
//    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didFailWritingFileAtPath path: String!, forRequest request: GRDataExchangeRequestProtocol!, error: Error!) {
//        print(error)
//    }

    
    
}

