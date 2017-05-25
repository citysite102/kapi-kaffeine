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
    
    
    public static var accessToken: String? {
        didSet {
            defaults?.set(accessToken, forKey: "accessToken")
        }
    }
    
    static func loadUserInformation() {
        accessToken = defaults?.object(forKey: "accessToken") as? String
    }
    
}
