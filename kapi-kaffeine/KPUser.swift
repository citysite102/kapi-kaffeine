//
//  KPUser.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore

public class KPUser {
    
    var demoData: Int = 0
    
}

public var currentUser: KPUser {
    
    struct Static {
        static var instance: KPUser?
    }
    
    if Static.instance == nil {
        Static.instance = KPUser()
        Static.instance?.demoData = 3
    }
    
    return Static.instance!
}
