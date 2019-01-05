//
//  SendMail.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 23/03/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation

class SendMail : NSObject {
    
    private var progressHUD : ProgressHUD!
    private var mailText : String!
    private var objSendMail : MCOSMTPSession!
    private var vc = CustomUIViewController()
    private var sendTo = "" , mailSubject = ""
    init(sendTo : String , mailSubject : String , vc : CustomUIViewController , mailText : String ) {
        super.init()
      
        self.vc = vc
        progressHUD = ProgressHUD(vc: vc)
        self.mailSubject = "\(mailSubject)"
        self.sendTo = sendTo
        self.configMail()
        
        self.mailText = getHTMLText( mailText : mailText)
        
    }
    
    func getHTMLText( mailText : String) -> String{
        
        let result = mailText.replacingOccurrences(of: "\n", with: "</br> <br>",
                                                    options: NSString.CompareOptions.literal, range:nil)
        
        let convertedText = "<p><br> \(result.appending(" </br></p>"))"
        
        print("result :\(convertedText)")
       
        return convertedText
    }
    
    func sendMail(){
        sendingOperation()
    }
    
    private func configMail(){
        progressHUD.show(text: "Please wait ...\nSending Mail" )
        
        objSendMail = MCOSMTPSession()
        objSendMail.hostname = "smtp.gmail.com"
        objSendMail.username = "mobileapperror@gmail.com"
        objSendMail.password = "Cbo@12345"
        objSendMail.port = 465
        objSendMail.authType = MCOAuthType.saslPlain
        objSendMail.connectionType = MCOConnectionType.TLS
        objSendMail.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
    }
    
    
    
    private func sendingOperation(){
    
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: sendTo, mailbox: sendTo)]
        builder.header.from = MCOAddress(displayName: "mobileapperror@gmail.com", mailbox: sendTo)
        builder.header.subject =  mailSubject
        builder.htmlBody = mailText
        
        let mailData = builder.data()
        let sendOperation = objSendMail.sendOperation(with: mailData)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
            } else {
                self.progressHUD.dismiss()
                NSLog("Successfully sent email!")
            }
        }
        
        progressHUD.dismiss()
    }
    
}
