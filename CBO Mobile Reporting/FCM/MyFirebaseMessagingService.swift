//
//  FCM_Silent_Notification.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 27/06/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UserNotifications
import UIKit
class  MyFirebaseMessagingService : NSObject{
    
    private var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    private var msg : String!
    private var msgtyp : String!
    private var title : String!
    private var requestCode = 0
    private var url = ""
    private var  logo = ""
    private var center : UNUserNotificationCenter!
    private var flag_logo=false,flag_info=false,insert=true;
    private var cboDbHelper : CBO_DB_Helper!
//    private var custom
    private var customVariablesAndMethods : Custom_Variables_And_Method!
    
    
    init(msg : String) {
        super.init()
        
//        topWindow?.rootViewController = CustomUIViewController()
//        topWindow?.windowLevel = UIWindowLevelAlert + 1
//
        
        customVariablesAndMethods = Custom_Variables_And_Method.getInstance()
        center = UNUserNotificationCenter.current()
        sendNotification(message: msg)
    }
    

    
    private func presentFCM_Notification(){
        let alert = UIAlertController(title: "APNS", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("this is the msg \(self.msg)")
            self.topWindow?.isHidden = true // if you want to hide the topwindow then use this
//            topWindow = nil
           
        }))
        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }


    
    //This method is generating a notification and displaying the notification
    
    private func sendNotification( message : String) {
        
        
        msgtyp = "Message from server";
        title = "Hello";
        msg = "Hello";
        url="";
        logo="";
        
        cboDbHelper = CBO_DB_Helper.shared
        var msgDict = [String : String]()
        let dict = CboServices().convertStringToDictionary(text: message )
        let innerBody = dict!["body"] as! [NSDictionary]
        print(innerBody)
        for i in innerBody{
            msgDict["\(i.allKeys[0] as! String )"] = i.value(forKey: i.allKeys[0] as! String ) as? String
        }
        print(msgDict)
    
        if msgDict["msgtyp"]! == "MAIL"{
            logo = msgDict["logo"]!
            url = msgDict["url"]!
            if logo.isEmpty || logo == ""{
                flag_logo = false
            }else {
                flag_logo = true
            }
            if url.isEmpty || url == ""{
                flag_info=false
            }else {
                flag_info=true;
            }
        
            insert=false;
            //    new generatePictureStyleNotification(this,title,msg,url,intent).execute();
            //
        } else if msgDict["msgtyp"]! == "DOB_DOA"{
            if (logo.isEmpty || logo == ""){
                    flag_logo=false;
                }else{
                    flag_logo=true;
                }
                if (url.isEmpty || url == ""){
                    flag_info=false;
                }else {
                    flag_info=true;
                }
                //    new generatePictureStyleNotification(this,title,msg,url,intent).execute();
        } else if (msgDict["msgtyp"]!.contains("WS_")) {
               // let tag = msgDict["msgtyp"]!.substringFrom(offSetFrom: 3)
        } else if (msgDict["msgtyp"]! == "MSG") {
             title = msgDict["tilte"]!
             url = msgDict["url"]!
             msg = msgDict["msg"]!
           
            _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)
        }else if (msgDict["msgtyp"]! ==  "SERVICE_URL") {
            
            title = "WEB SERVICE UPDATED"
        
            msg = msgDict["msg"]!

            
            if( !msg.isEmpty && msg != "" && msg != "Hello") {
                 customVariablesAndMethods.setDataInTo_FMCG_PREFRENCE(key: "WEBSERVICE_URL", value: msg)
            }
                msg = "New webservices configured successfully";
             _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)
        
        } else if (msgDict["msgtyp"]! == "SET_PREFRENCE") {
        //    intent = new Intent(this, com.cbo.cbomobilereporting.ui_new.mail_activities.Notification.class);
        //    JSONObject jsonObject1 = jsonArray.getJSONObject(1);
         
                title = msgDict["tilte"]!
                msg = msgDict["msg"]!
                if( !msg.isEmpty  && msg != "Hello" ) {
                    customVariablesAndMethods.setDataInTo_FMCG_PREFRENCE(key: title, value: msg)
                }
                msg="Setting updated successfully";

            _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)
         
 
        }else if (msgDict["msgtyp"]! == ("FLASH_MESSAGE")) {

            title="FLASH MESSAGE";
            msg = msgDict["msg"]!

            if(!msg.isEmpty  && msg != "" && msg != "Hello") {
                customVariablesAndMethods.setDataInTo_FMCG_PREFRENCE(key: "mark", value: msg)
            }
            _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)

        }else if msgDict["msgtyp"]! == "CALL" {
            title = msgDict["tilte"]!
            url = msgDict["url"]!
            msg = msgDict["msg"]!
            logo = msgDict["logo"]!
            
              if(!msg.isEmpty && msg != "" && msg != "Hello") {
                //cboDbHelper.updateLatLongOnCall(lat_long,dr_id,doc_type);
                
                cboDbHelper.updateLatLongOnCall(latlong: url, id: title, type: msg);
                title = "Updated...";
                msg = "DCR Successfully Updated...";
                _ = LocalNotification(title: title, msg: msg,url: "",logo: "")
            }
            //insert=false;
        } else if (msgDict["msgtyp"]! == "REG") {

            title = msgDict["tilte"]!
            url = msgDict["url"]!
            msg = msgDict["msg"]!
            logo = msgDict["logo"]!

            if(!msg.isEmpty && msg != "" && msg != "Hello") {
                //cboDbHelper.updateLatLong(lat_long,dr_id,doc_type);
                
                cboDbHelper.updateLatLong(latlong: url, id: title, type: msg,index: logo)
                
                if(msg == ("D")) {
                    title = "Doctor Registration";
                }else if(msg == ("S")) {
                    title = "Stockist Registration";
                }else {
                    title = "Chemist Registration";
                }
                if(url == ("")) {
                    msg = "Registration Successfully Reset";
                }else {
                    msg = "Registration Successfully Done";
                }
            }
            _ = LocalNotification(title: title, msg: msg,url: "",logo: logo)
        } else if (msgDict["msgtyp"]! == "CALL_LOCK") {
            

            title = msgDict["tilte"]!
            msg = msgDict["msg"]!

            if (!msg.isEmpty && msg != "Hello" && msg.contains("unlocked")) {
                customVariablesAndMethods.setDataInTo_FMCG_PREFRENCE(key: "CALL_UNLOCK_STATUS", value: "[CALL_UNLOCK]")
            }
             _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)
        }else if (msgDict["msgtyp"]! == "APPROVAL_URL") {
            
            title = msgDict["tilte"]!
            msg = msgDict["msg"]!
            url = msgDict["url"]!

            
//            if( !url.isEmpty && url != "") {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "Doctor_registration_GPS") as! Doctor_registration_GPS
//                    vc.VCIntent["A_TP"] = url
//                    vc.VCIntent["Title"] = title
////                intent = new Intent(context, DrRegistrationView.class);
////                intent.putExtra("A_TP", url);
////                intent.putExtra("Title", title);
//            }
             _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)
        }else{
            title = msgDict["tilte"]!
            msg = msgDict["msg"]!
            url = msgDict["url"]!
            logo = msgDict["logo"]!
            
            if (logo.isEmpty || logo == "" ){
                flag_logo=false;
            }else{
                flag_logo=true;
            }
            if (url.isEmpty || url == "" ){
                flag_info=false;
            }else {
                flag_info=true;
            }
             _ = LocalNotification(title: title, msg: msg,url: url,logo: logo)
        }
        //let badgeCount = cboDbHelper.getNotification_count() + 1
