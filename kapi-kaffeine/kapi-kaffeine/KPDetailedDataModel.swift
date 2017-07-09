//
//  KPDetailedDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDetailedDataModel: KPDataModel {

    var photos: [String]? //
    var comments:[KPCommentModel]? //
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        photos          <-    map["photos"]
        comments        <-    map["comments"]
    }
}
