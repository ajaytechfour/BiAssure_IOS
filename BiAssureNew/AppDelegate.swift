//
//  AppDelegate.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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


}

