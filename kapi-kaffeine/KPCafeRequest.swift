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

class businessHour: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class rate: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class photo: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class searchResult: Mappable {
    
    var identifier: String!
    var address: String!
    var name: String!
    var phone: String?
    var city: String?
    var latitude: NSNumber?
    var longtitude: NSNumber?
    var standingDesk: NSNumber?
    var socket: NSNumber?
    var limitedTime: NSNumber?
    var url: String?
    var fbUrl: String?
    var mrt: String?
    var businessHour: businessHour?
    var tags: [AnyObject]?
    var rates: rate?
    var photos: photo?
    var isKapi: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
    }
}

class KPCafeRequest: NetworkRequest {

    typealias ResponseType = searchResult
    
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
    
    public func perform(_ limitedTime: NSNumber?,
                        _ socket: NSNumber?,
                        _ standingDesk: NSNumber?,
                        _ mrt: String?,
                        _ city: String?) -> Promise<([ResponseType])> {
        self.limitedTime = limitedTime
        self.socket = socket
        self.standingDesk = standingDesk
        self.mrt = mrt
        self.city = city
        return networkClient.performRequest(self).then(execute: arrayResponseHandler)
    }
}
