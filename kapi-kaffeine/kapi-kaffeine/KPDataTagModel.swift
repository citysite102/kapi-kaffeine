//
//  KPDataTagModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDataTagModel: NSObject, Mappable {

    var identifier: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier          <-    map["tag_id"]
        name                <-    map["name"]
    }
    
}
