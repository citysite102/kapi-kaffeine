//
//  KPCafeRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPCafeRequest: NetworkUploadRequest {

    typealias ResponseType = RawJsonResult
    
    private var limitedTime: NSNumber?
    private var socket: NSNumber?
    private var standingDesk: NSNumber?
    private var mrt: String?
    private var city: String?
    var endpoint: String { return "/cafes" }
    
    var parameters: [String : Any]? {    
        var parameters = [String : Any]()
        
        if self.limitedTime != nil {
            parameters["limited_time"] = self.limitedTime
        }
        if self.socket != nil {
            parameters["socket"] = self.socket
        }
        if self.standingDesk != nil {
            parameters["standing_desk"] = self.standingDesk
        }
        if self.mrt != nil {
            parameters["mrt"] = self.mrt
        }
        if self.city != nil {
            parameters["city"] = self.city
        }
        
        return parameters
    }
    
    var method: Alamofire.HTTPMethod { return .get }
    
    var headers: [String : String] {
        return ["token": (KPUserManager.sharedManager.currentUser?.accessToken)!]
    }
    
    
    
    public func perform(_ limitedTime: NSNumber? = nil,
                        _ socket: NSNumber? = nil,
                        _ standingDesk: NSNumber? = nil,
                        _ mrt: String? = nil,
                        _ city: String? = nil) -> Promise<(ResponseType)> {
        self.limitedTime = limitedTime
        self.socket = socket
        self.standingDesk = standingDesk
        self.mrt = mrt
        self.city = city
        return  networkClient.performUploadRequest(self).then(execute: responseHandler)
//        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
