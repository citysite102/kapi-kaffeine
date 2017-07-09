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
    var likes: [String: Any]?
    var memberID: String!
    var photoURL: String!
    
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
