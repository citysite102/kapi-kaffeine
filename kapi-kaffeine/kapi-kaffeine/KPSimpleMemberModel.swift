//
//  KPSimpleMemberModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPSimpleMemberModel: NSObject, Mappable {
    
    var memberID: String?
    var displayName: String?
    var photoURL: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        memberID        <- map["member_id"]
        displayName     <- map["display_name"]
        photoURL        <- map["photo_url"]
    }
    
}