//        ShortcutBadger.applyCount(this, badgeCount); //for 1.1.4+
        
//        Calendar cal = Calendar.getInstance();
//        cal.add(Calendar.DATE, -7);
        //cboDbHelper.delete_weakOld_Notification(cal);
        if (insert) {
            let date1 = customVariablesAndMethods.currentDate();
            let time = customVariablesAndMethods.currentTime(context: nil);
            cboDbHelper.insert_Notification(Title: title, msg: msg, logo: logo, content: url, status: "0", date: date1, time: time);
        }

       
    }



    private func big_table_Style( requestCode : Int ){
//    PendingIntent pendingIntent = PendingIntent.getActivity(this, requestCode, intent, PendingIntent.FLAG_ONE_SHOT);
//    
        var dis : String!
//
//    //Assign inbox style notification
//    NotificationCompat.InboxStyle inboxStyle =
//    new NotificationCompat.InboxStyle();
//    inboxStyle.setBigContentTitle(title);
        
        
        var msg2 = msg;
        msg2 = msg2?.replacingOccurrences(of: "@", with: "#_") //  .replace("@","#_");
        msg2 = msg2?.replacingOccurrences(of: "^" , with:"@");
        
        var msglist = msg2?.split(separator: "@")
        dis = String( msglist![0])
        var x = (msglist?.count)!
        if x>=6{
            x = 6
        }
        
        
        var y = (msglist?.count)! - x
        if y>0{
//             inboxStyle.setSummaryText("+"+y+" more");
        }

        for i in 0..<x {
            var msg1 = String (msglist![i])
            msg1 = msg1.replacingOccurrences(of: "#_", with: "@");
            //    inboxStyle.addLine(msg1);
        }
        
    }
    
    

    
}





