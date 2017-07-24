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
    
    var commentID: String!
    var content: String!
    var createdTime: NSNumber!
    var dislikeCount: NSNumber? = 0
    var displayName: String!
    var likeCount: NSNumber? = 0
    var likes: [KPLikeModel]?
    var memberID: String!
    var photoURL: String!
    var createdModifiedContent: String! {
        let diffInterval = Date().timeIntervalSince1970 - createdTime.doubleValue
        if diffInterval < 60*60 {
            return String(format: "%d分鐘前", Int(diffInterval/60))
        } else if diffInterval < 60*60*24 {
            return String(format: "%d小時前", Int(diffInterval/(60*60)))
        } else {
            return String(format: "%d天前", Int(diffInterval/(60*60*24)))
        }
    }
    
    
    required init?(map: Map) {
        if map.JSON["comment_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        commentID           <-    map["comment_id"]
        content             <-    map["content"]
        createdTime         <-    map["created_time"]
        dislikeCount        <-    map["dislike_count"]
        displayName         <-    map["display_name"]
        likeCount           <-    map["like_count"]
        likes               <-    map["likes"]
        memberID            <-    map["member_id"]
        photoURL            <-    map["photo_url"]
    }
    
}
