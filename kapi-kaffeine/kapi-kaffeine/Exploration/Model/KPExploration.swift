
//
//  KPExploration.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 23/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPExplorationShop: NSObject, Mappable {
    
    var cafe_id: String!
    var address: String!
    var place: String!
    var name: String!
    
    var imageURL_s: URL?
    var imageURL_l: URL?
    
    var googleURL_s: URL?
    var googleURL_l: URL?
    
    required init?(map: Map) {
        if map.JSON["cafe_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        cafe_id         <-  map["cafe_id"]
        address         <-  map["address"]
        name            <-  map["name"]
        place           <-  map["place"]
        
        imageURL_s      <-  (map["covers.kapi_s"], URLTransform())
        imageURL_l      <-  (map["covers.kapi_l"], URLTransform())
        
        googleURL_s     <-  (map["covers.google_s"], URLTransform())
        googleURL_l     <-  (map["covers.google_l"], URLTransform())
    }
}

class KPExplorationSection: NSObject, Mappable {

    var title: String!
    var explorationDescription: String!
    var tag: String!
    
    var shops: [KPExplorationShop] = []
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title                   <-  map["title"]
        explorationDescription  <-  map["description"]
        tag                     <-  map["tag"]
        shops                   <-  map["shops"]
    }
    
}
