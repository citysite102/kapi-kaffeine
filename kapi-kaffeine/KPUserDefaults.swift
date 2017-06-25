//
//  KPUserDefaults.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

final public class KPUserDefaults {

    
    static let defaults = UserDefaults(suiteName: AppConstant.userDefaultsSuitName)
    
    
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
            defaults?.set(accessToken, forKey: "accessToken")
        }
    }
    
    public static var userInformation: NSDictionary? {
        didSet {
            defaults?.set(userInformation?["id"], forKey: "user_identifier")
            
            
            
            self.userIdentifier = userInformation?["id"] as? String
        }
    }
    
    static func loadUserInformation() {
        accessToken = defaults?.object(forKey: "accessToken") as? String
        userIdentifier = defaults?.object(forKey: "user_identifier") as? String
    }
    
    static func clearUserInformation() {
        defaults?.removeObject(forKey: userInformationKey.accessToken)
        defaults?.removeObject(forKey: userInformationKey.userIdentifier)
    }
    
}
