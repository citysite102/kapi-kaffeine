//
//  KPRateDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPRateDataModel: NSObject, Mappable {

    var cafeID: String!
    var cheapAverage: NSNumber? = 0
    var foodAverage: NSNumber? = 0
    var quietAverage: NSNumber? = 0
    var seatAverage: NSNumber? = 0
    var tastyAverage: NSNumber? = 0
    var musicAverage: NSNumber? = 0
    var wifiAverage: NSNumber? = 0
    

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        cafeID          <- map["cafe_id"]
        cheapAverage    <- map["cheap_avg"]
        foodAverage     <- map["food_avg"]
        quietAverage    <- map["quiet_avg"]
        seatAverage     <- map["seat_avg"]
        tastyAverage    <- map["tasty_avg"]
        musicAverage    <- map["music_avg"]
        wifiAverage     <- map["wifi_avg"]
    }
}
