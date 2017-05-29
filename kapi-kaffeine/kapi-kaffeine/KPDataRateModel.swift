//
//  KPDataRateModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDataRateModel: NSObject, Mappable {

    var wifi: NSNumber? = 0
    var seat: NSNumber? = 0
    var food: NSNumber? = 0
    var quite: NSNumber? = 0
    var tasty: NSNumber? = 0
    var cheap: NSNumber? = 0
    var music: NSNumber? = 0
    var average: NSNumber? = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        wifi    <- map["wifi"]
        seat    <- map["seat"]
        food    <- map["food"]
        quite   <- map["quite"]
        tasty   <- map["tasty"]
        cheap   <- map["cheap"]
        music   <- map["music"]
        average <- map["average"]
        
    }
}
