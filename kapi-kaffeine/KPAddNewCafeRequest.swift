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
        
        var rates = [String: NSNumber]()
        if wifi != 0 {
            rates["wifi"] = NSNumber(value: wifi)
        }
        if quiet != 0 {
            rates["quiet"] = NSNumber(value: quiet)
        }
        if cheap != 0 {
            rates["cheap"] = NSNumber(value: cheap)
        }
        if seat != 0 {
            rates["seat"] = NSNumber(value: seat)
        }
        if tasty != 0 {
            rates["tasty"] = NSNumber(value: tasty)
        }
        if food != 0 {
            rates["food"] = NSNumber(value: food)
        }
        if music != 0 {
            rates["music"] = NSNumber(value: music)
        }
        
        parameters["rates"] = rates
        
        parameters["phone"] = phone
        
        parameters["latitude"] = latitude
        parameters["longitude"] = longtitude
        
//        parameters["tags"] = tags?.toJSONString()
        
        var tagStrings = [String]()
        for tag in tags ?? [] {
            tagStrings.append(tag.identifier)
        }
        parameters["tags"] = tagStrings
        
        
        parameters["business_hours"] = business_hour
        
        parameters["price_average"] = price_average
        
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier

        return parameters
    
    }
    
    private var name: String?
    private var address: String?
    private var city: String?
    private var latitude: NSNumber?
    private var longtitude: NSNumber?
    
    private var url: String?
    private var facebookURL: String?
    
    private var limitedTime: Int?
    private var socket: Int?
    private var standingDesk: Int?
    
    private var wifi: Int!
    private var quiet: Int!
    private var cheap: Int!
    private var seat: Int!
    private var tasty: Int!
    private var food: Int!
    private var music: Int!
    
    private var mrt: String?
    private var phone: String?
    
    private var tags: [KPDataTagModel]?
    
    private var business_hour: [String: String]!
    
    private var price_average: Int?
    
    public func perform(_ name: String,
                        _ address: String,
                        _ city:String,
                        _ latitude: Double,
                        _ longitude: Double,
                        _ fb_url:String,
                        _ limited_time: Int,
                        _ standingDesk: Int,
                        _ socket: Int,
                        _ wifi: Int,
                        _ quiet: Int,
                        _ cheap: Int,
                        _ seat: Int,
                        _ tasty: Int,
                        _ food: Int,
                        _ music: Int,
                        _ phone: String,
                        _ tags: [KPDataTagModel],
                        _ business_hour: [String: String],
                        _ price_average: Int) -> Promise<(ResponseType)> {
        
        self.name = name
        self.address = address
        self.city = city
        
        self.latitude = NSNumber(value: latitude)
        self.longtitude = NSNumber(value: longitude)
        
        self.facebookURL = fb_url
        
        self.limitedTime = limited_time
        self.socket = socket
        
        self.wifi = wifi
        self.quiet = quiet
        self.cheap = cheap
        self.seat = seat
        self.tasty = tasty
        self.food = food
        self.music = music
        
        self.phone = phone
        
        self.tags = tags
        
        self.business_hour = business_hour
        
        self.price_average = price_average
        
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
