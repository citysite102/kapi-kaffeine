//
//  KPAddFavoriteRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPFavoriteRequest: NetworkRequest {

    enum requestType {
        case delete
        case add
    }
    
    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    private var type: requestType?
    
    var endpoint: String { return "/favorites" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["cafe_id"] = cafeID
        
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
    
    
    
    public func perform(_ cafeID: String,
                        _ type: requestType) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.type = type
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
