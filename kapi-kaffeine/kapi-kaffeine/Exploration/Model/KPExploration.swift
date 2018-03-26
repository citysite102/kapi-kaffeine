
//
//  KPExploration.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 23/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPExplorationSection: NSObject, Mappable {

    var title: String!
    var explorationDescription: String!
    var tag: String!
    
    var shops: [KPDataModel] = []
    

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title                   <-  map["title"]
        explorationDescription  <-  map["description"]
        tag                     <-  map["tag"]
        shops                   <-  map["shops"]
    }
    
}
