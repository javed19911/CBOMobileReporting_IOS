//
//  Up_Dwon_Ftp.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 07/03/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Foundation
import GoldRaccoon
//import CFNetwork
import LxFTPRequest
// MARK:- delegate method
protocol Up_Down_Output {
//    func result(fileNameArray : [String])
    func getPercant(precent : Int , fileName : String)
}

protocol FTPUploadDelegate {
    func upload_complete(IsCompleted : String)
}
class Up_Down_Ftp : NSObject,GRRequestsManagerDelegate{
    
    
    var remoteFileList = [String]()
    var saveToPath = [String]()
    var fileDisplayName = [String]()
    var callCount = 0
    var finalFileList = [String]()
    
    
    
    var itemCount = 0
    var childDirFound = false
    var tempFileName = ""
    var myImagesDic = [[String : [String]]]()
    var phonePath = ""
    var indexA : Int  = 0
    var indexId : Int = 0
    var myArray : [String]!
    var files : [String]!
    var currentDir = ""
    var currentDirectory = ""
    var catDir = ""
    var isCatalogFound = false
    var directoryIndex = 0
    var alertDsiplay = false
    var child_file_List = [String]()
    var child_directory_List = [String]()
    var file_List = [String]()
    var directory_List = [String]()
    var file_Name_download = [String]()
    var who : Int = 0;
    var file_Name = [String]()
    var item_Name = [String]()
    var dic_count = 0
    var temp_child_directory_List = [String]()
    var requestsManager : GRRequestsManager!
    var delegate : Up_Down_Output?
    var finalDownloadingList = [String]()
    
   

    var customVariablesAndMethod :      Custom_Variables_And_Method!
    
    
    var ftp_hostname="",ftp_username="",ftp_password="",ftp_port="",web_root_path=""
  
    
    var cbohelp  : CBO_DB_Helper = CBO_DB_Helper.shared
  
    var UploadDelegate : FTPUploadDelegate?
    var fullpath : String!
   
  
    
    override init(){
        super.init()
    
//        requestsManager = GRRequestsManager(hostname: "220.158.164.114/CBO_IOS", user: "cbo_ios", password: "ioscbo")
        
        //
        getFtpDetail()
        
    customVariablesAndMethod=Custom_Variables_And_Method.getInstance()
        connnectingwithFTP(ftp_hostname: ftp_hostname, ftp_username: ftp_username, ftp_password: ftp_password)

        
         remoteFileList.removeAll()
         saveToPath.removeAll()
         fileDisplayName.removeAll()
         finalFileList.removeAll()

         files = [String]()
         file_List = [String]()
         files.removeAll()
         myArray = [String]()

         myArray.removeAll()
         file_List.removeAll()

    }
//
    
    func connnectingwithFTP(ftp_hostname : String, ftp_username : String, ftp_password:String){
        // initialize the request manager
         requestsManager = GRRequestsManager(hostname: ftp_hostname , user:  ftp_username , password: ftp_password )
        requestsManager.delegate = self
        // copy the current web path into currentDir
        currentDir = web_root_path
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //////////////////////// upload download delegate function /////////////
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didScheduleRequest request: GRRequestProtocol!){
        print("Start")
//        print(indexId)
//        if(myArray.count > 0){
//            if indexId <= myArray.count - 1 {
//                    indexId += 1
//            }
//        }
    }
    

    
    // fetching root host name
    func getRootDirectory() -> String{
        return requestsManager.hostname
    }
   
    
    // making root directroy for user
    func rootDirectoryForUser() -> String{
        return   web_root_path
    }
    
    
    func checkRootDirectoryOnFTP(hostname : String) -> Bool{
        if hostname == requestsManager.hostname{
            return true   }
        else{
            return false  }
    }
    
    
//    func currentDirectory() -> String {
//        return currentDir
//    }
//
  

