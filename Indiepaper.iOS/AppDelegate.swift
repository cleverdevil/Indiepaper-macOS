//
//  AppDelegate.swift
//  Indiepaper.iOS
//
//  Created by Edward Hinkle on 7/9/18.
//  Copyright © 2018 Jonathan LaCour. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle URL's for configuration of the format:
        //
        //     indiepaper://configure?micropubTargetURL=XXX&bearerToken=YYY
        //
        // Eventually, we could support additional URL options, but only configuration for now.
        print("Attempting URL Call in App Delegate")

        // TODO: The line below needs to be uncommented and the suiteName needs to become the App Group name
        // let defaults = UserDefaults(suiteName: "group.io.cleverdevil.Indiepaper")!
        let defaults = UserDefaults.standard
        let urlToOpen = URLComponents(url: url.absoluteURL, resolvingAgainstBaseURL: false)

        if urlToOpen?.host == "configure" {
            urlToOpen?.queryItems?.forEach { item in
                if item.name == "micropubTargetURL" {
                    if item.value != nil, let micropubTargetUrl = URL(string: item.value!) {
                        print("Setting Target Url")
                        defaults.set(micropubTargetUrl, forKey: "targetURL")
                    }
                }
                if item.name == "bearerToken" {
                    if item.value != nil {
                        print("Setting Bearer Token")
                        defaults.set(item.value!, forKey: "bearerToken")
                    }
                }
            }
        }
        
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


}

