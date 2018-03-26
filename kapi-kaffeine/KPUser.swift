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
    
    var accessToken: String?
    var identifier: String?
    var displayName: String?
    var photoURL: String?
    var defaultLocation: String?
    var intro: String?
    var level: NSNumber?
    var exp: NSNumber?
    var email: String?
    var createdDate: NSNumber?
    var modifiedDate: NSNumber?
    
    var reviewsCount: NSNumber?
    var reviews: [KPDataModel]?
    var ratesCount: NSNumber?
    var rates: [KPDataModel]?
    var favoritesCount: NSNumber?
    var favorites: [KPDataModel]?
    var articlesCount: NSNumber?
    var articles: [KPArticleItem]?
    var visitsCount: NSNumber?
    var visits: [KPDataModel]?
    
    
    
    required init?(map: Map) {
        
        if map.JSON["member_id"] == nil {
            return nil
        }
        
//        favorites = ["0de448f3-f9ca-48a1-82ea-6035f20af922",
//            "00e21150-8b6d-4a54-b4bb-5fa45099b15e",
//            "bb970f5b-eee6-4977-a954-913df8893bfa",
//            "620bf13e-9b91-4753-acf6-454b5652be8b",
//            "63a7d995-dad8-4ea9-aeb6-491864f35e1d"]
//        visits = ["1b2a2f3e-0a57-4dc1-b0e8-2c1ee8c683f3",
//            "1eedae3c-4edd-4310-8f4e-28a9bdf2799e",
//            "9fbc5b98-cd70-495f-9023-c4d079467c16",
//            "9cae70e6-7d8e-4db6-9548-4fbd78f76b9b"]
        
    }
    
    func hasReviewed(_ cafeID: String) -> Bool {
        if reviews != nil {
            for cafeData in reviews! {
                if cafeData.identifier == cafeID {
                    return true
                }
            }
        } else {
            return false
        }
        
        return false
    }
    
    func hasCollected(_ articleID: String) -> Bool {
        if articles != nil {
            for articleData in articles! {
                if articleData.articleID == articleID {
                    return true
                }
            }
        } else {
            return false
        }
        
        return false
    }
    
    func hasRated(_ cafeID: String) -> Bool {
        if rates != nil {
            for cafeData in rates! {
                if cafeData.identifier == cafeID {
                    return true
                }
            }
        } else {
            return false
        }
        
        return false
    }
    
    func hasFavorited(_ cafeID: String) -> Bool {
        if favorites != nil {
            for cafeData in favorites! {
                if cafeData.identifier == cafeID {
                    return true
                }
            }
        } else {
            return false
        }
        return false
    }
    
    func hasVisited(_ cafeID: String) -> Bool {
        if visits != nil {
            for cafeData in visits! {
                if cafeData.identifier == cafeID {
                    return true
                }
            }
        } else {
            return false
        }
        return false
    }
    
    func mapping(map: Map) {
        accessToken         <-    map["access_token"]
        identifier          <-    map["member_id"]
        displayName         <-    map["display_name"]
        photoURL            <-    map["photo_url"]
        defaultLocation     <-    map["default_location"]
        intro               <-    map["intro"]
        level               <-    map["level"]
        exp                 <-    map["exp"]
        email               <-    map["email"]
        createdDate         <-    map["created_time"]
        modifiedDate        <-    map["modified_time"]
        reviewsCount        <-    map["review_count"]
        reviews             <-    map["reviews"]
        ratesCount          <-    map["rate_count"]
        rates               <-    map["rates"]
        favoritesCount      <-    map["favorite_count"]
        favorites           <-    map["favorites"]
        visitsCount         <-    map["visit_count"]
        visits              <-    map["visits"]
    }
    

}