    func changeDirectoryUp(path : String) -> String{
        var newPath = ""
        let mypath = String(path.dropLast())
        var counter = 0 ,temp_counter = 0 ,pos = 0 , charLastPos = 0
     
        for a in mypath {
            if a == "/"{
                charLastPos = pos
                counter += 1
            }
            pos += 1
        }
        for a in mypath{
            let b = a
            if a == "/"{
                temp_counter += 1
                if counter > temp_counter {
                    newPath = newPath.appending("\(b)")
                }
            }else{
                newPath = newPath.appending("\(b)")
            }
        }
        
        if newPath.substringFrom(offSetTo: charLastPos - 1).appending("/").count > 1{
            return newPath.substringFrom(offSetTo: charLastPos - 1).appending("/")
        }else  { return "" }
        
        
//        return newPath.substringFrom(offSetTo: charLastPos - 1).appending("/")
        //return currentDir
    }
    

    
    // get FTP Details from DB
    func getFtpDetail()
    {
        do {
            let statement = try cbohelp.getFTPDATA()
            let db = cbohelp
            while let c = statement.next() {
                
                ftp_hostname = try c[db.getColumnIndex(statement: statement, Coloumn_Name: "ftpip")] as! String
                
                ftp_username = try c[db.getColumnIndex(statement: statement, Coloumn_Name: "username")] as! String
                // CBO_DOMAIN_SERVER
                
                
                ftp_password = try c[db.getColumnIndex(statement: statement, Coloumn_Name: "password")] as! String
                // cbodomain@321

                
                web_root_path = try c[db.getColumnIndex(statement: statement, Coloumn_Name: "path")] as! String
//
//                web_root_path = "/DEMO/Javed1/"
                ftp_port = try c[db.getColumnIndex(statement: statement, Coloumn_Name: "port")] as! String
            }
        }catch{
            print(error)
        }
    }
        

    
    // display list of files
    
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompleteListingRequest request: GRRequestProtocol!, listing: [Any]!) {
        files.removeAll()
        files = listing as! [String]
        
//        print( "1", request.path.replacingOccurrences(of:  changeDirectoryUp(path: request.path) , with: ""))
        
    
        
//        print("List Of files upload file :\n" , files )
        if who == 0 {
//            print(files)
            // prepare list for download
            file_List.removeAll()
            directory_List.removeAll()
            
          //  var i = 0
            for file in files{
                
                if (file.contains(".") &&  file_Name.contains(file.substringFrom(offSetTo: file.lastIndexOf(char: ".")-1 ))) {
                    file_List.append(file)
                    finalDownloadingList.append(file) //item_Name[i])
//                    i += 1
                }else if(file.contains(".") &&  file.contains("_") && file_Name.contains(file.substringFrom(offSetTo: file.lastIndexOf(char: "_")-1))){
                    file_List.append(file)
                    fileDisplayName.append(file) //item_Name[i])
                    finalDownloadingList.append(file) //item_Name[i])
//                    i += 1
                }else if (file.uppercased() == "CATALOG" ) {
                    directory_List.append("CATALOG")
//                  i += 1
                }
                
            }
            
            if !directory_List.isEmpty{
                finalDownloadingList.append(contentsOf: directory_List)
            }

//            print(file_List)
//
//            print(finalDownloadingList)
            DownloadVisualAds(downloadLevel: 0 , downloadFromDirectory:  request.path.replacingOccurrences(of:  changeDirectoryUp(path: request.path) , with: "")   , saveDirectortTo : request.path.replacingOccurrences(of:  changeDirectoryUp(path: request.path) , with: ""))
        }else if who == 1 {
          
            // prepare list for download
            child_file_List.removeAll()
            child_directory_List.removeAll()
            for file in files {
             
                if (file.contains(".") ) {
                    child_file_List.append(file);
                }else {
                    child_directory_List.append(file);
                }
            }
            
//            print( "2", request.path.replacingOccurrences(of:  changeDirectoryUp(path: request.path) , with: ""))
            
            DownloadVisualAds(downloadLevel:  1 ,  downloadFromDirectory: request.path   , saveDirectortTo : request.path.replacingOccurrences(of:  changeDirectoryUp(path: request.path) , with: ""))
        }
    }
    


    
    func DownloadVisualAds( downloadLevel: Int , downloadFromDirectory : String , saveDirectortTo : String){
         print(downloadFromDirectory , saveDirectortTo)
        
        
        
        do {
            if downloadLevel == 0{
                print(file_List)
                for fileName in file_List{
                    finalFileList.append(fileName)
                    let currentFile = changeDirectoryUp(path: web_root_path).appending(downloadFromDirectory).appending(fileName)
                    let savedpath  = try (getDocumentDirectory()) as String
                    phonePath = savedpath
                    itemCount += 1
                    
                    remoteFileList.append(currentFile)
                    saveToPath.append(savedpath.appending(fileName))
                    
                    print( savedpath , currentFile)
                    
                    
                    

//      requestsManager.addRequestForDownloadFile(atRemotePath: currentFile, toLocalPath: savedpath.appending(fileName))
//                    requestsManager.startProcessingRequests()
                }
                
                if directory_List.count == 0{
                    downloadFiles()
                }
                
                print(directory_List)
                for directoryName in directory_List{
                    
                    who = 1
                    currentDir = changeDirectoryUp(path: web_root_path).appending(downloadFromDirectory).appending(directoryName).appending("/")
                   
                    phonePath = creatSubDirectoryToPhone(dirName:directoryName.appending("/"))
                    
//                    print(saveDirectortTo , downloadFromDirectory , downloadLevel)
////
//                    print("3",currentDir)
//                    print(phonePath)
                    // request to fatch all files from directory
                    requestsManager.addRequestForListDirectory(atPath: currentDir )
                    requestsManager.startProcessingRequests()
                }
            }else if downloadLevel == 1{
                print("4",currentDir)
            
                file_List.append(contentsOf: child_file_List)
               
                if childDirFound == true{
                    callCount += 1
                }
                
                
                
                for fileName in child_file_List{
                   finalFileList.append(fileName)
//                    print("Filename" , fileName)
//                    print(saveDirectortTo , downloadFromDirectory , downloadLevel)
                    
                    if childDirFound == true {
                         let currentFile =   changeDirectoryUp(path:currentDir ).appending(saveDirectortTo).appending(fileName)
                         remoteFileList.append(currentFile)
                        
                        saveToPath.append(phonePath.appending(saveDirectortTo).appending(fileName))
                        
//                         requestsManager.addRequestForDownloadFile(atRemotePath: currentFile, toLocalPath: phonePath.appending(saveDirectortTo).appending(fileName))
//                        print(phonePath.appending(saveDirectortTo).appending(fileName))
                    }else{
                         let currentFile = currentDir.appending(fileName)
                         remoteFileList.append(currentFile)
                        saveToPath.append(phonePath.appending(fileName))
//                         requestsManager.addRequestForDownloadFile(atRemotePath: currentFile, toLocalPath: phonePath.appending(fileName))
//                        print(phonePath.appending(fileName))
                    }
                }
                
               
                for directoryName in child_directory_List{
                    who = 1
                    currentDir = downloadFromDirectory.appending(directoryName).appending("/")
                    phonePath = creatSubDirectoryToPhone(dirName:directoryName.appending("/"))
                    phonePath = changeDirectoryUp(path: phonePath)
//                    print(phonePath)
//                    print("5",currentDir)
                    // request to fatch all files from directory
                    requestsManager.addRequestForListDirectory(atPath: currentDir )
                    requestsManager.startProcessingRequests()
                    childDirFound = true
                    temp_child_directory_List = child_directory_List
                }
            }
        }catch {
            print(error)
        }
        
        if callCount == temp_child_directory_List.count && childDirFound == true{
          downloadFiles()
        }
        
        
    }
    
    
    
    func downloadFiles(){
        print(saveToPath.count , remoteFileList.count , finalFileList.count)
        print("save to path\n" , saveToPath , "\n" , "remoteFile\n" , remoteFileList )
        print("\n file List\n" , finalFileList)
        var i = 0
        for item in remoteFileList{
            
            requestsManager.addRequestForDownloadFile(atRemotePath: item, toLocalPath: saveToPath[i])
            requestsManager.startProcessingRequests()
            i += 1
        }
    }
    
    
    func uploadFile(fileName : String){

        requestsManager.addRequestForUploadFile(atLocalPath: currentDir, toRemotePath: fileName)
        requestsManager.startProcessingRequests()
    }

