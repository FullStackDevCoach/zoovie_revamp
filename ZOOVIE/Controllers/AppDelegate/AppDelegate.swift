//
//  AppDelegate.swift
//  ZOOVIE
//
//  Created by abc on 12/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    //MARK:- Variables
    var window: UIWindow?
    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var previousCell:BookingTableCell!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        print(AppManager.sharedInstance.userToken ?? "")
        if AppManager.sharedInstance.userToken == nil || AppManager.sharedInstance.userToken == ""{
            self.goToSplashVC()
        }else{
            self.goToHomeVC()
        }
       STPPaymentConfiguration.shared().publishableKey =
        "pk_test_87jHzpePjzoUCzS5EgxjmKgq00fOpIbCGm" //Test
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.Zoovie"
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            }
            application.registerForRemoteNotifications()
            Messaging.messaging().delegate = self
        
        return true
    }
    func goToHomeVC(){
        let homeNavigation = self.mainStoryboard.instantiateViewController(identifier: "HomeNav") as! UINavigationController
        self.window?.rootViewController = homeNavigation
        self.window?.makeKeyAndVisible()
    }
    func goToSplashVC(){
        UserDefaults.standard.removeObject(forKey: Constants.Variables.kAuthToken)
        let homeNavigation = self.mainStoryboard.instantiateViewController(identifier: "SplashNav") as! UINavigationController
        self.window?.rootViewController = homeNavigation
        self.window?.makeKeyAndVisible()
    }
}

// MARK: Create Instance
extension AppDelegate {
   static var sharedDelegate: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        if let dict = userInfo as? [String:Any] {
            print(dict)
        }
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("",userInfo)
        if let dict = userInfo as? [String:Any] {
            
            print("******  second   *********")
            
            print(dict)
            
        }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppManager.sharedInstance.deviceToken = fcmToken
    }
}
