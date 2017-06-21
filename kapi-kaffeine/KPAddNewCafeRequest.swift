//
//  KPAddNewCafeRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPAddNewCafeRequest: NetworkUploadRequest {

    typealias ResponseType = RawJsonResult
    
    var endpoint: String { return "/cafes" }
    var parameters: [String : Any]? {
        return nil
    }
    var headers: [String : String] {
        return ["token": (KPUserManager.sharedManager.currentUser?.accessToken)!]
    }
    
    
    private var name: String?
    private var address: String?
    private var city: String?
    private var latitude: NSNumber?
    private var longtitude: NSNumber?
    
    private var url: String?
    private var facebookURL: String?
    
    private var limitedTime: String? // 限制時間 (1:很多,2:很少,3:看狀況,4:沒設定)
    private var socket: NSNumber? // 插座 (1:很多,2:很少,3:看狀況,4:沒設定)
    private var standingDesk: NSNumber? // 站立位 (1:很多,2:很少,3:看狀況,4:沒設定)
    private var mrt: String?
    private var phone: String?
    private var timeStamp: String? // Time stamp 去掉小數點部分
    
}
