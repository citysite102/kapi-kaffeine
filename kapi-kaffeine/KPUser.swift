//
//  KPUser.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

final class KPUser: NSObject, Mappable {
    
    var accessToken: String!
    var identifier: String!
    var displayName: String!
    var photoURL: String?
    var defaultLocation: String!
    var intro: String?
    var level: NSNumber?
    var exp: NSNumber?
    var email: String?
    var createdDate: NSNumber?
    var favorites: [String]?
    var visits: [String]?
    
    
    
    required init?(map: Map) {
        
//        if map.JSON["identifier"] == nil {
//            return nil
//        }
        
    }
    
    func mapping(map: Map) {
        accessToken         <-    map["access_token"]
        identifier          <-    map["id"]
        displayName         <-    map["display_name"]
        photoURL            <-    map["photo_url"]
        defaultLocation     <-    map["default_location"]
        intro               <-    map["intro"]
        level               <-    map["level"]
        exp                 <-    map["exp"]
        email               <-    map["email"]
        createdDate         <-    map["created_date"]
        favorites           <-    map["favorites"]
        visits              <-    map["visits"]
    }
    

}
