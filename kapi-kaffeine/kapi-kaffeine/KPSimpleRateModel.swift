//
//  KPSimpleRateModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPSimpleRateModel: NSObject, Mappable {

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
    var displayName: String?
    var photoURL: String?
    var createdModifiedContent: String! {
        let diffInterval = Date().timeIntervalSince1970 - (createdTime?.doubleValue ?? 0)
        if diffInterval < 10*60 {
            return String(format: "剛剛", Int(diffInterval/60))
        } else if diffInterval < 60*60 {
            return String(format: "%d分鐘前", Int(diffInterval/60))
        } else if diffInterval < 60*60*24 {
            return String(format: "%d小時前", Int(diffInterval/(60*60)))
        } else {
            return String(format: "%d天前", Int(diffInterval/(60*60*24)))
        }
    }
    
    var averageRate: CGFloat {
        get {
            var totalRate: CGFloat = 0
            var availableRateCount: CGFloat = 0
            
            if let rate = cheap?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }
            
            if let rate = food?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }
            
            if let rate = quiet?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }
            
            if let rate = seat?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }
            
            if let rate = wifi?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }
            
            if let rate = tasty?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }
            
            if let rate = music?.cgFloatValue,
                rate > 0 {
                totalRate += rate
                availableRateCount += 1
            }

            return totalRate/availableRateCount
        }
    }
    
    
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
        displayName     <- map["display_name"]
        photoURL        <- map["photo_url"]
    }
    
}
