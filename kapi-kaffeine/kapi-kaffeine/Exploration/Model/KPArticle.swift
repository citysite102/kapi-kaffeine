//
//  KPArticle.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 04/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPArticleItem: NSObject, Mappable {
    
    var articleID: String!
    var title: String?
    var peopleRead: Int = 0

    required init?(map: Map) {
        if map.JSON["article_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        articleID       <-  map["article_id"]
        title           <-  map["title"]
        peopleRead      <-  map["people_read"]
    }

}
