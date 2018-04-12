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
import GoogleMobileAds
import UserNotifications
import Fabric
import Crashlytics
import Amplitude_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // Google Map
        GMSServices.provideAPIKey("AIzaSyCZiprr4NXdrs4ChdmQ8nNVrAPZJWoy3TQ")
        GMSPlacesClient.provideAPIKey("AIzaSyCZiprr4NXdrs4ChdmQ8nNVrAPZJWoy3TQ")
        
        let _ = KPLocationManager.sharedInstance()
                
        // Facebook
        SDKApplicationDelegate.shared.application(application,
                                                  didFinishLaunchingWithOptions: launchOptions)
        
        // Firebase
        FirebaseApp.configure()
        
        // Amplitude
        Amplitude.instance().initializeApiKey("4f5f1d32e1e9fde0c7d307c92340944b")
        
        // iRate
        iRate.sharedInstance().appStoreID = 1261224197
        if iRate.sharedInstance().ratedThisVersion {
            iRate.sharedInstance().promptAtLaunch = false
        } else {
            iRate.sharedInstance().remindPeriod = 7
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Ads
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3383422855659572~7972797640")
        
        // Crashlytics
        Fabric.with([Crashlytics.self])
        
        // Remove Login cancel
        UserDefaults.standard.set(false,
                                  forKey: AppConstant.cancelLogInKey)
        
        // Navigation Custom Settings
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.isTranslucent = false

//        navigationBarAppearace.tintColor = KPColorPalette.KPTextColor.whiteColor
//        navigationBarAppearace.barTintColor = KPColorPalette.KPMainColor_v2.mainColor_light
//        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20),
//                                                      NSForegroundColorAttributeName: KPColorPalette.KPTextColor.whiteColor!]
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if KPSchemeHandler.sharedHandler.shouldHandleURLScheme(url) {
            return KPSchemeHandler.sharedHandler.handleURLScheme(url)
        } else {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
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
    
//    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }


}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


