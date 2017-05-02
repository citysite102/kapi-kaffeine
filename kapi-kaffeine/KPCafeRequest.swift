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

class searchResult: Mappable {
    
//    var identifier: String!
//    var address: String!
//    var name: String!
//    var phone: String?
//    var city: String?
//    var latitude: NSNumber?
//    var longtitude: NSNumber?
//    
//    var cheap: NSNumber?
//    var music: NSNumber?
//    var url: String?
//    var address: String?
//    var latitude: String?
//    var longitude: String?
//    var limitedTime: String?
//    var socket: String?
//    var standingDesk: String?
//    var mrt: String?
//    var openTime: String?
//    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
    
//    "id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
//    "address": "\u5609\u7fa9\u5e02\u6771\u5340\u5fe0\u5b5d\u8def205\u865f",
//    "name": "R5\u5c0f\u9910\u9928",
//    "phone": "052770250",
//    "city": "chiayi",
//    "latitude": 23.4838654,
//    "longitude": 120.4535834,
//    "standing_desk": 2
//    "socket": 3,
//    "limited_time": 3,
//    "url": null,
//    "fb_url": "https://www.facebook.com/r5.bistro",
//    "mrt": null,
//    "business_hour": {
//    "sun_1_open": "11:30",
//    "wed_1_open": "11:30",
//    "sat_1_open": "11:30",
//    "sun_1_close": "21:00",
//    "thu_1_open": "11:30",
//    "mon_1_open": "11:30",
//    "wed_1_close": "21:00",
//    "sat_1_close": "21:00",
//    "tue_1_open": "11:30",
//    "thu_1_close": "21:00",
//    "fri_1_close": "21:00",
//    "mon_1_close": "21:00",
//    "fri_1_open": "11:30",
//    "tue_1_close": "21:00"
//    },
//    "tags": null,
//    "rates": {
//    "seat": 5.0,
//    "food": null,
//    "average": 5.0,
//    "wifi": 5.0,
//    "quiet": 5.0,
//    "tasty": 5.0,
//    "music": 5.0,
//    "cheap": 5.0
//    },
//    "photos": {
//    "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
//    "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx"
//    },
//    "is_kapi": false,
//
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
