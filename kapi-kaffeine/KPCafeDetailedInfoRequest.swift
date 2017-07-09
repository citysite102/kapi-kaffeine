//
//  KPCafeDetailedInfoRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class KPCafeDetailedInfoRequest: NetworkRequest {
    typealias ResponseType = RawJsonResult
    
    private var identifier: String!
    var endpoint: String { return "/details" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        parameters["cafe_id"] = identifier
        return parameters
    }
    
    var method: Alamofire.HTTPMethod { return .get }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    public func perform(_ cafeID: String? = nil) -> Promise<(ResponseType)> {
        self.identifier = cafeID
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
