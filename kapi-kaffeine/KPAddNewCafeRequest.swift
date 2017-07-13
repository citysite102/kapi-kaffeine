//
//  KPAddNewCafeRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class KPAddNewCafeRequest: NetworkRequest {

    typealias ResponseType = RawJsonResult
    
    var endpoint: String { return "/cafes" }
    var method: Alamofire.HTTPMethod { return .post }
    var parameters: [String : Any]? {
        
        var parameters = [String : Any]()
        
        parameters["name"] = name
        parameters["address"] = address
        parameters["city"] = city
        parameters["fb_url"] = facebookURL
        parameters["limited_time"] = limitedTime
        parameters["socket"] = socket
        parameters["phone"] = phone
        
        parameters["latitude"] = NSNumber(value: 23.4838654)
        parameters["longitude"] = NSNumber(value: 120.4535834)
        
        parameters["business_hours"] = business_hour
        
        return parameters
    
    }
    
    private var name: String?
    private var address: String?
    private var city: String?
    private var latitude: NSNumber?
    private var longtitude: NSNumber?
    
    private var url: String?
    private var facebookURL: String?
    
    private var limitedTime: String? // 限制時間 (1:很多,2:很少,3:看狀況,4:沒設定)
    private var socket: String? // 插座 (1:很多,2:很少,3:看狀況,4:沒設定)
    private var standingDesk: String? // 站立位 (1:很多,2:很少,3:看狀況,4:沒設定)
    private var mrt: String?
    private var phone: String?
    private var timeStamp: String? // Time stamp 去掉小數點部分
    
    private var business_hour: [String: String]?
    
    public func perform(_ name: String,
                        _ address: String,
                        _ city: String,
                        _ fb_url: String,
                        _ limited_time: String,
                        _ socket: String,
                        _ phone: String,
                        _ business_hour: [String: String]) -> Promise<(ResponseType)> {
        
        self.name = name
        self.address = address
        self.city = city
        
        self.facebookURL = fb_url
        
        self.limitedTime = limited_time
        self.socket = socket
        self.phone = phone
        
        self.business_hour = business_hour
        
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
