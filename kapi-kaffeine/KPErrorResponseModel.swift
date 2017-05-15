//
//  KPErrorResponseModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPErrorResponseModel: Mappable {
    
    var errorCode: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        errorCode <- map["error_code"]
    }
    
}