//    func uploadFile(imagePath : String , fileName : String){
//        let fileManager = FileManager.default
//
//
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//            let documentsDirectory = paths[0]
//
//        let fullpath = documentsDirectory.appending("/\(imagePath)/\(fileName)")
//
//        if fileManager.fileExists(atPath: fullpath) {
//            print("FILE AVAILABLE")
//        }else{
//            print("FILE NOT AVAILABLE")
//        }
//        requestsManager.addRequestForUploadFile(atLocalPath: fullpath, toRemotePath: "Demo/Upload1/\()")
//
//       // requestsManager.addRequestForUploadFile(atLocalPath: fullpath, toRemotePath: web_root_path.appending("\(fileName)"))
//        requestsManager.startProcessingRequests()
//    }
//
    func createDirectoryOnFTPServer(directoryName : String){
        requestsManager.addRequestForCreateDirectory(atPath: directoryName)
        requestsManager.startProcessingRequests()
    }
    
    
    
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompleteUploadRequest request: GRDataExchangeRequestProtocol!) {
        print("done")
    }
    
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didFailRequest request: GRRequestProtocol!, withError error: Error!) {
        //startDownloadImages( indexValue : index)
//        print("\n \(error)")
    
        calCEvent()
    }
    
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didFailWritingFileAtPath path: String!, forRequest request: GRDataExchangeRequestProtocol!, error: Error!) {
//        print(error)
        
        calCEvent()
    }
    
    
    
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompletePercent percent: Float, forRequest request: GRRequestProtocol!) {
        
//        calculatePercant(indexId: Float(indexId ) ,  totalfiles: Float(myArray.count - 1))
    }
    
    
    
    func calCEvent(){

        if ( indexA < finalFileList.count)
        {
            calculatePercant(indexIdB: Float(indexA))
        }
        
        if finalFileList.count == indexA {
            calculatePercant(indexIdB: Float(finalFileList.count))
            
        }
        indexA += 1
    }
    
    
    func requestsManager(_ requestsManager: GRRequestsManagerProtocol!, didCompleteDownloadRequest request: GRDataExchangeRequestProtocol!) {
       
        calCEvent()
        print("its download")
    }
    
    
    
    
    // download single file
    func downloadSingleFile(file_Name : [String] , item_Name :  [String]) {
        who = 0;
        self.file_Name = file_Name
        self.item_Name = item_Name
        
//        print(file_Name , item_Name)
        currentDir = (changeDirectoryUp(path: web_root_path).appending("VisualAid/"))
        // request to fatch all files from directory
        
        requestsManager.addRequestForListDirectory(atPath: currentDir )
        requestsManager.startProcessingRequests()
    }

    
    // downloaqd full directory
    func downloadDirectory(directoryPath : String , listName : [String]){
        who = 1;

        currentDir = (changeDirectoryUp(path: web_root_path).appending("VisualAid/"))
        // request to fatch all files from directory
        requestsManager.addRequestForListDirectory(atPath: currentDir )
        requestsManager.startProcessingRequests()
        
    }
    
    func calculatePercant(indexIdB : Float ){
        
        
          //   print( indexId , totalfiles , (indexId * 1000) / totalfiles )
            let temp = indexIdB * 100
//            print(temp)
//
//
//            print("print2" ,indexIdB,finalDownloadingList.count  )
        print(indexIdB , finalFileList.count)
            
            if indexIdB == 0 {
                delegate?.getPercant(precent: 0, fileName: finalFileList[Int(indexIdB)])            }
            else if Int(indexIdB) == finalFileList.count-1{
                    delegate?.getPercant(precent: 100, fileName:finalFileList[(finalFileList.count-1)])
            }
            else {
//                print ( "print3",(Int(temp) / finalDownloadingList.count-1))
                
                delegate?.getPercant(precent: (Int(temp) / finalFileList.count),  fileName:finalFileList[Int(indexIdB)])
            }
        
    }
    
    
    
