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
        static let userInformation = "user_information"
    }
    
    public static var accessToken: String? {
        didSet {
            if accessToken != nil {
                UserDefaults.standard.set(accessToken, forKey: userInformationKey.accessToken)
            }
        }
    }
    
    public static var userInformation: Dictionary<String, Any>? = nil {
        didSet {
            UserDefaults.standard.set(userInformation, forKey: userInformationKey.userInformation)
        }
    }
    
    static func loadUserInformation() {
        userInformation = UserDefaults.standard.object(forKey: userInformationKey.userInformation) as? Dictionary
        accessToken = UserDefaults.standard.object(forKey: userInformationKey.accessToken) as? String
    }
    
    static func clearUserInformation() {
        UserDefaults.standard.removeObject(forKey: userInformationKey.accessToken)
        UserDefaults.standard.removeObject(forKey: userInformationKey.userInformation)
    }
    
}
