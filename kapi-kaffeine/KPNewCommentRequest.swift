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

class KPNewCommentRequest: NetworkUploadRequest {

    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    private var comment: String?
    
    var endpoint: String { return "/comments" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        parameters["comment"] = comment
        
        return parameters
    }
    
    
    var headers: [String : String] {
        return ["token": (KPUserManager.sharedManager.currentUser?.accessToken)!]
    }
    
    
    
    public func perform(_ cafeID: String,
                        _ comment: String) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.comment = comment
        return  networkClient.performUploadRequest(self).then(execute: responseHandler)
    }
    
}
