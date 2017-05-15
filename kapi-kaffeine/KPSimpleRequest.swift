//
//  KPSimpleRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/2.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class KPSimpleRequest: NetworkRequest {
    
    public typealias ResponseType = RawJsonResult
    
    var endpoint: String {
        return simpleEndpoint
    }
    var parameters: [String : Any]? {
        return simpleParameters
    }
    var method: HTTPMethod {
        return simpleMethod
    }
    
    private var simpleEndpoint: String!
    private var simpleParameters: [String : Any]!
    private var simpleMethod: Alamofire.HTTPMethod!
    
    init(endpoint: String,
         parameters: [String : Any],
         method: Alamofire.HTTPMethod) {
        self.simpleEndpoint = endpoint
        self.simpleParameters = parameters
        self.simpleMethod = method
    }
    
    public func perform() -> Promise<ResponseType> {
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
