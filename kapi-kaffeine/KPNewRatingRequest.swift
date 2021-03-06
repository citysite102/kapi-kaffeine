//
//  KPNewRatingRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPNewRatingRequest: NetworkRequest {
    
    
    enum requestType {
        case put
        case add
    }
    
    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    private var wifi: NSNumber?
    private var seat: NSNumber?
    private var food: NSNumber?
    private var quiet: NSNumber?
    private var tasty: NSNumber?
    private var cheap: NSNumber?
    private var music: NSNumber?
    private var type: requestType?
    
    var method: Alamofire.HTTPMethod {
        return self.type == requestType.add ?
            .post :
            .put }
    
    var endpoint: String { return "/rates" }
    
    var parameters: [String : Any]? {
        
        var parameters = [String : Any]()
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        if wifi?.intValue ?? 0 != 0 {
            parameters["wifi"] = wifi
        }
        if seat?.intValue ?? 0 != 0 {
            parameters["seat"] = seat
        }
        if food?.intValue ?? 0 != 0 {
            parameters["food"] = food
        }
        if quiet?.intValue ?? 0 != 0 {
            parameters["quiet"] = quiet
        }
        if tasty?.intValue ?? 0 != 0 {
            parameters["tasty"] = tasty
        }
        if cheap?.intValue ?? 0 != 0 {
            parameters["cheap"] = cheap
        }
        if music?.intValue ?? 0 != 0 {
            parameters["music"] = music
        }
        
        return parameters
    }
    
    public func perform(_ cafeID: String,
                        _ wifi: NSNumber? = 0,
                        _ seat: NSNumber? = 0,
                        _ food: NSNumber? = 0,
                        _ quiet: NSNumber? = 0,
                        _ tasty: NSNumber? = 0,
                        _ cheap: NSNumber? = 0,
                        _ music: NSNumber? = 0,
                        _ type: requestType) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.wifi = wifi
        self.seat = seat
        self.food = food
        self.quiet = quiet
        self.tasty = tasty
        self.cheap = cheap
        self.music = music
        self.type = type
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
