//
//  VisualAdAdaptor.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 21/03/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
class VisualAdAdaptor : NSObject , UITableViewDataSource , UITableViewDelegate{
  
    var sample_id = [String]()
    var sample_name = [String]()
    var dataList = [DocSampleModel]()
    var tableView : UITableView!
 
    var customVariablesAndMethod : Custom_Variables_And_Method!
    var storyboard : UIStoryboard!
    var context = CustomUIViewController()
    init(tableView : UITableView   , vc : CustomUIViewController , dataList : [DocSampleModel] , sample_id : [String]  , sample_name : [String]) {
        super.init()
        self.tableView = tableView
        self.sample_id = sample_id
        self.sample_name = sample_name
        self.dataList = dataList
        context = vc
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = Bundle.main.loadNibNamed("VisualAdRow", owner: self, options: nil)?.first as! VisualAdRow
        cell.selectionStyle = .none
        cell.adName.text = dataList[indexPath.row].getName()
        
        if (dataList[indexPath.row].get_Checked()){
             cell.adName.textColor = UIColor(hex: "#7c7b7b")
            
             cell.promoted.isHidden = false
              cell.contentView.backgroundColor = UIColor(hex: "#e7e7e8")
            
//          view.setBackgroundResource(R.drawable.list_selector_selected);
            
        }else {
             cell.adName.textColor = UIColor(hex:"#000000")
              cell.promoted.isHidden = true
          cell.contentView.backgroundColor = UIColor.white
//    view.setBackgroundResource(R.drawable.list_selector_unselected);
        }
        
        
        
        
        switch (dataList[indexPath.row].get_file_ext().lowercased()) {
        case ".pdf":
            cell.myImageView?.image = UIImage(named: "pdf_icon.png")
            break;
        case ".avi",".mov",".3gp",".mp4":
            cell.myImageView?.image = UIImage(named: "mp4_icon.png")
            break
        case ".mp3":
            cell.myImageView?.image = UIImage(named: "music_icon.png")
            break;
        case ".html":
            cell.myImageView?.image = UIImage(named: "web_login_white.png")
            break;
        
        case ".bmp",".jpg",".gif",".png":
            cell.myImageView?.image = UIImage(named: "image_icon.png")
            break
        
        default:
            
            cell.myImageView?.image = UIImage(named: "no_image.png")
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myFilesPath = documentDirectoryPath.appending("/Cbo/Product/")

        
       let VISUALAIDPDFYN = customVariablesAndMethod.getDataFrom_FMCG_PREFRENCE(vc: context , key: "VISUALAIDPDFYN", defaultValue: "N")
   
        if VISUALAIDPDFYN == "Y"{
        
            openWithWebView(path : myFilesPath.appending("\(sample_id[indexPath.row])\(dataList[indexPath.row].get_file_ext().lowercased())") , index : indexPath.row)
            
        }else {
            
             switch (dataList[indexPath.row].get_file_ext().lowercased()) {
               
                case ".html",".mp3",".mov",".avi",".3gp",".mp4",".pdf":
                    openWithWebView(path : myFilesPath.appending("\(sample_id[indexPath.row])\(dataList[indexPath.row].get_file_ext().lowercased())") , index : indexPath.row)
                break
                case ".jpg",".bmp",".gif",".png":
                showImagesGallery(index:  indexPath.row)
                
                 default:
                showImagesGallery(index:  indexPath.row)
            }
        }
    }
    
    
    
    func showImagesGallery(index: Int){
        let vc = context.storyboard?.instantiateViewController(withIdentifier: "AdImageViewController") as! AdImageViewController
        vc.indexId = index
        vc.VCIntentArray["sample_id"] = sample_id
        vc.VCIntentArray["sample_name"] = sample_name
        context.present(vc, animated: true, completion: nil)
    }
    
    func openWithWebView(path : String , index : Int){
        let vc = context.storyboard?.instantiateViewController(withIdentifier: "CBOwebViewViewController") as! CBOwebViewViewController
        print(path)
        vc.fileExtention = (dataList[index].get_file_ext().lowercased())
        vc.path = path
        print(sample_name[index])
        vc.VCIntent["title"] = sample_name[index]
        context.present(vc, animated: true, completion: nil)
        
    }
    
}
    


