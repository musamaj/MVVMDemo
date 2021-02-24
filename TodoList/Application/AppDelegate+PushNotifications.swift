//
//  AppDelegate+PushNotifications.swift
//  TodoList
//
//  Created by Usama Jamil on 27/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import UserNotifications
import UserNotificationsUI
import FirebaseInstanceID
import ObjectMapper
//import FirebaseMessaging


enum dataTypes: String {
    
    case list
    case task
    case subtask
    case comment
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        guard let map = Mapper<CategoryData>().map(JSON: userInfo["list"] as! [String : Any]) else { return }
//        guard let recentUserStr = userInfo["recent_user"] as? String else { return }
//        let con = try! JSONSerialization.jsonObject(with: recentUserStr.data(using: .utf8)!, options: []) as! [String:Any]
//        guard let mapp = Mapper<User>().map(JSON: con) else { return }
        
        self.category = map
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEvent), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //completionHandler()
        
    }
    
    @objc func handleEvent() {
        // handle event
//        let delay = killedState ? 2.0 : 0.0
//        if Persistence.shared.isUserAlreadyLoggedIn {
//            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { // Change `2.0` to the desired number of seconds.
//                // Code you want to be delayed
//                self.navigate(data: self.notifData)
//            }
//        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
        Persistence.shared.deviceID = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    
    
    /// Register for push notifications
    
    func registerForPushNotification(){
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
}
