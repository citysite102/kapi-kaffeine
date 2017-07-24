//
//  KPLikeModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPLikeModel: Mappable {

    var createdTime: NSNumber!
    var isLike: NSNumber!
    var memberID: String!

    required init?(map: Map) {
        if map.JSON["liker_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        createdTime      <-    map["created_time"]
        isLike           <-    map["is_like"]
        memberID         <-    map["liker_id"]
    }
}
