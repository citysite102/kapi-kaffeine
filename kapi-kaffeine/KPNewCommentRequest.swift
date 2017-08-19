//
//  KPNewCommentRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPNewCommentRequest: NetworkRequest {
    
    enum requestType {
        case put
        case add
    }

    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    private var content: String?
    private var comment_id: String?
    
    var method: Alamofire.HTTPMethod {
        return self.type == requestType.add ?
        .post :
        .put }
    
    private var type: requestType?
    
    var endpoint: String { return "/comments" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        parameters["content"] = content
        
        if type == .put {
            parameters["comment_id"] = comment_id
        }
        
        return parameters
    }
    
    public func perform(_ cafeID: String,
                        _ comment_id: String?,
                        _ content: String,
                        _ type: requestType) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.content = content
        self.comment_id = comment_id
        self.type = type
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
