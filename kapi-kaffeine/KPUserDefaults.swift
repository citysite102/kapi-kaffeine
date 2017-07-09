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
    
    public static var accessToken: String? {
        didSet {
            if accessToken != nil {
                print("Set Access Token as \(accessToken!)")
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                print("Stored Access Token \(UserDefaults.standard.object(forKey: "accessToken") as! String)")
                
            }
        }
    }
    
    public static var userInformation: Dictionary<String, Any>? = nil {
        didSet {
            UserDefaults.standard.set(userInformation, forKey: "user_information")
        }
    }
    
    static func loadUserInformation() {
        
        userInformation = UserDefaults.standard.object(forKey: "user_information") as? Dictionary
        accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String
        if accessToken != nil {
            print("Get Access Token as \(accessToken!)")
        }
    }
    
    static func clearUserInformation() {
        UserDefaults.standard.removeObject(forKey: userInformationKey.accessToken)
        UserDefaults.standard.removeObject(forKey: userInformationKey.userIdentifier)
    }
    
}
