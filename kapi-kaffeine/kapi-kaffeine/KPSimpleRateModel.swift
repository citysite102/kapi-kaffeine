//
//  KPSimpleRateModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPSimpleRateModel: NSObject {

    var cheap: NSNumber? = 0
    var food: NSNumber? = 0
    var quiet: NSNumber? = 0
    var seat: NSNumber? = 0
    var wifi: NSNumber? = 0
    var tasty: NSNumber? = 0
    var music: NSNumber? = 0
    var createdTime: NSNumber? = 0
    var modifiedTime: NSNumber? = 0
    var memberID: String?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cheap           <- map["cheap"]
        food            <- map["food"]
        quiet           <- map["quiet"]
        seat            <- map["seat"]
        wifi            <- map["wifi"]
        tasty           <- map["tasty"]
        music           <- map["music"]
        createdTime     <- map["created_time"]
        modifiedTime    <- map["modified_time"]
        memberID        <- map["member_id"]
    }
    
}
