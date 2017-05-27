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

    var wifi: NSNumber?
    var seat: NSNumber?
    var food: NSNumber?
    var quite: NSNumber?
    var tasty: NSNumber?
    var cheap: NSNumber?
    var music: NSNumber?
    var average: NSNumber?
    
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
