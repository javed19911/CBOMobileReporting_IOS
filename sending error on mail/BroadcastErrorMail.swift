//
//  BroadcastErrorMail.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 31/03/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UserNotifications
class BroadcastErrorMail : NSObject {
//    static var sharedBroadCast = BroadcastErrorMail()
    private var customVariablesAndMethod : Custom_Variables_And_Method!
    private var center : UNUserNotificationCenter!
    private var dataDict = [String : String]()
//    private var sendTo = "" , mailSubject = "" , mailText = ""
    private var mailSubject = "" , methodName = "" , errorAlert = "" , extraMsg = "" , errorType = "" , url = ""
    private var vc : CustomUIViewController!
     var msgString = ""
    
    
    init( dataDict : [String : String] ,mailSubject : String,   vc : CustomUIViewController  ) {
        super.init()
        center = UNUserNotificationCenter.current()
        self.vc = vc
        self.mailSubject = mailSubject
        self.dataDict = dataDict
        customVariablesAndMethod = Custom_Variables_And_Method.getInstance()
    }
    

    
    func requestAuthorization()  {
        center.requestAuthorization(options: [.alert]){  (genrate , error)  in
            if error == nil{
                self.sendLocal(in: TimeInterval(1) , dataDict:  self.dataDict )
            }
        }
    }
        func sendLocal(in timer : TimeInterval , dataDict : [String : String]) {
            let content = UNMutableNotificationContent()
            
            var msgText = ""
//        content.title = NSString.localizedUserNotificationString(forKey: "hello", arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: " this is last day of this financial year 2017-2018", arguments: nil)
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timer, repeats: false)
        let request = UNNotificationRequest(identifier: "sendErrorMail", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error == nil {
            
                for dataitems in dataDict{
                      msgText = msgText.appending("\(dataitems.key) : \(dataitems.value) \n")
                }
                
                print(msgText)
                
                print(self.customVariablesAndMethod.getObject(context: self.vc, key: "currentBestLocation_Validated").coordinate)
                
                print(self.customVariablesAndMethod.getObject(context: self.vc, key: "currentBestLocation_Validated").timestamp)
                let objSendMail = SendMail(sendTo: "mobileapperror@gmail.com", mailSubject: "\(Custom_Variables_And_Method.COMPANY_CODE!) : \(self.mailSubject)" , vc: self.vc, mailText: "\(self.customVariablesAndMethod.getAppName()) \n Company Code : \(Custom_Variables_And_Method.COMPANY_CODE!) \n DCR ID : \(Custom_Variables_And_Method.DCR_ID) \n PA ID : \(Custom_Variables_And_Method.PA_ID) \n  App version : \(Custom_Variables_And_Method.VERSION)\n Lat & Long : \(self.customVariablesAndMethod.getObject(context: self.vc, key: "currentBestLocation_Validated").coordinate) \n  Time : \(self.customVariablesAndMethod.getObject(context: self.vc, key: "currentBestLocation_Validated").timestamp) \n \(msgText)")
                
                objSendMail.sendMail()

            }
        }
    }
}



