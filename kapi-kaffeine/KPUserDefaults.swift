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
    
    
    struct UserInformationKey {
        static let accessToken = "access_token"
        static let accessGroup = "A43Y729CXH.com.kapi.kapi-kaffeine"
        static let recentSearch = "recent_search"
        static let userIdentifier = "user_identifier"
        static let userInformation = "user_information"
    }
    
    public static var accessToken: String? {
        didSet {
            if accessToken != nil {
                let keychainItemWrapper = KeychainItemWrapper(identifier: UserInformationKey.accessToken,
                                                              accessGroup: UserInformationKey.accessGroup)
                keychainItemWrapper[UserInformationKey.accessToken] = accessToken as AnyObject?
            }
        }
    }
    
    public static var userInformation: Dictionary<String, Any>? = nil {
        didSet {
            UserDefaults.standard.set(userInformation, forKey: UserInformationKey.userInformation)
        }
    }
    
    public static var recentSearch: Array<Dictionary<String, Any>>? = nil {
        didSet {
            UserDefaults.standard.set(recentSearch, forKey: UserInformationKey.recentSearch)
        }
    }
    
    static func loadUserInformation() {
        userInformation = UserDefaults.standard.object(forKey: UserInformationKey.userInformation) as? Dictionary
        recentSearch = UserDefaults.standard.object(forKey: UserInformationKey.recentSearch) as? Array
        
        let keychainItemWrapper = KeychainItemWrapper(identifier: UserInformationKey.accessToken,
                                                      accessGroup: UserInformationKey.accessGroup)
        if let secretToken = keychainItemWrapper[UserInformationKey.accessToken] as? String? {
            accessToken = secretToken
        }
    }
    
    static func clearUserInformation() {
        
        let keychainItemWrapper = KeychainItemWrapper(identifier: UserInformationKey.accessToken,
                                                      accessGroup: UserInformationKey.accessGroup)
        keychainItemWrapper.resetKeychain()
        UserDefaults.standard.removeObject(forKey: UserInformationKey.userInformation)
        UserDefaults.standard.removeObject(forKey: UserInformationKey.recentSearch)
    }
    
}
