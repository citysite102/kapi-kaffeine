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
    
    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    private var wifi: NSNumber?
    private var seat: NSNumber?
    private var food: NSNumber?
    private var quiet: NSNumber?
    private var tasty: NSNumber?
    private var cheap: NSNumber?
    private var music: NSNumber?
    
    var method: Alamofire.HTTPMethod { return .post }
    var endpoint: String { return "/rates" }
    
    var parameters: [String : Any]? {
        
        var parameters = [String : Any]()
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        parameters["wifi"] = wifi
        parameters["seat"] = seat
        parameters["food"] = food
        parameters["quiet"] = quiet
        parameters["tasty"] = tasty
        parameters["cheap"] = cheap
        parameters["music"] = music
        
        return parameters
    }
    
    public func perform(_ cafeID: String,
                        _ wifi: NSNumber? = 0,
                        _ seat: NSNumber? = 0,
                        _ food: NSNumber? = 0,
                        _ quiet: NSNumber? = 0,
                        _ tasty: NSNumber? = 0,
                        _ cheap: NSNumber? = 0,
                        _ music: NSNumber? = 0) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.wifi = wifi
        self.seat = seat
        self.food = food
        self.quiet = quiet
        self.tasty = tasty
        self.cheap = cheap
        self.music = music
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
