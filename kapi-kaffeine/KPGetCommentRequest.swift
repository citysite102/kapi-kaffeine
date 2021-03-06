//
//  KPGetCommentRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPGetCommentRequest: NetworkRequest {

    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    
    var endpoint: String { return "/reviews" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        parameters["cafe_id"] = cafeID
        
        return parameters
    }
    
    public func perform(_ cafeID: String) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
