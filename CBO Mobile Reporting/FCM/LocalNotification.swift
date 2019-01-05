//
//  LocalNotification.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 28/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import  UserNotifications
class LocalNotification : NSObject , UNUserNotificationCenterDelegate{
    
    private var title : String!
    private var msg : String!
    private var url : String!
    private var logo : String!
    private var cboDbHelper : CBO_DB_Helper = CBO_DB_Helper.shared
    
    init( title : String , msg : String,url : String , logo : String  ){
        super.init()
        self.title = title
        self.msg = msg
        self.url = url
        self.logo = logo
        genrateLocalNotification(title: title, msg: msg)
    }
    

    
    private func genrateLocalNotification(title : String , msg : String ){
        
        //UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = msg
        content.badge = (cboDbHelper.getNotification_count() + 1) as NSNumber
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Local_Notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            // handler
            if let error = error {
                // Something went wrong
                print(error.localizedDescription)
            }
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge]) //required to show notification when in foreground
    }
   
    

}
