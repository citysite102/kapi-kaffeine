//
//  KPUserDefaults.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

final public class KPUserDefaults {

    
//    static var defaults = UserDefaults(suiteName: AppConstant.userDefaultsSuitName)
    static var defaults = UserDefaults.standard
    
    
    struct userInformationKey {
        static let accessToken = "accessToken"
        static let userIdentifier = "user_identifier"
    }
    
    public static var userIdentifier: String?
    public static var userDisplayName: String?
    public static var userIntro: String?
    public static var userEmail: String?
    
    public static var accessToken: String? {
        didSet {
            if accessToken != nil {
                print("Set Access Token as \(accessToken!)")
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                print("Stored Access Token \(UserDefaults.standard.object(forKey: "accessToken") as! String)")
                
            }
        }
    }
    
    public static var userInformation: NSDictionary? {
        didSet {
            
            if let identifier = userInformation?["member_id"] {
                UserDefaults.standard.set(identifier as? String, forKey: "user_identifier")
                self.userIdentifier = identifier as? String
            }
        }
    }
    
    static func loadUserInformation() {
//        if defaults == nil {
//            defaults = UserDefaults(suiteName: AppConstant.userDefaultsSuitName)
//        }
        accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String
        userIdentifier = UserDefaults.standard.object(forKey: "user_identifier") as? String
        
        if accessToken != nil {
            print("Get Access Token as \(accessToken!)")
        }
    }
    
    static func clearUserInformation() {
        UserDefaults.standard.removeObject(forKey: userInformationKey.accessToken)
        UserDefaults.standard.removeObject(forKey: userInformationKey.userIdentifier)
    }
    
}