//    public class generatePictureStyleNotification extends AsyncTask<String, Void, Bitmap> {
//    
//    private Context mContext;
//    private String title, message, imageUrl;
//    int requestCode =0;
//    Intent intent;
//    
//    public generatePictureStyleNotification(Context context, String title, String message, String imageUrl,Intent intent) {
//    super();
//    this.mContext = context;
//    this.title = title;
//    this.message = message;
//    this.imageUrl = imageUrl;
//    this.intent=intent;
//    /*DisplayMetrics displaymetrics = new DisplayMetrics();
//     ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
//     height = (displaymetrics.heightPixels-displaymetrics.heightPixels%5)/5;
//     width = displaymetrics.widthPixels;*/
//    }
//    
//    @Override
//    protected Bitmap doInBackground(String... params) {
//    
//    InputStream in;
//    Bitmap myBitmap=null;
//    try {
//    if(flag_info) {
//    URL url = new URL(this.imageUrl);
//    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
//    connection.setDoInput(true);
//    connection.connect();
//    in = connection.getInputStream();
//    myBitmap = BitmapFactory.decodeStream(in);
//    connection.disconnect();
//    Log.v("javed","true2");
//    //Bitmap resized = Bitmap.createScaledBitmap(myBitmap, width, height, true);
//    }
//    if(flag_logo){
//    URL url = new URL(logo);
//    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
//    connection.setDoInput(true);
//    connection.connect();
//    in = connection.getInputStream();
//    largeIcon = BitmapFactory.decodeStream(in);
//    connection.disconnect();
//    }
//    if(flag_info){
//    return myBitmap;
//    }
//    return myBitmap;
//    } catch (IOException e) {
//    e.printStackTrace();
//    }
//    return null;
//    }
//    
//    
//    @Override
//    protected void onPostExecute(Bitmap result) {
//    super.onPostExecute(result);
//    if(!flag_info){
//    big_table_Style(requestCode,intent);
//    }else {
//    PendingIntent pendingIntent = PendingIntent.getActivity(mContext, requestCode, intent, PendingIntent.FLAG_ONE_SHOT);
//    Uri sound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
//    
//    NotificationCompat.Builder noBuilder = new NotificationCompat.Builder(mContext)
//    .setContentTitle(title)
//    .setContentText(msg)
//    .setSmallIcon(R.drawable.cbo_noti)
//    .setAutoCancel(true)
//    .setDefaults(Notification.DEFAULT_ALL)
//    .setLargeIcon(largeIcon)
//    .setStyle(new NotificationCompat.BigPictureStyle().bigPicture(result))
//    .setContentIntent(pendingIntent);
//    
//    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//    int color = 0x125688;
//    noBuilder.setColor(color);
//    noBuilder.setSmallIcon(R.drawable.cbo_noti);
//    }
//    
//    Random random = new Random();
//    int m = random.nextInt(9999 - 1000) + 1000;
//    NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
//    notificationManager.notify(m, noBuilder.build()); //m = ID of notification
//    
//    }
//    }
//    }
//    
//    
//    public class generateInboxStyleNotification extends AsyncTask<String, Void, Bitmap> {
//    
//    private Context mContext;
//    private String  message, imageUrl,dis,tag,paid,companyFolder;
//    int requestCode =0;
//    Intent intent;
//    
//    public generateInboxStyleNotification(Context context,String tag) {
//    super();
//    this.mContext = context;
//    this.tag=tag;
//    this.paid=cboDbHelper.getPaid();
//    this.companyFolder=cboDbHelper.getCompanyCode();
//    }
//    
//    @Override
//    protected Bitmap doInBackground(String... params) {
//    intent = new Intent(getApplicationContext(), com.cbo.cbomobilereporting.ui_new.mail_activities.Notification.class);
//    JSONArray jsonArray = null;
//    try {
//    //message=new ServiceHandler(mContext).getReponseGcmCommon(companyFolder,paid,tag);
//    message="[{\"tilte\":\"You have a mail\"},{\"msg\":[{\"item\":\"<TD><STRONG>NAME</STRONG></TD><TD><STRONG>DR</STRONG></TD>" +
//    "    <TD><STRONG>CHEMIST</STRONG></TD>\"},{\"item\":\"message 2\"},{\"item\":\"message 1\"},{\"item\":\"message 2\"},{\"item\":\"message 3\"},{\"item\":\"message 1\"},{\"item\":\"message 2\"},{\"item\":\"message 3\"},{\"item\":\"message 3\"}]}]";
//    jsonArray = new JSONArray(message);
//    JSONObject jsonObject = jsonArray.getJSONObject(0);
//    title = jsonObject.getString("tilte");
//    JSONObject jsonObject1 = jsonArray.getJSONObject(1);
//    msg = jsonObject1.getString("msg");
//    } catch (JSONException e) {
//    e.printStackTrace();
//    }
//    
//    return null;
//    }
//    
//    
//    @Override
//    protected void onPostExecute(Bitmap result) {
//    super.onPostExecute(result);
//    PendingIntent pendingIntent = PendingIntent.getActivity(mContext, requestCode, intent, PendingIntent.FLAG_ONE_SHOT);
//    
//    
//    
//    //Assign inbox style notification
//    NotificationCompat.InboxStyle inboxStyle =
//    new NotificationCompat.InboxStyle();
//    
//    inboxStyle.setBigContentTitle(title);
//    try {
//    JSONArray jsonArray1 = new JSONArray(msg);
//    JSONObject jsonObject9 = jsonArray1.getJSONObject(jsonArray1.length()-1);
//    dis =jsonObject9.getString("item");
//    
//    int x=jsonArray1.length();
//    if(x>=6){
//    x=6;
//    }
//    int y=jsonArray1.length()-x;
//    if(y>0){
//    inboxStyle.setSummaryText("+"+y+" more");
//    }
//    for (int i=0;i<x-1;i++){
//    JSONObject jsonObject = jsonArray1.getJSONObject(i);
//    inboxStyle.addLine(Html.fromHtml(jsonObject.getString("item")));
//    }
//    
//    } catch (JSONException e) {
//    e.printStackTrace();
//    }
//    
//    
//    //build notification
//    NotificationCompat.Builder mBuilder =
//    new NotificationCompat.Builder(mContext)
//    .setSmallIcon(R.drawable.cbo_noti)
//    .setContentTitle(title)
//    .setContentText(dis)
//    .setAutoCancel(true)
//    .setDefaults(Notification.DEFAULT_ALL)
//    .setStyle(inboxStyle)
//    .setContentIntent(pendingIntent);
//    
//    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//    int color = 0x125688;
//    mBuilder.setColor(color);
//    mBuilder.setSmallIcon(R.drawable.cbo_noti);
//    }
//    
//    Random random = new Random();
//    int m = random.nextInt(9999 - 1000) + 1000;
//    NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
//    notificationManager.notify(m, mBuilder.build()); //m = ID of notification
//    
//    }
//    }


