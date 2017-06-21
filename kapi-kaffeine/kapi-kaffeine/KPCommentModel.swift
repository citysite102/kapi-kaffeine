//
//  KPCommentModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPCommentModel: Mappable {
    
    var memberID: String!
    var comment: String!
    var updateDate: Date?
    
    
//    var voteUpCount: NSNumber?
//    var voteDownCount: NSNumber?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        memberID          <-    map["member_id"]
        comment           <-    map["comment"]
        updateDate        <-    (map["date"], DateTransform())
//        voteUpCount       <-    map["voteUpCount"]
//        voteDownCount     <-    map["voteDownCount"]
    }
    
}
