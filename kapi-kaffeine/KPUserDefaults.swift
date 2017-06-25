//
//  KPUserDefaults.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

final public class KPUserDefaults {

    
    static var defaults = UserDefaults(suiteName: AppConstant.userDefaultsSuitName)
    
    
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
                defaults?.set(accessToken, forKey: "accessToken")
            }
        }
    }
    
    public static var userInformation: NSDictionary? {
        didSet {
            
            if let identifier = userInformation?["id"] {
                defaults?.set(identifier as? String, forKey: "user_identifier")
                self.userIdentifier = identifier as? String
            }
        }
    }
    
    static func loadUserInformation() {
        if defaults == nil {
            defaults = UserDefaults(suiteName: AppConstant.userDefaultsSuitName)
        }
        accessToken = defaults?.object(forKey: "accessToken") as? String
        userIdentifier = defaults?.object(forKey: "user_identifier") as? String
    }
    
    static func clearUserInformation() {
        defaults?.removeObject(forKey: userInformationKey.accessToken)
        defaults?.removeObject(forKey: userInformationKey.userIdentifier)
    }
    
}
