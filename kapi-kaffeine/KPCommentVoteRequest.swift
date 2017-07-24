//
//  KPCommentVoteRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

enum voteType: NSNumber {
    case dislike
    case like
    case cancel
}

class KPCommentVoteRequest: NetworkRequest {
    
    typealias ResponseType = RawJsonResult
    private var commentID: String?
    private var cafeID: String?
    private var type: voteType?
    private var like: NSNumber?
    
    var endpoint: String { return "/likes" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        parameters["comment_id"] = commentID
        parameters["like"] = type?.rawValue ?? 2
        
        return parameters
    }
    
    var method: Alamofire.HTTPMethod {
        return .put
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json",
                "token": (KPUserManager.sharedManager.currentUser?.accessToken) ?? ""]
    }
    
    
    
    public func perform(_ cafeID: String,
                        _ type: voteType,
                        _ commentID: String) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.type = type
        self.commentID = commentID
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
    
}
