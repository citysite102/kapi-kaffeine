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

    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    private var content: String?
    
    var method: Alamofire.HTTPMethod { return .post }
    var endpoint: String { return "/comments" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        parameters["content"] = content
        
        return parameters
    }
    
    public func perform(_ cafeID: String,
                        _ content: String) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.content = content
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
