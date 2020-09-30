//
//  AppDelegate.swift
//  BiAssure
//
//  Created by Divya on 25/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase

let Base_Url = "http://bi.servassure.net/api/"
let kMainViewController = (UIApplication.shared.delegate?.window as? UIWindow)?.rootViewController as! MainViewController
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func storeSessionId(session_id:String)
    {
        UserDefaults.standard .set(session_id, forKey: "session_id")
        UserDefaults.standard.synchronize()
    }
    func getSessionId() -> String
    {
        return UserDefaults.standard.value(forKey: "session_id") as? String ?? ""
        
    }
    func storeUserName(user_name:String)
    {
        UserDefaults.standard .set(user_name, forKey: "username")
        UserDefaults.standard.synchronize()
    }
    func getUserName() -> String
    {
        return UserDefaults.standard.value(forKey: "username") as? String ?? ""
        
    }
    func storebuttonName(button:String)
    {
        UserDefaults.standard .set(button, forKey: "buttontap")
        UserDefaults.standard.synchronize()
    }
    func getbuttonName() -> String
    {
        return UserDefaults.standard.value(forKey: "buttontap") as? String ?? ""
        
    }
    func getNewToken() -> String
    {
        return UserDefaults.standard.value(forKey: "newToken") as? String ?? ""
        
    }
    func getToken() -> String
    {
        return UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
    }
    func saveToken(Token:String)
    {
        UserDefaults.standard.set(Token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
}