//    func contDownload(){
//        if isCatalogFound == true {
//            currentDir = changeFTPPath(directoryName: "Catalog")
//            phonePath =  creatDirectoryToPhone(dirName: "Catalog")
//            print(phonePath)
//            print(currentDir)
//            requestsManager.addRequestForListDirectory(atPath: currentDir )
//            requestsManager.startProcessingRequests()
//
//            isCatalogFound = false
//        }
//        if currentDir.contains("Catalog") && directoryNames.count > 0 && directoryNames.count > directoryIndex{
//            if directoryIndex == 0{
//                currentDir = changeDirectoryUp(path: directoryNames[directoryIndex])
//            }
//            else {
//                currentDir = changeDirectoryUp(path: currentDir)
//                currentDir = changeDirectoryUp(path: directoryNames[directoryIndex])
//            }
//            requestsManager.addRequestForListDirectory(atPath: currentDir )
//            requestsManager.startProcessingRequests()
//            directoryIndex += 1
//        }
//    }
//
    
    func changeFTPPath(directoryName : String) -> String{
        return currentDir.appending("\(directoryName)/")
    }
    

    
    func clearDiskCache(){
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("/Cbo/Product/")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        print(filePaths)
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
    
    
    func creatSubDirectoryToPhone( dirName : String)  -> String {
    
        let fileManager = FileManager.default
        
         phonePath = phonePath.appending(dirName)
        
        if !fileManager.fileExists(atPath: phonePath){
            do {
                try fileManager.createDirectory(atPath: phonePath , withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
//        print(phonePath)
        return phonePath
    }
    
    
    
    
    func getDocumentDirectory() throws -> String{
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
        let fileManager = FileManager.default
        
        let filePath = documentDirectory.appending("/Cbo/Product/")
            if !fileManager.fileExists(atPath: filePath) {
                do {
                    try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                   throw error
                }
                return filePath
            }
            else {
                return  filePath
            }
    }
    
    
    
    
    
    
    
    private func setFtpUserName(for ftpWriteStream: CFWriteStream, userName: CFString) throws {
        let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPUserName)
            CFWriteStreamSetProperty(ftpWriteStream, propertyKey, userName)
    }
    
    private func setFtpPassword(for ftpWriteStream: CFWriteStream, password: CFString) throws {
        let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPPassword)
             CFWriteStreamSetProperty(ftpWriteStream, propertyKey, password)
    }
    
    fileprivate func ftpWriteStream(forFileName fileName: String) -> CFWriteStream? {
       
        let fullyQualifiedPath = "ftp://\(ftp_hostname)\(web_root_path)\(fileName)"
        
        guard let ftpUrl = CFURLCreateWithString(kCFAllocatorDefault, fullyQualifiedPath as CFString, nil) else {
            //get the reason
            
            return nil }
        let ftpStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorDefault, ftpUrl)
        
        let ftpWriteStream = ftpStream.takeRetainedValue()
        do{
            try setFtpUserName(for: ftpWriteStream, userName: ftp_username as CFString)
            try setFtpPassword(for: ftpWriteStream, password: ftp_password as CFString)
        }catch{
            print(error)
        }

        
        return ftpWriteStream
    }
    
    
    
    
    fileprivate func uploadFile(data: Data, with fileName: String, success: @escaping ((Bool)->Void)) {
        
        guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else {
            success(false)
            return
        }
        
        if CFWriteStreamOpen(ftpWriteStream) == false {
            print("Could not open stream")
            success(false)
            return
        }
        
        
       
        let fileSize = data.count
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
        data.copyBytes(to: buffer, count: fileSize)
        
        defer {
            CFWriteStreamClose(ftpWriteStream)
            buffer.deallocate(capacity: fileSize)
        }
        
        var offset: Int = 0
        var dataToSendSize: Int = fileSize
        
        repeat {
            let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
            if bytesWritten > 0 {
                offset += bytesWritten.littleEndian
                dataToSendSize -= bytesWritten
                continue
            } else if bytesWritten < 0 {
//
                break
            } else if bytesWritten == 0 {
                
                break
            }
        } while CFWriteStreamCanAcceptBytes(ftpWriteStream)
//
        success(true)
    }
    


    
    func checkDirectoryOnServer() -> Bool{
        var flag = true
        let request = LxFTPRequest.resourceList()
        request?.serverURL = (URL(string: "ftp://\(ftp_hostname)\(web_root_path)")! as URL)
        request?.username = ftp_username
        request?.password = ftp_password
        request?.progressAction = {(_ totalSize: Int, _ finishedSize: Int, _ finishedPercent: CGFloat) -> Void in
        }

        request?.successAction = { (resultClass, result) in
            print(resultClass as Any , result as Any)
        }

        request?.failAction = { (domain, error, errorMessage) in
            print(domain , error, errorMessage!)
            //Fail ....
       
            switch error {
                case 550:
                    // file or directory not found
                    
                
                    self.createDirectoryOnFTPServer(directoryName: self.web_root_path)
//                    self.UploadDelegate?.upload_complete(IsCompleted: "ERROR")
                    flag = self.checkDirectoryOnServer()
                    break
                case 530:
                    // not logged in
                    flag = false
                    self.UploadDelegate?.upload_complete(IsCompleted: "530")
                    break
                
                case 50:
                    self.UploadDelegate?.upload_complete(IsCompleted: "50")
                    // connection error
                    flag = false
                break
                default:
                    print("")
            }
        }
        request?.start()
        return flag
    }
    
    func uploadFile(data : Data , fileName : String){
        DispatchQueue.main.async {
            self.UploadDelegate?.upload_complete(IsCompleted: "S")
        }
        
        if (checkDirectoryOnServer()){
        
            uploadFile(data: data , with: fileName) { _ in
               DispatchQueue.main.async { self.UploadDelegate?.upload_complete(IsCompleted: "Y")
                }
            }
        }
    }
    
    
    
    

}
    
    
//    func convertingArrayToDictionary(listName : [String]){
//        myImagesDic.removeAll()
//        var tempArray = [String]()
//        var l = 0
//        for i in 0 ..< listName.count{
//            if (listName[i] as NSString).pathExtension ==  "jpg" || (listName[i] as NSString).pathExtension ==  "png"   {
//
//                tempArray.removeAll()
//
//                for j in 0 ..< listName.count{
//                    // print(listName[j].first! , i)
//
//                    var k = 0
//                    let var1  : String =  listName[j].subString(offsetFrom: 0, offSetTo: 0)  , var2 = "\(i)"
//
//                    if var1 == var2 {
//                        //                    print("\(i)=\(listName[j])")
//                        tempArray.insert(listName[j], at: k)
//                        k += 1
//                    }
//                }
//                if !( tempArray.isEmpty){
//                    //                    print(tempArray)
//                    myImagesDic.insert([tempArray[0] : tempArray], at: l)
//                    l += 1
//                }
//            }
//        }
//
//        // self.myImagesDic = myImagesDic
//        for indexpathrow in 0 ..< myImagesDic.count{
//            let innerDic = myImagesDic[indexpathrow] as Dictionary<String , [String]>
//
//            for innerArray in innerDic{
//
//                //                print(innerArray.value)
//
//                print("print" , innerArray.key)
//                //                                print(arrayDic.keys.startIndex)
//                //                                if innerArray == i.keys.first  {
//                //                                    print(i.keys)
//                //                                }
//            }
//        }
//    }
//
    

    
    
   // cc novo
   // 38demo
   // pw 38
//
//}







