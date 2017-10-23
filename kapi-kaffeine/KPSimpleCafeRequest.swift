//
//  KPSimpleCafeRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/10/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPSimpleCafeRequest: NetworkRequest {
    
    typealias ResponseType = RawJsonResult
    
    private var identifier: String?
    
    var endpoint: String { return "/simples" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        if self.identifier != nil {
            parameters["cafe_id"] = self.identifier
        }

        return parameters
    }
    
    var method: Alamofire.HTTPMethod { return .get }
    
    public func perform(_ cafeID: String? = nil) -> Promise<(ResponseType)> {
        self.identifier = cafeID
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}

