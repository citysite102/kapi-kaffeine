//
//  AppDelegate.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 18/03/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FacebookCore
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // Google Map
        GMSServices.provideAPIKey("AIzaSyCZiprr4NXdrs4ChdmQ8nNVrAPZJWoy3TQ")
        GMSPlacesClient.provideAPIKey("AIzaSyCZiprr4NXdrs4ChdmQ8nNVrAPZJWoy3TQ")
        
        KPLocationManager.sharedInstance().hello()
        
        
        // Facebook
        SDKApplicationDelegate.shared.application(application,
                                                  didFinishLaunchingWithOptions: launchOptions)
        
        
        // Firebase
        FIRApp.configure()
        
        // Navigation Custom Settings
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.isTranslucent = false;
        navigationBarAppearace.tintColor = KPColorPalette.KPTextColor.whiteColor
        navigationBarAppearace.barTintColor = KPColorPalette.KPMainColor.mainColor_light
        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                                                      NSForegroundColorAttributeName: KPColorPalette.KPTextColor.whiteColor!]
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
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
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


