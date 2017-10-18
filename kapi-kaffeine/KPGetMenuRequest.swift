//
//  KPGetMenuRequest.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 18/10/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class KPGetMenuRequest: NetworkRequest {
    
    typealias ResponseType = RawJsonResult
    private var cafeID: String?
    
    var endpoint: String { return "/menus" }
    
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

