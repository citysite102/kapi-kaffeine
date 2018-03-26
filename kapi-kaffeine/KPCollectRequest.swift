//
//  KPCollectRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/3/26.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPCollectRequest: NetworkRequest {

    enum requestType {
        case delete
        case add
    }
    
    typealias ResponseType = RawJsonResult
    private var articleID: String?
    private var type: requestType?
    
    var endpoint: String { return "/favorite_articles" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["article_id"] = articleID
        
        return parameters
    }
    
    var method: Alamofire.HTTPMethod {
        return self.type == requestType.add ?
            .post :
            .delete }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json",
                "token": (KPUserManager.sharedManager.currentUser?.accessToken) ?? ""]
    }
    
    
    
    public func perform(_ articleID: String,
                        _ type: requestType) -> Promise<(ResponseType)> {
        self.articleID = articleID
        self.type = type
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
